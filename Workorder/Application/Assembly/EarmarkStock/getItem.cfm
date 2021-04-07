
<cfparam name="url.mode" default="standard">
<cfparam name="url.workorderid" default="all">

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
			
		try { document.getElementById('itemno').value  = "#get.Itemno#"	} catch(e) {}
		ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getUoM.cfm?mission=#url.mission#&workorderid=#url.workorderid#&itemno=#url.ItemNo#','uombox')		
					
	</script>	
		
	<table width="100%" cellspacing="0" border="0" cellpadding="0">
			
			<cfif url.mode eq "standard">
			<tr>				
			    <td colspan="2" style="height:20px;padding-left:0px;padding-right:3px" class="labelmedium">#get.ItemNo# #get.ItemDescription#</td>				
			</tr>
			</cfif>
			
			<tr>
				<td class="labelmedium" style="height:20px;padding-left:0px;padding-right:3px">#get.Description# / #get.ItemClass#</td>				
			</tr>
									
	</table>			

</cfoutput>

