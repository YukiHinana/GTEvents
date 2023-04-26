import {
    BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Line
} from "recharts";
import PropTypes from "prop-types";
import "./chart.css";

function Chart(props) {
    if (props.data !== undefined && props.data !== null) {
        console.log(props.data)
        return (
            <div className="event-num-clicks-chart-container">
                <div className="event-num-clicks-chart-title-style">
                    Top 10 highest clicks events
                </div>
                <ResponsiveContainer width="100%" height={420}  >
                    <BarChart data={props.data} margin={{top: 5, right: 30, left: 20, bottom: 20}}>
                        <XAxis dataKey="event.id"
                               label={{ value: "Event Id", position: "insideBottomRight", dy: 20}} />
                        <YAxis dataKey="clicks"
                               label={{value: 'clicks',
                                   style: {textAnchor: 'middle'},
                                   angle: -90,
                                   position: 'left'
                               }} tickCount={4}/>
                        <Tooltip/>
                        <Legend verticalAlign='top' align='right' layout='horizontal' />
                        <Bar dataKey="clicks" fill="#82ca9d" name="number of clicks"  barSize={20}/>
                    </BarChart>
                </ResponsiveContainer>
            </div>
        )
    } else {
        return (
            <div></div>
        )
    }
}

Chart.propTypes = {
    data: PropTypes.array
}

export default Chart;