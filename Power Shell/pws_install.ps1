# Verifica se o PowerShell já está instalado
if ($PSVersionTable.PSEdition -eq 'Desktop' -and $PSVersionTable.PSVersion.Major -ge 5) {
    Write-Host "O PowerShell já está instalado."
} else {
    # Define o nome do arquivo de instalação
    $installerFile = "PowerShell-latest-win-x64.msi"

    # Define o URL para baixar o arquivo de instalação
    $downloadUrl = "https://github.com/PowerShell/PowerShell/releases/latest/download/$installerFile"

    # Define o local onde o arquivo será salvo temporariamente
    $tempFile = "$env:TEMP\$installerFile"

    # Baixa o arquivo de instalação
    Write-Host "Baixando o arquivo de instalação do PowerShell..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

    # Instala o PowerShell usando o arquivo de instalação
    Write-Host "Instalando o PowerShell..."
    Start-Process -Wait -FilePath msiexec.exe -ArgumentList "/i `"$tempFile`" /quiet"

    # Verifica se a instalação foi concluída com sucesso
    if ($LASTEXITCODE -eq 0) {
        Write-Host "A instalação do PowerShell foi concluída com sucesso."
    } else {
        Write-Host "Ocorreu um erro durante a instalação do PowerShell."
    }

    # Remove o arquivo de instalação temporário
    Remove-Item -Path $tempFile -Force
}

Invoke-Command 




