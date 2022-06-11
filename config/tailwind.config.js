const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],

  theme: {
    screens: {
      'ph': '1px',
      'tabp': '600px',
      'tabl': '900px',
      'dt': '1200px',
      'ws': '1600px'
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
