import React from "react";

const Sandbox = () => {
    return (
        <div className='relative'>
            <a href='#'>
                <div className='absolute w-[4rem] h-[4rem] bg-offBlack2 top-5 right-5 rounded-full flex items-center hover:bg-primaryDark'>
                    <i class='fa-solid fa-image mx-auto text-[2rem]'></i>
                </div>
            </a>
            <embed
                className='flex flex-col h-[93vh] lg:h-[92vh] w-full'
                src={`${process.env.PUBLIC_URL}/elm/index.html`}
            ></embed>
        </div>
    );
};

export default Sandbox;
