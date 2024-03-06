# Apuntes de "Desarrollo de Videojuegos 3D"
Copyright 2020-2024 Jesús Torres \<jmtorres@ull.es\>

## Requisitos

Para la generación de la documentación es necesario tener instalado el paquete [Quarto](https://quarto.org/).

## Generación de la documentación

La documentación se genera usando la herramienta de línea de comandos *Quarto*: 

~~~
quarto render --to pdf
~~~

## Solución de problemas

### Imágenes vectoriales

Debido a que el *backend* que utiliza *Quarto* para la generación de PDF no soporta adecuadamente el formato SVG, es necesario exportar los diagramas creados con [diagrams.net](http://diagrams.net) como PDF.

## Estilos

Para ayudar a mantener un estilo consistente a lo largo del tiempo en los diferentes artículos y secciones, se han establecido unas reglas sobre los estilos a aplicar en distintos casos:

 * Aplicación o Paquete de software.
 * *\*término en otro idioma\** o *\*«Videojuego» (2000)»\**.
 * **\*\*Elemento de la GUI\*\***: **\*\*Etiqueta\***, **\*\*Menú\***, **\*\*Submenú\*\***, **\*\*Botón\*\***, **\*\*Icono\*\***, **\*\*Ventana\*\***, **\*\*Interfaz\*\*** o **\*\*Nodo o tipo de Blueprint\*\***.
 * `` `nombre_de_archivo` ``, `` `ruta` ``, `` `VARIABLE_DE_ENTORNO` ``, `` `comando` ``, `` `--argumento` `` `` `método()` ``.
 * Entrada de teclado: `{{< kbd Tecla1+Tecla2+... >}}`.

Estas reglas están basadas en la guía de GNOME para escribir documentación de software.
Respecto a las referencias bibliográficas se sigue la norma Chicago y se incluyen como pie de página.

 * [GNOME Handbook of Writing Software Documentation — 4. DocBook Basics](https://developer.gnome.org/gdp-handbook/stable/docbook.html.en).
 * [The Chicago Manual of Style Online — Notes and Bibliography: Sample Citations](https://www.chicagomanualofstyle.org/tools_citationguide/citation-guide-1.html).
