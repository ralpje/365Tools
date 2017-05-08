function Get-AdminInfo
{
  <#
    .SYNOPSIS
    Gets information on the administrative users on your tenant, to make sure you comply with Microsoft best practices.
    .DESCRIPTION
    
    .EXAMPLE
    Get-AdminInfo
    #>
  [CmdletBinding()]
if (!(get-module msonline)) {open-msolconnection}
#region Get data
$AdminRole = Get-MsolRole | where {$_.name -like 'Company Administrator'}
$GlobalAdmins = Get-MsolRoleMember -RoleObjectId $adminrole.ObjectId
$GACount = ($GlobalAdmins).count
#endregion

#region Get number of GA's
if ($GACount -eq 1) {Write-Output 'Only one global admin present. As best practice, you should use at least 2 global admin accounts.'} `
elseif ($GACount -gt 5) {Write-Output "There are $GACount global admin accounts. As best practice, you should not have more than 5 global admin accounts."} `
else {Write-Output "There are $GACount global admin accounts. This complies with best practices."}
#endregion

#region Check MFA
Write-Output "You should check the MFA status of all global admins using the Office 365-portal. This check will be included in this script in the near future."
#endregion

#region  Non-global Admins
Write-Output "You should use the portal to check if non-global admin roles are used. As best practice, you should use these roles to minimize risks."
Write-Output "You should check if the users holding non-global admin roles should still be having these priviliges."
Write-Output "These checks will be included in this script in the near future."
#endregion