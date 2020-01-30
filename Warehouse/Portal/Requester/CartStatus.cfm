<cfquery name="Cart" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   WarehouseCart
		WHERE  UserAccount = '#SESSION.acc#'
		AND    (ShipToWarehouse is NULL or ShipToLocation is NULL)
</cfquery>
		
<cfoutput>	

<cfif cart.recordcount neq "0">
	
	<table cellspacing="0" cellpadding="0">
		<tr><td name="cartshow" align="center">								
		<img src="#SESSION.root#/images/view_cart.png" height="28" align="absmiddle" border="0"><br>
			View Cart (#Cart.recordCount# item<cfif Cart.RecordCount gt "1">s</cfif>)					
		</td></tr>
	</table>	

</cfif>

</cfoutput>	