import { useEffect, useState } from "react";
import Chart from "./Chart";
import axios from "axios";

function App() {
  const [data, setData] = useState();
  useEffect(() => {
    const fetchData = async() => {
      axios.get('http://localhost:8080/clicks/view-events-top-10')
          .then(response => {
              // console.log(response.data);
              setData(response.data.data);
          })
          .catch(err => {
          })
      const res = await fetch("https://api.coincap.io/v2/assets/?limit=20");
      const data = await res.json();
      console.log(data);
      // setData(data?.data);
    };
    fetchData();
  }, []);
  return (
    <div className="App">
      DEMO
      <Chart data={data}/>
    </div>
  );
}

export default App;
