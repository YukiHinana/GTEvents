import { useEffect, useState } from "react";
import Chart from "./component/chart";
import axios from "axios";
import Dropdown from 'react-bootstrap/Dropdown';
import EventTable from "./eventTable";
import CustomLineChart from "./component/customLineChart";
import TagChart from "./component/TagChart";

function convertDateToTimeStamp(date) {
    return Math.floor(date / 1000);
}

function EventInfoPage() {
    const [data, setData] = useState();
    const [dateRange, setDateRange] = useState(7);
    const [dropDownButtonName, setDropDownButtonName] = useState("View past week activities");

    const [tagData, setTagData] = useState();
    const [tagDateRange, setTagDateRange] = useState(7);

    const [lineChartData, setLineChartData] = useState([]);
    const [lineChartDateRange, setLineChartDateRange] = useState(7);

    useEffect(() => {
        axios.get('http://3.145.83.83:8080/clicks/view-events-top-10', {
            params: {
                startDate: convertDateToTimeStamp(Date.now() - dateRange * 24 * 60 * 60 * 1000),
                endDate: convertDateToTimeStamp(Date.now())
            }
        })
            .then(response => {
                setData(response.data.data);
            })
            .catch(err => {
            });
    }, [dateRange]);

    useEffect(() => {
        axios.get('http://3.145.83.83:8080/clicks/view-tags', {
            params: {
                startDate: convertDateToTimeStamp(Date.now() - dateRange * 24 * 60 * 60 * 1000),
                endDate: convertDateToTimeStamp(Date.now())
            }
        })
            .then(response => {
                console.log(response.data.data);
                setTagData(response.data.data);
            })
            .catch(err => {
            });
    }, [tagDateRange]);

    useEffect(() => {
        axios.get('http://3.145.83.83:8080/events/created-events-between', {
            params: {
                startDate: convertDateToTimeStamp(Date.now()),
                days: 31
            }
        })
            .then(response => {
                let createdEventsArr = [];
                for (let i = 0; i < response.data.data.date.length; i++) {
                    createdEventsArr.push(
                        {
                            date: response.data.data.date[i],
                            numEvents: parseInt(response.data.data.numEvents[i]),
                        }
                    )
                }
                setLineChartData(createdEventsArr);
            })
            .catch(err => {
            });
    }, []);


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
            <div>
                <TagChart data={tagData}></TagChart>
            </div>
            <div>
                <CustomLineChart data={lineChartData}></CustomLineChart>
            </div>
        </div>
    );
}

export default EventInfoPage;
