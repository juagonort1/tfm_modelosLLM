# Ruta donde se guardará el log
$archivo = "$env:USERPROFILE\hardware_monitor_log.csv"

# Cabecera del CSV
"Hora,Temperatura CPU (°C),Temperatura GPU (°C),Uso GPU (%),Memoria GPU usada (MB)" | Out-File -Encoding UTF8 $archivo

# Bucle de captura cada 5 segundos
while ($true) {
    # Hora actual
    $hora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Temperatura CPU (por WMI)
    $tempCPU = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" |
        Select-Object -First 1 |
        ForEach-Object { [math]::Round(($_.CurrentTemperature - 2732) / 10, 1) }

    # Temperatura GPU, uso y memoria (requiere driver NVIDIA y nvidia-smi en PATH)
    $nvidiaData = & nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used `
        --format=csv,noheader,nounits 2>$null

    if ($nvidiaData) {
        $parts = $nvidiaData -split ", "
        $tempGPU = $parts[0]
        $usoGPU = $parts[1]
        $memGPU = $parts[2]
    } else {
        $tempGPU = $usoGPU = $memGPU = "N/A"
    }

    # Guardar en CSV
    "$hora,$tempCPU,$tempGPU,$usoGPU,$memGPU" | Out-File -Append -Encoding UTF8 $archivo

    Start-Sleep -Seconds 10
}
