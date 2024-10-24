<?php
$queries = array();
parse_str($_SERVER['QUERY_STRING'], $queries);

if (!array_key_exists('resource', $queries)) {
    header("HTTP/1.1 400 Bad Request");
    echo 'resource parameter missing';
    exit();
}
if (count($queries) > 1) {
    header("HTTP/1.1 400 Bad Request");
    echo 'more parameters than resources found';
    exit();
}

$accounts = array(
    "acct:nicholas@dille.name" => array(
        "subject" => "acct:nicholasdille@freiburg.social",
        "aliases" => array(
            "https://freiburg.social/@nicholasdille",
            "https://freiburg.social/users/nicholasdille"
        ),
        "links" => array(
            array(
                "rel" => "http://webfinger.net/rel/profile-page",
                "type" => "text/html",
                "href" => "https://freiburg.social/@nicholasdille"
            ),
            array(
                "ref" => "self",
                "type" => "application/activity+json",
                "href" => "https://freiburg.social/users/nicholasdille"
            ),
            array(
                "rel" => "http://ostatus.org/schema/1.0/subscribe",
                "template" => "https://freiburg.social/authorize_interaction?uri={uri}"
            ),
            array(
                "rel" => 'self',
                "type" => 'application/activity+json',
                "href" => 'https://freiburg.social/users/nicholasdille'
            ),
            array(
                "rel" => 'http://schemas.google.com/g/2010#updates-from',
                "href" => 'https://freiburg.social/@nicholasdille',
                "type" => 'application/activity+json',
            ),
            array(
                "rel" => "http://webfinger.net/rel/avatar",
                "type" => "image/jpeg",
                "href" => "https://dille.name/nicholas.jpg"
            ),
            array(
                "rel" => "http://packetizer.com/rel/businesscard",
                "type" => "text/vcard",
                "href" => "https://dille.name/nicholas.vcf"
            ),
            array(
                "rel" => "http://packetizer.com/rel/blog",
                "type" => "text/html",
                "href" => "https://dille.name",
                "titles" => array(
                    "en-us" => "Automation, DevOps and containerization",
                    "de-de" => "Automatisierung, DevOps und Containerisierung"
                )
            ),
            array(
                "rel" => 'alternate',
                "type" => 'application/rss+xml',
                "href" => 'https://dille.name/feed.xml',
            )
        )
    )
);

header("Content-Type: application/json");
if (!array_key_exists($queries['resource'], $accounts)) {
    exit();
}
echo json_encode($accounts[$queries['resource']]);
?>