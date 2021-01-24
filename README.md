# Apuntes de "Desarrollo de Videojuegos 3D"
Copyright 2020 Jesús Torres \<jmtorres@ull.es\>

## Requisitos

Para la generación de la documentación en HTML es necesario instalar las siguientes gemas:

 * asciidoctor
 * asciidoctor-diagram
 * rouge

Para las versiones en PDF y EPUB:

 * asciidoctor-pdf
 * asciidoctor-mathematical
 * asciidoctor-epub (actualmente en pre-release en RubyGems.org)

Y para los tests:

 * html-proofer

Todas las dependencias se pueden instalar fácilmente con *Bundle*:

~~~~
$ bundle config build.nokogiri --use-system-libraries
$ bundle install
~~~~

o a mano con *Gem*:

~~~
$ sudo gem install asciidoctor asciidoctor-diagram asciidoctor-mathematical asciidoctor-pdf rouge
$ sudo gem install asciidoctor-epub3 --pre -- --use-system-libraries
$ sudo gem install html-proofer
~~~ 

Algunas gemas son extensiones nativas o dependen de programas externos, así que es necesario instalar previamente algunos paquetes nativos de los que dependen:

* asciidoctor-diagram:
  * default-jre
  * graphviz

* asciidoctor-epub3 (   )
  * pkg-config
  * libxml2-dev
  * libxslt-dev

* asciidoctor-mathematical (mathematical)
  * bison
  * flex
  * libffi-dev
  * libxml2-dev
  * libgdk-pixbuf2.0-dev
  * libcairo2-dev
  * libpango1.0-dev
  * fonts-lyx
  * cmake

Por ejemplo, en distribuciones derivadas de Debian:

~~~
$ sudo apt install ruby-dev pkg-config libxml2-dev libxslt-dev default-jre graphviz bison flex libffi-dev libgdk-pixbuf2.0-dev libcairo2-dev libpango1.0-dev fonts-lyx cmake
~~~

## Solución de problemas

### Problemas con mathematical

En caso de problemas con `mathematical.so` porque no encuentra `liblasem.so`, puede deberse a haber instalado los paquetes con `bundle install` de forma global, para todo el sistema.
Si *Bundle* no puede escribir en el directorio donde se instalan las gemas, lo hace en un directorio temporal, donde también compila las extensiones, y después pide permiso para ejecutar `sudo` y copiar los archivos a su ubicación definitiva.

En ese caso, la ruta donde `mathematical.so` espera encontrar `liblasem.so` —indicada en RUNPATH en `mathematical.so`— puede que ya no sirva.

La solución más sencilla es desinstalar y volver a instalar nuevamente *mathematical* usando *Gem* en esta ocasión:

~~~
$ sudo gem uninstall mathematical
$ sudo gem install mathematical
~~~