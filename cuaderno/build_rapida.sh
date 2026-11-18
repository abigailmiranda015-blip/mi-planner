#!/bin/sh
# genera la página de Nota rápida a partir del cuaderno
cd "$(dirname "$0")"
sed -e 's#src="../config.js"#src="../../config.js"#' -e 's#<title>Mi Cuaderno</title>#<title>Nota rápida</title>#' -e 's#content="Mi Cuaderno"#content="Nota rápida"#' index.html > rapida/index.html
