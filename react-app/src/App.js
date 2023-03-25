import { HashRouter, Route, Routes } from 'react-router-dom';
import { Home, LessonPage, Lessons, Sandbox } from './components';

const App = () => (
	<HashRouter>
		<Routes>
			<Route path="/" exact element={<Home />} />
			<Route path="/home" element={<Home />} />
			<Route path="/lessons" element={<Lessons />} />
			<Route path="/lessons/:lessonTitle" element={<LessonPage />} />
			<Route path="/sandbox" element={<Sandbox />} />
		</Routes>
	</HashRouter>
);
export default App;
