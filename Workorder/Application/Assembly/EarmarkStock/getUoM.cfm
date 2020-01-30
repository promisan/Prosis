<!--- get UoM --->

<cfoutput>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#url.ItemNo#'		
</cfquery>

<cfset lnk = "ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getStockLevel.cfm?mission=#url.mission#&workorderidselect=#url.workorderid#&warehouse='+document.getElementById('warehouse').value+'&itemno=#url.ItemNo#&uom='+this.value+'&workorderid='+document.getElementById('workorderid').value+'&workorderline='+document.getElementById('workorderline').value,'stockbox')">

<cfif get.recordcount gte "4">
		
<select name="uom" id="uom" class="enterastab regularxl" 
onchange="#lnk#">
		
	<cfloop query="get">
		<option value="#UoM#">#UoMDescription#</option>
	</cfloop>
		
</select>	

<cfelse>
	
	<input type="hidden" name="uom" id="uom" value="#get.uom#">
	
	<table><tr>	
	<cfloop query="get">
	<td>
	<input onclick="#lnk#;document.getElementById('uom').value='#uom#'"
	     type="radio" class="enterastab radiol" name="uomselect" value="#UoM#" <cfif get.currentrow eq "1">checked</cfif>>	
		 </td>
		 <td class="labelmedium" style="padding-left:3px;padding-right:10px">
		#UoMDescription# 
		</td>
	</cfloop>
	</tr>
	</table>

</cfif>

	
<script language="JavaScript">
   document.getElementById('boxwarehouse').className = "regular"
	ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getWarehouse.cfm?mission=#url.mission#&workorderid=#url.workorderid#&itemno=#url.ItemNo#&uom=#get.uom#','boxwarehouse')		
</script>


</cfoutput>		

