import {
    BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Line
} from "recharts";
import PropTypes from "prop-types";

function Chart(props) {
    if (props.data !== undefined && props.data !== null) {

        console.log(props.data.length);
        console.log(props.data.at(0));
        console.log(props.data[0]);
        return (
            <ResponsiveContainer width="100%" height={400}>
                <BarChart data={props.data} margin={{top: 5, right: 30, left: 20, bottom: 5}}>
                    <CartesianGrid strokeDasharray="10 3" />
                    {/*<XAxis dataKey={props.data.eventId} />*/}
                    <XAxis dataKey="eventId.title"/>
                    <YAxis dataKey="numClick" />
                    <Tooltip/>
                    <Legend/>
                    <Bar dataKey="numClick" fill="#82ca9d" />
                </BarChart>
            </ResponsiveContainer>
        )
    } else {
        return (
            <div></div>
        )
    }

    // console.log(props.data[0]);

}

Chart.propTypes = {
    data: PropTypes.array
}

export default Chart;