xquery version "3.1";

module namespace app="Notes From Egypt/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="Notes From Egypt/config" at "config.xqm";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(:~
 : list titles of all letters
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)

declare function app:listLetters($node as node(), $model as map(*)) {
    <ul>
{ 
    for $resource in collection("/db/apps/notes-from-egypt/data")
        let $path := concat("/exist/rest/apps/notes-from-egypt/data/",util:document-name($resource))
        return <li><a href="{$path}">{$resource//tei:title/text()}</a></li>
}    
    </ul>
};

