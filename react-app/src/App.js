import { HashRouter, Route, Routes } from 'react-router-dom';
import { Home, LessonPage, Lessons } from './components';

const App = () => (
	<HashRouter>
		<Routes>
			<Route path="/" element={<Home />} />
			<Route path="/home" element={<Home />} />
			<Route path="/lessons" element={<Lessons />} />
			<Route path="/lessons/:lessonTitle" element={<LessonPage />} />
		</Routes>
	</HashRouter>
);
export default App;
