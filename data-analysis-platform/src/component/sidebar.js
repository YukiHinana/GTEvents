import {useState} from "react";
import * as FaIcons from "react-icons/fa";
import * as AiIcons from "react-icons/ai";
import { Link } from "react-router-dom";
import "../chart.css"
import "./sidebar.css"

function Sidebar() {
    const [sidebarCollapse, setSidebarCollapse] = useState(false);
    return (
        <div>
            <div className="sidebar-menu-container-style">
                <div className="sidebar-menu-style">
                    <FaIcons.FaBars size={30} onClick={() => setSidebarCollapse(!sidebarCollapse)}></FaIcons.FaBars>
                </div>
            </div>
            <nav className={sidebarCollapse ? "nav-menu active" : "nav-menu"}>
                <ul className="sidebar-item-list-container-style" onClick={() => setSidebarCollapse(!sidebarCollapse)}>
                    <li className="sidebar-menu-close-icon-style">
                        <AiIcons.AiOutlineClose size={30}></AiIcons.AiOutlineClose>
                    </li>
                    <li className="sidebar-item-container-style">
                        <Link to="/" className="sidebar-item-style">
                            <AiIcons.AiFillHome size={25}></AiIcons.AiFillHome>
                            <div className="sidebar-item-text-style">
                                Home
                            </div>
                        </Link>
                    </li>
                    <li className="sidebar-item-container-style">
                        <Link to="/chart" className="sidebar-item-style">
                            <AiIcons.AiOutlineBarChart size={25}></AiIcons.AiOutlineBarChart>
                            <div className="sidebar-item-text-style">
                                Events Info
                            </div>
                        </Link>
                    </li>
                </ul>
            </nav>
        </div>
    )
}

export default Sidebar;