import LessonCard from './LessonCard';
const Lessons = () => {
	const LessonArr = [
		{
			title: 'vectors',
			image:
				'https://imgs.search.brave.com/FDVZez-eVaaToLgfDUsPLfDZj8AsstmtCrwAjlQoRZY/rs:fit:474:344:1/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi8yLzJmL0xp/bmVhcl9zdWJzcGFj/ZXNfd2l0aF9zaGFk/aW5nLnN2Zy81MDBw/eC1MaW5lYXJfc3Vi/c3BhY2VzX3dpdGhf/c2hhZGluZy5zdmcu/cG5n',
			text: 'Learn about vectors, their components, and how to use them to solve problems.',
		},
	];
	return (
		<div className="flex justify-center py-10">
			{LessonArr.map((lesson) => (
				<LessonCard
					title={lesson.title}
					image={lesson.image}
					text={lesson.text}
				/>
			))}
		</div>
	);
};

export default Lessons;
