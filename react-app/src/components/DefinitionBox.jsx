const DefinitionBox = ({ title, content }) => {
	return (
		<div className="text-offBlack flex flex-col p-[0.5rem] lg:flex-row  bg-offWhite rounded-lg overflow-hidden my-[1.5rem]">
			<div className="flex items-center justify-center mx-[2rem]">
				<i class="fa-solid fa-circle-info text-xl "></i>
				<p className="font-bold pl-[0.5rem]">{title} </p>
			</div>
			<p>{content}</p>
		</div>
	);
};

export default DefinitionBox;
