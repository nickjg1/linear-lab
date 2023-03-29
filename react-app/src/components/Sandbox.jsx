import React from 'react';

const Sandbox = () => {
	return (
		<div>
			<embed
				className="flex flex-col h-[90.65vh] w-full"
				src={`${process.env.PUBLIC_URL}/elm/index.html`}
			></embed>
		</div>
	);
};

export default Sandbox;
