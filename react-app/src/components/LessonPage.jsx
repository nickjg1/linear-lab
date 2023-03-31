import React from 'react';
import AsideBox from './AsideBox';
import DefinitionBox from './DefinitionBox';
import LessonImage from './LessonImage';
var Latex = require('react-latex');

const LessonPage = () => {
	return (
		<div className="article">
			<div className="articleBody">
				<h1>Vectors</h1>
				<p>
					In this lesson, we're going to explore vectors. Vectors are an
					essential mathematical tool that has many applications in science,
					engineering, economics, and more. We'll explore the basic properties
					of vectors, including addition, subtraction, and scalar
					multiplication. We'll also discuss how to find the magnitude and
					direction of a vector and learn how to solve vector problems in two
					and three dimensions. By the end of this lesson, you'll have a solid
					understanding of vectors.
				</p>
				<LessonImage
					src="https://miro.medium.com/v2/resize:fit:1100/format:webp/1*x5k7D6D-uYkFbEVwXSikhw.png"
					caption="This is probably a vector"
					alt="vectorimg"
					figNum={0}
				/>

				<h2>Getting Acquainted with Vectors</h2>
			</div>
			<div className="articleBody">
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
			</div>
			<div className="articleBody">
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
			</div>

			<div className="articleBody">
				<hr />
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
			</div>

			<div className="articleBody">
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
					<em> An example of an arrow vector is given in Figure 2</em>
				</p>
			</div>

			<AsideBox
				title="Note:"
				content="Both the arrow vector and the magnitude and direction vector can be extended to higher dimensions."
			/>

			<div className="articleBody">
				<LessonImage
					src="https://tasty-frill-5f8.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Ffddbb0c1-b73a-40e9-8643-f11eb2d8e022%2FUntitled.png?id=652c4733-7cb9-4d3b-b4a2-3c35f21d61ff&table=block&spaceId=52114063-5293-4fd1-98f0-0f98a42e8d6b&width=1230&userId=&cache=v2"
					caption="An arrow vector. Drag the blue dot to see how the direction and length of the vector change."
					alt="vectorimg"
					figNum={2}
				/>
				<h5>Algebraic Representation:</h5>
				<p>
					The most abstract, but most computationally useful definition is the
					algebraic representation of the vector. To feel confident in linear
					algebra, it is important that one can intuitively grasp this concept.
					To define an algebraic vector, let’s first build off the intuitive
					concept of the arrow vector. Let’s imagine an **arrow vector** sitting
					on a Cartesian plane—or <strong>X-Y plane</strong>—with its{' '}
					<strong>tail</strong>
					end sitting at the <strong>origin,</strong> and the{' '}
					<strong>head</strong> of the arrow sitting elsewhere on the plane. The
					position of the head on the plane can be described by a pair of
					coordinates.{' '}
					<strong>
						These coordinates encode the instructions for reaching the head of
						that vector, starting from it’s tail, which is always on the origin.
					</strong>{' '}
					This means that all vectors can be written as simply a set of
					coordinates. Vectors are typically written with a set of numbers{' '}
					<strong>vertically,</strong> and with brackets around them. Let’s take
					a look at an example of a vector that lives in
					<strong> two-dimensions</strong>.
				</p>
				<LessonImage
					src="https://tasty-frill-5f8.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F1d6298ed-b8b6-4f64-9331-4f4162ed2c61%2FUntitled.png?id=32b3b281-e0d9-4dd9-a4ea-fa7a3cb52aed&table=block&spaceId=52114063-5293-4fd1-98f0-0f98a42e8d6b&width=1230&userId=&cache=v2"
					caption="A 2 dimensional vector represented by the coordinates (-2, 3). "
					figNum={2}
				/>
				<p>
					Let’s say we have a vector described by the coordinates{' '}
					<Latex>
						$\begin&#123;bmatrix&#125;-2 \\ 3 \end&#123;bmatrix&#125;$
					</Latex>
					 (read as the x coordinate is -2, and y coordinate is 3). To reach the
					<strong> head</strong> of the vector, we take{' '}
					<strong>2 steps to the left </strong>
					(represented by the -2) and <strong>3 steps up</strong> (represented
					by the 3). We’ll talk about it more later but notice how in{' '}
					<strong>Interactive Figure 2</strong> you can break the vector up into
					two component vectors along the vertical and horizontal axis. This is
					an important property of vectors, and one we will explore more when we
					discuss <strong>vector addition</strong> and{' '}
					<strong>vector basis</strong> For now, you don’t have to worry about
					it. What if we want a vector that lives in
					<strong> three-dimensions</strong>? We can represent a 3-D vector by
					an ordered
					<strong> triple</strong> of numbers, such as 
					<Latex>
						$\begin&#123;bmatrix&#125;-2 \\ 3 \\ 1 \end&#123;bmatrix&#125;$
					</Latex>
					(Figure 3). The last number in this column now
					<strong> encodes</strong> the <strong>instruction</strong> on where to{' '}
					<strong>move</strong> along the third axis (typically the{' '}
					<strong>Z-axis</strong>) to reach the <strong>tip</strong> of the
					vector.
				</p>

				<LessonImage
					src="https://tasty-frill-5f8.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F25946d1f-7162-4c5c-912f-7ef439898f7e%2FUntitled.png?id=5df3c609-a3cf-41a3-9113-4df596bfab55&table=block&spaceId=52114063-5293-4fd1-98f0-0f98a42e8d6b&width=2000&userId=&cache=v2"
					caption="A 3 dimensional vector represented by the coordinates (-2, 3, 1)."
					figNum={3}
				/>
				<DefinitionBox
					title="Definition"
					content="The dimension of a vector correspoinds to how many elements/values it contains."
				/>

				<h4>Applications of Vectors</h4>
				<p>
					Vectors are used in many different fields and have numerous practical
					applications. Here are a few examples:
					<li>Navigation</li>
					<li>Engineering</li>
					<li>Physics</li>
					<li>Graphics</li>
					<li>Economics</li>
				</p>
			</div>
		</div>
	);
};

export default LessonPage;
