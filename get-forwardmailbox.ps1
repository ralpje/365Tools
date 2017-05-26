function New-MSOLReport
{
  <#
    .SYNOPSIS
    Gets all mailboxes with that forward mail to a different address
    .DESCRIPTION
    This function outputs all mailboxes that forward mail to a different address. You can use this for compliancy checks.  
    .EXAMPLE
    Get-ForwardMailbox
  #>
get-maiblbox | where {$_.ForwardingSMTPAddress -ne $null} | select-object Name, PrimarySMTPAddress, ForwardingSMTPAddress