import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { Home, LessonPage, Lessons } from './components';

const App = () => (
	<BrowserRouter>
		<Routes>
			<Route path="/" exact element={<Home />} />
			<Route path="/lessons" element={<Lessons />} />
			<Route path="/lessons/:lessonTitle" element={<LessonPage />} />
		</Routes>
	</BrowserRouter>
);
export default App;
