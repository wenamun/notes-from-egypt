xquery version "3.1";

module namespace index = "http://exist.org/apps/nfe/index";

import module namespace templates = "http://exist-db.org/xquery/templates";
import module namespace config = "http://notesfromegypt.info/config" at "config.xqm";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare function index:show_index_type($node as node(), $model as map(*), $type as xs:string) {
     <span>Index: {$type}</span>
};

declare function index:show_index_list($node as node(), $model as map(*), $type as xs:string) {
    let $entries := if ($type='places') 
                then doc('/db/apps/nfe/authority/places.xml')//tei:place
                else doc('/db/apps/nfe/authority/people.xml')//tei:person
    return <div>
    {for $entry in $entries
        return if ($type = 'places') 
            then <div><a href="./show_place.html?placename={$entry/@xml:id}">{$entry/tei:placeName}</a></div>
            else <div><a href="./show_person.html?personname={$entry/@xml:id}">{$entry/tei:name}</a></div>
    }</div>
};

