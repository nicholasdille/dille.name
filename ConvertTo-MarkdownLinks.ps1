$ErrorActionPreference = 'Stop'

Get-ChildItem -Path "$PSScriptRoot\_posts\*.md" | ForEach-Object {
    $Content = Get-Content -Path $_.FullName -Raw

    $Links = @()

    $StartIndex = 0
    while ($true) {
        $StartIndex = $Content.IndexOf('<a ', $StartIndex)
        if ($StartIndex -lt 0) {
            break
        }

        $EndIndex = $Content.IndexOf('</a>', $StartIndex)
        if ($EndIndex -lt 0) {
            throw 'Closing tag not found. Malformed data.'
        }

        $Link = $Content.Substring($StartIndex, $EndIndex - $StartIndex + 4)

        if ($Link -imatch ' name=') {
            break
        }

        $LinkInfo = @{
            File     = $_.FullName
            Link     = $Link
        }

        $LinkTarget = ''
        if ($Link -imatch ' href="([^"]+)"') {
            $LinkTarget = $Matches[1]
            $LinkInfo.Add('Target', $LinkTarget)

        } else {
            throw 'No link target found'
        }

        $LinkText = ''
        if ($Link -imatch '>(.+)</a>') {
            $LinkText = $Matches[1]
            $LinkInfo.Add('Text', $LinkText)

        } else {
            throw 'No link text found'
        }

        $LinkTitle = ''
        if ($Link -imatch ' title="([^"]+)"') {
            $LinkTitle = $Matches[1]
            $LinkInfo.Add('Title', $LinkTarget)
            $LinkInfo.Add('Markdown', ('[{0}]("{1}" {2})' -f $LinkText, $LinkTitle, $LinkTarget))

        } else {
            $LinkInfo.Add('Markdown', ('[{0}]({1})' -f $LinkText, $LinkTarget))
        }

        $Links += [pscustomobject]$LinkInfo

        $StartIndex = $EndIndex
    }

    if ($Links.Count -gt 0) {
        foreach ($LinkInfo in $Links) {
            $LinkInfo
            #$Content = $Content -replace $LinkInfo.Link,$LinkInfo.Markdown
        }

        #$Content
    
        #Set-Content -Value $Content -Path $_.FullName
    }
}