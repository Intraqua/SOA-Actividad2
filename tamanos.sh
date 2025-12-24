#!/bin/bash

# Asignatura SOA - David Valbuena Segura
# Script tamanos.sh
# Ejecuta lista_size y analiza el fichero /tmp/lista_sz
# Devuelve: espacio total, fichero mas grande y fichero mas pequeño

echo "Ejecutando lista_size..."
echo ""

# Ejecutar el programa lista_size
if [ -x ./lista_size ]; then
	./lista_size
	if [ $? -ne 0 ]; then
		echo "Error al ejecutar lista_size"
		exit 1
	fi
	echo "Programa ejecutado correctamente"
	echo ""
else
	echo "Error: No se encuentra lista_size en el directorio actual o no es ejecutable"
	exit 1
fi

# Procesar el fichero generado
FICHERO_ENTRADA="/tmp/lista_sz"

if [ ! -f "$FICHERO_ENTRADA" ]; then
	echo "Error: No se encuentra el fichero $FICHERO_ENTRADA"
	exit 1
fi

echo "Analizando ficheros..."
echo ""

# Variables para calculos
total_bytes=0
contador=0
fichero_mas_grande=""
tamano_mas_grande=0
fichero_mas_pequeno=""
tamano_mas_pequeno=-1

# Leer el fichero linea por linea
# Esta versión maneja correctamente nombres con espacios
while read -r linea; do
	# Extraer el último campo (el tamaño) y el resto (el nombre)
	tamano="${linea##* }"
	nombre="${linea% *}"
	
	# Verificar que tenemos ambos campos
	if [ -z "$nombre" ] || [ -z "$tamano" ]; then
		continue
	fi
	
	# Verificar que tamano es un número
	if ! [[ "$tamano" =~ ^[0-9]+$ ]]; then
		continue
	fi
	
	# Acumular tamaño total
	total_bytes=$((total_bytes + tamano))
	contador=$((contador + 1))
	
	# Buscar fichero mas grande
	if [ $tamano -gt $tamano_mas_grande ]; then
		tamano_mas_grande=$tamano
		fichero_mas_grande="$nombre"
	fi
	
	# Buscar fichero mas pequeño
	if [ $tamano_mas_pequeno -eq -1 ] || [ $tamano -lt $tamano_mas_pequeno ]; then
		tamano_mas_pequeno=$tamano
		fichero_mas_pequeno="$nombre"
	fi
	
done < "$FICHERO_ENTRADA"

# Calcular tamaños en KB y MB
total_kb=$((total_bytes / 1024))
total_mb=$((total_bytes / 1048576))
tamano_mas_grande_kb=$((tamano_mas_grande / 1024))
tamano_mas_pequeno_kb=$((tamano_mas_pequeno / 1024))

# Mostrar resultados
echo "=========================================="
echo "RESULTADOS DEL ANALISIS"
echo "=========================================="
echo ""
echo "Espacio ocupado por el directorio:"
echo " - Total en bytes: $total_bytes"
echo " - Total en KB: $total_kb"
echo " - Total en MB: $total_mb"
echo ""
echo "Fichero mas grande:"
echo " - Nombre: $fichero_mas_grande"
echo " - Tamaño: $tamano_mas_grande bytes ($tamano_mas_grande_kb KB)"
echo ""
echo "Fichero mas pequeño:"
echo " - Nombre: $fichero_mas_pequeno"
echo " - Tamaño: $tamano_mas_pequeno bytes ($tamano_mas_pequeno_kb KB)"
echo ""
echo "Total de ficheros analizados: $contador"
echo "=========================================="