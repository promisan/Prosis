


<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT      *
	FROM        Item T
	WHERE       T.ItemNo         = '#url.itemno#'	
</cfquery>

<cfquery name="itemuom" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT      *
	FROM        ItemUoM T
	WHERE       T.ItemNo         = '#url.itemno#'	
	AND         T.UoM            = '#url.uom#'
</cfquery>

<cfquery name="stock" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT      W.WarehouseName, T.Warehouse, SUM(T.TransactionQuantity) AS OnHand 
	FROM        ItemTransaction AS T INNER JOIN
	            Warehouse AS W ON T.Warehouse = W.Warehouse 
	WHERE       T.Mission        = '#url.mission#' 
	AND         T.ItemNo         = '#url.itemno#'
	AND         T.TransactionUoM = '#url.uom#'
	GROUP BY    T.Warehouse, W.WarehouseName
</cfquery>

<cfoutput>

<cfset sum = 0>

<cf_precision number="#item.ItemPrecision#">
	 
	<table width="100%">
	<tr class="line labelmedium"><td style="padding-left:5px;background-color:c5c5c5" colspan="2">#item.ItemDescription# #ItemUoM.ItemBarCode#</td></tr>
	<tr class="line labelmedium">
	    <td><cf_tl id="Warehouse"></td><td align="right"><cf_tl id="OnHand"></td>
	</tr>
	<cfloop query="stock">
	<tr class="line labelmedium"><td>#WarehouseName#</td><td align="right">#numberFormat(OnHand,"#pformat#")#</td></tr>
	<cfset sum = sum+onhand>
	</cfloop>	
	<tr class="line labelmedium"><td>#url.mission#</td><td align="right" style="font-weight:bold">#numberFormat(sum,"#pformat#")#</td></tr>	
	</table>

</cfoutput>

</cftransaction>
