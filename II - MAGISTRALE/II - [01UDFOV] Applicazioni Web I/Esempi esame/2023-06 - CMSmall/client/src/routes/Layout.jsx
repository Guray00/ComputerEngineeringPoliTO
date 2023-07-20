import { Outlet } from "react-router-dom";
import Nacvbar_c from "../components/Navbar_c";

function Layout(props) {
    return (
        <>
            <div>
               <Nacvbar_c login={props.login} logout={props.logout}/>
               <Outlet />
            </div>
        </>
    )
}

export default Layout;