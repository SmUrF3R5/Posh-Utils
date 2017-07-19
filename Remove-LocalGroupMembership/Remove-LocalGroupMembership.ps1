$GroupName = "TestGroup"

$results = @() 

Write-Host -ForegroundColor Green "[+] " -NoNewline
Write-Host "Retrieving members of: " -NoNewline
Write-Host -ForegroundColor Yellow $GroupName

""

# Using .NET to enumerate local group members

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$contextType = [System.DirectoryServices.AccountManagement.ContextType]::Machine
$context = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList $contextType,$env:COMPUTERNAME
$IdentityType = [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName
$GroupPrincipal = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($context, $IdentityType, $GroupName)

 

#See all attributes
#$GroupPrincipal | gm
#$GroupPrincipal.Members | gm

<#
        PS\> $GroupPrincipal.Members | gm 

           TypeName: System.DirectoryServices.AccountManagement.UserPrincipal

 

        Name                              MemberType    	Definition                                                                                                                                    

        ----                              ---------- ----------                                                                                                                                    

        ChangePassword                    Method     void ChangePassword(string oldPassword, string newPassword)                                                                                   

        Delete                            Method     void Delete()                                                                                                                                  

        Dispose                           Method     void Dispose(), void IDisposable.Dispose()                                                                                                    

        Equals                            Method     bool Equals(System.Object o)                                                                                                                  

        ExpirePasswordNow                 Method     void ExpirePasswordNow()                                                                                                                      

        GetAuthorizationGroups            Method     System.DirectoryServices.AccountManagement.PrincipalSearchResult[System.DirectoryServices.AccountManagement.Principal] GetAuthorizationGroups()

        GetGroups                         Method     System.DirectoryServices.AccountManagement.PrincipalSearchResult[System.DirectoryServices.AccountManagement.Principal] GetGroups(), System.D...

        GetHashCode                       Method     int GetHashCode()                                                                                                                             

        GetType                           Method     type GetType()                                                                                                                                

        GetUnderlyingObject               Method     System.Object GetUnderlyingObject()                                                                                                            

        GetUnderlyingObjectType           Method     type GetUnderlyingObjectType()                                                                                                                 

        IsAccountLockedOut                Method     bool IsAccountLockedOut()                                                                                                                     

        IsMemberOf                        Method     bool IsMemberOf(System.DirectoryServices.AccountManagement.GroupPrincipal group), bool IsMemberOf(System.DirectoryServices.AccountManagement...

        RefreshExpiredPassword            Method     void RefreshExpiredPassword()                                                                                                                  

        Save                              Method     void Save(), void Save(System.DirectoryServices.AccountManagement.PrincipalContext context)                                                    

        SetPassword                       Method     void SetPassword(string newPassword)                                                                                                          

        ToString                          Method     string ToString()                                                                                                                             

        UnlockAccount                     Method     void UnlockAccount()                                                                                                                          

        AccountExpirationDate             Property   System.Nullable[datetime] AccountExpirationDate {get;set;}                                                                                    

        AccountLockoutTime                Property   System.Nullable[datetime] AccountLockoutTime {get;}                                                                                            

        AdvancedSearchFilter              Property   System.DirectoryServices.AccountManagement.AdvancedFilters AdvancedSearchFilter {get;}                                                         

        AllowReversiblePasswordEncryption Property   bool AllowReversiblePasswordEncryption {get;set;}                                                                                             

        BadLogonCount                     Property   int BadLogonCount {get;}                                                                                                                      

        Certificates                      Property   System.Security.Cryptography.X509Certificates.X509Certificate2Collection Certificates {get;}                                                  

        Context                           Property   System.DirectoryServices.AccountManagement.PrincipalContext Context {get;}                                                                     

        ContextType                       Property   System.DirectoryServices.AccountManagement.ContextType ContextType {get;}                                                                     

        DelegationPermitted               Property   bool DelegationPermitted {get;set;}                                                                                                           

        Description                       Property   string Description {get;set;}                                                                                                                 

        DisplayName                       Property   string DisplayName {get;set;}                                                                                                                  

        DistinguishedName                 Property   string DistinguishedName {get;}                                                                                                               

        EmailAddress                      Property   string EmailAddress {get;set;}                                                                                                                

        EmployeeId                        Property   string EmployeeId {get;set;}                                                                                                                  

        Enabled                           Property   System.Nullable[bool] Enabled {get;set;}                                                                                                       

        GivenName                         Property   string GivenName {get;set;}                                                                                                                    

        Guid                              Property   System.Nullable[guid] Guid {get;}                                                                                                             

        HomeDirectory                     Property   string HomeDirectory {get;set;}                                                                                                               

        HomeDrive                         Property   string HomeDrive {get;set;}                                                                                                                    

        LastBadPasswordAttempt            Property   System.Nullable[datetime] LastBadPasswordAttempt {get;}                                                                                        

        LastLogon                         Property   System.Nullable[datetime] LastLogon {get;}                                                                                                    

        LastPasswordSet                   Property   System.Nullable[datetime] LastPasswordSet {get;}                                                                                              

        MiddleName                        Property   string MiddleName {get;set;}                                                                                                                  

        Name                              Property   string Name {get;set;}                                                                                                                         

        PasswordNeverExpires              Property   bool PasswordNeverExpires {get;set;}                                                                                                           

        PasswordNotRequired               Property   bool PasswordNotRequired {get;set;}                                                                                                           

        PermittedLogonTimes               Property   byte[] PermittedLogonTimes {get;set;}                                                                                                         

        PermittedWorkstations             Property   System.DirectoryServices.AccountManagement.PrincipalValueCollection[string] PermittedWorkstations {get;}                                      

        SamAccountName                    Property   string SamAccountName {get;set;}                                                                                                              

        ScriptPath                        Property   string ScriptPath {get;set;}                                                                                                                   

        Sid                               Property   System.Security.Principal.SecurityIdentifier Sid {get;}                                                                                        

        SmartcardLogonRequired            Property   bool SmartcardLogonRequired {get;set;}                                                                                                        

        StructuralObjectClass             Property   string StructuralObjectClass {get;}                                                                                                           

        Surname                           Property   string Surname {get;set;}                                                                                                                      

        UserCannotChangePassword          Property   bool UserCannotChangePassword {get;set;}                                                                                                       

        UserPrincipalName                 Property   string UserPrincipalName {get;set;}                                                                                                           

        VoiceTelephoneNumber              Property   string VoiceTelephoneNumber {get;set;}

#>

 

Write-Host -ForegroundColor Green "[+] " -NoNewline
Write-Host "Machine specific " -NoNewline
Write-Host -ForegroundColor Yellow "Users/Groups"

# Machine/Local Users Only
$GroupPrincipal.Members | where{$_.ContextType -eq 'Machine'} | select SamAccountName, ContextType, StructuralObjectClass | Out-String 

# Domain users Groups Only
Write-Host -ForegroundColor Green "[+] " -NoNewline
Write-Host "Domian specific: " -NoNewline
Write-Host -ForegroundColor Yellow "Users"

$GroupPrincipal.Members | where{$_.ContextType -eq 'Domain' -and $_.StructuralObjectClass  -eq 'User'} | select SamAccountName, ContextType, StructuralObjectClass | out-string

 
# Domain Groups Only
Write-Host -ForegroundColor Green "[+] " -NoNewline
Write-Host "Domian specific: " -NoNewline
Write-Host -ForegroundColor Yellow "Groups"

$GroupPrincipal.Members | where{$_.ContextType -eq 'Domain' -and $_.StructuralObjectClass  -eq 'Group'} | select SamAccountName, ContextType, StructuralObjectClass | out-string
 

# remove accounts from Group
Write-Host -ForegroundColor Green "[+] " -NoNewline
Write-Host "Managing Group Memberships"   

foreach($entry in $GroupPrincipal.GetMembers())
{   

    Write-Host -ForegroundColor Green "`t[+] " -NoNewline
    Write-Host "Checking: " -NoNewline
    Write-Host -ForegroundColor Yellow $($entry.SamAccountName)   

    <#  Edit the if Statement to remove other groups or domain users based
        on whatever properties you want         

        Would get rid of all domain Users from Local Admin Group
        $enrty.ContextType -eq 'Domain' -and $entry.StructuralObjectClass  -eq 'User'
    #> 

    # This will remove All Domain User type accounts from the Selected $GroupName and Remove the "Domain Users" group from $GroupName group

    if( ($entry.ContextType -eq 'Domain' -and $entry.StructuralObjectClass -eq 'user') -or ($entry.SamAccountName -eq 'Domain Users') )
    {
        Write-Host -ForegroundColor Red "`t`t[*] " -NoNewline
        Write-Host "Removing " -NoNewline
        Write-Host -ForegroundColor Yellow $($entry.SamAccountName) -NoNewline
        Write-Host " membership from " -NoNewline
        Write-Host -ForegroundColor Yellow $GroupName
        Try
        {
            $GroupPrincipal.members.Remove($entry) | out-null
            $GroupPrincipal.Save() | Out-Null      
        }
        catch [exception]
        {
            Write-Error "$($_.exception.message)"
        }
    }  
}
