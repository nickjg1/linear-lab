import logo from './logo.svg';
import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import Iframe from 'react-iframe';

function App() {
  return (
    <div className="App">
      <h3>Iframes in React</h3>
      <iframe src="elm/index.html"></iframe>
    </div>
  );
}

export default App;


// 