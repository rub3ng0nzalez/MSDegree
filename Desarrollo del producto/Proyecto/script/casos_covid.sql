/* Universidad Galileo
   Maestría en Data Science
   Product Development
   Integrantes: Lilian Rebeca Carrera Lemus
                José Armando Barrios León
				Rubén Dario Gonzalez Moterroso
				Vidal Fortunato
   ------------------------------------------
   Archivo de configuración de base de datos 
   ------------------------------------------
*/

CREATE DATABASE IF NOT EXISTS Mapamundi;
USE Mapamundi;

/* --------------------------------------
   Creación de estructura de la base de datos
 --------------------------------------*/
# Información de casos acumulados
CREATE TABLE IF NOT EXISTS casos_covid(
    Pais                VARCHAR(50),
    Estado              VARCHAR(50),
    Latitud                 FLOAT,
    Longitud                FLOAT,
    Fecha   			DATE,
	Confirmados 		INT, 
	Recuperados 		INT, 
	Fallecidos 			INT
);

TRUNCATE TABLE casos_covid; 