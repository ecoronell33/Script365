Habilitar compartir archivos con usuarios externos (no invitados) durante un chat en Microsoft Teams 

 

Primero debemos instalar si tenemos los módulo de Microsoft Teams instalado en el equipo 

 

Install-Module -Name MicrosoftTeams -Force –AllowClobber 

 

Para comprobar que la instalacion fue realizada correctamente, consultaremos si modulo fue instalado. 

 

Get-InstalledModule -Name MicrosoftTeams 

 

Importaremos el módulo para lograr ejecutar los comandos necesarios 

 

Import-Module MicrosoftTeams 

 

Nos conectaremos a Microsoft Teams 

 

Connect-MicrosoftTeams 

 

Ejecutaremos el siguiente comando para habilitar compartir archivos en chats con usuarios externos 

 

Set-CsTeamsFilesPolicy -Identity Global FileSharingInChatswithExternalUsers Enabled 

 

Si deseas comprobar si el atributo de la política global cambio, puedes ejecutar el siguiente comando: 

 

Get-CsTeamsFilesPolicy 

 

Para verificar que usuarios tiene desactivo la caracteristicas de compartir con usuarios externos, ejecutaremos el siguiente comando 

 

Get-CsOnlineUser | Where-Object {$_.TeamsFilesPolicy -ne "Global" -and $_.TeamsFilesPolicy -ne $null} | ForEach-Object { $p = Get-CsTeamsFilesPolicy -Identity $_.TeamsFilesPolicy -ErrorAction SilentlyContinue; if($p.FileSharingInChatswithExternalUsers -eq "Disabled"){ [PSCustomObject]@{Name=$_.DisplayName;UPN=$_.UserPrincipalName;Policy=$_.TeamsFilesPolicy} } } | Format-Table –AutoSize 

 

Este cambio puede demorar en ejecutarse hasta 24 horas luego de aplicarse. 
