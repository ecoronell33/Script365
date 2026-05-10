$pathToCSV = "/home/coronel-laureano/Report_Tagsv14.csv" 
$csv = Import-CSV -path $pathToCSV
 
# Order by Subscription to speed up operation
foreach ($record in $csv | Sort-Object SUBSCRIPTION) {
    # Get the current Azure context, if it differs from the record then switch Subscription
    $currentSub = Get-AzContext
    if ($currentSub.Subscription.Name -ne $record.SUBSCRIPTION) {
        Get-AzSubscription -SubscriptionName $record.SUBSCRIPTION -WarningAction SilentlyContinue | Set-AZContext -WarningAction SilentlyContinue
    }
     
    # Ensure the ResourceId is provided
    if (-not $record.RESOURCEID) {
        Write-Warning "ResourceId is missing for a record in subscription $($record.SUBSCRIPTION)"
        continue
    }

    # Fetch the resource using ResourceId
    try {
        $ResourceGroup = Get-AzResourceGroup -ResourceId $record.RESOURCEID -ErrorAction Stop
    } catch {
        Write-Warning "Failed to get resource with ResourceId - $($record.RESOURCEID)"
        continue
    }
 
    # Create the Tag set, currently it only sets a Tag if it is not empty
    $tagSet = @{}
    if ($record.BUSINESSCRITICALITY -ne "") {
        $tagSet += @{"Business criticality" = $record.BUSINESSCRITICALITY}
    }
 
    # Update the Tags on the Resource, merging with the existing set
    try {
        Update-AzTag -ResourceId $ResourceGroup.ResourceId -Tag $tagSet -Operation Merge
    } catch {
        Write-Warning "Failed to merge tags on resource - $($ResourceGroup.ResourceGroupName)"
        continue
    }
 
    Write-Host -ForegroundColor Green "Set tags on $($ResourceGroup.ResourceGroupName)"
}
