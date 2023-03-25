import { useNavigate } from 'react-router-dom';

const LessonCard = ({ title, image, text }) => {
	const navigate = useNavigate();
	return (
		<div>
			<h1
				className="cursor-pointer text-3xl"
				onClick={() => {
					navigate(title);
				}}
			>
				example
			</h1>
		</div>
	);
};

export default LessonCard;
