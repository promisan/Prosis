
<cfparam name="url.itemuom" default="">

<cfif url.warehouse eq "">

	<script>
	 document.getElementById('itemline').className = "hide"
	</script>

<cfelse>

	<script>
	 document.getElementById('itemline').className = "regular"
	</script>
	
	<cfquery name="getItem" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT      I.ItemNo, I.ItemDescription
		FROM        ItemWarehouse AS IW INNER JOIN
	                         Item AS I ON IW.ItemNo = I.ItemNo
		WHERE       IW.Warehouse = '#url.warehouse#'
		AND         I.Operational = 1
		ORDER BY    I.ItemNo ASC
	</cfquery>
	
	<cfset itm = getItem.ItemNo>
	
	<cfoutput>
	
	
	<select style="width:320px" name="ItemNo" class="regularxl" 
	     onchange="_cf_loadingtexthtml='';ptoken.navigate('getWarehouseItemUoM.cfm?warehouse=#url.warehouse#&itemno='+this.value,'itemuom')">	
	   	<cfloop query="getItem">
			<option value="#ItemNo#" <cfif url.itemno eq itemno>selected</cfif>>#ItemNo# - #ItemDescription#</option>
			
			<cfif url.itemno eq itemno>
				<cfset itm = itemno>
			</cfif>
			
		</cfloop>			
	</select>		
	
	
	<script>
		ptoken.navigate('getWarehouseItemUoM.cfm?warehouse=#url.warehouse#&itemno=#itm#&itemuom=#url.itemuom#','itemuom')		
	</script>	
	
	</cfoutput>

</cfif>