import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { Home, Lessons } from './components';

const App = () => (
	<BrowserRouter>
		<Routes>
			<Route path="/" exact element={<Home />} />
			<Route path="/lessons" exact element={<Lessons />} />
		</Routes>
	</BrowserRouter>
);

export default App;
