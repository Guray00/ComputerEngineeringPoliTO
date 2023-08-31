use std::{option::Option, time::{SystemTime, UNIX_EPOCH}};

#[derive(Debug)]
pub enum FileType {
    Text,
    Binary,
}

#[derive(Debug)]
pub struct File {
    pub name: String,
    pub content: Vec<u8>,
    pub creation_time: u64,
    pub type_: FileType,
}

impl File {
    pub fn new(name: &str, content: Vec<u8>, type_: FileType) -> Self {
        let t = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();
        File { name: String::from(name), content, creation_time: t, type_ }
    }
}

#[derive(Debug)]
pub struct Dir {
    pub name: String,
    pub creation_time: u64,
    children: Vec<Node>,
}

impl Dir {
    pub fn new(name: String) -> Self {
        Dir {
            name,
            creation_time: 0,
            children: vec![],
        }
    }
}

#[derive(Debug)]
pub enum Node {
    File(File),
    Dir(Dir),
}

#[derive(Debug)]
pub struct Filesystem {
    root: Dir,
}

pub struct MatchResult<'a> {
    qs: Vec<&'a str>,
    matched_nodes: Vec<&'a mut Node>,
}


impl Filesystem {
    pub fn new() -> Self {
        Filesystem {
            root: Dir::new(String::from("")),
        }
    }

    fn check_path(path: &str) -> bool {
        let parts = path.split("/").collect::<Vec<&str>>();
        if parts.len() < 2 || parts[0] != "" {
            return false;
        }
        true
    }

    // accepting only absolute paths
    fn split_path(path: &str) -> Option<(String, String)> {
        if !Filesystem::check_path(path) {
            return None;
        }
        let mut parts = path.split("/").collect::<Vec<&str>>();
        let last = parts.remove(parts.len() - 1);
        Some((parts.join("/"), String::from(last)))
    }

    fn find_dir(&mut self, path: &str) -> Option<&mut Dir> {
        let parts = path.split("/").collect::<Vec<&str>>();
        if parts.len() < 1 {
            return None
        }
        
        let mut cdir = &mut self.root;
        if parts.len() == 1 && parts[0] == "" {
            return Some(cdir);
        }

        for part in parts.iter() {
            if *part == "" {
                continue;
            }
            let n = cdir.children.iter_mut().find(|x| match x {
                Node::Dir(x) => x.name == *part,
                _ => false,
            });
            match n {
                Some(Node::Dir(ref mut x)) => {
                    cdir = x;
                }
                _ => return None,
            }
        }
        Some(cdir)
        
    }

    pub fn mk_dir(&mut self, path: &str) -> Option<&mut Dir> {
        if let Some((path, last)) = Filesystem::split_path(path) {
            let parent = self.find_dir(&path);
            return match parent {
                Some(x) => {
                    let new_dir = Dir::new(String::from(last));
                    x.children.push(Node::Dir(new_dir));
                    Some(x)
                }
                None => None,
            };
        }
        None
    }

    pub fn rm_dir(&mut self, path: &str) {
        if let Some((path, last)) = Filesystem::split_path(path) {
            let parent = self.find_dir(&path);
            match parent {
                Some(x) => {
                    x.children.retain(|x| match x {
                        Node::Dir(x) => x.name != last,
                        _ => true,
                    });
                }
                None => (),
            }
        }
    }

    pub fn new_file(&mut self, path: &str, file: File) -> Option<()> {
        let d = self.find_dir(path);
        match d {
            Some(x) => {
                x.children.push(Node::File(file));
                Some(())
            }
            None => None,
        }
    }

    pub fn rm_file(&mut self, path: &str) {
        if let Some((path, last)) = Filesystem::split_path(path) {
            let parent = self.find_dir(&path);
            match parent {
                Some(x) => {
                    x.children.retain(|x| match x {
                        Node::File(x) => x.name != last,
                        _ => true,
                    });
                }
                None => (),
            }
        };
    }

    pub fn get_file(&mut self, path: &str) -> Option<&mut File> {
        if let Some((path, last)) = Filesystem::split_path(path) {
            let parent = self.find_dir(&path);
            return match parent {
                Some(x) => {
                    let f = x.children.iter_mut().find(|x| match x {
                        Node::File(x) => x.name == last,
                        _ => false,
                    });
                    match f {
                        Some(Node::File(ref mut x)) => Some(x),
                        _ => None,
                    }
                }
                None => None,
            }
        }
        None
    }

    fn do_match<'a>(f: &File, qs: &'a[&'a str]) -> Option<Vec<&'a str>> {
        let mut matched = vec![];
        for q in qs {
            let toks = q.split(":").collect::<Vec<&str>>();
            let qtype = toks[0];
            let qval = toks[1];
            match qtype {
                "name" => {
                    if f.name.contains(&qval) {
                        matched.push(*q);
                    }
                }
                // TODO: add here other matches
                _ => println!("'{}' unknown or unhandled qtype", qtype),
            }
        }
        if matched.len() == 0 {
            return None;
        }
        Some(matched)
    }

    pub fn search<'a>(&'a mut self, qs: &'a [&'a str]) -> Option<MatchResult> {
        
        let mut mr = MatchResult {
            qs: vec![],
            matched_nodes: vec![],
        };

        let mut visits = vec![&mut self.root];
        while let Some(d) = visits.pop() {
            for cc in d.children.iter_mut() {
                match cc {
                    Node::Dir(ref mut x) => {
                        visits.push(x);
                    }
                    Node::File(x) => {
                        if let Some(matches) = Filesystem::do_match(x, qs){
                            for m in matches {
                                if !mr.qs.contains(&m) {
                                    mr.qs.push(m);
                                }
                            }
                            mr.matched_nodes.push(cc);
                        };
                    }
                }
            }
        }
        Some(mr)
    }

    pub fn print(&mut self) {
        let mut visits = vec![&mut self.root];
        while let Some(d) = visits.pop() {
            for cc in d.children.iter_mut() {
                //let cc = &mut *c;
                match cc {
                    Node::Dir(ref mut x) => {
                        println!("dir: {}/{}", d.name, x.name);
                        visits.push(x);
                    }
                    Node::File(x) => {
                        println!("file: {}/{}", d.name, x.name);
                    }
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn mk_fs() -> Filesystem {
        let mut fs = Filesystem::new();
        fs.mk_dir("/home");
        fs.mk_dir("/home/me");
        fs
    }

    #[test]
    fn create_empty_fs() {
        let fs = Filesystem::new();
        assert_eq!(fs.root.name, "");
    }

    #[test]
    fn create_dir() {
        let mut fs = Filesystem::new();
        fs.mk_dir("/home");
        assert_eq!(fs.root.children.len(), 1);
        if let Node::Dir(ref d) = fs.root.children[0] {
            assert_eq!(d.name, "home");
        } else {
            assert!(false, "expected dir")
        }
    }

    #[test]
    fn create_multiple_dirs() {
        let mut fs = mk_fs();
        assert_eq!(fs.root.children.len(), 1);

        if let Node::Dir(ref d) = fs.root.children[0] {
            assert_eq!(d.name, "home");
            assert_eq!(d.children.len(), 1);
            if let Node::Dir(ref d) = d.children[0] {
                assert_eq!(d.name, "me");
            } else {
                assert!(false, "expected dir")
            }
        } else {
            assert!(false, "expected dir")
        }
    }

    #[test]
    fn rm_dir() {
        let mut fs = mk_fs();
        fs.rm_dir("/home/me");
        assert_eq!(fs.root.children.len(), 1);
        fs.rm_dir("/home");
        assert_eq!(fs.root.children.len(), 0);

    }

    #[test]
    fn invalid_paths() {
        let mut fs = Filesystem::new();
        match fs.mk_dir("home") {
            Some(_) => assert!(false, "expected None"),
            None => (),
        };

        assert_eq!(fs.root.children.len(), 0);
    } 

    #[test]
    fn add_file() {
        let mut fs = mk_fs();
        fs.new_file("/", File::new("test", "my content".into(), FileType::Text ));
        assert_eq!(fs.root.children.len(), 2);
        fs.new_file("/home", File::new("test", "my content".into(), FileType::Text ));
        if let Node::Dir(ref d) = fs.root.children[0] {
            assert_eq!(d.children.len(), 2);
        } else {
            assert!(false, "expected dir")
        }
    }

    #[test]
    fn match_files() {
        
        let mut fs = mk_fs();
        fs.new_file("/", File::new("test1", "my content".into(), FileType::Text ));
        assert_eq!(fs.root.children.len(), 2);
        fs.new_file("/home", File::new("test2", "my content".into(), FileType::Text ));

        let mr = fs.search(&["name:test1"]).unwrap();
        assert_eq!(mr.qs.len(), 1);
        assert_eq!(mr.matched_nodes.len(), 1);
        let mr = fs.search(&["name:test"]).unwrap();
        assert_eq!(mr.qs.len(), 1);
        assert_eq!(mr.matched_nodes.len(), 2);
        let mr = fs.search(&["name:nomatch"]).unwrap();
        assert_eq!(mr.qs.len(), 0);
        assert_eq!(mr.matched_nodes.len(), 0);

    }

}
