import "./customTable.css"
import axios from "axios";
import {useEffect, useState} from "react";

function convertTimestamptoDate(timestamp) {
    const result = new Date(timestamp * 1000);
    const year = result.getFullYear();
    const month = '0' + result.getMonth();
    const date = result.getDate();
    const hour = '0' + result.getHours();
    const min = '0' + result.getMinutes();
    return month.slice(-2) + '/' + date + '/' + year + ' ' + hour.slice(-2) + ":" + min.slice(-2);
}

function CustomTable() {
    const [data, setData] = useState();
    const columns = ["Id", "Title", "CreationDate", "Author"]
    const [curPage, setCurPage] = useState(0);
    const [maxPages, setMaxPages] = useState(0);

    useEffect(() => {
        axios.get('http://3.145.83.83:8080/events/events', {params: {
                pageNumber: curPage,
                pageSize: 5
            }})
            .then(response => {
                setData(response.data.data);
                if (curPage === 0) {
                    setMaxPages(response.data.data.totalPages);
                }
            })
            .catch(err => {
            });
    }, [curPage]);

    if (data !== null && data !== undefined) {
        return (
            <div className="info-table-container-style">
                <caption className="info-table-caption-style">Event Information</caption>
                <table className="info-table-style">
                    <thead>
                    <tr>
                        {columns.map((val) => {
                            return (
                                <th className="info-table-thead-style">{val}</th>
                            )
                        })}
                    </tr>
                    </thead>
                    <tbody>
                    {data.content.map((val) => {
                        return (
                            <tr key={val.id} className="info-table-row-style">
                                <td className="info-table-cell-style">{val.id}</td>
                                <td className="info-table-cell-style">{val.title}</td>
                                <td className="info-table-cell-style">{convertTimestamptoDate(val.eventCreationDate)}</td>
                                <td className="info-table-cell-style">{val.author.username}</td>
                            </tr>
                        )
                    })}
                    </tbody>
                </table>
                <div>
                    <button className="page-button-style"
                        onClick={() => {
                        if (curPage - 1 >= 0) {
                            setCurPage(curPage - 1);
                        }
                    }}>
                        previous
                    </button>
                    <button className="page-button-style"
                        onClick={() => {
                        if (curPage + 1 < maxPages) {
                            setCurPage(curPage + 1);
                        }
                    }}>
                        next
                    </button>
                </div>
            </div>
        )
    } else {
        return <div></div>
    }
}

export default CustomTable;