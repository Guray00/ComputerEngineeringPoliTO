import { useEffect, useState, useContext } from "react";
import loginContext from "../context/loginContext";
import { APIURL } from "../main";
import { useNavigate } from "react-router-dom";
import { Form } from "react-bootstrap";
function Nacvbar_c(props) {

    const [appName, setAppName] = useState("CMSmall");

    let [showLoginForm, setshowLoginForm] = useState(false);
    let [username, setUsername] = useState('');
    let [password, setPassword] = useState('');
    let [invalidData, setInvalidData] = useState(false);
    let [displayWebSiteName, setDisplayWebSiteName] = useState(false);
    let [websiteNewName, setWebsiteNewName] = useState('');
    let [errorUpdating, setErrorUpdating] = useState(false);

    const submitForm = (event) => {
        event.preventDefault();

        if (username == undefined || username == "") {
            setInvalidEmail(true);
            return;
        }

        if (password == undefined || password == "" || password == " ") {
            setInvalidPsw(true);
            return;
        }

        props.login(username, password)
            .then((result) => {
                if (result.success == true) {
                    // succesful login
                    setshowLoginForm(() => { return !showLoginForm });
                    setInvalidData(() => { return false; })
                    navigate("../Home");
                }
                else {
                    setInvalidData(true);
                    setTimeout(() => {setInvalidData(false)},2000)
                }
            })
    }
    const change_website_name = () => {
        let websitename = websiteNewName;
        fetch(APIURL + 'config', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ website_name: websitename }),
            credentials: 'include'
        })
            .then((result) => {
                if (result.ok) {
                    if (result.status == 200) {
                        getWebSiteName();
                        return;
                    }
                    else {
                        setErrorUpdating(true);
                        setTimeout(() => {
                            setErrorUpdating(false);
                        }, 2000)
                    }
                }
                else if (result.status == 422) {
                    setErrorUpdating(true);
                    setTimeout(() => {
                        setErrorUpdating(false);
                    }, 2000)
                    return;
                }
                else if (result.status == 500) {
                    setErrorUpdating(true);
                    setTimeout(() => {
                        setErrorUpdating(false);
                    }, 2000)
                    return;
                }
                else {
                    setErrorUpdating(true);
                    setTimeout(() => {
                        setErrorUpdating(false);
                    }, 2000)
                    return;
                }
            })
    }

    const loginState = useContext(loginContext);
    const navigate = useNavigate();
    // load website name
    const getWebSiteName = async () => {
        const result = await fetch(APIURL + 'website_name');
        if (result.ok) {
            if (result.status == 200) {
                const resp = await result.json();
                setAppName(resp.data.name)
            }
        }
    }
    useEffect(() => {
        getWebSiteName();
    }, []) // called once per page loading.

    const logout = () => {
        props.logout();
    }
    return (
        <>
            <div>
                <h1 onClick={() => { navigate('../Home') }}>{appName}</h1>
                {loginState.loginstate.authorized == true ?
                    <div>
                        <h3>Welcome back, {loginState.loginstate.name}</h3>
                        {loginState.loginstate.role == 'Admin' ?
                            <div>
                                <div style={{ display: "inline" }}>
                                    <h5 style={{ textDecoration: 'underline' }}>Admin Account</h5>
                                    {displayWebSiteName == false ? <button onClick={() => { setDisplayWebSiteName(true) }} style={{ margin: '1em' }} >Edit website name</button> : ""}
                                    {errorUpdating ? <h3 style={{ color: 'red' }}>Error updating the website name.</h3> : ""}
                                </div>
                                {displayWebSiteName ?
                                    <div>
                                        <Form onSubmit={(event) => { event.preventDefault() }}>
                                            <Form.Group>
                                                <Form.Label>New name</Form.Label>
                                                <Form.Control type="text" placeholder="Website Name" value={websiteNewName} onChange={(event) => setWebsiteNewName(event.target.value)} />
                                            </Form.Group>
                                        </Form>
                                        <button onClick={() => { change_website_name(); setDisplayWebSiteName(false); setWebsiteNewName('') }} style={{ margin: '1em' }}>Save new name</button>
                                        <button onClick={() => { setDisplayWebSiteName(false); setWebsiteNewName(''); }} style={{ margin: '1em' }}>Abort</button>
                                    </div>
                                    : ""}
                            </div> : ""}
                        <button onClick={() => logout()} style={{ margin: '1em' }} >Logout</button>
                    </div>
                    :
                    <div>
                        <h3>You are not logged in.</h3>
                        {showLoginForm == false ? <button onClick={() => setshowLoginForm(() => { return !showLoginForm })}>Login</button> : ""}
                        {showLoginForm ?
                            <Form>
                                {invalidData ? <h3 style={{ color: 'red' }}>Invalid data</h3> : ""}
                                <Form.Group>
                                    <Form.Label>username</Form.Label>
                                    <Form.Control type="text" placeholder="username" required={true} value={username} onChange={(event) => setUsername(event.target.value)} />
                                </Form.Group>
                                <Form.Group>
                                    <Form.Label>Password</Form.Label>
                                    <Form.Control type="password" min={0} max={20} required={true} value={password} onChange={(event) => setPassword(event.target.value)} />
                                </Form.Group>
                                <button type="submit" style={{ margin: '1em' }} onClick={(event) => submitForm(event)}>Perform Login</button>
                                <button type="submit" style={{ margin: '1em' }} onClick={(event) => { setshowLoginForm(() => { return !showLoginForm }) }}>Close</button>

                            </Form>
                            :
                            ""}
                    </div>


                }
                <div style={{ display: 'block', padding: '1rem' }}>
                    <button style={{ margin: '1em', fontSize: '2em', border: '5px solid lightblue' }} onClick={() => { navigate('../FrontOffice') }}>Front-Office</button>
                    <button style={{ margin: '1em', fontSize: '2em', border: '5px solid red' }} onClick={() => { navigate('../Backoffice') }}>Back-Office</button>
                </div>
            </div>
        </>
    )
}

export default Nacvbar_c;