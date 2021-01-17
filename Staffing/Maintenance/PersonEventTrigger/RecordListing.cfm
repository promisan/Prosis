
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_EventTrigger
	Order by ListingOrder
</cfquery>



<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

	<script>
	
		function recordadd(grp) {
		   ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=350, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordedit(id1) {
		   ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=800, height=800, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function ask(id) {
			if (confirm("Do you want to remove this Event Trigger ?")) {
				ptoken.navigate('RecordPurge.cfm?id1='+id,'processDelete');
			}
		}	

	
	</script>	

</cfoutput>	

<tr><td>

	<cf_divscroll>

	<table width="94%" align="center" class="navigation_table">
	
		<tr class="labelmedium line">
		    <td></td> 
		    <td><cf_tl id="Code"></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="Associated Object"></td>
			<td align="center">Order</td>
			<td align="center">Officer</td>
			<td align="center">Created</td>
		</tr>
		
		<cfoutput query="SearchResult">
		   
		    <tr height="20" class="labelmedium2 line navigation_row">
				<td align="center" style="width:30px;padding-top:1px" id="processDelete"> 
					<table>
						<tr>
							<td>
								<cf_img navigation="Yes" icon="open" onclick="recordedit('#Code#')"> 
							</td>
							<td style="padding-right:4px">
								<cfquery name="CountRec" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT EventTrigger
										FROM PersonEvent
										WHERE EventTrigger  = '#code#' 
								</cfquery>
								
								<cfif CountRec.recordCount eq 0>
									<cf_img icon="delete" onclick="ask('#code#')"> 
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</tr>
					</table>
					
				</td>		
				<td>#Code#</td>
				<td>#Description#</td>
				
				<cfquery name="Entity" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Ref_Entity 
							WHERE EntityCode = '#EntityCode#'									
					</cfquery>
				
				<td>#Entity.EntityDescription#</td>
				<td align="center">#ListingOrder#</td>
				<td align="center">#OfficerLastName#</td>
				<td align="center">#dateformat(Created,client.dateformatshow)#</td>
		    </tr>
			
		</cfoutput>
		
	</table>

	</cf_divscroll>

</td></tr>

</table>

