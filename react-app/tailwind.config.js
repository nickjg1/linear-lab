/** @type {import('tailwindcss').Config} */
module.exports = {
	content: ['./src/**/*.{js,jsx,ts,tsx}'],
	mode: 'jit',
	theme: {
		extend: {
			colors: {
				primaryDark: '#322F5C',
				primaryLight: '#0078FF',
				secondLight: '#00E790',
				offBlack: '#262030',
				secondLight: '#2F525C',
				highlight: '#2F525C',
				secondaryHighlight: '#FBD887',
				offWhite: '#FFFAEC',
			},
			fontFamily: {
				sans: ['Assistant', 'sans-serif'],
			},
		},
	},
};
