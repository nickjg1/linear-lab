const HomepageCard = ({ title, image, text, pageLink }) => {
	const universalExpr = new RegExp('^(?:[a-z+]+:)?//', 'i');

	// const navigate = useNavigate();
	return (
		<div className="p-[2rem]">
			<a
				className="cursor-pointer group"
				href={pageLink ? `#/${pageLink}` : title ? `#/${title}` : '#/404'}
			>
				<div
					className="max-w-md
						rounded-lg
						overflow-hidden
						bg-offBlack

						border-4
						border-offWhite

						h-full

						hover:scale-105
						transition duration-200
						hover:duration-200"
				>
					<div className="bg-offWhite w-fill aspect-[16/9]">
						<img
							className="h-[100%] object-contain object-center mx-auto"
							src={
								image
									? universalExpr.test(image)
										? image
										: process.env.PUBLIC_URL + image
									: process.env.PUBLIC_URL + '/filler-image.png'
							}
						/>
					</div>

					<div className="px-[2rem] pb-[1rem] text-center">
						{/* <a className='cursor-pointer' href={`#/lessons/${title}`}> */}
						<h4 className="fl text-center">{title}</h4>

						<p className=" text-offWhite text-base w-[100%]">{text}</p>

						<p
							className="mt-auto px-[1rem] py-[0.5rem] my-[0.5rem] rounded bg-offWhite2 text-offBlack mx-auto font-bold
					group-hover:bg-highlight2 transition duration-200 shover:duration-200"
						>
							Check it out!
						</p>
					</div>
				</div>
			</a>
		</div>
	);
};

export default HomepageCard;
