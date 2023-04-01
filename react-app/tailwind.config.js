/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./src/**/*.{js,jsx,ts,tsx}"],
    mode: "jit",
    theme: {
        extend: {
            colors: {
                primaryDark: "#322F5C",
                primaryLight: "#0078FF",
                secondLight: "#00E790",
                offBlack: "#150F1E",
                offBlack2: "#262030",
                highlight: "#EE69EA",
                highlight2: "#53A4FF",
                secondaryHighlight: "#FBD877",
                highlightTransparent: "#0078FF55",
                offWhite: "#FFFAEC",
                offWhite2: "#D4E8FF",
            },
            fontFamily: {
                sans: ["Assistant", "sans-serif"],
            },
            aspectRatio: {
                image: "4 / 3",
            },
        },
    },
};
