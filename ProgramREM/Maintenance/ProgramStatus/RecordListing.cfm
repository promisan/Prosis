<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ProgramStatus
	ORDER BY StatusClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	
 
<cfoutput>
 
<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 270, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 270, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<cf_divscroll>

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelheader linedotted">
    <td>Class</td>
	<td></td>
    <td>Code</td>
	<td>Description</td>
	<td>Officer</td>
    <td>Entered</td>
</tr>

<cfoutput query="SearchResult" group="statusClass">
    
	<tr><td colspan="5" style="height:40px" class="labellarge">#StatusClass#</td></tr>
	
	<cfoutput>
	<tr class="labelmedium linedotted navigation_row">
		<td></td>
		<td align="center" style="padding-top:2px">
			<cf_img icon="select" onclick="recordedit('#Code#')" navigation="yes">
		</td>
		<td>#Code#</td>
		<td>#Description#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	</cfoutput>
	
</cfoutput>

</table>

</cf_divscroll>

</BODY></HTML>