Param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path = (Get-Location)
    ,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $RemotePath = 'ftp://waws-prod-am2-049.ftp.azurewebsites.windows.net/site/wwwroot'
    ,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [pscredential]
    $Credential
)

if (Test-Path -Path "$PSScriptRoot\Set-StaticAzureWebsite.clixml") {
    $Credential = Import-Clixml -Path "$PSScriptRoot\Set-StaticAzureWebsite.clixml"
}

$Files = Get-ChildItem -Path $Path -Recurse -File

$FtpClient = New-Object -TypeName System.Net.WebClient
$FtpClient.Credentials = $Credential

$Count = $Files.Count
$Index = 1
foreach($File in $Files) {
    Write-Progress -Activity 'Uploading directory' -Status "Processing $Index/$Count" -PercentComplete ($Index/$Count*100)

    $Source = $File.FullName

    $Directory = $File.DirectoryName.Replace($Path, '').Replace('\', '/')
    if ($Directory.Length -gt 1) {
        try {
            $DirectoryUri = '{0}{1}' -f $RemotePath, $Directory
            $makeDirectory = [System.Net.WebRequest]::Create($DirectoryUri)
            $makeDirectory.Credentials = $Credential
            $makeDirectory.Method = [System.Net.WebRequestMethods+FTP]::MakeDirectory
            $makeDirectory.GetResponse() | Out-Null
        } catch {
            #
        }
    }

    $FtpCommand = '{0}{1}/{2}' -f $RemotePath, $Directory, $File.Name

    'Command is {0} and file is {1}' -f $FtpCommand, $Source

    $FtpUri = New-Object -TypeName System.Uri -ArgumentList $FtpCommand
    $FtpClient.UploadFile($FtpUri, $Source)

    ++$Index
}