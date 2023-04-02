import { HashRouter, Route, Routes } from 'react-router-dom';
import {
	Home,
	LessonPage,
	Lessons,
	Navbar,
	Sandbox,
	SandboxMockup,
} from './components';

const App = () => (
	<HashRouter>
		<Navbar />
		<Routes>
			<Route path="/" exact element={<Home />} />
			<Route path="/home" element={<Home />} />
			<Route path="/lessons" element={<Lessons />} />
			<Route path="/lessons/:lessonTitle" element={<LessonPage />} />
			<Route path="/sandbox" element={<Sandbox />} />
			<Route path="/sandbox/mockup" element={<SandboxMockup />} />
		</Routes>
	</HashRouter>
);
export default App;
