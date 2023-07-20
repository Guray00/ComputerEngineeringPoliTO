import { useEffect, useState } from 'react'
import './App.css'
import { APIURL } from './main';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Layout from './routes/Layout';
import Homepage from './routes/Homepage';
import Notfound from './routes/Notfound';
import loginContext from './context/loginContext';
import Front_Office from './components/Front_Office';
import Back_office from './components/Back_Office';
function App() {
  const [loginState, setLoginState] = useState({ authorized: false, name: "", userid: "", role: "" });

  const perform_login = async (email, password) => {
    try {
      const result = await fetch(APIURL + "login", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ username: email, password: password }),
        credentials: 'include',
      });
      if (result.ok) {
        if (result.status == 200) {
          const user = await result.json();
          setLoginState(() => {
            return { authorized: true, name: user.data.username, role: user.data.role, userid: user.data.id };
          })
          return {success : true}
        }
        else {
          return {success : false, message: "Wrong user data."};
        }
      }
      else {
        return {success : false, message: "result not ok , error in fetch"}
      }
    }
    catch (err) {
      // TODO > REMOVE
      console.err(err);
      return {success: false, message: err};
    }
  }
  const perform_logout = async () => {
    try {
      const result = await fetch(APIURL + "logout", {
        method: 'POST',
        credentials: 'include',
      })
      if (result.ok) {
        if (result.status == 200) {
          setLoginState(() => {
            return { authorized: false, name: "", email: "", userid: "" };
          })
          return true;
        }
      }
    }
    catch (err) {
      console.error(err);
      return false;
    }
  }

  return (
    <>
      <BrowserRouter>
        <loginContext.Provider value={{ loginstate: loginState }}>
          <Routes>
            <Route path='/' element={<Layout login={perform_login} logout={perform_logout} />} >
              <Route index path="Home" element={<Homepage />}/>
              <Route path="FrontOffice" element={<Front_Office />} />
              <Route path="BackOffice" element={<Back_office />} />
              <Route path='*' element={<Notfound />} />
            </Route>
          </Routes>
        </loginContext.Provider>
      </BrowserRouter>
    </>
  )
}

export default App
