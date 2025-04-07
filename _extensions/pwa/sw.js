const VERSION = '1'
const URLS_TO_CACHE = []

//-----SERVICE WORKER-----

const CACHE_NAME = `site-cache-v${VERSION}`

self.addEventListener('install', event => {
  self.skipWaiting()  // Force immediate activation
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(URLS_TO_CACHE))
      .catch(error => {
        console.error('Cache installation failed:', error)
        throw error
      })
  )
})

// Cache first strategy with network fallback
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(cachedResponse => {
        if (cachedResponse) {
          return cachedResponse
        }
        
        // If the request is not in the cache, we try to fetch it
        return fetch(event.request.clone())
          .then(response => {
            // If the network is available and the response is valid,
            // we save a copy in the cache for future use
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response
            }

            const responseToCache = response.clone()
            return caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache)
                return response
              })
          })
          .catch(() => {
            // Return a fallback response if the network is unavailable
            return caches.match('/index.html')
          })
      })
  )
})

// Update service worker
self.addEventListener('activate', event => {
  event.waitUntil(
    // Remove old caches
    caches.keys().then(cacheNames => {
      return Promise.all([
        self.clients.claim(), // Take control of all open clients
        cacheNames
          .filter(cacheName => cacheName !== CACHE_NAME)
          .map(cacheName => caches.delete(cacheName))
      ])
    })
  )
})