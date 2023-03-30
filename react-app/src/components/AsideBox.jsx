const AsideBox = ({ title, content }) => {
	return (
		<aside className="asideBox">
			<i class="fa-solid fa-circle-info text-blue-400 text-xl"></i>
			<h4 className="text-blue-400 mt-[0.3rem]">{title}</h4>
			<div className=" border-l-[1px] border-blue-400 pl-[1rem]">
				<p>{content}</p>
			</div>
		</aside>
	);
};

export default AsideBox;
