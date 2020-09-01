<!--- retrieve the item --->
<cfparam name="url.showLocation" default="yes">

<cfquery name="Warehouse" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Warehouse
		WHERE    Warehouse = '#url.warehouse#'		
</cfquery>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Item I, Ref_Category R
		WHERE    I.Category = R.Category
		AND      I.ItemNo = '#url.ItemNo#'		
</cfquery>
	
<cfoutput>
			
	<script language="JavaScript">
			
		document.getElementById('itemno').value  = "#get.Itemno#"				
		ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getUoM.cfm?mode=#url.mode#&itemno=#url.ItemNo#&showLocation=#url.showLocation#','uombox')				
					
	</script>	
	
	<table style="width:100%" cellspacing="0" cellpadding="0">
	
		<cfif url.showLocation eq "yes">
		
			<tr>
				<td width="10%" style="border-bottom:1px solid silver;padding-right:3px" class="labelit"><cf_tl id="Id"></td>
			    <td width="40%" style="padding-left:5px;padding-right:3px" class="labelmedium"><a href="javascript:item('#get.ItemNo#','','#warehouse.mission#')">#get.ItemNo#</a></td>
				<td width="10%" style="border-bottom:1px solid silver;padding-right:3px" class="labelit"><cf_tl id="Name"></td>
			    <td style="padding-left:5px"  width="40%" class="labelmedium">#get.ItemDescription#</td>		
			</tr>
			
			<tr>
				<td class="labelit" style="border-bottom:1px solid silver;padding-right:3px"><cf_tl id="Category"></td>
			    <td style="padding-left:5px;padding-right:3px" class="labelmedium">#get.Description#</td>
				<td class="labelit" style="border-bottom:1px solid silver;padding-right:3px"><cf_tl id="Class"></td>
			    <td style="padding-left:5px" class="labelmedium">#get.ItemClass#</td>		
			</tr>
		
		<cfelse>
		
			<tr>
				<td class="labelmedium">#get.ItemDescription#</b></td>
			</tr>
		
		</cfif>
				
	</table>			

</cfoutput>

