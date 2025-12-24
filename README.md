# Actividad 2 - Programación en Linux: tamaño de ficheros

**Asignatura:** Sistemas Operativos Avanzados  
**Autor:** David Valbuena Segura  
**Fecha:** Enero 2026

## Descripción

Este proyecto implementa un programa en C para Linux que lista los ficheros del directorio actual con sus tamaños, y un script de bash que analiza los resultados para proporcionar estadísticas sobre el espacio ocupado.

## Contenido del repositorio

- `lista_size.c` - Programa en C que obtiene la lista de ficheros y sus tamaños
- `tamanos.sh` - Script de bash que analiza el fichero generado
- `SOA-Actividad2_David_Valbuena_Segura.docx` - Documentación completa de la actividad

## Requisitos previos

### Instalar GCC (si no está instalado)

Verifica si GCC está instalado:

```bash
gcc --version
```

Si no está instalado, ejecuta:

```bash
sudo apt update
sudo apt install gcc
```

**Alternativa recomendada:** Instalar el paquete completo de herramientas de desarrollo:

```bash
sudo apt install build-essential
```

El paquete `build-essential` incluye:
- gcc (compilador de C)
- g++ (compilador de C++)
- make (herramienta de construcción)
- otras utilidades de desarrollo

## Compilación y ejecución

### Compilar el programa en C

```bash
gcc lista_size.c -o lista_size
```

### Dar permisos de ejecución al script

```bash
chmod +x tamanos.sh
```

### Ejecutar el script

```bash
./tamanos.sh
```

El script ejecutará automáticamente el programa `lista_size` y mostrará:
- Espacio total ocupado por el directorio (en bytes, KB y MB)
- Fichero más grande (nombre y tamaño)
- Fichero más pequeño (nombre y tamaño)
- Total de ficheros analizados

### Ejecutar solo el programa en C

Si quieres ejecutar el programa compilado directamente:

```bash
./lista_size
```

**Nota:** El programa no muestra salida en pantalla. Solo genera el fichero `/tmp/lista_sz` con la lista de ficheros y tamaños.

Para ver el contenido generado:

```bash
cat /tmp/lista_sz
```

Verás algo como:
```
.gitattributes 66
lista_size 16592
lista_size.c 2172
Prueba de archivo con espacios.txt 117
README.md 5009
tamanos.sh 2666
```

## Características técnicas

### Programa en C

El programa `lista_size.c` utiliza las siguientes llamadas al sistema de Linux:

- `opendir()` - Abre el directorio actual
- `readdir()` - Lee las entradas del directorio
- `stat()` - Obtiene información sobre cada fichero
- `open()` - Crea el fichero de salida `/tmp/lista_sz`
- `write()` - Escribe los datos en el fichero
- `close()` y `closedir()` - Cierra los descriptores

**Características destacadas:**
- Control de errores completo en todas las llamadas al sistema
- Uso de tipos de datos de 64 bits para soportar ficheros grandes
- Exclusión de directorios especiales (`.` y `..`)
- Filtrado de ficheros regulares

### Script de bash

El script `tamanos.sh` implementa:

- Verificación de la existencia y ejecutabilidad del programa
- Lectura robusta del fichero de salida (maneja nombres con espacios)
- Cálculo del espacio total ocupado
- Búsqueda del fichero más grande y más pequeño
- Presentación de resultados en formato legible

## Formato de salida

El programa genera un fichero `/tmp/lista_sz` con el siguiente formato:

```
nombre_fichero1 tamaño1
nombre_fichero2 tamaño2
nombre_fichero3 tamaño3
...
```

Cada línea contiene el nombre del fichero, un espacio y el tamaño en bytes.

## Requisitos del sistema

- Sistema operativo: Linux (probado en Ubuntu 24.04)
- Compilador: GCC (GNU Compiler Collection)
- Shell: bash
- Permisos: sudo (solo para instalación de dependencias)

## Solución de problemas

### Error: "gcc: command not found"

Si al compilar aparece este error, instala GCC siguiendo las instrucciones de "Requisitos previos".

### El script muestra errores con nombres de archivo

Si ves errores como `[: Actividad: se esperaba una expresión entera`, significa que tienes archivos con espacios en el nombre. El script actual maneja correctamente este caso, pero asegúrate de usar la versión más reciente del script.

### El programa no genera salida

El programa `lista_size` no muestra nada en pantalla si se ejecuta correctamente. Verifica que se creó el fichero `/tmp/lista_sz`:

```bash
ls -l /tmp/lista_sz
```

### Permisos denegados

Si aparece "Permission denied" al ejecutar el script:

```bash
chmod +x tamanos.sh
./tamanos.sh
```

## Notas técnicas

Este programa ha sido desarrollado siguiendo las mejores prácticas de programación en sistemas UNIX/Linux:

1. **Control de errores exhaustivo:** Todas las llamadas al sistema verifican su valor de retorno
2. **Gestión de recursos:** Todos los descriptores se cierran correctamente, incluso en caso de error
3. **Tipos de datos apropiados:** Uso de `off_t` y `long` para tamaños de ficheros
4. **Mensajes de error descriptivos:** Utilización de `strerror(errno)` para mensajes claros
5. **Script robusto:** Manejo correcto de nombres de fichero con caracteres especiales

## Licencia

Este proyecto es material académico de la asignatura Sistemas Operativos Avanzados.
