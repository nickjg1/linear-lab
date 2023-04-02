import React from "react";

const Sandbox = () => {
    return (
        <div className='relative'>
            <a href='#/sandbox/mockup'>
                <button className='absolute w-[4rem] h-[4rem] bg-offBlack2 top-5 right-5 rounded-full flex items-center hover:bg-primaryDark border-4'>
                    <i class='fa-solid fa-image mx-auto text-[2rem]'></i>
                </button>
            </a>
            <embed
                className='flex flex-col h-[93vh] lg:h-[92vh] w-full'
                src={`${process.env.PUBLIC_URL}/elm/sandbox.html`}
            ></embed>
        </div>
    );
};

export default Sandbox;
