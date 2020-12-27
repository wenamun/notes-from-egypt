xquery version "3.1";

module namespace person = "http://exist.org/apps/nfe/person";

import module namespace templates = "http://exist-db.org/xquery/templates";
import module namespace config = "http://notesfromegypt.info/config" at "config.xqm";

declare namespace tei = "http://www.tei-c.org/ns/1.0";


(: returns name according to parameter :)
declare function person:show_personname($node as node(), $model as map(*), $personname as xs:string) {
    let $person := doc('/db/apps/nfe/authority/people.xml')//tei:person[@xml:id = lower-case($personname)]
    return
    <span>Authority File Entry (Person): {$person//tei:name/text()}</span>
};

(: display all attestations of person in texts for person detail view page :)
declare function person:show_attestations_of_person($node as node(), $model as map(*), $personname as xs:string) {
    for $doc in collection("/db/apps/nfe/data/")
    let $collection := replace(util:collection-name($doc), "/db/apps/nfe/data/", "")
    let $filename := util:document-name($doc)
    let $datum := $doc//tei:correspAction/tei:date/@when/string()
    order by $collection, $datum
    where $doc//tei:name[@ref="#"||$personname]
    return <div><a href="./show_item.html?collection={$collection}&amp;item={$filename}">{ upper-case(replace($collection, "_", " "))||": " || $doc//tei:title/string()}</a></div> 
};

(: returns info about person :)
declare function person:show_personinfo($node as node(), $model as map(*), $personname as xs:string) {
    let $person := doc('/db/apps/nfe/authority/people.xml')//tei:person[@xml:id = lower-case($personname)]
    let $name := $person/tei:name
    let $note := $person//tei:note/text()
    let $links := $person//tei:idno
    return
    <div>
        <h3>{$name}</h3>
        <p>{$note}</p>
        {if ($links) then  <p style="margin-top:2em;margin-bottom:0rem;"><strong>See also:</strong></p> else () }
    
    {
        for $l in $links
        return <p style="margin-top:0rem;margin-bottom:0rem;"><a href="{$l}">{$l}</a></p> 
    }
    </div>
};
