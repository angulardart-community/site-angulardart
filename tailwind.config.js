module.exports = {
	mode: 'jit',
  purge: [
    './_includes/**/*.html',
    './_layouts/**/*.html',
    './**/**.md',
    './**/**/**.md',
    './**/**/**/**.md',
    './**/**/**/**/**.md',
    './_posts/*.md',
    './*.html',
  ],
  darkMode: false,
  theme: {
    extend: {},
  },
  variants: {},
}
