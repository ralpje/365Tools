function Get-MSOLIPRanges {
    <#
    .SYNOPSIS
    Finds IP range for given O365 Products to create firewall rules.
    .DESCRIPTION
    Finds IP range for given O365 Products to create firewall rules.
    .PARAMETER IPType
    Select which IP type you want to find the ranges for.
    Possible options are IPv4 and IPv6, default is IPv4.
    .EXAMPLE
    Get-MSOLIPRanges
    #>
    [cmdletbinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('IPv4', 'IPv6')]
        [string]$IPType = 'IPv4'
    )
    $Office365IPsXml = New-Object System.Xml.XmlDocument
    $Office365IPsXml.Load("https://support.content.office.net/en-us/static/O365IPAddresses.xml")
    $updated = $Office365IPsXml.products.updated
    Write-Output "Last updated: $updated"
    [array]$Products = $Office365IPsXml.products.product | Sort-Object Name | Out-GridView -PassThru -Title 'Select Product(s)'
    foreach ($Product in $Products) {
        $IPRanges = ($Product | Select-Object -ExpandProperty Addresslist | Where-Object {$_.Type -eq $IPType}) | Where-Object {$_.address -ne $null} | Select-Object -ExpandProperty address
        foreach ($Range in $IPRanges) {
            $ProductIPRange = New-Object -TypeName PSObject -Property @{
                'Product' = $Product.Name;
                'IPRange' = $Range;
            }
            Write-Output $ProductIPRange | Select-Object Product, IPRange
        }
    }
}