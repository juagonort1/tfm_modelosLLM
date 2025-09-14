# 📊 Scripts de monitorización (`ficheros_estadisticas/`)

Esta carpeta contiene los scripts utilizados durante el desarrollo del TFM para recopilar las diferentes estadísticas de interés  tanto en **Windows (PowerShell)** como en **Linux (Bash)**.  Los resultados se guardan en **archivos CSV**.
 
---

## ⚙️ Requisitos Windows
- **Windows PowerShell** 5.x o superior.  
- **Docker Desktop** instalado (para `estadisticas_docker_desktop.ps1`).  
- **nvidia-smi** disponible (para capturar métricas de GPU NVIDIA).
### ▶️ Comandos de ejecución
- **estadisticas_docker_desktop.ps1** powershell -ExecutionPolicy Bypass -File C:\Ruta\al\fichero\estadisticas_docker_desktop.ps1
- **estadisticas_docker_model_so_anfitrion.ps1** powershell -ExecutionPolicy Bypass -File C:\Ruta\al\fichero\estadisticas_docker_model_so_anfitrion.ps1
 
## ⚙️ Requisitos Linux - Ubuntu 22.04
- Shell **Bash**.  
- **Docker** instalado y funcionando (para `stats.sh`).  
- Acceso a `/proc/stat` (disponible en cualquier kernel Linux).  
- Comando `awk` para cálculos en `stats_cortex.sh`.
- Permisos de ejecución   
### ▶️ Comandos de ejecución
- **stats.sh** ./stats.sh
- **stats_cortex.sh** ./stats_cortex.sh  
---


