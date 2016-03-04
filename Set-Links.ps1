Get-ChildItem -Path "$PSScriptRoot\_posts\*.md" -Recurse -File | ForEach-Object {
    $Content = Get-Content -Path $_.FullName

    $Content = $Content | Foreach-Object {
        
        <#if ($_ -match 'permalink: (/20.+)') {
            $_ = 'permalink: /blog{0}' -f $Matches[1]
        }#>
        
        #$_ = $_ -replace '/blog/blog/blog','/blog'
        
        #$_ = $_ -replace '{{ site.baseurl }}','/blog'
        
        #$_ = $_ -replace '/blog/wp-content/uploads','/assets'
        
        $_ = $_ -replace '/assets/','/media/'
        
        $_
    }
    
    Set-Content -Value $Content -Path $_.FullName
}