#!/bin/bash

CONTENEDOR="docker-model-runner"  # Este es el nombre del contenedor por defecto al arrancarse con docker model el nombre es "docker-model-runner"
INTERVALO=10           # Intervalo en segundos para realizar las medidas

echo "Hora,CPU,Memoria" > recursos_mistral.csv # primero exportamos las cabeceras

#Bucle while
#Mientras el contenedor esté en ejecución obtenemos
# Hora
# Obtenemos CPU y memoria usadas a partir del comando docker stats
# esperamos el intervalo definido

while docker ps | grep -q "$CONTENEDOR"; do
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  STATS=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}}" "$CONTENEDOR")
  echo "$TIMESTAMP,$STATS" >> recursos_mistral.csv
  sleep $INTERVALO
done

# Mensaje de parado del contenedor
echo "Contenedor detenido. Monitorización finalizada."
