module.exports = {
	parser: 'postcss-scss',
	plugins: [
		require('postcss-scss'),
		require('postcss-import'),
		require('tailwindcss'),
		require('autoprefixer'),
	]
}
