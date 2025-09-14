# 📊 Scripts de monitorización (`ficheros_estadisticas/`)

Esta carpeta contiene los scripts utilizados para recopilar estadísticas de **CPU, GPU y memoria**, tanto en **Windows (PowerShell)** como en **Linux (Bash)**.  
Los resultados se guardan en **archivos CSV**, listos para analizar en Excel, Python, R u otras herramientas.
 
---

## ⚙️ Requisitos

### 🔹 Windows (PowerShell)
- Windows PowerShell 5.x o superior.  
- **Docker Desktop** instalado (para `estadisticas_docker_desktop.ps1`).  
- **nvidia-smi** disponible (para capturar métricas de GPU NVIDIA).  

### 🔹 Linux (Bash)
- Shell **Bash**.  
- **Docker** instalado y funcionando (para `stats.sh`).  
- Acceso a `/proc/stat` (disponible en cualquier kernel Linux).  
- Comando `awk` para cálculos en `stats_cortex.sh`.  

---

## ▶️ Ejemplos de uso

### 🪟 Windows – Monitorizar Docker Desktop
```powershell
cd ficheros_estadisticas
.\estadisticas_docker_desktop.ps1
