xquery version "3.1";

module namespace time = "http://exist.org/apps/nfe/time";

import module namespace templates = "http://exist-db.org/xquery/templates";
import module namespace config = "http://notesfromegypt.info/config" at "config.xqm";
import module namespace util = "http://exist-db.org/xquery/util";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: returns timeline :)
declare function time:show_timeline($node as node(), $model as map(*)) {
    
    
    
    
    <div><ul
            class="timeline">
            {
                for $doc in collection("/db/apps/nfe/data/")
                let $collection := replace(util:collection-name($doc), "/db/apps/nfe/data/", "")
                let $filename := util:document-name($doc)
                let $datum := $doc//tei:correspAction/tei:date/@when/string()
                let $teiHeader := $doc//tei:teiHeader
                
                order by $datum
                where $datum != ""
                return
                    <li>
                        <a
                            style="font-size:1.5rem;"
                            href="./show_item.html?collection={$collection}&amp;item={$filename}">{$doc//tei:correspAction[@type = 'sent']/tei:date/text()}</a>
                        <p>{$doc//tei:correspAction[@type = 'sent']/tei:name[@type = 'person']} to {$doc//tei:correspAction[@type = 'received']/tei:name[@type = 'person']}
                        { if ($doc//tei:correspAction[@type = 'sent']/tei:name[@type = 'place'] != "") then " ("||string-join($doc//tei:correspAction[@type = 'sent']/tei:name[@type = 'place'][1]/string())||")" else ()}
                        </p>
                    </li>
            }
        
        </ul></div>

};
