function Get-ServiceAccountInfo
{
    get-aduser -Filter {AdminCOunt -eq 1} -Properties * | `
        select Name, `
        WhenCreated, `
        @{name = "pwdlastset"; expression = {[system.datetime]::FromFileTime($_.pwdlastset)}}, `
        @{name = "lastLogon"; expression = {[system.datetime]::FromFileTime($_.lastLogon)}} | sort pwdlastset
} 
