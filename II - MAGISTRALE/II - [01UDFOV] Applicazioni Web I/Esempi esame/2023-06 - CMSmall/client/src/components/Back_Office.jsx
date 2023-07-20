import { useContext, useEffect, useState } from "react"
import loginContext from "../context/loginContext"
import Page_form from "./Page_form"
import { APIURL } from "../main";
import Single_page from "./Page_component";
function Back_office(props) {
    const loginState = useContext(loginContext);

    const get_pages = async () => {
        setWaitingPages(true);
        let response = await fetch(APIURL + 'pages', {
            method: 'GET',
            credentials: 'include'
        });
        if (response.ok) {
            const final_response = await response.json();

            setResultPages({ available: true, pages: final_response.data });
            setWaitingPages(false);
        }
        else {
            setResult({ available: false, pages: [] });
            setWaitingPages(false);
        }
    }

    useEffect(() => {
        setWaiting(false);
        setResult(null);
        setDisplayPageCreation(false);


        get_pages();
    }, [])

    const update_pages = () => {
        get_pages();
    }

    const closePageCreationProcess = () => {
        setDisplayPageCreation(() => { return false; })
    }
    const displayResult = (result) => {
        setWaiting(false);
        setResult(result);
        setTimeout(() => {
            setResult(null);
            setWaiting(false);
            get_pages();
        },2000);
    }


    const [displayPageCreation, setDisplayPageCreation] = useState(false);
    const [waiting, setWaiting] = useState(false);
    const [waitingPages, setWaitingPages] = useState(false);
    const [resultPages, setResultPages] = useState({ available: false, pages: [] });
    const [result, setResult] = useState(null)

    return (
        <>
            <h2 style={{ textDecoration: 'underline' }}> Back office</h2>
            {loginState.loginstate.authorized ?
                <div>
                    <h3>Viewing all pages</h3>

                    <button onClick={() => { setDisplayPageCreation(() => { return true }) }}>Create page</button>
                    {displayPageCreation ? <Page_form close_form={closePageCreationProcess} wait={setWaiting} displayResult={displayResult} /> : ""}
                    {waiting ? <div style={{ border: '1px solid black', backgroundColor: 'lightblue' }}><h2>Please wait while we perform your operation.</h2></div> : ""}
                    {result ? <div style={{ border: '1px solid black', backgroundColor: 'lightblue' }}><h2>{result.message}</h2></div> : ""}


                    {waitingPages ? <h3>Retrieving all pages...</h3> : ""}
                    {resultPages.available ?
                        <div>
                            {resultPages.pages.map(e =>
                                <div key={e.id}>
                                    {
                                        e.author == loginState.loginstate.name || loginState.loginstate.role == 'Admin' ?
                                            <Single_page element={e} key={e.id} editable={true} deletable={true} refresh={update_pages} /> :
                                            <Single_page element={e} key={e.id} refresh={update_pages} />
                                    }
                                </div>
                            )}
                        </div>
                        : <h3>There was an error retrieving the pages.</h3>}
                </div>
                : <h3>You need to login to perform this action.</h3>
            }
        </>
    )
}
export default Back_office