
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #CLIENT.LanPrefix#Ref_Resource
	ORDER BY ListingOrder
</cfquery>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height=380, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=550, height= 380, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<thead>
<tr class="labelmedium line">
    <td></td>
    <td><cf_tl id="Code"></td>
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Execution"></td>
	<td><cf_tl id="Order"></td>	
	<td><cf_tl id="Officer"></td>
    <td><cf_tl id="Entered"></td>  
</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
	<tr height="20" class="navigation_row labelmedium line" style="padding-top:3px;height:20px">	
		<td align="center" style="padding-top:2px">	
			<cf_img icon="edit" navigation="Yes" onclick="recordedit('#Code#')">	
		</td>	
		<td>#Code#</td>
		<td>#Description#</td>
		<td><cfif executiondetail eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif></td>
		<td>#ListingOrder#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>
</tbody>

</table>

