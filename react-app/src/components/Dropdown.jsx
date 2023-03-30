import { Menu, Transition } from "@headlessui/react";
import { ChevronDownIcon } from "@heroicons/react/20/solid";
import { Fragment } from "react";

function classNames(...classes) {
    return classes.filter(Boolean).join(" ");
}

function attributes(active) {
    return {
        className: classNames(
            active ? "bg-secondaryHighlight text-offBlack" : "text-offBlack2",
            "block px-4 py-2 text-sm"
        ),
    };
}

function menuItem(title = "", link = "#") {
    return (
        <Menu.Item>
            {({ active }) => (
                <a href={link} className={attributes(active).className}>
                    {title}
                </a>
            )}
        </Menu.Item>
    );
}

export default function Navbar() {
    return (
        <Menu
            as='div'
            className='relative inline-block text-left mr-[1rem] lg:mr-0'
        >
            <div>
                <Menu.Button className='inline-flex font-sans w-full justify-center gap-x-1  '>
                    Lessons
                    <ChevronDownIcon className='mt-1 w-5 group-hover:text-gray-400' />
                </Menu.Button>
            </div>

            <Transition
                as={Fragment}
                enter='transition ease-out duration-100'
                enterFrom='transform opacity-0 scale-95'
                enterTo='transform opacity-100 scale-100'
                leave='transition ease-in duration-75'
                leaveFrom='transform opacity-100 scale-100'
                leaveTo='transform opacity-0 scale-95'
            >
                <Menu.Items className='absolute z-10 mt-3 -right-5 w-[7rem] origin-top-right rounded-md bg-offWhite shadow-lg ring-2 ring-offBlack ring-opacity-5 focus:outline-none'>
                    <div className='py-1'>
                        {menuItem("Vectors", "#/lessons/vectors")}
                        {menuItem("Matrices", "#/lessons/matrices")}
                        {menuItem("All Lessons", "#/lessons")}
                    </div>
                </Menu.Items>
            </Transition>
        </Menu>
    );
}
