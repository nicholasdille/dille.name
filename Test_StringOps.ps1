$Content = @'
aöfgknvwefrdiov weöiovf aöinvcewö <a href="line1href" title="line1title">line1text</a> lösngwrue <a href="line1href2">eljkgnw
söglnfroö</a>
sdflkvlfwgn ewriglöwe dibvwe w einmw <a title="line2title" href="line2href">line2 text</a> efvwsf <a href="line2href2">line2text2</a> grfegvwe
<a href="line3href">line3text</a> wfeww
ldfbnjkl <a href="line4href">line4text</a>
'@

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

    $LinkTarget = ''
    if ($Link -imatch ' href="([^"]+)"') {
        $LinkTarget = $Matches[1]
    }

    $LinkTitle = ''
    if ($Link -imatch ' title="([^"]+)"') {
        $LinkTitle = $Matches[1]
    }

    $LinkText = ''
    if ($Link -imatch '>([^<]+)</a>') {
        $LinkText = $Matches[1]
    }

    [pscustomobject]@{
        Link   = $Link
        Target = $LinkTarget
        Title  = $LinkTitle
        Text   = $LinkText
    }

    $StartIndex = $EndIndex
}