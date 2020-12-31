# Apuntes de "Desarrollo de Videojuegos 3D"
Copyright 2020 Jesús Torres \<jmtorres@ull.es\>

## Requisitos

Para la generación de la documentación en HTML es necesario instalar las siguientes gemas:

 * asciidoctor
 * asciidoctor-diagram
 * rouge

Para las versiones en PDF y EPUB:

 * asciidoctor-pdf
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
$ sudo gem install asciidoctor asciidoctor-diagram asciidoctor-pdf rouge
$ sudo gem install asciidoctor-epub3 --pre -- --use-system-libraries
$ sudo gem install html-proofer
~~~ 

Algunas gemas son extensiones nativas o dependen de programas externos, así que es necesario instalar previamente los siguientes paquetes nativos de los que dependen:

 * ruby-dev
 * pkg-config
 * libxml2-dev
 * libxslt-dev
 * default-jre
 * graphviz

Por ejemplo, en distribuciones derivadas de Debian:

~~~
$ sudo apt install ruby-dev pkg-config libxml2-dev libxslt-dev default-jre graphviz
~~~