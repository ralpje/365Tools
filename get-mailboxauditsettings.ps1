function Get-MailboxAuditSettings
{
  <#
    .SYNOPSIS
    Display all mailboxes that don't have audit enabled. Gives you the option to enable directly.
    .DESCRIPTION
    This function generates an overview of all mailboxes that don't have auditing enabled. When specifying the -activate switch, auditing will be enabled for those mailboxes with a maximum log age of 365 days.
    .EXAMPLE
    get-mailboxauditsettings
    get-mailboxauditsettings -update
    #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [switch]
    $update
  )
  if (!(get-module msonline)) {open-msolconnection}
#region Set variables
  $mbxs = get-mailbox -resultsize unlimited
  $AuditDisabled = $mbxs | where-object {$_.AuditEnabled -ne $true}
  $DisabledCount = $AuditDisabled.count
#endregion
if ($update) {
  write-output "There are $DisabledCount mailboxes that don't have auditing enabled."
  write-output "Enabling auditing on the following mailboxes:"
  $AuditDisabled
  foreach ($mbx in $AuditDisabled) {set-mailbox $mbx.alias -AuditEnabled $true -AuditLogAgeLimit 365 -Verbose}
  }
if (!($Update)) {
  write-output "There are $DisabledCount mailboxes that don't have auditing enabled."
  if ($DisabledCount -eq 0){
  write-output "The following mailboxes don't have auditing enabled:"
  $AuditDisabled
  write-output "You can manually enable auditing on these mailboxes or run get-mailboxauditsettings -update to enable auditing on all mailboxes"
  }
}
}