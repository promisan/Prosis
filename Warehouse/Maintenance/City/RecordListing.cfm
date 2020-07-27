<cf_screentop html="No" jquery="Yes">
<cf_divscroll>

<cfquery name="SearchResult"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_WarehouseCity
		ORDER BY Mission, ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>
	<script>
		function recordadd(grp) {
			window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddWarehouseCity", "left=80, top=80, width=450, height= 275, toolbar=no, status=no, scrollbars=no, resizable=yes");
		}
		
		function recordedit(mission,city) {
			window.open("RecordEdit.cfm?idmenu=#url.idmenu#&mission="+mission+"&city=" + city, "EditWarehousecity", "left=80, top=80, width= 450, height= 275, toolbar=no, status=no, scrollbars=no, resizable=yes");
		}
	</script>	
</cfoutput>

<table width="96%" border="0" align="center" bordercolor="silver" cellspacing="0" cellpadding="0"  >  
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				<tr>
				    <td></td> 
				    <td></td>
					<td>Region</td>
					<td align="center">Order</td>
					<td>Officer</td>
				    <td>Entered</td>
				</tr>
				
				<cfoutput query="SearchResult" group="mission">
					<tr><td colspan="6" style="font-size:14px;">#Mission#</td></tr>
					<cfoutput>
					    <tr><td height="1" colspan="6" class="line"></td></tr>	
					    <tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor=""> 
							<td width="15"></td>
							<td height="20" width="5%" align="center" style="padding-top:3px">
							  <cf_img icon="open" onclick="recordedit('#mission#','#city#');">
							</td>		
							<td>#City#</td>
							<td align="center">#listingOrder#</td>
							<td>#OfficerFirstName# #OfficerLastName#</td>
							<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
					    </tr>
					</cfoutput>
					<tr><td height="5"></td></tr>
				</cfoutput>
				
				<tr><td class="line" colspan="6"></td></tr>
			</table>
		</td>
	</tr>
</table>

</cf_divscroll>