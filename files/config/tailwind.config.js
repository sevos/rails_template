const defaultTheme = require('tailwindcss/defaultTheme')
const colors = {
  'mint-tulip': { // mint-tulip
    '50': '#f0fafb',
    '100': '#c6ebf1',
    '200': '#b5e3ec',
    '300': '#82cede',
    '400': '#48b0c8',
    '500': '#2c94ae',
    '600': '#277893',
    '700': '#266278',
    '800': '#275263',
    '900': '#244555',
  },
  'morning-glory': { // morning-glory
    '50': '#f0fafb',
    '100': '#d9f3f4',
    '200': '#a5e0e4',
    '300': '#86d3da',
    '400': '#4db8c3',
    '500': '#329ca8',
    '600': '#2c7f8e',
    '700': '#2a6774',
    '800': '#295561',
    '900': '#264953',
  },
  'sail': { //sail
    '50': '#f0f8fe',
    '100': '#ddedfc',
    '200': '#b8dcf9',
    '300': '#9acff6',
    '400': '#6ab5f0',
    '500': '#4797ea',
    '600': '#327bde',
    '700': '#2966cc',
    '800': '#2753a6',
    '900': '#254783',
  },
  gray: {
    '50':  '#FAFCFC',
    '100': '#E4E8EE',
    '200': '#C1C9D0',
    '300': '#A2ABB7',
    '400': '#8892A2',
    '500': '#6B7385',
    '600': '#505669',
    '700': '#3C4055',
    '800': '#2B2E44',
    '900': '#2B2E44',
  },
  teal: {
    '50':  '#EEFDFE',
    '100': '#CFF3FB',
    '200': '#8ED8E9',
    '300': '#62BDE4',
    '400': '#4D9DCE',
    '500': '#277FB5',
    '600': '#1C5B92',
    '700': '#154876',
    '800': '#0F3451',
    '900': '#082530',
  },
  emerald: {
    '50':  '#F2FEEE',
    '100': '#CFF7C9',
    '200': '#91E396',
    '300': '#52D080',
    '400': '#3EB574',
    '500': '#288D60',
    '600': '#216B44',
    '700': '#18533A',
    '800': '#113B34',
    '900': '#0A2627',
  },
  orange: {
    '50':  '#FBF9EA',
    '100': '#F6E4BA',
    '200': '#E7C07B',
    '300': '#DC9742',
    '400': '#CB7519',
    '500': '#AD5102',
    '600': '#893301',
    '700': '#6C2706',
    '800': '#501A0F',
    '900': '#361206',
  },
  cerise: {
    '50':  '#FEF7F4',
    '100': '#FBE0DD',
    '200': '#F2AFB3',
    '300': '#EC798B',
    '400': '#DC5472',
    '500': '#BC3263',
    '600': '#98184D',
    '700': '#73123F',
    '800': '#560E39',
    '900': '#3B0427',
  },
  purple: {
    '50':  '#FEF7FF',
    '100': '#F8DDF4',
    '200': '#E8ADE1',
    '300': '#D882D9',
    '400': '#BF62CF',
    '500': '#9B47B2',
    '600': '#743095',
    '700': '#57237E',
    '800': '#3D1867',
    '900': '#2A0D53',
  },
}

const colorFamily = (family) => {
  return {
    ...family,
    light: family[100],
    lighter: family[50],
    DEFAULT: family[500],
    dark: family[800],
  }
}

module.exports = {
  content: [
    './app/builders/**/*.rb',
    './app/views/**/*.rb',
    './app/components/**/*rb',
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    container: {
      center: true,
      padding: {
        DEFAULT: '1rem',
        sm: '2rem',
        lg: '4rem',
        xl: '5rem',
        '2xl': '6rem',
      },
    },
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        ...colors,
        primary: colorFamily(colors.purple),
        secondary: colorFamily(colors.teal),
      }
    },
    height: theme => ({
      auto: 'auto',
      ...theme('spacing'),
      full: '100%',
      screen: 'calc(var(--vh) * 100)',
      'screen-1/2': 'calc(var(--vh) * 50)',
      'screen-3/5': 'calc(var(--vh) * 60)',
      'screen-2/3': 'calc(var(--vh) * 66.6666666667)',
    }),
    minHeight: theme => ({
      '0': '0',
      ...theme('spacing'),
      full: '100%',
      screen: 'calc(var(--vh) * 100)',
      'screen-1/2': 'calc(var(--vh) * 50)',
      'screen-3/5': 'calc(var(--vh) * 60)',
      'screen-2/3': 'calc(var(--vh) * 66.6666666667)',
    }),
    maxHeight: theme => ({
      '0': '0',
      ...theme('spacing'),
      full: '100%',
      screen: 'calc(var(--vh) * 100)',
      'screen-1/2': 'calc(var(--vh) * 50)',
      'screen-3/5': 'calc(var(--vh) * 60)',
      'screen-2/3': 'calc(var(--vh) * 66.6666666667)',
    }),
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    ({ addVariant, matchVariant }) => {
      addVariant('turbo-native', "html[data-turbo-native-app] &"),
      addVariant('non-turbo-native', "html:not([data-turbo-native-app]) &"),
      matchVariant('bridge-component', (value) => {
        return [
          `[data-bridge-components~="${value}"] &[data-controller="bridge--${value}"]`,
          `[data-bridge-components~="${value}"] [data-controller="bridge--${value}"] &`
        ]
      })
    },
  ]
}
