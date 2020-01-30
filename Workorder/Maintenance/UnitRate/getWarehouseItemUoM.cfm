
<cfparam name="url.itemuom" default="">

<cfquery name="getItemUoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      I.ItemNo, I.UoM, I.UoMDescription
	FROM        ItemWarehouse AS IW INNER JOIN
                         ItemUoM AS I ON IW.ItemNo = I.ItemNo and IW.UoM = I.UoM
	WHERE       IW.Warehouse = '#url.warehouse#'
	AND         I.ItemNo = '#url.itemno#'	
</cfquery>

<select name="itemuom" style="width:140px" class="regularxl">	
	<cfoutput query="getItemUoM">
		<option value="#uom#" <cfif url.itemuom eq uom>selected</cfif>>#UoMDescription#</option>
	</cfoutput>			
</select>		