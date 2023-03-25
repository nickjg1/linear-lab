import React from 'react';

const Sandbox = () => {
	return (
		<div>
			<embed
				className="w-full min-h-screen"
				src={`${process.env.PUBLIC_URL}/elm/index.html`}
			></embed>
		</div>
	);
};

export default Sandbox;
