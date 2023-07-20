import { APIURL, IMAGES } from "../main";
import { useContext, useState } from "react";
import { Form } from "react-bootstrap";
import loginContext from "../context/loginContext";
function Single_page(props) {
    // takes as input page class instance
    let indexes = 0;

    const loginState = useContext(loginContext);
    let modifiableAuthor = props.modifyAuthor ? props.modifyAuthor : false; // if user is admin, can modify author.
    let editable = props.editable ? props.editable : false;
    let deletable = props.deletable ? props.deletable : false;
    let creat_date = new Date(props.element.creation_date).toUTCString();
    let pubbl_date = new Date(props.element.pubblication_date);
    let pubbl_date_formatted;
    let content_counter = 0;
    let content_with_id = props.element.content.map(e => {
        return { id: content_counter++, type: e.type, content: e.content }
    });
    let modifyTable_id = content_with_id.map(e => { return { id: e.id, modify: true } });
    let modifyContent_id = content_with_id.map(e => { return { id: e.id, modify: false } });
    if (isNaN(pubbl_date)) {
        pubbl_date_formatted = 'none';
    }
    else {
        pubbl_date_formatted = pubbl_date.toISOString().substring(0, 10);
    }

    const divStyle = {
        backgroundColor: 'lightblue',
        textAlign: 'start'
    }

    const [deleting, setDeleting] = useState(false);
    const [errorDeleting, setErrordeleting] = useState(false);
    const [modifiable, setModifiable] = useState(false);
    const [modifyTable, setModifyTable] = useState(modifyTable_id);
    const [modifyContentTable, setModifyContentTable] = useState(modifyContent_id);
    // editing page states
    const [title, setTitle] = useState(props.element.title);
    const [author, setAuthor] = useState(props.element.author);
    // missing change author
    const [pubblication_date, setPubblication_date] = useState(pubbl_date_formatted == 'none' ? '' : pubbl_date_formatted);
    const [dontSpecifyPubblication_date, setDontSpecifyPubblication_date] = useState(props.element.pubblication_date == 'none' ? true : false);
    const [content, setContent] = useState(content_with_id);

    const [contentType, setContentType] = useState(''); // adding / removing new contents
    const [contentCont, setContentCont] = useState(''); // adding / removing new contents
    const [contentCounter, setContentCounter] = useState(content_counter); // adding / removing new contents
    const [current_content, setCurrent_content] = useState(''); // editing content
    const [editingContent, setEditingContent] = useState(false); // editing content
    const [updateMessage, setUpdateMessage] = useState(null);

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
        setModifyContentTable((old_table) => {
            let new_table = [];
            old_table.forEach(e => new_table.push(e));
            new_table.push({ id: contentCounter, modify: false })
            return new_table;
        })
        setModifyTable((old_table) => {
            let new_table = [];
            old_table.forEach(e => new_table.push(e));
            new_table.push({ id: contentCounter, modify: true })
            return new_table;
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

    const startEditing = (id) => { // when editing a single block, set everything to false so that you cant edit any other and only set the current one to true
        setEditingContent(true);
        setCurrent_content(() => {
            return content.filter(e => e.id == id)[0].content;
        })
        setModifyContentTable((current_table) => {
            let new_table = [];
            current_table.forEach(e => {
                if (e.id == id) {
                    new_table.push({ id: e.id, modify: true });
                }
                else {
                    new_table.push(({ id: e.id, modify: false }));
                }
            })
            return new_table;
        })
        setModifyTable((current_table) => {
            let new_table = [];
            current_table.forEach(e => {
                if (e.id == id) {
                    new_table.push({ id: e.id, modify: true });
                }
                else {
                    new_table.push(({ id: e.id, modify: false }));
                }
            })
            return new_table;
        })
    }
    const abortEditing = () => { // set all values to default
        setContent(content_with_id);
        setTitle(props.element.title);
        setAuthor(props.element.author);
        setPubblication_date(pubbl_date_formatted == 'none' ? '' : pubbl_date_formatted);
        setModifyTable(modifyTable_id);
        setModifiable(false);
    }

    const updateEditingFormValue = (new_content, id) => {
        setCurrent_content(new_content);
    }

    const saveEditing = (id) => {
        // send request with fetch and handle all cases
        // remember setTimeout to remove message
        setModifiable(false);
        const final_content = content.map(e => { return { type: e.type, content: e.content } });
        let test = {
            title: title,
            author: author,
            creation_date: props.element.creation_date,
            pubblication_date: pubblication_date,
            content: final_content
        }
        fetch(APIURL + 'pages/' + props.element.id, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                title: title,
                author: author,
                creation_date: props.element.creation_date,
                pubblication_date: dontSpecifyPubblication_date ? 'none' : pubblication_date,
                content: final_content
            }),
            credentials: 'include',
        })
            .then((result) => {
                if (result.ok) {
                    if (result.status == 200) {
                        setUpdateMessage({ success: true, message: "Page updated succesfully" });
                        setTimeout(() => {
                            setUpdateMessage(null);
                            props.refresh();
                        }, 2000);
                    }
                    else {
                        setUpdateMessage({ success: false, message: "Request didn't end well. Please try again." });
                        setTimeout(() => {
                            setUpdateMessage(null);
                        }, 2000);
                    }
                }
                else {
                    result.json().then((responsebody) => {
                        setUpdateMessage({ success: false, message: responsebody.error });
                        setTimeout(() => {
                            setUpdateMessage(null);
                        }, 2000);
                    })

                }
            })
            .catch((err) => {
                setUpdateMessage({ success: false, message: err })
            })
    }
    const doneEditingContent = (id) => {
        // save new text content inside of [content] where id == input id
        setEditingContent(false);

        /// IMPORTANT >> update current content
        setContent((old_table) => {
            let new_content_table = [];
            old_table.forEach(e => {
                if (e.id == id) {
                    new_content_table.push({ id: e.id, type: e.type, content: current_content });
                }
                else {
                    new_content_table.push(e);
                }
            })
            return new_content_table;
        })
        setModifyContentTable((current_table) => {
            let new_table = [];
            current_table.forEach(e => {
                new_table.push({ id: e.id, modify: false });
            })
            return new_table;
        })
        setModifyTable((current_table) => {
            let new_table = [];
            current_table.forEach(e => {
                new_table.push({ id: e.id, modify: true });
            })
            return new_table;
        })
    }

    const delete_page = () => {
        setDeleting(true);
        fetch(APIURL + 'pages/' + props.element.id, {
            method: 'DELETE',
            credentials: 'include'
        })
            .then((result) => {
                if (result.ok) {
                    if (result.status == 200) {
                        setDeleting(false);
                        // call function from props to remove this from the current state
                        props.refresh();
                    }
                    else {
                        setErrordeleting(true);
                        setDeleting(false);
                        setTimeout(() => { setErrordeleting(false) }, 2000)
                    }
                }
                else {
                    setDeleting(false);
                    setErrordeleting(true);
                    setTimeout(() => { setErrordeleting(false) }, 2000)
                }
            })
    }
    return (
        <>
            {
                modifiable ?
                    <div style={divStyle}>
                        <h3>Editing page</h3>
                        <Form style={{ fontSize: '1.2rem' }} onSubmit={(event) => { event.preventDefault() }}>
                            <Form.Group style={{ padding: '0.3em' }}>
                                <Form.Label>Page Title</Form.Label>
                                <Form.Control type="text" placeholder="Title" minLength={2} maxLength={30} required={true} value={title} onChange={(event) => setTitle(event.target.value)} />
                            </Form.Group>
                            {loginState.loginstate.role === 'Admin' ?
                                <Form.Group style={{ padding: '0.3em' }}>
                                    <Form.Label>Author</Form.Label>
                                    <Form.Control type="text" placeholder="Title" minLength={2} maxLength={30} required={true} value={author} onChange={(event) => setAuthor(event.target.value)} />
                                </Form.Group>
                                : ""
                            }
                            <Form.Group style={{ padding: '0.3em' }}>
                                <Form.Label>Don't specify pubblication date</Form.Label>
                                <Form.Control type="checkbox" placeholder="specifyDate" checked={dontSpecifyPubblication_date} value={dontSpecifyPubblication_date} onChange={(event) => setDontSpecifyPubblication_date(event.target.checked)} />
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
                                        <p style={{ display: 'inline' }}><b>TYPE</b>: {e.type}   -   <b>CONTENT</b> :
                                            {modifyContentTable.filter(e2 => e2.id == e.id)[0].modify ?
                                                <Form.Control type="text" placeholder="Content" value={current_content} onChange={(event) => updateEditingFormValue(event.target.value, e.id)} />
                                                :
                                                <i>{e.content}</i>
                                            }
                                        </p> {e.type == 'i' ? <img src={IMAGES.filter(e2 => e2.name == e.content)[0].image} width={50} height={50} /> : ""}
                                        {modifyTable.filter(e2 => e2.id == e.id)[0].modify ?
                                            <div style={{ display: 'inline', width: '100%', textAlign: 'start' }}>
                                                {editingContent ?
                                                    <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { doneEditingContent(e.id) }}>Done</button>
                                                    :
                                                    <div style={{ display: 'inline' }}>
                                                        {e.type != 'i' ?
                                                            <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { startEditing(e.id) }}>Edit content</button>
                                                            : ""
                                                        }
                                                    </div>
                                                }
                                                <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { moveUp(e.id) }}>Up</button>
                                                <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { moveDown(e.id) }}>Down</button>
                                                <button type="button" style={{ display: 'inline', fontSize: '0.7em', margin: '1em' }} onClick={() => { removeContent(e.id) }}>Remove</button>

                                            </div>
                                            :
                                            " "
                                        }

                                    </div>
                                </div>
                            )}
                        </Form>
                        <button type="button" onClick={() => { saveEditing() }} style={{ fontSize: '0.8em', margin: '0.4em' }}>Save</button>
                        <button type="button" onClick={() => { abortEditing(); }} style={{ fontSize: '0.8em', margin: '0.4em' }}>Abort</button>

                    </div>
                    :
                    <div style={divStyle}>
                        <h3>Title : {props.element.title}</h3>
                        {updateMessage ? <div>
                            {updateMessage.success == true ?
                                <h3 style={{ color: 'darkgreen' }}>{updateMessage.message}</h3>
                                :
                                <h3 style={{ color: 'red' }}>{updateMessage.message}</h3>
                            }
                        </div> : ""}
                        {deleting ? <h5 style={{ color: 'red' }}>Deleting this page...</h5> : ""}
                        {errorDeleting ? <h5 style={{ color: 'red' }}>There was an error trying to delete this page.</h5> : ""}
                        {editable && modifiable == false ? <button style={{ fontSize: '0.8em', margin: '0.4em' }} onClick={() => { setModifiable(true); }}>Edit</button> : ""}
                        {deletable ? <button style={{ fontSize: '0.8em', margin: '0.4em' }} onClick={() => { delete_page() }}>Delete</button> : ""}

                        <h4>Author : {props.element.author}</h4>
                        <h5>Creation Date : {creat_date.substring(0,16)}</h5>
                        <h5 style={{textDecoration: 'underline'}}>Pubblication Date : {isNaN(pubbl_date) ? 'Not specified' : pubbl_date.toUTCString().substring(0,16)}</h5>
                        {props.element.content.map(e => <div key={indexes++}>
                            {e.type == 'h' ? <p>Header : {e.content}</p> : ""}
                            {e.type == 'i' ? <img src={IMAGES.filter(e2 => e2.name == e.content)[0].image} width={100} height={100} /> : ""}
                            {e.type == 'p' ? <p>Paragraph : {e.content}</p> : ""}
                        </div>)}
                    </div>
            }

        </>
    )
}

export default Single_page;