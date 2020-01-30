
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ApplicantSection
	ORDER BY TriggerGroup, ListingOrder ASC
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Candidate Section">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=", "Add", "left=80, top=80, width=850, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=850, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>	  
		<td align="center"><cf_tl id="Order"></td>	  
		<td align="center"><cf_tl id="Obligatory"></td>	  
		<td align="center"><cf_tl id="Operational"></td>	  
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult" group="TriggerGroup">
		<tr>
			<td colspan="6" class="labelit" style="font-size:20px;height:40px">#TriggerGroup#</td>
		</tr>
		<cfoutput>
			<tr class="navigation_row">
				<td width="5%" align="center">
				  <cf_img icon="edit" onclick="recordedit('#Code#')" navigation="Yes">
				</td>	
				<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
				<td>#Description#</td>
				<td align="center">#ListingOrder#</td>	
				<td align="center"><cfif Obligatory eq 1>Yes<cfelse><b>No</b></cfif></td>
				<td align="center"><cfif Operational eq 1>Yes<cfelse><b>No</b></cfif></td>
		    </tr>
		</cfoutput>
	</cfoutput>
</tbody>
   
</table>

</cf_divscroll>