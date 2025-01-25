# Description: This script demonstrates the various functions of the MCAS ToolBox

# Set the variables
$tenantId = '' ### Paste your tenant ID here
$appId = '' ### Paste your Application ID here
$appSecret = '' ### Paste your Application key here
$resourceAppIdUri = '05a65629-4c1b-48c1-a78b-804c4abdd4af' #Microsoft Cloud App Security
$mcasportalAPI = "" ### Your MCAS Portal API, like https://securecorp.eu2.portal.cloudappsecurity.com

# Get the access token
$oAuthUri = "https://login.microsoftonline.com/$TenantId/oauth2/token"
$authBody = [Ordered] @{
    resource = "$resourceAppIdUri"
    client_id = "$appId"
    client_secret = "$appSecret"
    grant_type = 'client_credentials'
}
$authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
$token = $authResponse.access_token

# Get All the Microsoft Defender for Cloud App Security IP Ranges
Get-MCASIPRanges -McasPortalAPI $mcasportalAPI -Token $token

# Creae IP Ranges in Microsoft Defender for Cloud App Security
$newiprangecsvFilePath = "C:\Dev\Alex\Modules\MCASToolBoxV2\SampleData\mcasip_new.csv"
New-MCASIpRange -CsvFilePath $newiprangecsvFilePath -McasPortalAPI $mcasportalAPI -Token $token -Verbose

# export the IP Ranges in Microsoft Defender for Cloud App Security
$exportiprangecsvFilePath = "C:\Dev\Alex\Modules\MCASToolBoxV2\SampleData\mcasip_export.csv"
Export-MCASIpRange -OutputCsvFilePath $exportiprangecsvFilePath -McasPortalAPI $mcasportalAPI -Token $token -Verbose

# Remove IP Ranges in Microsoft Defender for Cloud App Security
$removeiprangecsvFilePath = "C:\Dev\Alex\Modules\MCASToolBoxV2\SampleData\mcasip_remove.csv"
Remove-MCASIPRange -CsvFilePath $removeiprangecsvFilePath -McasPortalAPI $mcasportalAPI -Token $token -Verbose

# Update IP Ranges in Microsoft Defender for Cloud App Security
$updateiprangecsvFilePath = "C:\Dev\Alex\Modules\MCASToolBoxV2\SampleData\mcasip_update.csv"
Update-MCASIPRange -CsvFilePath $updateiprangecsvFilePath -McasPortalAPI $mcasportalAPI -Token $token -Verbose 

# Generate Microsoft Defender for Cloud App Security IP Ranges Block List
Export-MCASBlocklist -Appliance 'Zscaler (120)' -McasPortalAPI $mcasportalAPI -Token $token




