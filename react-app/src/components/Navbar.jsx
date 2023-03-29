import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Dropdown from './Dropdown';

const Navbar = () => {
	const navigate = useNavigate();

	const menuToggle = (param) => {
		document.getElementById('menu-toggle').checked = param;
	};

	return (
		<header className="lg:px-16 px-4 bg-offBlack flex flex-wrap justify-between lg:justify-start items-center lg:py-2 py-4 border-b-2 ">
			<img
				onClick={() => {
					navigate('/');
					menuToggle(false);
				}}
				className="h-[2rem] pr-[2rem] cursor-pointer"
				src={process.env.PUBLIC_URL + '/flogo.png'}
				alt="logo"
			/>

			<label for="menu-toggle" className="cursor-pointer lg:hidden block">
				<svg
					xmlns="http://www.w3.org/2000/svg"
					fill="none"
					viewBox="0 0 24 24"
					stroke-width="1.5"
					stroke="currentColor"
					class="w-6 h-6"
				>
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
					/>
				</svg>
			</label>
			<input type="checkbox" className="hidden" id="menu-toggle" />

			<div
				className="hidden lg:flex lg:items-centre lg:w-auto w-full"
				id="menu"
			>
				<nav>
					<ul className="lg:flex items-center justify-between text-offWhite pt-4 lg:pt-0">
						<li className="navLi hidden lg:block">
							<Dropdown />
						</li>

						<li
							className="navLi"
							onClick={() => {
								navigate('/sandbox');
								menuToggle(false);
							}}
						>
							Sandbox
						</li>
						<li
							className="navLi lg:hidden block"
							onClick={() => {
								navigate('/lessons');
								menuToggle(false);
							}}
						>
							Lessons
						</li>
					</ul>
				</nav>
			</div>
			<div className="hidden lg:flex lg:ml-auto">
				<ul>
					<li className="hidden  lg:flex lg:items-center lg:">
						<div className="  mt-1 ">
							<div className="cursor-pointer  rounded-full bg-indigo-700 relative shadow-sm">
								<input
									defaultChecked
									type="checkbox"
									name="toggle"
									id="toggle2"
									className="focus:outline-none checkbox w-6 h-6 rounded-full bg-white absolute shadow-sm appearance-none cursor-pointer border border-transparent top-0 bottom-0 m-auto"
								/>
								<label
									htmlFor="toggle2"
									className="toggle-label dark:bg-gray-700 block w-12 h-4 overflow-hidden rounded-full bg-gray-300 cursor-pointer"
								/>
							</div>

							<style>
								{`.checkbox:checked {
								/* Apply class right-0*/
								right: 0;
								}
								.checkbox:checked + .toggle-label {


								background-color: #4c51bf;
								}`}
							</style>
						</div>
						<li className="ml-[1rem]">Dark Mode</li>
					</li>
				</ul>
			</div>
		</header>
	);
};

export default Navbar;
