$Tweets = Get-Content -Path "$PSScriptRoot\tweets.csv" -Encoding Ascii `
    | Select-Object -Skip 1 `
    | ConvertFrom-Csv -Delimiter ',' -Header Id, InReplyToStatusId, InReplyToUserId, Timestamp, Source, Text, RetweetedStatusId, RetweetedStatusUserId, RetweetedStatusTimestamp, ExpandedUrls

$Tweets[0]