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
                    
(: shows single item from data :)                    
declare function app:show_item($node as node(), $model as map(*), $item as xs:string?) {
    let $file := concat('/db/apps/notes-from-egypt/data/',$item,'.xml')
(:    return $file:)
    for $doc in doc($file)
        let $title := $doc//tei:title/text()
        let $from  := $doc//tei:correspAction[@type="sent"]/tei:persName
        let $to    := $doc//tei:correspAction[@type="received"]/tei:persName
        let $date  := $doc//tei:teiHeader/tei:profileDesc/tei:correspDesc/tei:correspAction/tei:date/text()
        let $text  := $doc//tei:body
        let $settlement := $doc//tei:settlement
        return
            <div>
                <p><b>Title: </b> {$title}</p>
                <p><b>From</b>: <a href="{$from/@ref/string()}">{$from/text()}</a></p>
                <p><b>To</b>: <a href="{$to/@ref/string()}">{$to/text()}</a></p>
                <p><b>Date: </b> {$date} 
                { 
                    if ( $settlement/@ref/string() != "" ) 
                        then  
                            <span style="padding-left:5px">(<a href="{$settlement/@ref/string()}">{$settlement/text()}</a>)</span>
                        else () 
                }           
                </p>
                {$text}
            </div>
};

