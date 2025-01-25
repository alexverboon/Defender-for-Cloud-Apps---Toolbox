function Export-MCASIpRange {
    <#
    .SYNOPSIS
        Exports the list of IP Ranges from Microsoft Cloud App Security to a CSV file.
    .DESCRIPTION
        This function fetches the list of IP Ranges from Microsoft Cloud App Security using the MCAS Portal API and exports the data to a CSV file.
    .PARAMETER McasPortalAPI
        The URL of the MCAS Portal API.
    .PARAMETER Token
        The access token for authentication.
    .PARAMETER OutputCsvFilePath
        The path to the output CSV file.
    .EXAMPLE    
        Export-MCASIpRange -McasPortalAPI "https://mymtplab.eu2.portal.cloudappsecurity.com" -Token $token -OutputCsvFilePath "C:\Data\mcas\SampleData\mcasip_export.csv"
        Exports the list of IP Ranges to the specified CSV file.
    #>    
        [CmdletBinding()]
        param (
            # MCAS Portal API URL
            [Parameter(Mandatory = $true)]
            [string]$McasPortalAPI,
            # Access token for authentication
            [Parameter(Mandatory = $true)]
            [string]$Token,
            # Output CSV file path
            [Parameter(Mandatory = $true)]
            [string]$OutputCsvFilePath
        )
        # Define the API endpoint
        $endpoint = "$McasPortalAPI/api/v1/subnet/"
        $headers = @{ 'Authorization' = "Bearer $Token" }
        Write-Host "Fetching subnet data from $endpoint..."
    
        # Fetch the data from the API
        try {
            $response = Invoke-RestMethod -Uri $endpoint -Headers $headers -Method Post
            $iprangesinput = $response.data
        } catch {
            Write-Host "Failed to fetch data from API. Error: $_"
            return
        }
    
        # Process and transform the data
        $exportData = [System.Collections.ArrayList]::new()
        foreach ($range in $iprangesinput) {
            $ipranges = [System.Collections.ArrayList]::new()
            $tags = [System.Collections.ArrayList]::new()
            Foreach ($subnet in $range.subnets)
            {
                [void]$ipranges.Add(
                    @{
                        iprange = $subnet.originalString
                    }
                )
            }
            
            ForEach ($tag in $range.tags)
            {
                [void]$tags.Add(
                    @{
                        tag = $tag.name
                    }
                )
            }
    
            [void]$exportData.Add(
                 [PSCustomObject][ordered]@{
                id            = $range._id
                name          = $range.name
                category      = $range.category
                organization  = $range.organization
                subnets = $ipranges.iprange -join ";"
                tags          = $tags.tag -join ";"
            }
            )
        }
    
        # Convert to a CSV and export
        try {
            $exportData | Export-Csv -Path $OutputCsvFilePath -NoTypeInformation -Force
            Write-Host "Subnets exported successfully to $OutputCsvFilePath"
        } catch {
            Write-Host "Failed to export data to CSV. Error: $_"
        }
    }
    