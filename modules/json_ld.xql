xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
import module namespace request = "http://exist-db.org/xquery/request";

(: returns JSON-LD representation of place :)
declare function local:export_place_to_json_ld($placename as xs:string) as xs:string?{
    
    let $place := doc('/db/apps/nfe/authority/places.xml')//tei:place[@xml:id = lower-case($placename)]
    let $coordinates := $place//tei:geo/string()
    let $geo_lat := if ($coordinates) then tokenize($coordinates, ", ")[1] else ()
    let $geo_long := if ($coordinates) then tokenize($coordinates, ", ")[2] else ()
    let $name := $place//tei:placeName/string()
    let $description := $place//tei:note/string()
    let $same_as_array := for $url in $place//tei:idno/string() return $url
    
    let $place_map := map{
        "@context": "https://schema.org",
        "@type": "Place",
        "name": $name,
        "description": normalize-space($description),
        "sameAs": $same_as_array,
        "geo": map {
            "@type": "GeoCoordinates",
            "latitude": $geo_lat,
            "longitude": $geo_long
        }
    }
    
    return  
    (
    response:set-header( "Access-Control-Allow-Origin", '*' ),
    response:set-header( "Content-Type", 'application/ld+json; charset=utf-8' ),
    serialize(
        $place_map, 
        <output:serialization-parameters>
            <output:method>json</output:method>
        </output:serialization-parameters>
    )
)};

(: returns JSON-LD representation of place :)
declare function local:export_person_to_json_ld($personname as xs:string) as xs:string?{
    
    let $person := doc('/db/apps/nfe/authority/people.xml')//tei:person[@xml:id = lower-case($personname)]
    let $name := $person//tei:name/string()
    let $description := $person//tei:note/string()
    let $same_as_array := for $url in $person//tei:idno/string() return $url
    
    let $person_map := map{
        "@context": "https://schema.org",
        "@type": "Person",
        "name": $name,
        "description": normalize-space($description),
        "sameAs": $same_as_array
    }
    
    return  
    (
    response:set-header( "Access-Control-Allow-Origin", '*' ),
    response:set-header( "Content-Type", 'application/ld+json; charset=utf-8' ),
    serialize(
        $person_map, 
        <output:serialization-parameters>
            <output:method>json</output:method>
        </output:serialization-parameters>
    )
)};



let $type := request:get-parameter('type', '')
let $name := request:get-parameter('name', '')
return
    if ($type = 'place') then local:export_place_to_json_ld($name) else 
    if ($type = 'person') then local:export_person_to_json_ld($name) else ()

