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
	
	