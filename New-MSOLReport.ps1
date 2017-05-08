function New-MSOLReport
{
  <#
    .SYNOPSIS
    Creates a CSV-file with user data from Office 365
    .DESCRIPTION
    This function creates a CSV-file with user data fetched from Office 365, such as licensing status, mailbox size, etc. 
    .EXAMPLE
    New-MSOLReport -outfile c:\temp\somefile.csv
    .EXAMPLE
    New-MSOLReport -outfile c:\temp\somefile.csv -Verbose
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
  Write-Progress -Id 1 -Activity "Generating MSOL Report" -Status "Starting Inital Query" -PercentComplete 0
  $arrResults = @()
  $starttime = (get-date)
  $users = get-msoluser
  $total = ($users).count
  write-verbose "Getting $total mailboxes"
  Write-Progress -Id 1 -Status "Getting $total mailboxes" -PercentComplete 10 -Activity "Generating MSOL Report"
  $mbx = get-mailbox
  Write-Verbose "Getting mailbox statistics for $total mailboxes. This might take some time."
  Write-Progress -Id 1 -Status "Getting Statistics for $total mailboxes. This might take some time." -PercentComplete 20 -Activity "Generating MSOL Report"
  $statistics = ($mbx | get-mailboxstatistics)
  write-verbose "Starting processing of $total individual mailboxes"
  Write-Progress -Id 1 -Status "Processing individual users" -PercentComplete 60 -Activity "Generating MSOL Report"
  $current = 0
  forEach ( $user in $users ) {
    $current++
    $status = $user.displayname
    Write-Progress -Activity "Processing $total mailboxes" -Status "Processing mailbox $status" -PercentComplete ($current / $total*100) -ParentId 1
    Write-Verbose "Gathering statistics for $status"
    $stats = ($statistics | Where-Object {$_.Displayname -eq $user.DisplayName})
    $properties = @{'Name'=$user.DisplayName;
      'EmailAddress'=$user.UserPrincipalName;
      'Title'=$user.Title;
      'Licensed'=$user.IsLicensed;
      'MobilePhone'=$user.MobilePhone;
      'AlternateEmail'=$user.AlternateEmailAddress;
      'AlternatePhone'=$user.AlternateMobilePhones;
      'LastLogon'=$stats.LastLogonTime;
      'MailboxSize'=$stats.TotalItemSize;
    'DeletedItemSize'=$stats.TotalDeletedItemSize}
    $objResults = New-Object -TypeName PSObject -Property $properties
    $arrResults += $objResults
  }
  Write-Progress -Id 1 -Status "Writing $outfile" -PercentComplete 95 -Activity "Generating MSOL Report"
  $arrResults | Export-CSV -NoTypeInformation -Path $outfile
  $stoptime = (get-date)
  $time = (new-timespan -start $starttime -end $stoptime)
  write-output "Processed $total users in $time, exported to CSV file $outfile."
}