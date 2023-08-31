use std::{
    thread::sleep,
    time::{Duration, Instant},
};

use ipc_ringbuf::{my_time, RingBuf, SensorData};

use fcntl::{lock_file, unlock_file, FcntlLockType};

fn main() {
    let mut buf = RingBuf::new("buffer.bin", 10);
    let mut seq = 0;

    let start = Instant::now();

    loop {
        let data = SensorData {
            seq: seq,
            values: [0.0; 10],
            timestamp: my_time(),
        };

        if let Some(_) = buf.write(data) {
            println!("producer: wrote {}", seq);
        } else {
            println!("producer: buffer full");
        };

        let elapsed = start.elapsed().as_millis() as i64;
        let drift = elapsed - 1000 * seq as i64;
        
        sleep(Duration::from_millis((1000-drift).try_into().unwrap_or(0)));
        
        seq += 1;

    }
}
