function Get-EmtpyMSOLGroups {
    <#
    .SYNOPSIS
    Displays distribution groups with less then 2 members
    .DESCRIPTION
    This function displays all distribution groups with less then 2 members for administrative purposes.
    .EXAMPLE
    Get-EmptyMSOLGroups
  #>
    $arrgroups = @()
    $groups = get-distributiongroup
    foreach ($group in $groups) {
        $groupmembers = get-distributiongroupmember $group.displayname
        if ($groupmembers.count -lt 2) {
            $properties = @{'Name' = $group.DisplayName;
                'Alias' = $group.Alias
                'Emailaddress' = $group.PrimarySmtpAddress;
                'Type' = $group.GroupType;
                'Members' = $groupmembers.count
            }
            $results = New-Object -TypeName PSObject -Property $properties
            $arrgroups += $results
        }
    }
    write-output $arrgroups
}
