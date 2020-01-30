
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_EventTrigger
	Order by ListingOrder
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

	<script>
	
		function recordadd(grp) {
		   window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=250, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordedit(id1) {
		   window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=800, height=800, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function ask(id) {
			if (confirm("Do you want to remove this Event Trigger ?")) {
				ColdFusion.navigate('RecordPurge.cfm?id1='+id,'processDelete');
			}
		}	

	
	</script>	

</cfoutput>	


<script language="JavaScript">


</script>

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

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
	   
	    <tr height="20" class="labelmedium linedotted navigation_row">
			<td width="5%" align="center" style="padding-top:1px" id="processDelete"> 
				<table>
					<tr>
						<td>
							<cf_img navigation="Yes" icon="open" onclick="recordedit('#Code#')"> 
						</td>
						<td style="padding-left:5px;" width="20px">
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
			<td class="cellcontent">#Code#</td>
			<td class="cellcontent">#Description#</td>
			
			<cfquery name="Entity" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   Ref_Entity 
									WHERE EntityCode = '#EntityCode#'									
							</cfquery>
			
			<td class="cellcontent">#Entity.EntityDescription#</td>
			<td class="cellcontent" align="center">#ListingOrder#</td>
			<td class="cellcontent" align="center">#OfficerLastName#</td>
			<td class="cellcontent" align="center">#dateformat(Created,client.dateformatshow)#</td>
	    </tr>
		
	</cfoutput>
	
</table>

</cf_divscroll>
