const QUARTO_PROJECT_OUTPUT_DIR = process.env.QUARTO_PROJECT_OUTPUT_DIR || '_site'

const serviceWorkerPath = `${QUARTO_PROJECT_OUTPUT_DIR}/sw.js`

const getIconifyAPIRequestIcons = (url) => {
	const parsedUrl = new URL(url)
	const result = {
		prefix: '',
		iconNames: []
	}
	
	result.prefix = parsedUrl.pathname.replace('.json', '').substring(1)

	const icons = parsedUrl.searchParams.get('icons')
	if (!icons) {
		return result
	}

	result.iconNames = icons.split(',').map(icon => icon.trim())
	return result
}

const fetchIconifyIcons = async ({prefix, iconNames}) => {
	const iconUrl = `https://api.iconify.design/${prefix}.json?icons=${iconNames.join(',')}`
	return await fetch(iconUrl)
}

const cacheIconifyIcons = async (cache, {prefix, icons}) => {
	const promises = Object.entries(icons).map(async ([iconName, iconData]) => {
		const cacheUrl = `/${prefix}/${iconName}`
		await cache.put(cacheUrl, new Response(JSON.stringify({
			prefix: prefix,
			icons: {
				[iconName]: iconData
			}
		}), {
			headers: {
				'Content-Type': 'application/json',
			}
		}))
	})
	await Promise.all(promises)
}

const iconifyHandler = async ({request}) => {
	const {prefix, iconNames} = getIconifyAPIRequestIcons(request.url)

	const cache = await caches.open('iconify-cache')
	const finalResponse = {
		prefix: prefix,
		icons: {},
	};

	const cacheMisses = []
	const promises = iconNames.flatMap(async (iconName) => {
		const cacheResponse = await cache.match(`/${prefix}/${iconName}`)
		if (!cacheResponse) {
			cacheMisses.push(iconName)
			return []
		}
		const iconData = await cacheResponse.json()
		if (iconData.icons) {
			Object.assign(finalResponse.icons, iconData.icons);
		}
	});

	await Promise.all(promises)

	if (cacheMisses.length > 0) {
		const fetchResponse = await fetchIconifyIcons({prefix: prefix, iconNames: cacheMisses})
		if (fetchResponse && fetchResponse.ok) {
			const iconData = await fetchResponse.json()
			if (iconData.icons) {
				await cacheIconifyIcons(cache, {prefix: prefix, icons: iconData.icons})
				Object.assign(finalResponse.icons, iconData.icons)
			}
		}
	}

	return new Response(JSON.stringify(finalResponse), {
		headers: {
			'Content-Type': 'application/json',
		}
	});
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

	additionalManifestEntries: [
		'https://api.iconify.design/devicon-plain.json?icons=cplusplus',
		'https://api.iconify.design/fa6-brands.json?icons=github',
		'https://api.iconify.design/ph.json?icons=cube-bold,brackets-curly-bold,list-light,function-bold,lightning-bold',
		'https://api.iconify.design/simple-icons.json?icons=blueprint',
	],

	runtimeCaching: [
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
		},
		{
			urlPattern: /^https:\/\/api\.iconify\.design\/\w+\.json\?icons=\w/,
			handler: iconifyHandler,
		},
	]
}