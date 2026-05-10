Connect-MgGraph -Scopes User.ReadWrite.All,Directory.AccessAsUser.All

$passwordProfile = @{

ForceChangePasswordNextSignIn = $true

}

$users = Import-Csv '‪D:\usersprofile.csv'

$users | ForEach-Object {

Write-Host "Updating $($_.UserPrincipalName)" -ForegroundColor Yellow

Update-MgUser -UserId $_.UserPrincipalName -PasswordProfile $passwordProfile
}
