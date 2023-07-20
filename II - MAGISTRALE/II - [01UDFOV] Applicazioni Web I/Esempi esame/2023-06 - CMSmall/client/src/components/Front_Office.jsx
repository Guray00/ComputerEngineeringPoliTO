import { useEffect, useState } from "react";
import { IMAGES } from "../main";
import { APIURL } from "../main";
import Single_page from "./Page_component";
function Front_Office(props) {

    const [pages,setPages] = useState([]);
    const [waiting,setWaiting] = useState(false);

    // when loading the component, retrieve all pages.
    useEffect( () => {
        async function get_published_pages(){
            setWaiting(true);
            let response = await fetch(APIURL + 'published-pages');
            const final_response = await response.json();
            const final_pages = final_response.data.sort((a,b) => {
                let date1 = new Date(a.pubblication_date);
                let date2 = new Date(b.pubblication_date);
                if(date1 > date2){return -1} // date1 sorted BEFORE date2
                else if(date1 < date2){return 1}
                else return 0;
            })
            setPages(final_pages);
            setWaiting(false);
        }
        get_published_pages();
    },[])
    return (
        <>
            <h2 style={{ textDecoration: 'underline' }}> Front Office</h2>
           
            {waiting ? <h5>Loading pages...</h5> : 
            <div>
                 <h5>Visualize all published pages by our users.</h5>
                 {pages.map(e => <Single_page element={e} key={e.id}/>)}
            </div> }
        </>
    )
}
export default Front_Office;