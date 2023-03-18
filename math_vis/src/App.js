import './styles/main.css'
import 'bootstrap/dist/css/bootstrap.min.css';
import NavbarComp from "./components/NavbarComp";

function App() {
  return (
    <div className="App">
      <NavbarComp/>
      <div className="container">
        <button className="btn btn-primary d-block mx-auto my-5">Click me</button>
      </div>
      <div className="container">
        <embed className="overflow-hidden d-block w-100" scrolling="no" src="elm/index.html" height="1200px"></embed>
      </div>
    </div>
  );
}

export default App;
