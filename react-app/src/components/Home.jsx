import HomepageCard from "./HomepageCard";

const Home = () => {
    const Elements = [
        {
            title: "Lessons",
            text: "Learn about vectors, matrices, and more!",
            image: "/images/lessons/featured/vector-lesson.png",
            pageLink: "lessons/vectors",
        },
        {
            title: "Sandbox",
            text: "Experiment with Vectors and Matrices in a visual environment",
            image: "/images/lessons/featured/vector-lesson.png",
            pageLink: "sandbox",
        },
    ];
    return (
        <>
            <h1 className='mt-[6rem]'>Welcome to the Linear Lab</h1>
            <div className='flex justify-center flex-wrap grow'>
                {Elements.map((item) => (
                    <HomepageCard
                        title={item.title}
                        image={item.image}
                        text={item.text}
                        pageLink={item.pageLink}
                    />
                ))}
            </div>
        </>
    );
};

export default Home;
