import {
    BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Line, LineChart
} from "recharts";
import PropTypes from "prop-types";
import "./chart.css";

function CustomLineChart(props) {
    if (props.data !== undefined && props.data !== null) {
        console.log(props.data)
        return (
            <div >
                <div>
                    Created events
                </div>
                <ResponsiveContainer width="100%" height={420}  >
                    <LineChart width={730} height={250} data={props.data}
                                     margin={{ top: 5, right: 30, left: 20, bottom: 5 }}>
                        <CartesianGrid strokeDasharray="3 3" />
                        <XAxis dataKey="date" label="date" />
                        <YAxis dataKey="numEvents" label="numEvents" />
                        <Tooltip />
                        <Legend />
                        <Line type="monotone" dataKey="date" stroke="#8884d8" />
                        <Line type="monotone" dataKey="numEvents" stroke="#82ca9d" />
                    </LineChart>
                </ResponsiveContainer>
            </div>
        )
    } else {
        return (
            <></>
        )
    }
}


export default CustomLineChart;