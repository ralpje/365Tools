function Open-MSOLConnection {
    <#
    .SYNOPSIS
    Finds IP range for given O365 Products to create firewall rules.
    .DESCRIPTION
    Finds IP range for given O365 Products to create firewall rules.
    .EXAMPLE
    get-msolipranges
    #>
    $Office365IPsXml = New-Object System.Xml.XmlDocument
    $Office365IPsXml.Load("https://support.content.office.net/en-us/static/O365IPAddresses.xml")
    $updated = $Office365IPsXml.products.updated
    Write-Output "Last updated: $updated"
    [array]$products = $Office365IPsXml.products.product | Select-Object Name | ogv -PassThru
    foreach ($Product in ($Office365IPsXml.products.product | Where-Object ( {$Products -match $_.Name}) | Sort-Object Name)) {
        $IPv4Ranges = $Product | Select-Object -ExpandProperty Addresslist | Where-Object {$_.Type -eq "IPv4"}
        $IPv4Ranges = $IPv4Ranges | Where-Object {$_.address -ne $null} | Select-Object -ExpandProperty address
        foreach ($Range in $IPv4Ranges) {
            $ProductIPv4Range = New-Object -TypeName psobject -Property @{
                'Product'   = $Product.Name;
                'IPv4Range' = $Range;
            }
            Write-Output $ProductIPv4Range | Select-Object Product, IPv4Range
        }
    }
}