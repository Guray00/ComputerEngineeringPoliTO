'use strict';
const sqlite = require('sqlite3');
const crypto_ = require('crypto');
const db = new sqlite.Database('./DB/cms.db', (err) => {
    if (err) {
        console.log(err);
    }
});


class User {
    constructor(id, username, password, salt, role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.salt = salt;
        this.role = role;
    }
}

class Content {
    constructor(type2, content) {
        this.type = type2;
        this.content = content;
    }
}
class Page {
    constructor(id, title, author, creation_date, pubblication_date, content) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.creation_date = creation_date;
        this.pubblication_date = pubblication_date;
        let temp_content = [];

        let split_content = content.split('</>').filter(e => e.length > 0);
        // create content starting from each content
        split_content.forEach(e => {
            let temp_data = e.split('>').filter(e1 => e1.length > 0);
            temp_content.push(new Content(temp_data[0].charAt(1), temp_data[1]));
        });

        this.content = temp_content;
    }
}




/// BOTH retrieve_all and retrieve_published functions return a list of pages 
// that have its contents already serialized as Content objects, with fields
// "type" > h / p / i
// "content" > text
/// retrieve all pages - logged in users
exports.list_all_pages = () => {
    return new Promise((resolve, reject) => {
        const query = "SELECT * FROM pages";

        db.all(query, [], (err, rows) => {
            if (err) reject(err);
            else {
                const result_pages = rows.map(row => new Page(row.id, row.title, row.author, row.creation_date, row.pubblication_date, row.content));
                resolve(result_pages);
            }
        })
    })
}
// retrieve published pages - non-logged in users
exports.list_published_pages = () => {
    return new Promise((resolve, reject) => {
        const query = "SELECT * FROM pages";

        db.all(query, [], (err, rows) => {
            if (err) reject(err);
            else {
                const result_pages = rows.map(row => new Page(row.id, row.title, row.author, row.creation_date, row.pubblication_date, row.content));
                const today = new Date();
                let final_pages = [];
                result_pages.forEach(e => {
                    if (e.pubblication_date != undefined && e.pubblication_date != " " && e.pubblication_date.length > 0) {
                        const current_date = new Date(e.pubblication_date);
                        if (!isNaN(current_date)) {
                            if (current_date < today) { // if today is past the pubblication date for given page, it has been published.
                                final_pages.push(e);
                            }
                        }
                    }
                })
                resolve(final_pages);
            }
        })
    })
}

// CREATE NEW PAGE
// it is the API's responsability to properly transform the content from an array of objects to a string
exports.insert_page = (title, author, creation_date, pubblication_date, content) => {
    return new Promise((resolve, reject) => {
        const query = "INSERT INTO pages (title,author,creation_date,pubblication_date,content) VALUES(?,?,?,?,?)";

        db.all(query, [title, author, creation_date, pubblication_date, content], (error) => {
            if (error) {
                console.log(error);
                reject(error);
            }
            resolve("ok");
        })
    })
}


// UPDATE EXISTING PAGE
exports.update_page = (id, title, author, creation_date, pubblication_date, content) => {
    return new Promise((resolve, reject) => {
        const query = "UPDATE pages SET title = ?, author = ?, creation_date = ?, pubblication_date = ?, content = ? WHERE id = ?";

        db.all(query, [title, author, creation_date, pubblication_date, content, id], (err) => {
            if (err) reject(err);
            resolve("ok");
        })
    })
}


exports.delete_page = (id) => {
    return new Promise((resolve, reject) => {
        const query = "DELETE FROM pages WHERE id = ?";

        db.all(query, [id], (err) => {
            if (err) reject(err);
            resolve("ok");
        })
    })
}

/// CHANGE WEBSITE NAME 
exports.change_website_name = (new_name) => {
    return new Promise((resolve, reject) => {
        const query = "UPDATE configurations SET website_name = ? WHERE id = 1";

        db.all(query, [new_name], (err) => {
            if (err) reject(err);
            resolve("ok");
        })
    })
}

exports.get_website_name = ()=>{
    return new Promise((resolve,reject) => {
        const query = "SELECT * FROM configurations";

        db.all(query,[],(err,result) => {
            if(err) reject(err);
            resolve(result[0]);
        })
    })
}

exports.page_exists = (id) => {
    return new Promise((resolve, reject) => {
        const query = "SELECT * FROM pages WHERE id = ?";

        db.all(query, [id], (err,rows ) => {
            if (err) reject(err);
            if (rows != undefined && rows.length > 0) {
                resolve(rows);
            }
            else {
                resolve(false);
            }
        })
    })
}

/// RETRIEVE USER DATA ONLY IF THE TWO PASSWORDS MATCH >>> LOGIN FUNCTION
exports.retrieveUser = (username, password) => {
    return new Promise((resolve, reject) => {
        let query = 'SELECT * FROM users WHERE username = ?';
        db.all(query, [username], (err, result) => {
            if (err) reject(err);
            if(result == undefined || result == [] || result.length == 0) {resolve(false);}
            else if (result != [] && result[0].username === username) {
                crypto_.scrypt(password, Buffer.from(result[0].salt,'hex'), 32, (err, hashedpassword) => {
                    if (err) reject(err);

                    if (!crypto_.timingSafeEqual(Buffer.from(result[0].password, 'hex'), hashedpassword)) {
                        resolve(false);
                    }
                    else {
                        resolve(result[0]);
                    }
                })
            }
        })
    })
}
/// deveLopment only, disable later
/// INSERT A NEW USER
exports.insertUser = (username, password) => {
    return new Promise((resolve, reject) => {
        let query = 'INSERT INTO users (username,password,salt,role) VALUES (?,?,?,?)';
        const salt = crypto_.randomBytes(16);
        crypto_.scrypt(password, salt, 32, (err, result) => {
            if (err) reject(err);

            let hashed_pw = result.toString('hex');
            let salt_to_string = salt.toString('hex');
            db.all(query, [username, hashed_pw, salt_to_string,'user'], (err) => {
                if (err) {
                    reject(err);
                }

                resolve(true);
            })
        })

    })
}
/*
// to use in creation / modify form, to insert a new image.
exports.retrieveImages = () => {
    return new Promise((resolve,reject) => {
        const query = "SELECT * FROM images";

        db.all(query,[],(err,rows) => {
            if(err) reject(err);
            resolve(rows);
        })
    })
}
*/

exports.is_Admin = (userId) => {
    return new Promise((resolve,reject) => {
        const query = "SELECT * FROM users WHERE id = ?";

        db.all(query,[userId],(err,rows) => {
            if(err) reject(err);
            if(rows[0].role === "Admin"){
                resolve(true);
            }
            else{
                resolve(false);
            }
        })
    })
}