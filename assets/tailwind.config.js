// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require("tailwindcss/plugin");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      keyframes: {
        fade: {
          "0%": { opacity: 0.3 },
          "50%": { opacity: 0.8 },
          "100%": { opacity: 0.3 },
        },
      },
      animation: {
        waiting: `fade 1.25s ease-in infinite`,
      },
      fontSize: {
        huge: "10rem",
      },
      colors: {
        gray: {
          900: "#202024",
          800: "#36363C",
          700: "#4B4C55",
          600: "#61626D",
          500: "#777885",
          400: "#8C8E9E",
          300: "#A2A5B6",
          200: "#B8BCCE",
          100: "#CDD3E7",
          50: "#E3EAFF",
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", ["&.phx-no-feedback", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        "&.phx-click-loading",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        "&.phx-submit-loading",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        "&.phx-change-loading",
        ".phx-change-loading &",
      ])
    ),
  ],
};
