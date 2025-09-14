#!/usr/bin/env bash
# =========================================================
# Script: stats_cortex.sh
# Autor: (tu nombre)
# Descripción:
#   Monitoriza el uso total de CPU en un sistema Linux leyendo
#   directamente del archivo /proc/stat.
#   Guarda los resultados en un archivo CSV con dos columnas:
#   "Segundos" (tiempo transcurrido) y "CPU (%)".
# =========================================================

# Intervalo entre muestras (en segundos)
INTERVALO=10

# Nombre del archivo CSV de salida
SALIDA="cpu_usage.csv"

# Forzar configuración regional C para que los decimales usen "."
LC_ALL=C

# ---------------------------------------------------------
# Función: read_cpu_stat
# Lee de /proc/stat los contadores de CPU desde el arranque.
# Devuelve dos valores:
#   1. Tiempo idle acumulado (reposo)
#   2. Tiempo total acumulado
# ---------------------------------------------------------
read_cpu_stat(){ 
  # Extraemos los campos de la primera línea de /proc/stat
  # Formato: cpu user nice system idle iowait irq softirq steal ...
  read -r _ u n s i iw irq si st _ < /proc/stat

  # Tiempo ocioso total = idle + iowait
  local idle_all=$((i + iw))

  # Tiempo no ocioso = user + nice + system + irq + softirq + steal
  local non_idle=$((u + n + s + irq + si + st))

  # Tiempo total = idle_all + non_idle
  local total=$((idle_all + non_idle))

  # Devolvemos ambos valores (idle y total)
  printf "%s %s\n" "$idle_all" "$total"
}

# ---------------------------------------------------------
# Función: calc_cpu_pct
# Calcula el % de CPU usado entre dos muestras de /proc/stat.
# Parámetros:
#   pi -> idle anterior
#   pt -> total anterior
#   ci -> idle actual
#   ct -> total actual
# Devuelve:
#   Porcentaje de CPU usado en ese intervalo (0.00 - 100.00)
# ---------------------------------------------------------
calc_cpu_pct(){ 
  local pi="$1" pt="$2" ci="$3" ct="$4"

  # Diferencias entre la muestra actual y la anterior
  local dt=$((ct - pt))   # Diferencia en tiempo total
  local di=$((ci - pi))   # Diferencia en tiempo idle

  # Si no hay avance en el tiempo, devolvemos 0.00 para evitar división por cero
  [[ $dt -le 0 ]] && { printf "0.00"; return; }

  # Cálculo: (tiempo no idle / tiempo total) * 100
  # Usamos awk para obtener decimales con precisión
  awk -v t="$dt" -v i="$di" 'BEGIN{printf "%.2f",(t-i)*100.0/t}'
}

# ---------------------------------------------------------
# Cabecera del archivo CSV
# ---------------------------------------------------------
echo "Segundos,CPU (%)" > "$SALIDA"

# ---------------------------------------------------------
# Precalentamiento:
# Leemos dos muestras rápidas para iniciar el cálculo de CPU
# ---------------------------------------------------------
read -r P_I P_T < <(read_cpu_stat)
sleep 0.25
read -r C_I C_T < <(read_cpu_stat)

# Calculamos el primer valor de CPU
CPU="$(calc_cpu_pct "$P_I" "$P_T" "$C_I" "$C_T")"

# Guardamos las últimas muestras como referencia
P_I=$C_I; P_T=$C_T

# ---------------------------------------------------------
# Bucle principal
# ---------------------------------------------------------
# Captura señales INT (Ctrl+C) y TERM para terminar limpiamente
trap 'echo; echo "Finalizado. CSV en: '"$SALIDA"'"; exit 0' INT TERM

contador=0
while :; do
  # Esperamos el intervalo configurado
  sleep "$INTERVALO"

  # Aumentamos el contador de tiempo total transcurrido
  contador=$((contador + INTERVALO))

  # Leemos nueva muestra de /proc/stat
  read -r C_I C_T < <(read_cpu_stat)

  # Calculamos el % de CPU entre las dos muestras
  CPU="$(calc_cpu_pct "$P_I" "$P_T" "$C_I" "$C_T")"

  # Actualizamos valores de referencia
  P_I=$C_I; P_T=$C_T

  # Guardamos resultado en el archivo CSV
  echo "$contador,$CPU" >> "$SALIDA"
done
