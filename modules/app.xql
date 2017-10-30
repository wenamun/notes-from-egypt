xquery version "3.1";

module namespace app="http://notesfromegypt.info/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://notesfromegypt.info/config" at "config.xqm";
import module namespace kwic="http://exist-db.org/xquery/kwic";
import module namespace functx = "http://www.functx.com";

declare namespace tei="http://www.tei-c.org/ns/1.0";


(: return authorname from xml file :)                    
declare function app:show_authorname($node as node(), $model as map(*), $collection as xs:string?, $item as xs:string?) {
    let $file := concat('/db/apps/nfe/data/',$collection,'/',$item)
    for $doc in doc($file)
        return $doc//tei:correspAction[@type="sent"]/tei:persName/string()
};


(: return letter title from xml file :)                    
declare function app:show_letter_title($node as node(), $model as map(*), $collection as xs:string?, $item as xs:string?) {
    let $file := concat('/db/apps/nfe/data/',$collection,'/',$item)
    for $doc in doc($file)
        return $doc//tei:title/text()
};


(: show_search_params :)
declare function app:show_search_params($node as node(), $model as map(*), $query as xs:string) {
    let $query_string := $query
    return $query_string
};


(: show_search_results :)
declare function app:show_search_results($node as node(), $model as map(*), $query as xs:string) {
    try {
        for $hit in collection("/db/apps/nfe/data/")//tei:body/tei:p[ft:query(.,$query)]
            let $filename := util:document-name($hit)
            let $path := document-uri(root($hit))
            let $result := functx:substring-before-match($path, concat("/",$filename))
            let $collection := functx:substring-after-match($result, "/db/apps/nfe/data/")
            let $file := concat('/db/apps/nfe/data/',$collection,'/',$filename)
            for $doc in doc($file)
                let $title := $doc//tei:title/text()
                let $from  := $doc//tei:correspAction[@type="sent"]/tei:persName
            let $uri := concat("./show_item.html?collection=",$collection,"&amp;item=",$filename)
        return (
            <div>
                <b><a href="{$uri}">{concat($from, ": ", $title)}</a></b>:
                {kwic:summarize($hit, <config width="60"/>)}
            </div>
        )
    } catch * {
        <b><span style="color: red">Error in query syntax!</span></b>
    }
};

                    
(: shows single item from data :)                    
declare function app:show_item($node as node(), $model as map(*), $collection as xs:string?, $item as xs:string?) {
    let $file := concat('/db/apps/nfe/data/',$collection,'/',$item)
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
                {$text}
            </div>
};


(:~
 : list titles of all letters
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)

declare function app:listLetters($node as node(), $model as map(*), $collection as xs:string) {
    <ul>
{ 
    for $resource in collection(concat("/db/apps/nfe/data/",$collection))
        let $path := concat("/exist/rest/apps/nfe/data/", $collection,"/", util:document-name($resource))
        let $filename := util:document-name($resource)
        let $datum := $resource//tei:correspAction/tei:date/@when/string()
        let $uri := concat("./show_item.html?collection=",$collection,"&amp;item=",$filename)
        order by $datum
        return <li><a href="{$uri}">{$resource//tei:title/text()}</a></li> 
        
}    
    </ul>
};


declare function app:show_collection_info($node as node(), $model as map(*), $collection as xs:string?) 
{
<div>
        {
            let $coll := if ($collection = "lucie_duff_gordon") then
             (
                 <div>
                <p>
                Lucie, Lady Duff-Gordon (1821–1869) was an English author and translator who wrote under the name Lucie Gordon. She is best known for her Letters from Egypt, 1863–1865 (1865) and Last Letters from Egypt (1875).</p>
            <p>After moving in a circle of some of the most prominent authors and poets of her day in London, she contracted tuberculosis and in 1861, and went to South Africa for the "climate", which she hoped would help her health, living near the Cape of Good Hope for several years before travelling to Egypt in 1862.</p>
            <p>In Egypt, she settled in Luxor, where she learned Arabic and wrote many letters to her husband and her mother about her observations of Egyptian culture, religion and customs. Many critics regard her as being "progressive" and tolerant, although she also held problematic views on various racial groups. Her letters home are celebrated for their humour, her outrage at the ruling Ottomans, and many personal stories gleaned from the people around her. In many ways they are also typical of Orientalist travellers' tales of that time.</p>
            <p>Most of the letters are addressed to her husband, Alexander Duff-Gordon and her mother, Mrs Sarah Austin.</p>
            <p align="right">
                Text taken from <a href="https://en.wikipedia.org/wiki/Lucie,_Lady_Duff-Gordon"> Wikipedia</a>
            </p></div>,
            <div>
            <p align="center">
                <img style="border:2px solid #ccc; width:50%;" src="/exist/apps/nfe/images/Lucie_Gordon.jpg"/><br />
                
                <a href="https://en.wikipedia.org/wiki/File:Lucie_Gordon_(nee_Austin)_aged_fifteen.jpg">Source: Duff-Gordon, Lucie (1902). Ross, Janet, ed. Letters from Egypt (Revised Edition with Memoir by Her Daughter Janet Ross and New Introduction by George Meredith ed.). London: R. B. Johnson. facing page 4</a>
            </p>
        </div>  
            )
            else (
                 <div>
                <p>William Arnold Bromfield (1801–1851), was an English botanist.
Bromfield was born at Boldre, in the New Forest, Hampshire, in 1801, his father, the Rev. John Arnold Bromfield, dying in the same year. He received his early training under Dr. Knox of Tunbridge, Dr. Nicholas of Baling, and Rev. Mr. Phipps, a Warwickshire clergyman. He entered Glasgow University in 1821, and two years later he took his degree in medicine. During his university career he first showed a liking for botany, and made an excursion into the Scottish highlands in quest of plants.</p>
<p>He left Scotland in 1826, and, being independent of professional earnings, travelled through Germany, Italy, and France, returning to England in 1830. His mother died shortly afterwards, and he lived with his sister at Hastings and at Southampton, and finally settled at Ryde in 1836. He published in The Phytologist some observations on Hampshire plants, and then began to amass materials for a Flora of the Isle of Wight, which he did not consider complete even after fourteen years of assiduous labour. In 1842 he spent some weeks in Ireland, and in January 1844 he started for a six months' tour to the West Indies, spending most of the time in Trinidad and Jamaica. Two years later he visited North America, publishing some remarks in Hooker's Journal of Botany.</p>
<p>In September 1850 he embarked for the East, and spent some time in Egypt, penetrating as far as Khartoum, which he described in a letter as a 'region of dust, dirt, and barbarism.' Here he lost two of his companions, victims to the climate, and he returned to Cairo in the following June, after an absence of seven months. Continuing his journey, he passed by Jaffa, and stated his intention of leaving Constantinople for Southampton in September, but his last letter was dated "Bairout, 22 Sept.," when he was expecting a friend to join him on a trip to Baalbec and Damascus. At the latter place he was attacked by malignant typhus, and died on 9 Oct., four days after his arrival. His collections were sent to Kew, some of the contents being shared amongst his scientific friends. The Flora of the Isle of Wight was printed by Sir W. J. Hooker and Dr. Bell Salter in 1856, under the title of Flora Vectensis, in 8vo, with a topographical map and portrait of the author. His manuscript Flora of Hampshire was never published. His herbarium is now at Ryde in the Isle of Wight, but his manuscripts are in the library of the Royal Kew Gardens.</p>
            <p align="right">
                Text taken from <a href="https://en.wikipedia.org/wiki/William_Arnold_Bromfield">Wikipedia</a>
            </p></div>,
            <div>
            <p align="center">
                <img style="border:2px solid #ccc; width:50%;" src="/exist/apps/nfe/images/bromfield.png"/><br />
                
                <a href="https://books.google.de/books?id=wM8YAAAAYAAJ&amp;printsec=frontcover&amp;source=gbs_ge_summary_r&amp;cad=0#v=onepage&amp;q&amp;f=false">Picture taken from Cover of Bromfield's book 'Flora Vectensis'</a>
            </p>
        </div>
                )
            return $coll
        }   
</div>
};


(: print HTML Header with alt-class for start page, without alt-class for all the other pages :)
declare function app:print_header($node as node(), $model as map(*)) 
{
    let $class := if (ends-with(request:get-uri(), "index.html") ) then "alt" else ()
    
    return
                    <header id="header" class="{$class}">
						<h1><a href="index.html">Notes from Egypt</a></h1>
						<nav id="nav">
							<ul>
								<li class="special">
									<a href="#menu" class="menuToggle"><span>Menu</span></a>
									<div id="menu">
										<ul>
											<li><a href="index.html">Home</a></li>
											<li><a href="#">Collections</a>
												<ul>
													<li><a href="show_collection.html?collection=lucie_duff_gordon&amp;item=lfe001.xml">Lucie Duff Gordon</a></li>
													<li><a href="show_collection.html?collection=william_arnold_bromfield&amp;item=letter_1.xml">William Arnold Bromfield</a></li>
												</ul>
											</li>
											<li><a href="search_form.html">Fulltext Search</a></li>
											<li><a href="#">Map</a></li>
											<li><a href="#">Timeline</a></li>
											<li><a href="about.html">Disclaimer &amp; Credits</a></li>
										</ul>
									</div>
								</li>
							</ul>
						</nav>
					</header>
};


