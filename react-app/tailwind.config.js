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
        secondaryHighlight: "#FBD877",
        highlightTransparent: "#0078FF55",
        offWhite: "#FFFAEC",
      },
      fontFamily: {
        sans: ["Assistant", "sans-serif"],
      },
    },
  },
};
