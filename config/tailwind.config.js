module.exports = {
  content: [
    "./src/**/*.{html,js}",
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    "./app/frontend/**/*.{js,vue}",
    './app/views/**/*',
    './app/layouts/**/*',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#003459', 
        secondary: '#F7DBA7', 
        neutral_100: '#00171F', 
        neutral_80: '#242B33', 
        neutral_60: '#667479', 
        neutral_40: '#99A2A5', 
        neutral_20: '#CCD1D2', 
        neutral_10: '#EBEEEF', 
        neutral_00: '#FDFDFD', 
        pink_red: '#FF564F',
        green_light: '#34C759',
        orange_shine: '#FF912C',
        blue_sea: '#00A7E7',
      },
    },
  },
  plugins: [],
}