#  Primero, se define la ruta donde se guardará el CSV con los datos recogido
$archivo = "$env:USERPROFILE\hardware_monitor_log.csv"

# Para que los decimales usen punto (.) y no rompan el CSV con comas
$culture = [System.Globalization.CultureInfo]::InvariantCulture

# Escribe cabecera solo si el archivo no existe, es decir si existe el archivo, no se ejecuta esta linea
if (-not (Test-Path $archivo)) {
    "Hora,Temperatura CPU (°C),Temperatura GPU (°C),Uso CPU (%),Uso GPU (%),Memoria CPU usada (GiB),Memoria GPU usada (MB)" | Out-File -Encoding UTF8 $archivo
}

#----FUNCIONES-----
#function Get-CpuTemp
#Usa WMI (clase MSAcpi_ThermalZoneTemperature que se alimenta de ACPI (datos de placa base y CPU)) para obtener la temperatura.
#Convierte de décimas de Kelvin a °C.
#Redondea a un decimal.
#Si falla → devuelve "N/A".
function Get-CpuTemp {
    try {
        $t = Get-CimInstance -Namespace "root/wmi" -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction Stop |
             Select-Object -First 1
        if ($null -ne $t -and $t.CurrentTemperature) {
            return [math]::Round(($t.CurrentTemperature - 2732) / 10, 1).ToString("0.0", $culture)
        } else {
            return "N/A"
        }
    } catch {
        return "N/A"
    }
}

#function Get-CpuLoadPercent
#Usa la clase WMI Win32_Processor para leer la carga de CPU en %.
#Si hay varios procesadores/sockets, calcula la media.
#Redondea a un decimal.
#Si falla → "N/A".
function Get-CpuLoadPercent {
    try {
        $avg = Get-CimInstance Win32_Processor -ErrorAction Stop |
               Measure-Object -Property LoadPercentage -Average |
               Select-Object -ExpandProperty Average
        if ($null -ne $avg) {
            return [math]::Round([double]$avg, 1).ToString("0.0", $culture)
        } else {
            return "N/A"
        }
    } catch {
        return "N/A"
    }
}

#function Get-RamUsedGiB
#Consulta Win32_OperatingSystem vía WMI.
#TotalVisibleMemorySize y FreePhysicalMemory vienen en KB.
#Convierte a GiB (división entre 1MB = 1024×1024 KB).
#Calcula memoria usada = total – libre.
#Redondea a 2 decimales.
#Si falla → "N/A".


function Get-RamUsedGiB {
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        # TotalVisibleMemorySize y FreePhysicalMemory vienen en KB -> GiB (KB / 1048576)
        $totalGiB = $os.TotalVisibleMemorySize / 1MB
        $freeGiB  = $os.FreePhysicalMemory     / 1MB
        $usedGiB  = $totalGiB - $freeGiB
        return [math]::Round($usedGiB, 2).ToString("0.00", $culture)
    } catch {
        return "N/A"
    }
}

#function Get-NvidiaStat
#Llama a la herramienta de NVIDIA nvidia-smi para pedir tres métricas:
#Temperatura de la GPU (°C).
#Uso de la GPU (%).
#Memoria usada (MB).
#Procesa la salida (string o array).
#Si hay varios GPUs, coge solo el primero.
#Si falla → "N/A".
function Get-NvidiaStats {
    # Devuelve un objeto con Temp, Util y Mem (MB) como strings o "N/A"
    $result = [ordered]@{
        Temp = "N/A"
        Util = "N/A"
        Mem  = "N/A"
    }
# ---- FIN FUNCIONES ------

    try {
        $nvidiaData = & nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used `
            --format=csv,noheader,nounits 2>$null

        if ($nvidiaData) {
            if ($nvidiaData -is [array]) {
                $first = $nvidiaData[0]
            } else {
                $first = [string]$nvidiaData
            }

            $parts = $first -split ',\s*'
            if ($parts.Count -ge 3) {
                $result.Temp = $parts[0]
                $result.Util = $parts[1]
                $result.Mem  = $parts[2]
            }
        }
    } catch {
        # ignorar; se devuelven "N/A"
    }

    return $result
}

#Loop infinito (while ($true)).
#Obtiene la fecha y hora actual.
#Consulta temperatura, uso y memoria de CPU.
#Consulta temperatura, uso y memoria de GPU NVIDIA.
#Construye una línea en formato CSV.
#La añade al archivo.
#Espera 10 segundos y repite.
while ($true) {
    $hora     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $tempCPU  = Get-CpuTemp
    $usoCPU   = Get-CpuLoadPercent
    $memGiB   = Get-RamUsedGiB

    $gpu      = Get-NvidiaStats
    $tempGPU  = $gpu.Temp
    $usoGPU   = $gpu.Util
    $memGPU   = $gpu.Mem

    # Guardar en CSV
    "$hora,$tempCPU,$tempGPU,$usoCPU,$usoGPU,$memGiB,$memGPU" | Out-File -Append -Encoding UTF8 $archivo

    Start-Sleep -Seconds 10
}
