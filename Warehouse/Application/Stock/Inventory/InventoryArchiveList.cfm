
<!--- inventory history --->

<cfparam name="URL.InventoryId" default="">
<cfparam name="url.action" default="delete">

<cfif url.inventoryid neq "">
	
	<cfquery name="delete"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   ItemWarehouseLocationInventory
		WHERE InventoryId = '#url.inventoryid#'	
	</cfquery>

</cfif>

<cfquery name="Archive"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 20 * 
	FROM     ItemWarehouseLocationInventory
	WHERE    Warehouse      = '#URL.Warehouse#'
	AND      Location       = '#URL.Location#'
	AND      ItemNo         = '#URL.ItemNo#'
	AND      UoM            = '#url.UoM#'
	<cfif url.transactionlot eq "">
	AND      TransactionLot = '0'
	<cfelse>
	AND      TransactionLot = '#url.transactionLot#'
	</cfif>
	ORDER BY Created DESC	
</cfquery>

<cfquery name="Item"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Item
	WHERE   ItemNo = '#url.ItemNo#'
</cfquery>

<cf_precision number="#item.ItemPrecision#">

<table width="100%" 
       align="center" 	   
	   border="0"
	   class="formpadding navigation_table">

<cfif archive.recordcount eq "0">

	<tr class="line labelmedium"><td colspan="8" height="20" align="center"><cf_tl id="No inventory history found"></td></tr>

<cfelse>
		   
	<tr class="labelmedium line" style="height:20px">
		<td></td>
		<td><cf_tl id="Date"></td>
		<td><cf_tl id="Time"></td>
		<td><cf_tl id="Officer"></td>
		<td align="right"><cf_tl id="On Hand"><cf_space spaces="20"></td>
		<td align="right"><cf_tl id="Depth"></td>
		<td align="right"><cf_tl id="Temp."></td>
		<td align="right"><cf_tl id="Variance"></td>
	</tr>

</cfif>


<cfoutput query="Archive">
	
	<tr class="labelmedium navigation_row line" style="height:20px">
	    <td style="padding-left:3px;padding-top:2px">
			<cf_img icon="delete" onclick="#ajaxlink('#session.root#/Warehouse/Application/Stock/Inventory/InventoryArchiveList.cfm?inventoryid=#InventoryId#&action=delete&warehouse=#warehouse#&location=#location#&itemno=#itemno#&uom=#uom#&transactionlot=#transactionlot#')#">
		</td>
		<td>#dateformat(DateInventory,CLIENT.DateFormatShow)#</td>
		<td>#timeformat(DateInventory,"HH:MM")#</td>
		<td>#OfficerLastName#</td>
		<td align="right">#numberformat(QuantityOnHand,"#pformat#")#</td>
		<td align="right">#QuantityCounted#</td>
		<td align="right">#numberformat(ValueMetric,"._")#</td>
		<td align="right">#numberformat(QuantityVariance,"#pformat#")#</td>	
	</tr>
	
	<cfif memo neq "">
	<tr bgcolor="ffffef">
		<td></td>
		<td colspan="7">#Memo#</td>
	</tr>	
	</cfif>

</cfoutput>

<cfset ajaxonload("doHighlight")>
