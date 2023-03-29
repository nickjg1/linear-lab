import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Dropdown from './Dropdown';

const Navbar = () => {
	const navigate = useNavigate();

	const menuToggle = (param) => {
		document.getElementById('menu-toggle').checked = param;
	};

	return (
		<header className="lg:px-16 px-4 bg-offBlack flex flex-wrap lg:justify-start items-center lg:py-2 py-4">
			<div className="flex-1 lg:flex-none">
				<img
					onClick={() => {
						navigate('/');
						menuToggle(false);
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
						<li className="navLi">Dark Mode</li>
					</ul>
				</nav>
			</div>
		</header>
	);
};

export default Navbar;
