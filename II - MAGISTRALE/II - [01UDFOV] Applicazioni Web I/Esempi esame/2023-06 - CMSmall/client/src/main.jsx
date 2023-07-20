import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'
import img1 from './assets/img1.jpeg';
import img2 from './assets/img2.jpeg';
import img3 from './assets/img3.jpeg';
import img4 from './assets/img4.jpeg';

const APIURL = new URL('http://localhost:3001/api/');
const IMAGES = [
  {image: img1,name : 'mountains'},
  {image: img2,name : 'european city 1'},
  {image: img3,name : 'european city 2'},
  {image: img4,name : 'A Crocodile'},
]
ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
export{
  APIURL,
  IMAGES,
}