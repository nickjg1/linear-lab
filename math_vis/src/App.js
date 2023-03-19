import "./styles/main.css";
import "bootstrap/dist/css/bootstrap.min.css";
import NavbarComp from "./components/NavbarComp";
import Lesson1 from "./components/pages/Lesson1";

function App() {
	return (
		<div className="App">
			<NavbarComp />
			<Lesson1 />
		</div>
	);
}

export default App;
