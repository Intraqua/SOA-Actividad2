#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

int main(void)
{
	DIR *directorio;
	struct dirent *entrada;
	struct stat info;
	int fd;
	char buffer[512];
	ssize_t bytes_escritos;
	
	/* Abrir el directorio actual */
	directorio = opendir(".");
	if (directorio == NULL) {
		fprintf(stderr, "Error al abrir el directorio: %s\n", strerror(errno));
		return 1;
	}
	
	/* Crear el fichero de salida */
	fd = open("/tmp/lista_sz", O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (fd == -1) {
		fprintf(stderr, "Error al crear el fichero: %s\n", strerror(errno));
		closedir(directorio);
		return 1;
	}
	
	/* Recorrer las entradas del directorio */
	errno = 0;
	while ((entrada = readdir(directorio)) != NULL) {
		/* Saltar las entradas especiales . y .. */
		if (strcmp(entrada->d_name, ".") == 0 || strcmp(entrada->d_name, "..") == 0) {
			continue;
		}
		
		/* Obtener información del fichero */
		if (stat(entrada->d_name, &info) == -1) {
			fprintf(stderr, "Error al obtener información de %s: %s\n", 
				entrada->d_name, strerror(errno));
			continue;
		}
		
		/* Verificar que es un fichero regular */
		if (!S_ISREG(info.st_mode)) {
			continue;
		}
		
		/* Formatear la línea con nombre y tamaño */
		snprintf(buffer, sizeof(buffer), "%s %ld\n", entrada->d_name, (long)info.st_size);
		
		/* Escribir en el fichero */
		bytes_escritos = write(fd, buffer, strlen(buffer));
		if (bytes_escritos == -1) {
			fprintf(stderr, "Error al escribir en el fichero: %s\n", strerror(errno));
			close(fd);
			closedir(directorio);
			return 1;
		}
		
		errno = 0;
	}
	
	/* Verificar si readdir terminó por error */
	if (errno != 0) {
		fprintf(stderr, "Error al leer el directorio: %s\n", strerror(errno));
		close(fd);
		closedir(directorio);
		return 1;
	}
	
	/* Cerrar los descriptores */
	if (close(fd) == -1) {
		fprintf(stderr, "Error al cerrar el fichero: %s\n", strerror(errno));
		closedir(directorio);
		return 1;
	}
	
	if (closedir(directorio) == -1) {
		fprintf(stderr, "Error al cerrar el directorio: %s\n", strerror(errno));
		return 1;
	}
	
	return 0;
}
