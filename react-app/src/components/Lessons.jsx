import LessonCard from "./LessonCard";

const Lessons = () => {
    const vectorLessons = [
        {
            title: "1. Introduction to Vectors",
            text: "Learn about vectors, their components, and how to use them to solve problems.",
            image: "/images/lessons/featured/vector-lesson.png",
            pageLink: "vectors",
        },
        {},
        {},
        {},
    ];

    const matrixLessons = [
        {
            title: "1. Introduction to Vectors",
            text: "Learn about vectors, their components, and how to use them to solve problems.",
            image: "/images/lessons/featured/vector-lesson.png",
        },
    ];

    return (
        <>
            <div className='w-[90vw] lg:w-[75vw] mx-auto mt-[4rem]'>
                <h2 className='text-center'>Vectors</h2>
                <p className='text-center'>
                    Learn about vectors, their components, and how to use them
                    to solve problems.
                </p>
                {/* TODO: Make this gallery into a component */}
                <div className='flex justify-center flex-wrap grow'>
                    {vectorLessons.map((lesson) => (
                        <LessonCard
                            title={lesson.title}
                            image={lesson.image}
                            text={lesson.text}
                            pageLink={lesson.pageLink}
                        />
                    ))}
                </div>
                <hr />
            </div>

            <div className='w-[90vw] lg:w-[75vw] mx-auto mt-[4rem]'>
                <h2 className='text-center'>Matrices</h2>
                <p className='text-center'>
                    Learn about matrices, their components, and how to use them
                    to solve problems.
                </p>
            </div>
            <div className='flex justify-center w-[90vw] lg:w-[75vw] mx-auto flex-wrap'>
                {matrixLessons.map((lesson) => (
                    <LessonCard
                        title={lesson.title}
                        image={lesson.image}
                        text={lesson.text}
                        pageLink={lesson.pageLink}
                    />
                ))}
            </div>
        </>
    );
};

export default Lessons;
