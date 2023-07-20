import { useContext, useEffect, useState } from "react";
import { Form } from "react-bootstrap";
import { IMAGES } from "../main";
import loginContext from "../context/loginContext";
import { APIURL } from "../main";
function Page_form(props) {

   
    const loginState = useContext(loginContext);
    const submit_savepage = (event) => {
        // todo
        // check data validation then call add_page (fetch)
        let final_content = content.map(e => { return { type: e.type, content: e.content } });
        let author = loginState.loginstate.name;
        let pubb_date;
        if (dontSpecifyPubblication_date == true) {
            pubb_date = 'none';
        }
        else {
            pubb_date = new Date(pubblication_date);
            if (isNaN(pubb_date)) {
                pubb_date = 'none';
            }
        }
        props.close_form();
        props.wait();
        add_page(title, author, pubb_date, final_content)
            .then((result) => {
                console.log(result);
                props.displayResult(result);
                return;
            })
            .catch((err) => {
                console.log(err);
                props.displayResult({ message: err });
            })
        // set operation_Result as return value of fetch call
    }

    
    const add_page = async (title, author, pubblication_date, content) => {
        try {
            const result = await fetch(APIURL + "pages", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ title: title, author: author, pubblication_date: pubblication_date, content: content }),
                credentials: 'include',
            });
            if (result.ok) {
                if (result.status == 200) {
                    return { success: true, message: "Operation completed succesfully." };
                }
                else {
                    return { success: false, message: "Something went wrong with your request - please contact administration. " };
                }
            }
            else {
                if (result.status == 422) {
                    return { success: false, message: "Invalid input data." };
                }
                else if (result.status == 500) {
                    return { success: false, message: "Status 500 - server error.Please contact support" };
                }
                else{
                    let error = result.status;
                    return {success: false, message: "Error - status " + error };
                }
            }
        }
        catch (err) {
            console.log(err);
        }
    }

    const [title, setTitle] = useState('');
    const [pubblication_date, setPubblication_date] = useState('');
    const [dontSpecifyPubblication_date, setDontSpecifyPubblication_date] = useState(false);
    const [content, setContent] = useState([]);

    const [contentType, setContentType] = useState('');
    const [contentCont, setContentCont] = useState('');
    const [contentCounter, setContentCounter] = useState(0);

    const moveUp = (id) => {
        setContent((content) => {
            let new_content = [];
            content.forEach(e => new_content.push(e));
            const current_pos = new_content.map(e => e.id).indexOf(id);
            if (current_pos == -1) {
                return content;
            }
            if (current_pos == 0) { //cannot move before first item
                return content;
            };
            [new_content[current_pos], new_content[current_pos - 1]] = [new_content[current_pos - 1], new_content[current_pos]];
            return new_content;
        })
    }

    const moveDown = (id) => {
        setContent((content) => {
            let new_content = [];
            content.forEach(e => new_content.push(e));
            const current_pos = new_content.map(e => e.id).indexOf(id);
            if (current_pos == -1) {
                return content;
            }
            if (current_pos == new_content.length - 1) { // cannot move past last item
                return content;
            };
            [new_content[current_pos], new_content[current_pos + 1]] = [new_content[current_pos + 1], new_content[current_pos]];
            return new_content;
        })
    }

    const addContent = () => {
        setContent((content) => {
            let new_content = [];
            content.forEach(e => new_content.push(e));
            let new_item = { id: contentCounter, type: contentType, content: contentCont };
            new_content.push(new_item);
            return new_content;
        })
        setContentCounter((contentCounter) => { return contentCounter + 1 })
        setContentCont(() => {
            return '';
        })
        setContentType(() => {
            return '';
        })
    }

    const removeContent = (id) => {
        setContent((content) => {
            let new_content = content.filter(e => e.id != id);
            return new_content;
        })
    };

    // title can be specified
    // author is the current user (logged in)
    // creation date is not specified, assigned automatically
    // pubblication date can be specified or not 
    // content is an array - select menu to chose from type (h,p,i)
    // if i, select menu to chose from images

    return (
        <>
            <div style={{ border: '1px solid black', backgroundColor: 'lightblue', margin: '2em', padding: '1em' }}>
                <h3>Page creation form</h3>
                <Form style={{ fontSize: '1.2rem' }} onSubmit={(event) => {event.preventDefault()}}>
                    <Form.Group style={{ padding: '0.3em' }}>
                        <Form.Label>Page Title</Form.Label>
                        <Form.Control type="text" placeholder="Title" minLength={2} maxLength={30} required={true} value={title} onChange={(event) => setTitle(event.target.value)} />
                    </Form.Group>
                    <Form.Group style={{ padding: '0.3em' }}>
                        <Form.Label>Don't specify pubblication date</Form.Label>
                        <Form.Control type="checkbox" placeholder="specifyDate" value={dontSpecifyPubblication_date} onChange={(event) => setDontSpecifyPubblication_date(event.target.checked)} />
                    </Form.Group>
                    <Form.Group >
                        <Form.Control type="date" placeholder="Pubblication date" minLength={2} maxLength={10} disabled={dontSpecifyPubblication_date} value={pubblication_date} onChange={(event) => setPubblication_date(event.target.value)} />
                    </Form.Group>
                    <h3 style={{ paddingTop: '1em' }}>Content</h3>
                    <h6>Select the type of content you wish to add - remember, your page has to have atleast 1 header along with atleast 1 paragraph or image.</h6>
                    <Form.Group >
                        <Form.Label>Content Type  </Form.Label>
                        <Form.Select aria-label="Default select example" value={contentType} onChange={(event) => setContentType(event.target.value)} style={{ marginRight: '0.2em' }}>
                            <option value='none'></option>
                            <option value="h">Header</option>
                            <option value="p">Paragraph</option>
                            <option value="i">Image</option>
                        </Form.Select>
                        {contentType == 'h' || contentType == 'p' ?
                            <Form.Control type="text" placeholder="actual content" minLength={2} maxLength={500} value={contentCont} onChange={(event) => setContentCont(event.target.value)} />
                            : ""
                        }
                        {contentType == 'i' ?
                            <div>
                                <Form.Label>Available images  </Form.Label>
                                <Form.Select aria-label="Default select example" onChange={(event) => setContentCont(IMAGES[event.target.value].name)} style={{ marginRight: '0.2em' }}>
                                    <option value='none'></option>
                                    <option value="0">{IMAGES[0].name}</option>
                                    <option value="1">{IMAGES[1].name}</option>
                                    <option value="2">{IMAGES[2].name}</option>
                                    <option value="3">{IMAGES[3].name}</option>
                                </Form.Select>
                            </div>
                            : ""
                        }
                        {contentType != '' && contentCont != '' ?
                            <button type="button" onClick={() => addContent()} style={{ fontSize: '0.7em', margin: '1em' }}>Add</button>
                            : ""
                        }
                    </Form.Group>
                    <h6>The content you selected will be displayed here - you can change the order in which they are displayed by clicking the arrow up - arrow down button.</h6>
                    {content.map(e =>
                        <div style={{ display: 'inline', width: '100%', textAlign: 'start' }} key={e.id}>
                            <div>
                                <p style={{ display: 'inline' }}><b>TYPE</b>: {e.type}   -   <b>CONTENT</b> : {e.content}</p> {e.type == 'i' ? <img src={IMAGES.filter(e2 => e2.name == e.content)[0].image} width={50} height={50} /> : ""}
                                <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { moveUp(e.id) }}>Up</button>
                                <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { moveDown(e.id) }}>Down</button>
                                <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { removeContent(e.id) }}>Remove</button>
                            </div>
                        </div>
                    )}
                </Form>
                <button onClick={() => { submit_savepage() }} style={{margin:'1em'}}>Add page</button>
                <button onClick={() => { props.close_form() }}style={{margin:'1em'}}>Abort</button>
            </div>
        </>
    )
}

export default Page_form;