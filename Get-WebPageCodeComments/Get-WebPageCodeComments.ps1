<#
.Synopsis
    Search website code content for comments
.DESCRIPTION
    Search website code content for comments
.EXAMPLE
    get-WebPageCodeComments
.EXAMPLE
    get-WebPageCodeComments -OutGridView
#>
function get-WebPageCodeComments
{
    [CmdletBinding()]
    [OutputType([string])]   
    Param
    (
        # http://www.yoursite.com/
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$BaseUri,
        
        # Uri for the SiteMap if known
        [String]
        $siteMap, 

        # Output contents to gridview
        [switch]$OutGridView, 

        # Don't display to console
        [switch]$Silent
    )
    
    Write-Host -ForegroundColor Green "[+]" -NoNewline
    Write-Host -ForegroundColor Yellow " Enumerating webpage comments" 

    $results = @() 

    #$links = (Invoke-WebRequest -UseBasicParsing -uri $SiteMap).link.href
    $links = ( Invoke-WebRequest -UseBasicParsing -uri $BaseUri ).links.href | sort -Unique 

    foreach ($link in $links)
    {  
        if($link.StartsWith('/'))# "http://" -or $link.href -contains "https://")
        {  
            Write-Host -ForegroundColor Green "[+]" -NoNewline
            Write-Host  " Enumerating " -NoNewline
            Write-Host -ForegroundColor Yellow $($baseuri + $link)       

            ##search uri source for comments          

            try
            {
                $response = (Invoke-WebRequest -UseBasicParsing -uri ($baseuri + $link) | select-string -AllMatches  '<!--.*-->').matches.value
            }
            catch [Exception]
            { 
                Write-Host -ForegroundColor Red "`t[*]" -NoNewline
                Write-Host  " $($_.Exception.message)"
            }           

            if($response)
            {
                Write-Host -ForegroundColor Red "`t[-]" -NoNewline
                Write-Host  " Enumerating Comments"

                Write-Host -ForegroundColor Red "`t[-]" -NoNewline
                Write-Host  " Comments found: " -NoNewline
                Write-Host -ForegroundColor yellow $($response.count)
                                  
                foreach($r in $response)
                {
                    $result = "" | Select Uri, Comments
                    
                    If(!$silent)
                    {
                        # return comments to screen
                        Write-Host "`t`t$r"
                    }     
                    
                    $result.uri      = $baseURI + $link
                    $result.Comments = $r 

                    $results += $result 
                }
            } 
            # add comments to array     
        }

        else
        {
            # We don’t want to search these because they may be external links
            #$link.href
            #$results += (Invoke-WebRequest -UseBasicParsing -uri ($link.href) | select-string -AllMatches  '<!--.*-->').matches.value
        }
    } 

    if ($OutGridView)
    {
        $results | Out-GridView
    }
}
