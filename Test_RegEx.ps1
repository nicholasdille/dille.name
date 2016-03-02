$Content = @'
aöfgknvwefrdiov weöiovf aöinvcewö <a href="line1href" title="line1title">line1text</a> lösngwrue <a href="line1href2">eljkgnw
söglnfroö</a>
sdflkvlfwgn ewriglöwe dibvwe w einmw <a title="line2title" href="line2href">line2 text</a> efvwsf <a href="line2href2">line2text2</a> grfegvwe
<a href="line3href">line3text</a> wfeww
ldfbnjkl <a href="line4href">line4text</a>
'@

$Pattern = '(?im)<a(\s+([^=]+="[^"]+"))+\s*>([^<]+)</a>'
$RegEx = [regex]$Pattern

$Matches = $RegEx.Matches($Content)
$Matches