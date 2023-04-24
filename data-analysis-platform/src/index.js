import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import EventInfoPage from './EventInfoPage';
import {createBrowserRouter, Link, Outlet, redirect, RouterProvider, useLocation} from 'react-router-dom';
import Home from "./home";
import Sidebar from "./component/sidebar";

// const AppLayout = () => {
//     <div>
//         <Sidebar></Sidebar>
//         <Outlet/>
//     </div>
// };

function AppLayout() {
    return (
        <div>
            <Sidebar></Sidebar>
            <Outlet/>
        </div>
    );
}

const router = createBrowserRouter([
    {
        element: <AppLayout/>,
        children: [
            {
                path: "/",
                element: <Home></Home>,
            },
            {
                path: "/chart",
                element: <EventInfoPage></EventInfoPage>,
            }
        ]
    }
]);

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
      <RouterProvider router={router} />
  </React.StrictMode>
);