
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ApplicantSection
	ORDER BY TriggerGroup, ListingOrder ASC
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Candidate Section">

<table width="98%" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=", "Add", "left=80, top=80, width=850, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=850, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td>

<cf_divscroll>

<table width="95%" align="center" class="navigation_table">

<thead>
	<tr class="line labelmedium2">
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
		<tr class="labelmedium2 line">
			<td colspan="6" style="font-size:20px;height:40px">#TriggerGroup#</td>
		</tr>
		<cfoutput>
			<tr class="navigation_row labelmedium line">
				<td width="5%" align="center">
				  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
				</td>	
				<td>#Code#</td>
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

</td></tr>

</table>
