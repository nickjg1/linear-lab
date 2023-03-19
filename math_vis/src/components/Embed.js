import React from "react";

const Embed = () => {
	return (
		<div className="container">
			<embed
				class="embed-responsive-item"
				className="overflow-hidden d-block w-100"
				scrolling="no"
				src="elm/index.html"
				height="550px"
				width="900px"
			></embed>
		</div>
	);
};
export default Embed;
