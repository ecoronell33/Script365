# Export path for CSV file
$CSVPath = "C:\CSV\InactiveUsers.csv"

# Parameters
$InactiveUsers = @()

# Connect to Microsoft Graph API
Connect-MgGraph -Scopes "User.Read.All", "AuditLog.Read.All"

# Get properties
$Properties = @(
    'Id',
    'DisplayName',
    'Mail',
    'UserPrincipalName',
    'UserType',
    'AccountEnabled',
    'SignInActivity',
    'CreatedDateTime',
    'AssignedLicenses'
)

# Get all users along with the properties
$Domain = "quimicasuiza.com"
$AllUsers = Get-MgBetaUser -All -Property $Properties | Where-Object { $_.UserPrincipalName -like "*@$Domain" } | Select-Object $Properties

foreach ($User in $AllUsers) {
    $LastSuccessfulSignInDate = if ($User.SignInActivity.LastSuccessfulSignInDateTime) {
        $User.SignInActivity.LastSuccessfulSignInDateTime
    }
    else {
        "Never Signed-in."
    }

    $DaysSinceLastSignIn = if ($User.SignInActivity.LastSuccessfulSignInDateTime) {
        (New-TimeSpan -Start $User.SignInActivity.LastSuccessfulSignInDateTime -End (Get-Date)).Days
    }
    else {
        "N/A"
    }

    # Check if the user is licensed
    $IsLicensed = if ($User.AssignedLicenses) {
        "Yes"
    }
    else {
        "No"
    }

    # Collect data
    if (!$User.SignInActivity.LastSuccessfulSignInDateTime -or (Get-Date $User.SignInActivity.LastSuccessfulSignInDateTime)) {
        $InactiveUsers += [PSCustomObject]@{
            Id                       = $User.Id
            UserPrincipalName        = $User.UserPrincipalName
            DisplayName              = $User.DisplayName
            Email                    = $User.Mail
            UserType                 = $User.UserType
            AccountEnabled           = $User.AccountEnabled
            LastSuccessfulSignInDate = $LastSuccessfulSignInDate
            DaysSinceLastSignIn      = $DaysSinceLastSignIn
            CreatedDateTime          = $User.CreatedDateTime
            IsLicensed               = $IsLicensed

        }
    }
}

# Display data using Out-GridView
$InactiveUsers | Out-GridView -Title "Inactive Users"

# Export data to CSV file
try {
    $InactiveUsers | Export-Csv -Path $CSVPath -NoTypeInformation -Encoding UTF8
    Write-Host "Script completed. Results exported to $CSVPath." -ForegroundColor Cyan
}
catch {
    Write-Host "Error occurred while exporting to CSV: $_" -ForegroundColor Red
}
