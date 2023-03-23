import { useNavigate } from 'react-router-dom';

const Home = () => {
	const navigate = useNavigate();
	return (
		<div className="bg-gradient-to-br from-black to-[#3737d0] min-h-screen">
			<div className="px-6 py-12 md:px-12 text-center lg:text-left">
				<div className="container mx-auto xl:px-32">
					<div className="grid h-screen lg:grid-cols-2 gap-12 place-content-center">
						<div className="m-auto">
							<a href="/lessons">
								<h1 className="custom-h1 text-hover">Learn Linear Algebra</h1>
							</a>
							<a
								href="/lessons"
								className="font-bold inline-block px-5 py-3 mr-2 bg-gray-200 text-gray-700 text-sm uppercase rounded-md button-hover"
							>
								Explore Lessons
							</a>
						</div>
						<div className="m-auto">
							<img
								src="https://imgs.search.brave.com/FDVZez-eVaaToLgfDUsPLfDZj8AsstmtCrwAjlQoRZY/rs:fit:474:344:1/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi8yLzJmL0xp/bmVhcl9zdWJzcGFj/ZXNfd2l0aF9zaGFk/aW5nLnN2Zy81MDBw/eC1MaW5lYXJfc3Vi/c3BhY2VzX3dpdGhf/c2hhZGluZy5zdmcu/cG5n"
								className="w-full rounded-lg"
								alt="linearalgebra"
							/>
						</div>
					</div>
				</div>
			</div>
		</div>
	);
};

export default Home;
