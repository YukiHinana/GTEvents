import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import EventInfoPage from './EventInfoPage';
import {createBrowserRouter, Link, Outlet, redirect, RouterProvider, useLocation} from 'react-router-dom';
import Home from "./home";
import Sidebar from "./component/sidebar";
import 'bootstrap/dist/css/bootstrap.min.css';

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
                path: "/event-info",
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