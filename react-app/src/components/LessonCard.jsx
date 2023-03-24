import { Link } from 'react-router-dom';

const LessonCard = ({ title, image, text }) => {
	return (
		<div class="max-w-sm bg-white border border-gray-200 rounded-lg shadow-xl dark:bg-gray-800 dark:border-gray-700">
			<a href={title}>
				<img class="rounded-t-lg" src={image} alt="" />
			</a>
			<div class="p-5">
				<a href={title}>
					<h5 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white capitalize">
						{title}
					</h5>
				</a>
				<p class="mb-3 font-normal text-gray-700 dark:text-gray-400">{text}</p>
				<a
					href={title}
					class="inline-flex capitalize items-center px-3 py-2 text-sm font-medium text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
				>
					Learn {title} &rarr;
				</a>
			</div>
		</div>

		//create a card with the title, image, and content
		//use the Link component to link to the lesson page
	);
};

export default LessonCard;
