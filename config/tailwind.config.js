const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],

  theme: {
    screens: {
      'xs': {'max': '599px'},
      'sm': '600px',
      'md': '900px',
      'lg': '1200px',
      'xl': '1600px'
    },

    gradientColorStops: {
      'one': '#5b099b',
      'two': '#4f14f8',
      'three': '#ba0cfb',
    },

    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
