use std::{
    fs::OpenOptions,
    io::{Read, Seek, SeekFrom, Write},
    os::fd::RawFd,
    os::unix::io::AsRawFd,
    path::Path,
    thread::sleep,
    time::{Duration, SystemTime, UNIX_EPOCH},
};

pub fn my_time() -> u128 {
    let start = SystemTime::now();
    let since_the_epoch = start
        .duration_since(UNIX_EPOCH)
        .expect("Time went backwards");
    since_the_epoch.as_millis()
}

use fcntl::{lock_file, unlock_file, FcntlLockType};
use serde::{Deserialize, Serialize};

const S_SIZE: usize = std::mem::size_of::<usize>();
const HEADER_SIZE: usize = 2 * S_SIZE + 1;


#[derive(Serialize, Deserialize, Debug)]
pub struct SensorData {
    pub seq: u32, // sequenza letture
    pub values: [f32; 10],
    pub timestamp: u128,
}

struct Header {
    pub read_offset: usize,
    pub write_offset: usize,
    pub full: bool,
}

#[derive(Debug)]
pub struct RingBuf {
    file: std::fs::File,
    size: usize,
    vsize: usize
}

impl RingBuf {
    pub fn new(file: &str, size: usize) -> RingBuf {
        let exists = Path::new(file).exists();

        let file = OpenOptions::new()
            .read(true)
            .write(true)
            .create(!exists)
            .open(file)
            .unwrap();


        let vsize: usize = bincode::serialized_size(&SensorData {
            seq: 0,
            values: [0.0; 10],
            timestamp: 0,
        }).unwrap() as usize;

        let mut buf = RingBuf { file, size, vsize };

        if !exists {
            buf.run_inlock(|this| {
                this.save_header(Header {
                    read_offset: 0,
                    write_offset: 0,
                    full: false,
                });
                for idx in 0..size {
                    this.save_val(
                        idx,
                        SensorData {
                            seq: 0,
                            values: [0.0; 10],
                            timestamp: 0,
                        },
                    );
                }
            })
        }

        buf
    }

    fn run_inlock<T>(&mut self, f: impl FnOnce(&mut Self) -> T) -> T {
        while !lock_file(&self.get_fd(), None, Some(FcntlLockType::Write)).unwrap() {
            sleep(Duration::from_millis(1));
        }
        let res = f(self);
        unlock_file(&self.get_fd(), None).unwrap();
        res
    }

    fn read_header(&mut self) -> Header {
        let mut buf = [0; HEADER_SIZE];
        self.file.seek(SeekFrom::Start(0)).unwrap();
        self.file.read_exact(&mut buf).unwrap();

        
        Header {
            read_offset: usize::from_le_bytes(buf[0..S_SIZE].try_into().unwrap()),
            write_offset: usize::from_le_bytes(buf[S_SIZE..2 * S_SIZE].try_into().unwrap()),
            full: match buf[HEADER_SIZE - 1] {
                0 => false,
                1 => true,
                _ => panic!("invalid header"),
            },
        }
    }

    fn save_header(&mut self, header: Header) {
        let mut buf = [0; HEADER_SIZE];
        buf[0..S_SIZE].copy_from_slice(&header.read_offset.to_le_bytes());
        buf[S_SIZE..2 * S_SIZE].copy_from_slice(&header.write_offset.to_le_bytes());
        buf[HEADER_SIZE - 1] = match header.full {
            false => 0,
            true => 1,
        };
        self.file.seek(SeekFrom::Start(0)).unwrap();
        self.file.write(&buf).unwrap();
        self.file.flush().unwrap();
    }

    pub fn read(&mut self) -> Option<SensorData> {
        self.run_inlock(|this| this._read())
    }

    // None if buffer is full
    pub fn write(&mut self, val: SensorData) -> Option<()> {
        self.run_inlock(|this| this._write(val))
    }

    fn _read(&mut self) -> Option<SensorData> {
        let mut header = self.read_header();

        // buffer is empty?
        if header.read_offset == header.write_offset && !header.full {
            return None;
        }

        let val = self.read_val(header.read_offset);
        header.read_offset = (header.read_offset + 1) % self.size;
        if header.read_offset == header.write_offset {
            // if starts is equal to end, and we have just read buffer is empty
            header.full = false;
        }
        self.save_header(header);

        Some(val)
    }

    pub fn _write(&mut self, val: SensorData) -> Option<()> {
        let mut header = self.read_header();

        if header.full {
            return None;
        }
        self.save_val(header.write_offset, val);
        header.write_offset = (header.write_offset + 1) % self.size;
        if header.read_offset == header.write_offset {
            header.full = true;
        }
        self.save_header(header);

        Some(())
    }

    fn read_val(&mut self, idx: usize) -> SensorData {

        self.file
            .seek(SeekFrom::Start(
                (HEADER_SIZE + idx * self.vsize) as u64,
            ))
            .unwrap();

        let mut buf = vec![0; self.vsize];
        
        println!("buf len {}  offset {} idx {}", buf.len(), (HEADER_SIZE + idx * self.vsize), idx);

        self.file.read_exact(&mut buf).unwrap();
        bincode::deserialize(&buf).unwrap()
    }

    fn save_val(&mut self, idx: usize, val: SensorData) {
        let buf = bincode::serialize(&val).unwrap();
        self.file
            .seek(SeekFrom::Start(
                (HEADER_SIZE + idx * buf.len()) as u64,
            ))
            .unwrap();
        self.file.write(&buf).unwrap();
        self.file.flush().unwrap();
    }

    pub fn get_fd(&self) -> RawFd {
        self.file.as_raw_fd()
    }
}
