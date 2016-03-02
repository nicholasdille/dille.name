Get-ChildItem -Path "$PSScriptRoot\_posts\*.md" | ForEach-Object {
    $Content = Get-Content -Path $_.FullName -Raw

    if ($Content -imatch '&#\d+;') {
        Write-Output "$($_.FullName): $($Matches[0])"
        $Content = $Content -replace '&#8220;','"'
        $Content = $Content -replace '&#8221;','"'
        $Content = $Content -replace '&#8217;',"'"
        $Content = $Content -replace '&#8216;',"'"
        $Content = $Content -replace '&#8211;','-'
        $Content = $Content -replace '&#8230;','...'
        $Content = $Content -replace '&#8211;','-'
        $Content = $Content -replace '&#8212;','-'
        $Content = $Content -replace '&#215;','x'
            
        Set-Content -Value $Content -Path $_.FullName
    }
}