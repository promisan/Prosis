<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	
 
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_Beneficiary
	ORDER BY Description
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=180, toolbar=no, status=no, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
	<tr height="20" bgcolor="white" class="navigation_row">
		<td align="center" width="2%" style="padding-top:1px">
		   <cf_img icon="select" navigation="Yes" onclick="recordedit('#Code#')">
		</td>
		<td height="18">#Code#</td>
		<td>#Description#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>
</tbody>

</table>

</cf_divscroll>
