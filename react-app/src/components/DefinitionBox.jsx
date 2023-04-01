const DefinitionBox = ({ title, content }) => {
	return (
		<div className="text-offBlack flex flex-col p-[0.5rem] md:flex-row  bg-offWhite rounded-lg overflow-hidden my-[1.5rem]">
			<div className="flex items-center justify-center mx-[2rem] my-[1rem]">
				<i class="fa-solid fa-circle-info text-xl mr-[1rem]"></i>
				<p className="font-bold pl-[0.5rem] my-0">{title} </p>
			</div>
			<p className="text-center md:text-left mx-[1rem] mt-0 md:my-[1rem]">
				{content}
			</p>
		</div>
	);
};

export default DefinitionBox;
