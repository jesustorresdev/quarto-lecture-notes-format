const CACHE_NAME = 'ull-mudv-d3d';

// Archivos a cachear inicialmente
const urlsToCache = [
  '/',
  '/index.html',
  '/manifest.json',
  '/site_libs/bootstrap/bootstrap.min.css',
  '/site_libs/quarto-html/quarto.js',
  // Añade aquí tus recursos importantes (CSS, JS, imágenes principales, etc.)
];

// Instalación del Service Worker
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(urlsToCache);
      })
  );
});

// Estrategia de caché: Network First con fallback a caché
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request)
      .then(response => {
        // Si la respuesta es válida, la clonamos y la guardamos en caché
        if (response && response.status === 200) {
          const responseToCache = response.clone();
          caches.open(CACHE_NAME)
            .then(cache => {
              cache.put(event.request, responseToCache);
            });
        }
        return response;
      })
      .catch(() => {
        // Si falla la red, intentamos recuperar de caché
        return caches.match(event.request);
      })
  );
});

// Actualización del Service Worker
self.addEventListener('activate', event => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            // Elimina caches antiguos
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});