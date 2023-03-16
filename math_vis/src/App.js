import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import NavbarComp from "./components/NavbarComp";

function App() {
  return (
    <div className="App">
      <NavbarComp/>
      <button className="btn btn-primary">Click me</button>
      <embed src="elm/index.html" height="1000" width="1000"></embed>
    </div>
  );
}

export default App;
