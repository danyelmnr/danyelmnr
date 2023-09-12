$Computers = Get-Content -Path "C:\computadores.txt"

$InstallerPath = "\\172.16.107.22\PowerShell-7.3.5-win-x64.msi"  # Substitua pelo caminho completo do arquivo .msi

foreach ($Computer in $Computers) {
    Write-Host "Instalando o aplicativo no computador: $Computer"
    $Session = New-PSSession -ComputerName $Computer
    
    # testa se a sessao foi aberta normalmente
    if ($Session) {
        
        Invoke-Command -Session $Session -ScriptBlock {
            param($Path)
            Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$Path`" /qn" -Wait
        } -ArgumentList $InstallerPath
 
    }
    Remove-PSSession -Session $Session
}