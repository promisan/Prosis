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
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getUoM.cfm?mode=#url.mode#&itemno=#url.ItemNo#&showLocation=#url.showLocation#','uombox')				
					
	</script>	
	
	<table style="width:100%;border:0px solid silver" cellspacing="2" cellpadding="2">
	
		<cfif url.showLocation eq "yes">
		
			<tr class="fixlengthlist labelmedium2 line">
				<td style="background-color:f1f1f1;border-right:1px solid silver;padding-right:3px"><cf_tl id="Id"></td>
			    <td style="border-right:1px solid silver;padding-left:5px;padding-right:3px"><a href="javascript:item('#get.ItemNo#','','#warehouse.mission#')">#get.ItemNo#</a></td>
				<td style="background-color:f1f1f1;border-right:1px solid silver;padding-right:3px"><cf_tl id="Name"></td>
			    <td style="">#get.ItemNoExternal# #get.ItemDescription#</td>		
			</tr>
			
			<tr class="fixlengthlist labelmedium2">
				<td style="background-color:f1f1f1;border-right:1px solid silver;padding-right:3px"><cf_tl id="Category"></td>
			    <td style="border-right:1px solid silver;padding-left:5px;padding-right:3px">#get.Description#</td>
				<td style="background-color:f1f1f1;border-right:1px solid silver;padding-right:3px"><cf_tl id="Class"></td>
			    <td style="padding-left:5px">#get.ItemClass#</td>		
			</tr>
		
		<cfelse>
		
			<tr>
				<td class="labelmedium">#get.ItemDescription#</b></td>
			</tr>
		
		</cfif>
				
	</table>			

</cfoutput>

