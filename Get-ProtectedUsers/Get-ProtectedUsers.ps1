get-aduser -Filter {AdminCOunt -eq 1} -Properties * | select Name, `
  UserPrincipalname, `
  ServicePrincipalNames, `
  WhenCreated, `
  @{name = "pwdlastset"; expression = {[system.datetime]::FromFileTime($_.pwdlastset)}}, `
  @{name = "lastLogon"; expression = {[system.datetime]::FromFileTime($_.LastLogon)}}, `
  @{name = "MemberOf"; expression = {$_.memberof | Get-ADGroup | select name}}, `
  LogonWorkstations | sort pwdlastset 
