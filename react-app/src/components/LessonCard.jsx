import { useNavigate } from 'react-router-dom';

const LessonCard = ({ title, image, text }) => {
	const navigate = useNavigate();
	return (
		<div className="max-w-sm rounded overflow-hidden hover:shadow-lg border border-gray bg-offWhite">
			<a className="cursor-pointer focus:border-2" href={`#/lessons/${title}`}>
				<img className="w-full " src={image} alt={title} />
			</a>
			<div className="px-[1rem] border-2">
				<a className="cursor-pointer" href={`#/lessons/${title}`}>
					<h4 className="fl text-offBlack">{title}</h4>
				</a>
				<p className="text-gray-400 text-base">{text}</p>
			</div>
		</div>
	);
};

export default LessonCard;
