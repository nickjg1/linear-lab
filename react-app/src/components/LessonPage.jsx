import React from 'react';
import DefinitionBox from './DefinitionBox';

const LessonPage = () => {
	return (
		<div className="w-[90%] lg:w-2/3 mx-auto">
			<h1>Vectors</h1>
			<DefinitionBox
				title="Definition"
				content="Don't forget that our calculus test is today!"
			/>
			<DefinitionBox
				title="Example"
				content="Don't forget that our calculus test is today!"
			/>
		</div>
	);
};

export default LessonPage;
