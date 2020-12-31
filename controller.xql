xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

import module namespace util="http://exist-db.org/xquery/util";

if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>
    
else if ($exist:path eq "/") then
    (: forward root path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="index.html"/>
    </dispatch>

else if (contains(lower-case($exist:path), "/rest/")) then
    let $path := replace($exist:path, "nfe/", "")
    let $token := fn:tokenize($path, "/")
    let $collection := $token[4]
    let $item := $token[5]
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<forward url="{$exist:controller}/data/{$collection}/{$item}"/>
	</dispatch>

else if (starts-with(lower-case($exist:path), "/place") and 
        (ends-with(lower-case($exist:path), "/json") or ends-with(lower-case($exist:path), "/rdf")) ) then
    let $token := fn:tokenize($exist:path, "/")
    let $name := $token[3]
    let $format := $token[4]
    return if ($format = "json") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<forward url="{$exist:controller}/test.html"/>
		 <view>
			<forward url="{$exist:controller}/modules/json_ld.xql">
                 <add-parameter name="name" value="{$name}"/>
                 <add-parameter name="type" value="place"/>
		     </forward>
		</view>
	</dispatch>
	else
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<forward url="{$exist:controller}/test.html"/>
		 <view>
			<forward url="{$exist:controller}/modules/rdf.xql">
                 <add-parameter name="name" value="{$name}"/>
                 <add-parameter name="type" value="place"/>
		     </forward>
		</view>
	</dispatch>

else if (starts-with(lower-case($exist:path), "/person") and 
    (ends-with(lower-case($exist:path), "/json")) or ends-with(lower-case($exist:path), "/rdf")) then
    let $token := fn:tokenize($exist:path, "/")
    let $name := $token[3]
    let $format := $token[4]
    return if ($format = "json") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<forward url="{$exist:controller}/test.html"/>
		 <view>
			<forward url="{$exist:controller}/modules/json_ld.xql">
                 <add-parameter name="name" value="{$name}"/>
                 <add-parameter name="type" value="person"/>
		     </forward>
		</view>
	</dispatch>
	else
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<forward url="{$exist:controller}/test.html"/>
		 <view>
			<forward url="{$exist:controller}/modules/rdf.xql">
                 <add-parameter name="name" value="{$name}"/>
                 <add-parameter name="type" value="person"/>
		     </forward>
		</view>
	</dispatch>

(:
else if (starts-with(lower-case($exist:path), "/test")) then
    let $token := fn:tokenize($exist:path, "/")
    let $collection := $token[3]
    let $item := $token[4]
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<forward url="{$exist:controller}/test.html"/>
		 <view>
			<forward url="{$exist:controller}/modules/view.xql">				 
				 <add-parameter name="path" value="{$exist:path}"/>
				 <add-parameter name="collection" value="{$collection}"/>
                 <add-parameter name="item" value="{$item}.xml"/>
		     </forward>
		</view>
	</dispatch>
:)

else if (starts-with(lower-case($exist:path), "/map")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/show_map.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
            </forward>
        </view>
    </dispatch>

(:
else if (starts-with(lower-case($exist:path), "/place")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/show_place.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="placename" value="cairo"/>
            </forward>
        </view>
    </dispatch>
:)

else if (contains($exist:path, "/notes/") ) then
    let $token := fn:tokenize($exist:path, "/")
    let $collection := $token[3]
    let $item := $token[4]    
    (: return util:log("warn", concat("###", $collection, $item)) :)
    return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/show_item.html"/>
        <view>
            <forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="collection" value="{$collection}"/>
                <add-parameter name="item" value="{$item}.xml"/>
            </forward>
        </view>
    </dispatch>
   
else if (ends-with($exist:resource, ".html")) then
    (: the html page is run through view.xql to expand templates :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </view>
		<error-handler>
			<forward url="{$exist:controller}/error-page.html" method="get"/>
			<forward url="{$exist:controller}/modules/view.xql"/>
		</error-handler>
    </dispatch>
    
(: Resource paths starting with $shared are loaded from the shared-resources app :)
else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}">
            <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
        </forward>
    </dispatch>
else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
