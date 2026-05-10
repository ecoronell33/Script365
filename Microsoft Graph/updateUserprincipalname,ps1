Connect-MgGraph -Scopes "User.ReadWrite.All"

$Users = Import-CSV "C:\CSV\UsersUPN.csv"

foreach ($User in $Users) {
    # 1. Uso de -replace (insensible a mayúsculas/minúsculas) en lugar de .Replace()
    $NewUPN = $User.UserPrincipalName -replace "(?i)@Bluepartner053\.onmicrosoft\.com$", "@solutionit-nu.net.pe"
    
    Write-Host "Actualizando $($User.UserPrincipalName) a $NewUPN..." -ForegroundColor Cyan

    try {
        # 2. Uso del UPN actual en el parámetro -UserId en lugar de $User.Id
        Update-MgUser -UserId $User.UserPrincipalName -UserPrincipalName $NewUPN -ErrorAction Stop
        Write-Host "Éxito." -ForegroundColor Green
    }
    catch {
        # 3. Manejo de errores para que el bucle no se detenga si un usuario falla
        Write-Host "Error al actualizar $($User.UserPrincipalName): $($_.Exception.Message)" -ForegroundColor Red
    }
}
