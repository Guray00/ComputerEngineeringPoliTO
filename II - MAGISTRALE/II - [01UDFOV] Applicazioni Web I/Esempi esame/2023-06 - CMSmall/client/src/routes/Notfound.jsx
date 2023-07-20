import { useNavigate } from 'react-router-dom';


function Notfound(){
    const navigate = useNavigate();
    const backtoHomepage = () =>{
        navigate("../CMSmall");
    }
    return (
        <>
        <h1>Oops! The page you were looking found doesn't exist.</h1>
        <h3 style={{textDecoration: 'underline'}} onClick={() => backtoHomepage()}>Back to Homepage</h3>
        </>
    )
}

export default Notfound;