#Busqueda de registros de actividades relacionadas a Microsoft Teams

$results = Search-UnifiedAuditLog
StartDate (Get-Date). AddDays (-30)
-EndDate (Get-Date)
-RecordType MicrosoftTeams
-FreeText
-ResultSize 5000

# Creación de tabla de acuerdo a la consulta de eventos de auditoria de Microsoft Teams
$results | ForEach-Object {
$audit = $_. AuditData | ConvertFrom-Json
[pscustomobject]@{
CreationDate = $_. CreationDate
UserIds = $_. UserIds
Operations = $_. Operations
ClientIP = $audit.ClientIP
DisplayName = ($audit. Attendees | Select-Object -First 1).DisplayName
   }

 } | Format-Table -AutoSize
