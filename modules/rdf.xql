xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";

import module namespace request = "http://exist-db.org/xquery/request";

(: returns RDF/XML representation of place :)
declare function local:export_place_to_rdf($placename as xs:string) as xs:string?{
    
    let $place := doc('/db/apps/nfe/authority/places.xml')//tei:place[@xml:id = lower-case($placename)]
    let $coordinates := $place//tei:geo/string()
    let $geo_lat := if ($coordinates) then tokenize($coordinates, ", ")[1] else ()
    let $geo_long := if ($coordinates) then tokenize($coordinates, ", ")[2] else ()
    let $name := $place//tei:placeName/string()
    let $description := $place//tei:note/string()
    let $geonames_uri := $place//tei:idno[@type="geonames"]/string()
    let $wikipedia_uri := $place//tei:idno[@type="wikipedia"]/string()
    
    let $xml:=<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns:skos="http://www.w3.org/2004/02/skos/core#">
          <geo:Feature rdf:about="https://notesfromegypt.info/place/{$placename}">
            <rdfs:label xml:lang="en">{$name}</rdfs:label>
            <rdfs:comment xml:lanf="en">{$description}</rdfs:comment>
            <geo:long rdf:datatype="http://www.w3.org/2001/XMLSchemafloat">{$geo_lat}</geo:long>
            <geo:lat rdf:datatype="http://www.w3.org/2001/XMLSchemafloat">{$geo_long}</geo:lat>
            <skos:sameAs rdf:resource="{$geonames_uri}"/>
            <skos:sameAs rdf:resource="{$wikipedia_uri}"/>
          </geo:Feature>
        </rdf:RDF>
    
    return (
    response:set-header( "Access-Control-Allow-Origin", '*' ),
    serialize($xml)    
)};

(: returns RDF/XML representation of person :)
declare function local:export_person_to_rdf($personname as xs:string) as xs:string?{
    
    let $person := doc('/db/apps/nfe/authority/people.xml')//tei:person[@xml:id = lower-case($personname)]
    let $name := $person//tei:name/string()
    let $description := $person//tei:note/string()
    let $wikipedia_uri := $person//tei:idno[@type="wikipedia"]/string()
    let $wikidata_uri := $person//tei:idno[@type="wikidata"]/string()
    let $viaf_uri := $person//tei:idno[@type="viaf"]/string()
    let $gnd_uri := $person//tei:idno[@type="gnd"]/string()
    
    let $xml:=<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns:skos="http://www.w3.org/2004/02/skos/core#"
         xmlns:foaf="http://xmlns.com/foaf/0.1/">
        <foaf:Person rdf:about="https://notesfromegypt.info/person/{$personname}">
        <rdfs:label xml:lang="en">{$name}</rdfs:label>
        <rdfs:comment xml:lanf="en">{$description}</rdfs:comment>
        <skos:sameAs rdf:resource="{$wikipedia_uri}"/>
        <skos:sameAs rdf:resource="{$wikidata_uri}"/>
        <skos:sameAs rdf:resource="{$viaf_uri}"/>
        <skos:sameAs rdf:resource="{$gnd_uri}"/>
        </foaf:Person>
        </rdf:RDF>
        
    
    return (
    response:set-header( "Access-Control-Allow-Origin", '*' ),
    serialize($xml)
)};



let $type := request:get-parameter('type', '')
let $name := request:get-parameter('name', '')
return
    if ($type = 'place') then local:export_place_to_rdf($name) else 
    if ($type = 'person') then local:export_person_to_rdf($name) else ()

