import { useEffect, useState } from "react";
import Chart from "./component/chart";
import axios from "axios";
import Dropdown from 'react-bootstrap/Dropdown';
import EventTable from "./eventTable";

function convertDateToTimeStamp(date) {
    return Math.floor(date / 1000);
}

function EventInfoPage() {
  const [data, setData] = useState();
  const [dateRange, setDateRange] = useState(7);
  const [dropDownButtonName, setDropDownButtonName] = useState("View past week activities");

  useEffect(() => {
    const fetchData = async() => {
      axios.get('http://localhost:8080/clicks/view-events-top-10', {params: {
            startDate: convertDateToTimeStamp(Date.now() - dateRange * 24 * 60 * 60 * 1000),
            endDate: convertDateToTimeStamp(Date.now())
          }})
          .then(response => {
              setData(response.data.data);
          })
          .catch(err => {
          })
    };
    fetchData();
  }, [dateRange]);

  return (
    <div className="App">
        <EventTable></EventTable>
        <div>
            Select to view event clicks activities
            <Dropdown>
                <Dropdown.Toggle variant="success" id="dropdown-basic">
                    {dropDownButtonName}
                </Dropdown.Toggle>
                <Dropdown.Menu>
                    <Dropdown.Item href="#/action-1"
                                   onClick={() => {
                                       setDateRange(7);
                                       setDropDownButtonName("View past week activities");
                                   }}>
                        View past week activities
                    </Dropdown.Item>
                    <Dropdown.Item href="#/action-2"
                                   onClick={() => {
                                       setDateRange(31);
                                       setDropDownButtonName("View past month activities");
                                   }}>
                        View past month activities
                    </Dropdown.Item>
                    <Dropdown.Item href="#/action-3"
                                   onClick={() => {
                                       setDateRange(10000);
                                       setDropDownButtonName("All Time");
                                   }}>
                        All Time
                    </Dropdown.Item>
                </Dropdown.Menu>
            </Dropdown>
            <Chart data={data}/>
        </div>
    </div>
  );
}

export default EventInfoPage;
