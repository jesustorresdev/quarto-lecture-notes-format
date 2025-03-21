const CACHE_NAME = 'ull-mudv-d3d';

const URLS_TO_CACHE = [
  '/',
  '/index.html',
  '/manifest.json',
  // Añade aquí tus recursos importantes (CSS, JS, imágenes principales, etc.)
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(URLS_TO_CACHE);
    })
  )
})

// Cache first strategy with network fallback
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(cachedResponse => {

        if (cachedResponse) {
          return cachedResponse;
        }
        
        // If the request is not in the cache, we try to fetch it
        return fetch(event.request)
          .then(networkResponse => {
            // If the network is available and the response is valid,
            // we save a copy in the cache for future use
            if (networkResponse && networkResponse.status === 200 && 
                networkResponse.type === 'basic') {
              const responseToCache = networkResponse.clone();
              caches.open(CACHE_NAME)
                .then(cache => {
                  cache.put(event.request, responseToCache);
                });
            }
            
            return networkResponse;
          });
      })
  );
});

// Update service worker
self.addEventListener('activate', event => {
  // Add current cache to the whitelist
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            // Delete the cache if it is not in the whitelist
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});