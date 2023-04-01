const AsideBox = ({ title, content, marginTop = 1 }) => {
	return (
		<aside className="asideBox mt-[2rem]">
			<div className="flex flex-row items-center lg:items-start lg:flex-col">
				<i class="fa-solid fa-circle-info text-blue-400 text-xl mr-[1rem]"></i>
				<h4 className="text-blue-400 my-[0.3rem]">{title}</h4>
			</div>
			<div className=" border-l-[1px] border-blue-400 pl-[1rem]">
				<p>{content}</p>
			</div>
		</aside>
	);
};

export default AsideBox;
