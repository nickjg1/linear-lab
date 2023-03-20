import React from "react";
import { Container, Row, Col, Card, Button } from "react-bootstrap";
import Embed from "../Embed";

const Lesson1 = () => {
	return (
		<Container className="mt-5">
			<Row>
				<Col>
					<h1>Learn Linear Algebra</h1>
					<p>
						Linear is a branch of mathematics that deals with linear equations,
						matrices, vectors, and their properties. It has wide applications in
						various fields such as engineering, physics, computer science, and
						more.
					</p>
				</Col>
			</Row>

			<Row className="mt-4">
				<Col md={6} className="mb-4">
					<Card>
						<Card.Img
							variant="top"
							src="https://via.placeholder.com/300x150.png?text=Academy"
						/>
						<Card.Body>
							<Card.Title>Academy</Card.Title>
							<Card.Text>
								Work through a series of lessons to learn about core linear
								algebra concepts. When you're ready, try out some practice
								problems.
							</Card.Text>
							<Button variant="primary">Learn More</Button>
						</Card.Body>
					</Card>
				</Col>

				<Col md={6} className="mb-4">
					<Card>
						<Card.Img
							variant="top"
							src="https://via.placeholder.com/300x150.png?text=Sandbox"
						/>
						<Card.Body>
							<Card.Title>Sandbox</Card.Title>
							<Card.Text>
								Try out some linear algebra concepts in the sandbox. You can
								create matrices, vectors, and more to visualize how they work.
							</Card.Text>
							<Button variant="primary">Learn More</Button>
						</Card.Body>
					</Card>
				</Col>
			</Row>


      <Row className="mt-5">
        <h2 class="pb-2">Start Visualizing</h2>
        <Embed/>
        </Row>

			<Row className="mt-5">
				<Col>
					<h2>Practice Problems</h2>
					<p>
						Practice is essential to mastering linear algebra. Try out these
						problems to solidify your understanding of the concepts.
					</p>
					<Button variant="primary">View Problems</Button>
				</Col>
			</Row>

			<Row className="mt-5">
				<Col>
					<h2>Additional Resources</h2>
					<p>
						Here are some additional resources to help you learn more about
						linear algebra:
					</p>
					<ul>
						<li>
							<a href="#">MIT OpenCourseWare: Linear Algebra</a>
						</li>
						<li>
							<a href="#">Khan Academy: Linear Algebra</a>
						</li>
						<li>
							<a href="#">Linear Algebra Done Right (textbook)</a>
						</li>
					</ul>
				</Col>
			</Row>
		</Container>
	);
};

export default Lesson1;
