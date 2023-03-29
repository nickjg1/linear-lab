import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Dropdown from './Dropdown';

const Navbar = () => {
	const navigate = useNavigate();

	return (
		<header className="lg:px-16 px-6 bg-offBlack flex flex-wrap items-center lg:py-2 py-4 ">
			<div className="flex-1">
				<img
					onClick={() => {
						navigate('/');
					}}
					className="h-[2rem] pr-[2rem] cursor-pointer"
					src={process.env.PUBLIC_URL + '/flogo.png'}
					alt="logo"
				/>
			</div>
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
						<li className="navLi">Dark Mode</li>
						<li
							className="navLi"
							onClick={() => {
								navigate('/sandbox');
							}}
						>
							Sandbox
						</li>
						<li
							className="navLi lg:hidden block"
							onClick={() => {
								navigate('/lessons');
							}}
						>
							Lessons
						</li>

						<li className="navLi hidden lg:block">
							<Dropdown />
						</li>
					</ul>
				</nav>
			</div>
		</header>

		// <nav className="h-[4rem] py-[1rem] relative bg-offBlack flex justify-between px-4 md:px-6 lg:px-16 space-x-10">
		// 	<div className="flex items-center">
		// 		<img
		// 			onClick={() => {
		// 				navigate('/');
		// 			}}
		// 			className="h-[1.5rem] lg:h-[2rem] pr-[2rem] cursor-pointer"
		// 			src={process.env.PUBLIC_URL + '/flogo.png'}
		// 			alt="logo"
		// 		/>
		// 		<ul className="flex space-x-[1rem]">
		// 			<li>
		// 				<Dropdown />
		// 			</li>
		// 			<li className=""></li>
		// 			<li
		// 				className="cursor-pointer"
		// 				onClick={() => {
		// 					navigate('/sandbox');
		// 				}}
		// 			>
		// 				Sandbox
		// 			</li>
		// 		</ul>
		// 	</div>
		// 	<div className="flex items-center">
		// 		<input
		// 			class="mr-3 h-3.5 w-8 appearance-none rounded-[0.4375rem] bg-neutral-300 before:pointer-events-none before:absolute before:h-3.5 before:w-3.5 before:rounded-full before:bg-transparent before:content-[''] after:absolute after:z-[2] after:-mt-[0.1875rem] after:h-5 after:w-5 after:rounded-full after:border-none after:bg-neutral-100 after:shadow-[0_0px_3px_0_rgb(0_0_0_/_7%),_0_2px_2px_0_rgb(0_0_0_/_4%)] after:transition-[background-color_0.2s,transform_0.2s] after:content-[''] checked:bg-primary checked:after:absolute checked:after:z-[2] checked:after:-mt-[3px] checked:after:ml-[1.0625rem] checked:after:h-5 checked:after:w-5 checked:after:rounded-full checked:after:border-none checked:after:bg-primary checked:after:shadow-[0_3px_1px_-2px_rgba(0,0,0,0.2),_0_2px_2px_0_rgba(0,0,0,0.14),_0_1px_5px_0_rgba(0,0,0,0.12)] checked:after:transition-[background-color_0.2s,transform_0.2s] checked:after:content-[''] hover:cursor-pointer focus:before:scale-100 focus:before:opacity-[0.12] focus:before:shadow-[3px_-1px_0px_13px_rgba(0,0,0,0.6)] focus:before:transition-[box-shadow_0.2s,transform_0.2s] focus:after:absolute focus:after:z-[1] focus:after:block focus:after:h-5 focus:after:w-5 focus:after:rounded-full focus:after:content-[''] checked:focus:border-primary checked:focus:bg-primary checked:focus:before:ml-[1.0625rem] checked:focus:before:scale-100 checked:focus:before:shadow-[3px_-1px_0px_13px_#3b71ca] checked:focus:before:transition-[box-shadow_0.2s,transform_0.2s] dark:bg-neutral-600 dark:after:bg-neutral-400 dark:checked:bg-primary dark:checked:after:bg-primary"
		// 			type="checkbox"
		// 			role="switch"
		// 			id="flexSwitchCheckDefault"
		// 		/>
		// 		<ul>
		// 			<li class="hover:cursor-pointer" for="flexSwitchCheckDefault">
		// 				Dark Mode
		// 			</li>
		// 		</ul>
		// 	</div>
		// </nav>
	);
};

export default Navbar;
