const QUARTO_PROJECT_OUTPUT_DIR = process.env.QUARTO_PROJECT_OUTPUT_DIR || '_site'

const serviceWorkerPath = `${QUARTO_PROJECT_OUTPUT_DIR}/sw.js`

const iconifyAPIHandler = ({request}) => {
	const ICONS_ASSETS_PATH = `assets/icons`

	function getIconifyAPIRequestIcons(url) {
		const result = {
			prefix: '',
			icons: []
		}
		
		const pathSegments = url.pathname.split('/')
		const lastSegment = pathSegments[pathSegments.length - 1]
		result.prefix = lastSegment.replace('.json', '')
		const icons = url.searchParams.get('icons')
		if (!icons) {
			return result
		}

		result.icons = icons.split(',').map(icon => icon.trim())
		return result
	}

	async function fetchLocalIcons(prefix) {
		const baseUrl = location.href.substring(0, location.href.lastIndexOf('/'));
		const iconUrl = `${baseUrl}/${ICONS_ASSETS_PATH}/${prefix}.json`
		return await fetch(iconUrl)
	}
	
	async function iconifyAPIHandlerImpl(request) {
		const parsedUrl = new URL(request.url)

		if (!parsedUrl.pathname.endsWith('.json') || !parsedUrl.searchParams.has('icons')) {
			return new Response('404', { status: 404 })
		}

		const {prefix, icons} = getIconifyAPIRequestIcons(parsedUrl)
		const response = await fetchLocalIcons(prefix)
		if (!response || !response.ok) {
			return new Response('404', { status: 404 })
		}

		const iconData = await response.json()
		if (!iconData || !iconData.icons || Object.keys(iconData.icons).length === 0) {
			return new Response('500', { status: 500 })
		}

		if (icons.length === 0) {
			iconData.icons = {}
			iconData.not_found = [""]
			return new Response(JSON.stringify(iconData), {
				headers: {
					'Content-Type': 'application/json',
				}
			});
		}

		const filteredIcons = {}
		const notFound = []

		for (const requestedIcon of icons) {
			if (iconData.icons[requestedIcon]) {
				filteredIcons[requestedIcon] = iconData.icons[requestedIcon]
			} else {
				notFound.push(requestedIcon)
			}
		}

		iconData.icons = filteredIcons
		iconData.not_found = notFound
		
		return new Response(JSON.stringify(iconData), {
			headers: {
				'Content-Type': 'application/json',
			}
		});
	}

	return iconifyAPIHandlerImpl(request)
}

module.exports = {
	globDirectory: QUARTO_PROJECT_OUTPUT_DIR,
	globPatterns: [
		'**/*.{mp4,jpg,png,mp3,webp,html,json,css,woff,js}'
	],
	swDest: serviceWorkerPath,
	maximumFileSizeToCacheInBytes: 6 * 1024 * 1024,
	skipWaiting: true,
  clientsClaim: true,
	sourcemap: true,

	runtimeCaching: [
		{
			urlPattern: ({request}) => {
				const baseUrl = location.href.substring(0, location.href.lastIndexOf('/'));
				const urlPattern = new RegExp(`^${RegExp.escape(baseUrl)}/iconify/[\\w-]+\\.json`)
				return urlPattern.test(request.url)
	 		},
			handler: iconifyAPIHandler,
		},
		{
			urlPattern: ({request}) => !['video', 'audio'].includes(request.destination),
			handler: 'CacheFirst',
			options: {
				cacheName: 'app-cache',
			},
		},
		{
			urlPattern: ({request}) => ['video', 'audio'].includes(request.destination),
			handler: 'CacheFirst',
			options: {
				cacheName: 'media-cache',
				rangeRequests: true,
			},
		}
	]
}