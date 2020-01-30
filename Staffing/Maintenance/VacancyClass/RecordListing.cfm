<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_VacancyActionClass
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
   ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=550, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
   ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=550, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelmedium line">
	    <td></td> 
	    <td style="padding:3px">Code</td>
		<td>Description</td>
		<td>Trigger</td>
		<td>Show</td>
		<td>Color</td>
		<td>Listing Order</td>
		<TD><CF_TL id="Officer"></TD>
	</tr>
	
	<cfoutput query="SearchResult">
	    
		<tr class="line labelmedium navigation_row">
			<td width="5%" align="center" style="padding-top:3px; height="14"">
			 <cf_img icon="edit" navigation="Yes" onclick="recordedit('#Code#')">
			</td>		
			<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
			<td>#Description#</td>
			<td><cfif TriggerTrack eq "1">Trigger</cfif></td>
			<td><cfif ShowVacancy eq "1">Yes</cfif></td>
			<td>
				<table height="16" width="14" style="border:1px solid silver" cellspacing="0" cellpadding="0" >
					<tr><td bgcolor="#PresentationColor#"></td></tr>
				</table>
			</td>
			<td>#ListingOrder#</td>
			<td>#OfficerUserid#</td>
		
	    </tr>	
			
	</cfoutput>

</table>

</cf_divscroll>
