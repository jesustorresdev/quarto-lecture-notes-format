// START CONFIGURATION
CONFIG = {
  cacheName: 'ull-mudv-d3d',
  urlsToCache: [
    '/',
    '/index.html',
    '/manifest.json',
  ]
}
// END CONFIGURATION

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CONFIG.cacheName)
      .then(cache => {
        return cache.addAll(CONFIG.urlsToCache);
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
              caches.open(CONFIG.cacheName)
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
  const cacheWhitelist = [CONFIG.cacheName];
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