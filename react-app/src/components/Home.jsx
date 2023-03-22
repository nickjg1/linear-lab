import { useNavigate } from 'react-router-dom';
const Home = () => {
	const navigate = useNavigate();
	return (
		<body className="min-h-screen bg-gradient-to-br from-black to-[#121286]">
			<div className="flex flex-col items-center justify-center h-screen space-y-5">
				<h1 className="text-white font-bold text-5xl">Learn Linear Algebra</h1>
				<button
					onClick={() => navigate('/lessons')}
					className="bg-gray-300 font-bold text-black p-3 text-lg rounded-md outline-none sm:mt-0"
				>
					Explore Lessons
				</button>
			</div>
		</body>
	);
};

export default Home;
