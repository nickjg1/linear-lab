import logo from './logo.svg';
import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import Iframe from 'react-iframe';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <Iframe src='test.html' Iframe/>
        
        
      </header>
    </div>
  );
}

export default App;
