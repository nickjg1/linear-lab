import React from 'react';
import DefinitionBox from './DefinitionBox';
import LessonImage from './LessonImage';

const LessonPage = () => {
	return (
		<div className="article">
			<section>
				<h1>Vectors</h1>
				<DefinitionBox
					title="Definition"
					content="Don't forget that our calculus test is today!"
				/>
				<LessonImage
					src="https://miro.medium.com/v2/resize:fit:1100/format:webp/1*x5k7D6D-uYkFbEVwXSikhw.png"
					caption="This is probably a vector"
					alt="vectorimg"
					figNum={0}
				/>

				<h2>Getting Acquainted with Vectors</h2>
			</section>
			<section>
				<p>
					<i className="highlight">
						Vectors are the fundamental building block of Linear Algebra. All
						concepts in linear algebra
					</i>
					are based on the structure of and operations related to vectors. You
					may have heard of vectors before, but in this lesson, we’ll clarify
					what a vector is in theory, provide conceptual models for
					understanding them, and explore how they might be useful. We’ll
					introduce scalars, expand them to the concept of vectors, and suggest
					three different ways of understanding vectors.
				</p>
			</section>
			<aside>
				<h4>Key Takeaways</h4>
				<ul>
					<li>Vector 1</li>
					<li>Vector 2</li>
					<li>Vector 3</li>
					<p>
						Lorem ipsum dolor sit amet consectetur adipisicing elit.
						Necessitatibus cupiditate consequuntur sequi, adipisci dicta
						sapiente eos sed beatae ducimus! Molestiae amet expedita consectetur
						cupiditate ex sed consequuntur dolorum cum nobis.
					</p>
				</ul>
			</aside>
			<section>
				<h2>Scalars</h2>
				<p>
					Before we can define a vector, we may want to quickly define a
					related, but different kind of value—a scalar. In fact, you are likely
					already very familiar with the concept of a scalar, even if you
					haven’t heard of this word before.
				</p>
				<DefinitionBox
					title="Definition"
					content="A scalar is a magnitude (a numerical value)."
				/>
			</section>
		</div>
	);
};

export default LessonPage;
