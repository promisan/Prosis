<!--- automatically add the supply --->
<cftry>
	<cfquery name="insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO AssetItemSupply	(
				AssetId,
				SupplyItemNo,
				SupplyItemUoM,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName
			)
		VALUES	(
				'#url.itemno#',
				'#url.supply#',
				'#url.uom#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
			)
	</cfquery>
	
	<script>
		document.getElementById('autoInserted').value = 1;
	</script>
	
	<cfcatch></cfcatch>
</cftry>


<cfquery name="warehouse" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT WarehouseName FROM Warehouse WHERE Warehouse = S.Warehouse) as WarehouseName
	FROM 	AssetItemSupplyWarehouse S
	WHERE 	1=1
	<cfif url.itemno neq "">
		AND 	AssetId = '#url.itemno#'
	</cfif>
	AND 	SupplyItemNo = '#url.supply#'
	AND		SupplyItemUoM = '#url.uom#'
</cfquery>

<cfset whList = "">
<cfset whList = valueList(warehouse.WarehouseName)>
<cfset whList = replace(whList,",", ", ", "ALL")>

<cfif trim(whList) eq "">
	<cfset whList = "[Any warehouse]">
</cfif>

<table>
	<tr>
		<td class="labelmedium">
			<cfoutput>
			<cfif url.supply neq "" and url.uom neq "">
				<font color="808080">#whList#</font>
				<cfif url.itemno neq "">
					&nbsp;
					<a title="Edit warehouses" href="javascript:supplyeditwarehouse('#url.itemno#','#url.supply#','#url.uom#')"><font color="6688aa">[Edit]</font></a>
				</cfif>
			<cfelse>
				<font color="gray">Select a valid supply item</font>
			</cfif>	
			</cfoutput>
		</td>
	</tr>
</table>
