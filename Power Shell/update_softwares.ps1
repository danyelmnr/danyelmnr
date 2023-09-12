$Computers = Get-Content -Path "C:\computadores.txt"

#navega pela lista de computadores do arquivo .txt acima
foreach ($Computer in $Computers) {

    # Verifica se a sessão remota foi criada com sucesso
    if ($Session) {
     
        # Se a sessão foi criada, execute o bloco de script remoto
        Invoke-Command -Session $Session -ScriptBlock {           
            
            Write-Host "Verificando a presença do Winget em $Computer"   
           
            # verifica a existência do winget
            if (Get-Command winget -ErrorAction SilentlyContinue) {
                Write-Host "Winget localizado neste computador!"
            }
            else {
                Write-Host "Instalando o Winget no seu Windows!"
                Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
            }
    
            # atualiza os programas com updates disponíveis    
            Write-Host "Identificando atualizações de programas e atualizando..."
            winget upgrade --all --silent
        }

        # Remove a sessão remota apenas se ela existir
        Remove-PSSession -Session $Session
    }
}