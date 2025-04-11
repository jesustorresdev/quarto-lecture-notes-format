const QUARTO_PROJECT_OUTPUT_DIR = process.env.QUARTO_PROJECT_OUTPUT_DIR || '_site'

const serviceWorkerPath = `${QUARTO_PROJECT_OUTPUT_DIR}/sw.js`

module.exports = {
	globDirectory: QUARTO_PROJECT_OUTPUT_DIR,
	globPatterns: [
		'**/*.{mp4,jpg,png,mp3,webp,html,json,css,woff,js}'
	],
	swDest: serviceWorkerPath,
	maximumFileSizeToCacheInBytes: 6 * 1024 * 1024,
	skipWaiting: true,
  clientsClaim: true,
	sourcemap: false,

	runtimeCaching: [
		{
			urlPattern: ({request}) => !['video', 'audio'].includes(request.destination),
			handler: 'CacheOnly',
			options: {
				cacheName: 'app-cache',
			},
		},
		{
			urlPattern: ({request}) => ['video', 'audio'].includes(request.destination),
			handler: 'CacheOnly',
			options: {
				cacheName: 'media-cache',
				rangeRequests: true,
			},
		}
	]
}