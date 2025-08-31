<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="Cart" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Count(CartId) as total
	FROM  WarehouseCart
	WHERE UserAccount = '#SESSION.acc#' 
</cfquery>

<cfoutput>
<cfif cart.recordcount eq "1">
	<A href="javascript:cart()" target="right" >
	<img src="<cfoutput>#SESSION.root#</cfoutput>/images/cart.gif" alt="" align="absmiddle" border="0">
	&nbsp;<cf_tl id="My cart"> [#Cart.total# item<cfif #Cart.RecordCount# gt "1"><cf_tl id="s"></cfif>]</a>
</cfif>
</cfoutput>
	
	