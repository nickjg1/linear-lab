import React from 'react';
import AsideBox from './AsideBox';
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
				<p>
					A scalar is a magnitude. A magnitude is just a{' '}
					<i className="highlight">
						value that measures a quantity, or, more simply, a magnitude is a
						number.
					</i>
					To make this apparent, we can consider some common examples of
					scalars: Speed, mass, length, age, and time are all numerical values
					that measure a quantity. Many of the numbers you are familiar with can
					be considered a kind of scalar, containing a certain value.
				</p>
				<hr />
			</section>
			<AsideBox
				title="Here is some more info:"
				content="Lorem ipsum dolor sit amet consectetur adipisicing elit. Necessitatibus cupiditate consequuntur sequi, adipisci dicta sapiente eos sed beatae ducimus! Molestiae amet expedita consectetur cupiditate ex sed consequuntur dolorum cum nobis."
			/>
			<section>
				<h2>Vectors</h2>
				<h4>What is a Vector?</h4>
				<p>
					Notice how scalars do not have a definite direction. Although the
					direction may be implicit based on context or conversation, 50km/h is
					the same whether you are travelling East or West. What if it is
					important to be more specific?{' '}
					<i>
						If we couple the magnitude of a scalar with a definite direction, we
						have now created a new type of value, the vector.
					</i>
				</p>
				<DefinitionBox
					title="Definition"
					content="A vector is an object that has both a magnitude (size) and direction."
				/>
				<p>
					There are numerous ways of describing vectors, however we will
					describe three of the most common descriptions, the last of which will
					be the basis of computations done in linear algebra. It is important
					to note that while each representation is different, they all describe
					what a vector is. Each one should be used as a tool, depending on what
					bests promotes understanding.
				</p>
				<h4>Three methods of representing vectors</h4>
				<h5>Magnitude and Direction Representation:</h5>
				<p>
					Building off our earlier example with scalars, how could we use
					vectors to differentiate 50km/h travelling East or travelling West?
					When communicating with our friend, we might say “That car is
					travelling 50km/h West.” This lends itself well to a representation of
					a vector. We can specify the magnitude, and then in brackets indicate
					the direction. For example: 50 km/h [West] or 9.8 N [down] (this is
					the gravitational ‘weight’ of a 1kg object on Earth). This
					representation is commonly used when studying physics. We will not use
					this definition often when studying linear algebra, but it is useful
					to know.
				</p>
				<h5>Arrow Representation:</h5>
				<p>
					A highly intuitive representation of a vector, which we will use
					extensively throughout our lessons, is that of an arrow. The length of
					the arrow represents the magnitude of the vector, and the direction it
					is facing (from tail to head) indicates the direction of the vector.
					<em>An example is given in Figure 2</em>
				</p>
				<LessonImage
					src="https://tasty-frill-5f8.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Ffddbb0c1-b73a-40e9-8643-f11eb2d8e022%2FUntitled.png?id=652c4733-7cb9-4d3b-b4a2-3c35f21d61ff&table=block&spaceId=52114063-5293-4fd1-98f0-0f98a42e8d6b&width=1230&userId=&cache=v2"
					caption="An arrow vector. Drag the blue dot to see how the direction and length of the vector change."
					alt="vectorimg"
					figNum={2}
				/>
			</section>
		</div>
	);
};

export default LessonPage;
