'use strict';

const express = require('express');
const db_functions = require('./utils/db_functions.js');
const cors = require('cors');
const passport = require('passport');
const Localstrategy = require('passport-local');
const session = require('express-session');

// init express
const app = new express();
const port = 3001;

// we will use json to handle json objects
app.use(express.json());
// enable cors from react app - double server architecture
const corsOptions = {
  origin: 'http://localhost:5173',
  credentials: true,
}
app.use(cors(corsOptions));


app.use(session({
  secret: "0_0",
  resave: false,
  saveUninitialized: false,
}));

app.use(passport.authenticate('session'));

///
/// USER AUTHENTICATION
///
/// SPECIFY PASSPORT LOCAL STRATEGY >>>> PROVIDE USER AUTHENTICATION WITH SIMPLE USERNAME AND PASSWORD
passport.use(new Localstrategy(function verify(username, password, cb) {
  db_functions.retrieveUser(username, password)
    .then((user) => {
      if (!user) {
        return cb(null, false, { message: "incorrect email / password" });
      }
      return cb(null, user);
    })
}));

passport.serializeUser((user, cb) => {
  cb(null, { id: user.id, username: user.username, role: user.role });
})
passport.deserializeUser((user, cb) => {
  return cb(null, user);
})

/// MIDDLEWARE USED TO VERIFY WETHER A USER IS LOGGED IN OR NOT BEFORE GIVING ACCESS TO CERTAIN http METHODS
const isLoggedIn = (req, res, next) => {
  if (req.isAuthenticated()) {
    return next();
  }
  return res.status(403).json({ error: "You need to login to perform this action. (forbidden)" });
}




app.post('/api/login', passport.authenticate('local'), (req, res) => {
  res.status(200).json({ data: { id: req.user.id, username: req.user.username, role: req.user.role } });
  return res;
})

app.post('/api/logout', (req, res) => {
  req.logout(() => {
    res.status(200).end();
    return res;
  });
})
///
/// API METHODS
///
/// GET ALL AVAILABLE PAGES (LOGGED-IN USERS)
app.get('/api/pages', isLoggedIn, (req, res) => {
  db_functions.list_all_pages()
    .then((result) => {
      res.status(200).json({ data: result, userData: { username: req.user.username, role: req.user.role } })
    })
    .catch(err => {
      res.status(500).json({ error: "Could not retrieve data" });
      return res;
    })
})

/// GET ALL PUBLISHED PAGES (FRONT-OFFICE)
app.get('/api/published-pages', (req, res) => {
  db_functions.list_published_pages()
    .then((result) => {
      res.status(200).json({ data: result })
    })
    .catch(err => {
      res.status(500).json({ error: "Could not retrieve data" });
      return res;
    })
})

// create a new page
app.post('/api/pages', isLoggedIn, (req, res) => {
  // check data validity
  const data = req.body;
  if (req.body == undefined) {
    res.status(422).json({ error: "Missing input data" });
    return res;
  }


  const title = data.title;
  const author = data.author;
  let creation_date = new Date();
  creation_date = creation_date.toISOString();
  let pubblication_date = data.pubblication_date;
  const content = data.content;
  if (title === undefined || author === undefined || pubblication_date === undefined || content === undefined || title === null || author === null || creation_date === null || pubblication_date === null || content === null) {
    res.status(422).json({ error: "Invalid input data" });
    return res;
  }



  const test_pubblication_date = new Date(pubblication_date);
  if (pubblication_date == 'none' || isNaN(test_pubblication_date)) {
    pubblication_date = "none";
  }

  let headers = 0;
  let paragraphs = 0;
  let images = 0;
  let invalid_content = 0;

  content.forEach(e => {
    switch (e.type) {
      case 'h':
        headers++;
        break;
      case 'p':
        paragraphs++;
        break;
      case 'i':
        images++;
        break;
      default:
        invalid_content++;
        break;
    }
  })

  if (invalid_content != 0) {
    res.status(422).json({ error: "You inserted an invalid content type" });
    return res;
  }


  if (headers == 0) {
    res.status(422).json({ error: "The page content must have atleast 1 header and either 1 paragraph or 1 image." });
    return res;
  }

  if (paragraphs == 0 && images == 0) {
    res.status(422).json({ error: "The page content must have atleast 1 header and either 1 paragraph or 1 image." });
    return res;
  }

  // serialize into string the categories
  let temp_content = [];
  content.forEach(e => {
    let type = "<" + e.type + ">";
    let current_string = type.concat(e.content);
    temp_content.push(current_string);
  })
  const final_content = temp_content.join('</>');
  const final_content2 = final_content.concat('</>');




  db_functions.insert_page(title, author, creation_date, pubblication_date, final_content2)
    .then((result) => {
      res.status(200).json({ message: "Succesful creation" });
      return res;
    })
    .catch((err) => {
      res.status(500).json({ error: err });
      return res;
    })
})


app.put('/api/pages/:id', isLoggedIn, (req, res) => {

  // check data validity
  if (req.params == undefined) {
    res.status(422).json({ error: "Missing params" });
    return res;
  }

  const my_id = req.params.id;
  if (my_id == undefined || my_id == " " || my_id == "") {
    res.status(422).json({ error: "Invalid params" });
    return res;
  }

  const data = req.body;
  if (req.body == undefined) {
    res.status(422).json({ error: "No body detected." });
    return res;
  }

  const title = data.title;
  const author = data.author;
  let creation_date = data.creation_date;
  let pubblication_date = data.pubblication_date;
  const content = data.content;
  if (title === undefined || author === undefined || creation_date === undefined || pubblication_date === undefined || content === undefined || title === null || author === null || creation_date === null || pubblication_date === null || content === null) {
    res.status(422).json({ error: "Missing input data." });
    return res;
  }

  // in case the inserted date is somewhat invalid, insert the current one as the new one
  const test_creation_date = new Date(creation_date);

  const test_pubblication_date = new Date(pubblication_date);
  if (isNaN(test_pubblication_date)) {
    pubblication_date = "none";
  }


  /// CHECK IF THE PAGE HAS ATLEAST 1 HEADER, 1 PARAGRAPH, 1 IMAGE.

  let headers = 0;
  let paragraphs = 0;
  let images = 0;
  let invalid_content = 0;

  content.forEach(e => {
    switch (e.type) {
      case 'h':
        headers++;
        break;
      case 'p':
        paragraphs++;
        break;
      case 'i':
        images++;
        break;
      default:
        invalid_content++;
        break;
    }
  })
  if (invalid_content != 0) {
    res.status(422).json({ error: "You inserted an invalid content type" });
    return res;
  }

  if (headers == 0) {
    res.status(422).json({ error: "The page content must have atleast 1 header and either 1 paragraph or 1 image." });
    return res;
  }

  if (paragraphs == 0 && images == 0) {
    res.status(422).json({ error: "The page content must have atleast 1 header and either 1 paragraph or 1 image." });
    return res;
  }


  // serialize into string the categories
  let temp_content = [];
  content.forEach(e => {
    let type = "<" + e.type + ">";
    let current_string = type.concat(e.content);
    temp_content.push(current_string);
  })
  const final_content = temp_content.join('</>');
  const final_content2 = final_content.concat('</>');




  db_functions.page_exists(my_id) // check if page exists first
    .then((result) => {
      if (result != false) {
        /// CHECK IF THE AUTHOR AND THE CREATION DATE HAVE NOT BEEN EDITED - IF THEY HAVE, CHECK IF THE USER IS AN ADMIN.
        let check_date = new Date(result[0].creation_date);
        if (check_date.toISOString() !== test_creation_date.toISOString()) {
          res.status(422).json({ error: "Can't edit the creation date." });
          return res;
        }
        if (result[0].author !== req.user.username) {
          db_functions.is_Admin(req.user.id)
            .then((result) => {
              if (result === true) {
                // update even if author has been edited
                db_functions.update_page(my_id, title, author, creation_date, pubblication_date, final_content2)
                  .then((final_result) => {
                    res.status(200).json({ message: "Succesful update" });
                    return res;
                  })
                  .catch((err) => { // error updating the page
                    res.status(500).json({ error: err });
                    return res;
                  })
              }
              else {
                res.status(422).json({ error: "Cannot change creation date or author - you need to be an admin" })
                return res;
              }
            })
            .catch(err => {
              res.status(500).json({ error: "Error while checking if user is an admin or not." });
              return res;
            })
        }
        else { // author wasn't changed, simply update the page
          db_functions.update_page(my_id, title, author, creation_date, pubblication_date, final_content2)
            .then((final_result) => {
              res.status(200).json({ message: "Succesful update" });
              return res;
            })
            .catch((err) => { // error updating the page
              res.status(500).json({ error: err });
              return res;
            })
        }
      }
      else {
        res.status(404).json({ error: "The page doesn't exist" });
        return res;
      }
    })
    .catch((err) => {
      res.status(500).json({ error: err });
      return res;
    })
})


app.delete('/api/pages/:id', isLoggedIn, (req, res) => {

  /// NORMAL USERS ONLY DELETE THEIR OWN
  /// ADMINS DELETE ANY PAGE
  // check data validity
  if (req.params == undefined) {
    res.status(422).json({ error: "Missing params" });
    return res;
  }

  const my_id = req.params.id;
  if (my_id == undefined || my_id == " " || my_id == "") {
    res.status(422).json({ error: "Invalid params" });
    return res;
  }

  db_functions.page_exists(my_id) // check if page exists first
    .then((result) => {
      if (result != false) {
        // todo > check if current logged in user username is the same as the 
        if (result[0].author === req.user.username) { /// page belongs to current logged in user
          db_functions.delete_page(my_id)
            .then((final_result) => {
              res.status(200).json({ message: "Succesful delete." });
              return res;
            })
            .catch(err => { // error deleting the page
              res.status(500).json({ error: err });
              return res;
            })
        }
        else {
          db_functions.is_Admin(req.user.id)
            .then((result2) => {
              if (result2) {// is an admin
                db_functions.delete_page(my_id)
                  .then((final_result) => {
                    res.status(200).json({ message: "Succesful delete by admin account." });
                    return res;
                  })
                  .catch(err => { // error deleting the page
                    res.status(500).json({ error: err });
                    return res;
                  })
              }
              else { // not an admin
                res.status(403).json({ error: "You are not an admin and cannot delete other users page." });
                return res;
              }
            })
        }

      }
      else {
        res.status(404).json({ error: "Given page doesn't exist" });
        return res;
      }
    })
    .catch(err => {
      res.status(500).json({ error: err });
      return res;
    })
})


app.put('/api/config', isLoggedIn, (req, res) => {

  /// check if req.user is an admin
  const data = req.body;
  if (data == undefined) {
    res.status(422).json({ error: "Invalid input data" });
    return res;
  }

  const new_name = req.body.website_name;
  if (new_name != undefined && new_name.length > 0 && new_name != "" && new_name != ' ' && typeof new_name === 'string') {
    db_functions.change_website_name(new_name)
      .then((result) => {
        res.status(200).json({ message: "Succesfully changed website title." });
        return res;
      })
      .catch((err) => { // error updating config website_name 
        console.err(err);
        res.status(500).json({ error: err });
        return res;
      })
  }
  else {
    res.status(422).json({ error: "The new name you inserted is not valid." });
    return res;
  }
})

app.get('/api/website_name', (req, res) => {
  db_functions.get_website_name()
    .then(result => {
      res.status(200).json({ data: { name: result.website_name } });
      return res;
    })
    .catch(err => {
      res.status(500).json({ error: err });
      return res;
    })
})
// todo >> IMPLEMENT LOGIN AFTER CREATING FRONT-END
// OLD LOGIN FUNCTION - used in starting version to test api
/*
app.post('/api/login', (req, res) => {

  //res.status(500).json({error : "To be implemented"})
  const data = req.body;
  if (data == undefined) {
    res.status(422).json({ error: "Invalid input data" });
    return res;
  }

  const username = req.body.username;
  const password = req.body.password;
  if (username != undefined && password != undefined && username.length > 0 && password.length > 0) {
    db_functions.retrieveUser(username, password)
      .then(result => {
        if (result != false) {
          res.status(200).json({ message: "Succesful login.", data: result });
          return res;
        }
        else {
          res.status(401).json({ message: "Wrong data" });
          return res;
        }
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({ error: err });
        return res;
      })
  }
  else {
    res.status(422).json({ error: "Invalid input data" });
  }
})

app.post('/api/logout', (req, res) => {
  res.status(500).json({ error: "To be implemented" })
})
*/


/// DEVELOPMENT ONLY - REMOVE AFTER
// registering new users
app.post('/api/register', (req, res) => {
  const data = req.body;
  if (data == undefined) {
    res.status(422).json({ error: "Invalid input data" });
    return res;
  }

  const username = req.body.username;
  const password = req.body.password;
  if (username != undefined && password != undefined && username.length > 0 && password.length > 0) {
    db_functions.insertUser(username, password)
      .then(result => {
        res.status(200).json({ message: "Succesfully created user." });
        return res;
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({ error: err });
        return res;
      })
  }
  else {
    res.status(422).json({ error: "Invalid input data" });
  }
})


// activate the server
app.listen(port, () => {
  console.log(`CMSmall alpha server listening at http://localhost:${port}`);
});