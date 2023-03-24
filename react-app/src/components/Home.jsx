const Home = () => {
	return (
		<div className="bg-black min-h-screen py-32">
			<a href="/lessons">
				<h1 className="text-6xl text-center font-bold tracking-tight mb-8 bg-gradient-to-r from-blue-600 via-green-500 to-indigo-400 hover:bg-gradient-to-l  hover:from-blue-600 hover:via-green-500 hover:to-indigo-400 transition ease-in-out duration-1000 text-transparent bg-clip-text">
					Learn Linear Algebra
				</h1>
			</a>
			<div className="grid gap-8 items-start justify-center">
				<div className="relative group">
					<div className="absolute -inset-0.5 opacity-75 bg-gradient-to-r from-cyan-400 to-teal-600 rounded-lg blur-lg group-hover:opacity-100 transition duration-1000 group-hover:duration-200"></div>
					<a
						href="/lessons"
						className=" relative px-7 py-4 bg-black rounded-lg leading-none divide-x divide-gray-600 flex items-center space-x-5 "
					>
						<span className="flex items-center space-x-5">
							<svg
								xmlns="http://www.w3.org/2000/svg"
								fill="none"
								viewBox="0 0 24 24"
								stroke-width="1.5"
								stroke="currentColor"
								class="w-6 h-6 text-teal-400 -rotate-6"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									d="M15.75 15.75V18m-7.5-6.75h.008v.008H8.25v-.008zm0 2.25h.008v.008H8.25V13.5zm0 2.25h.008v.008H8.25v-.008zm0 2.25h.008v.008H8.25V18zm2.498-6.75h.007v.008h-.007v-.008zm0 2.25h.007v.008h-.007V13.5zm0 2.25h.007v.008h-.007v-.008zm0 2.25h.007v.008h-.007V18zm2.504-6.75h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V13.5zm0 2.25h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V18zm2.498-6.75h.008v.008h-.008v-.008zm0 2.25h.008v.008h-.008V13.5zM8.25 6h7.5v2.25h-7.5V6zM12 2.25c-1.892 0-3.758.11-5.593.322C5.307 2.7 4.5 3.65 4.5 4.757V19.5a2.25 2.25 0 002.25 2.25h10.5a2.25 2.25 0 002.25-2.25V4.757c0-1.108-.806-2.057-1.907-2.185A48.507 48.507 0 0012 2.25z"
								/>
							</svg>
							<span className="pr-6 text-gray-100">Enter The Matrix</span>
						</span>
						<span className="pl-6 text-cyan-400 group-hover:text-gray-100 transition duration-1000 group-hover:duration-200">
							Explore Now &rarr;
						</span>
					</a>
				</div>
			</div>
			<img
				src="https://imgs.search.brave.com/FDVZez-eVaaToLgfDUsPLfDZj8AsstmtCrwAjlQoRZY/rs:fit:474:344:1/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi8yLzJmL0xp/bmVhcl9zdWJzcGFj/ZXNfd2l0aF9zaGFk/aW5nLnN2Zy81MDBw/eC1MaW5lYXJfc3Vi/c3BhY2VzX3dpdGhf/c2hhZGluZy5zdmcu/cG5n"
				className="mx-auto mt-10"
			></img>
		</div>
	);
};

export default Home;
