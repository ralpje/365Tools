function Get-AlternateInfo
{
  <#
    .SYNOPSIS
    Creates a CSV-file with user data from Office 365 with users that don't have their alternate contact information set up.
    .DESCRIPTION
    This function creates a CSV-file with user data fetched from Office 365 that includes users that don't have their alternate information filled in. These alternate information should be filled in so that you can contact users to verify anomalous activity or enable MFA.
    .EXAMPLE
    Get-AlternateInfo -outfile c:\temp\incomplet.csv
    #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $outfile
  )
  $outpath = split-path $outfile
  if (!(test-path $outpath)) {new-item $outpath -ItemType Directory}
  if (!(get-module msonline)) {open-msolconnection}

$licusers = Get-MsolUser | where {$_.isLicensed -eq $true}
$IncompleteUsers = $licusers | where {($_.AlternateEmailAddress -eq $null) -or ($_.AlternateMobilePhones -eq $null)}
$IncompleteUsers | Select-Object DisplayName, UserPrincipalName, AlternateEmailAddress, AlternateMobilePhones | export-csv $outfile -NoTypeInformation
}

