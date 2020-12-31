xquery version "3.1";

module namespace place = "http://exist.org/apps/nfe/place";

import module namespace templates = "http://exist-db.org/xquery/templates";
import module namespace config = "http://notesfromegypt.info/config" at "config.xqm";
import module namespace util = "http://exist-db.org/xquery/util";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: returns placename according to parameter :)
declare function place:show_placename($node as node(), $model as map(*), $placename as xs:string) {
    let $place := doc('/db/apps/nfe/authority/places.xml')//tei:place[@xml:id = lower-case($placename)]
    return
    <span>Authority File Entry (Place): {$place//tei:placeName/text()}</span>
};

(: display all attestations of placename in texts for place detail view page :)
declare function place:show_attestations_of_place($node as node(), $model as map(*), $placename as xs:string) {
    for $doc in collection("/db/apps/nfe/data/")
    let $collection := replace(util:collection-name($doc), "/db/apps/nfe/data/", "")
    let $filename := util:document-name($doc)
    let $datum := $doc//tei:correspAction/tei:date/@when/string()
    order by $collection, $datum
    where $doc//tei:name[@ref="#"||$placename]
    return <div><a href="./show_item.html?collection={$collection}&amp;item={$filename}">{ upper-case(replace($collection, "_", " "))||": " || $doc//tei:title/string()}</a></div> 
};

(: displays all information about placename taken from authority file places.xml  :)
declare function place:show_placeinfo($node as node(), $model as map(*), $placename as xs:string) {
    let $place := doc('/db/apps/nfe/authority/places.xml')//tei:place[@xml:id = lower-case($placename)]
    let $name := $place//tei:placeName/text()
    let $coordinates := $place//tei:geo/text()
    let $geonames := $place//tei:idno[@type = "geonames"]/text()
    let $wikipedia := $place//tei:idno[@type = "wikipedia"]/text()
    let $note := $place//tei:note/text()
    return 
        <div> 
            <h3>{$name}</h3>
            <p>{$note}</p>
            <p><strong>Linked Open Data:</strong><br/>
            <a href="./place/{$placename}/rdf">RDF/XML</a><br/>
            <a href="./place/{$placename}/json">JSON-LD (Schema.org)</a>
            </p>
            <p style="margin-top:2em;"><strong>See also:</strong><br/>
            <a href="{$geonames}">{$geonames}</a> <br/>
            <a href="{$wikipedia}">{$wikipedia}</a></p>
            <div id="map" style="height:600px;widht:80%;border:1px solid #ccc" />
            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin=""/>
            <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""></script>
            <script>
                var mymap = L.map('map').setView([{$coordinates}], 8);
                
                L.tileLayer('https://api.mapbox.com/styles/v1/{{id}}/tiles/{{z}}/{{x}}/{{y}}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {{
                maxZoom: 18,
                attribution: 'Map data © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, ' +
                'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
                id: 'mapbox/streets-v11',
                tileSize: 512,
                zoomOffset: -1
                }}).addTo(mymap);
                
                mymap.scrollWheelZoom.disable();
                L.marker([{$coordinates}]).addTo(mymap);
            </script>
        </div>
};

(: show all places on a map :)
declare function place:show_all_places_on_map($node as node(), $model as map(*)) {
       
    <div> 
        <div id="map" style="height:600px;widht:80%;border:1px solid #ccc" />
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A==" crossorigin=""/>
        <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js" integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA==" crossorigin=""></script>
        <script>
            var mymap = L.map('map').setView([30.033333, 31.233333], 5);
            
            L.tileLayer('https://api.mapbox.com/styles/v1/{{id}}/tiles/{{z}}/{{x}}/{{y}}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {{
            maxZoom: 18,
            attribution: 'Map data © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, ' +
            'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
            id: 'mapbox/streets-v11',
            tileSize: 512,
            zoomOffset: -1,
            }}).addTo(mymap);            
            { 
                for $place in doc('/db/apps/nfe/authority/places.xml')//tei:place
                return 
                    if ($place//tei:geo/text() != " " and $place//tei:geo/text() != "") 
                    (:then "L.marker([" || $place//tei:geo/text() || "]).addTo(mymap).bindPopup(""" || "<a>"||$place//tei:placeName/text()||"</a>" || """);":)
                    then "L.marker([" || $place//tei:geo/text() || "]).addTo(mymap).bindPopup(""" ||$place//tei:placeName/text()|| """);"
                    else ()
            } 
            
        </script>
    </div>
};
