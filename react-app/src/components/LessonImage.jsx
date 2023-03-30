const LessonImage = ({ src, caption, alt, figNum }) => {
	return (
		<div className="my-[2rem]">
			<img
				alt={alt}
				src={src}
				className="rounded-lg w-[100%] object-contain "
			/>
			<p>
				<strong>Figure {figNum}:</strong> {caption}
			</p>
		</div>
	);
};

export default LessonImage;
