
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Group
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Group">
<cfinclude template = "../HeaderRoster.cfm">

<cfoutput>
 
	<script language = "JavaScript">

		function recordadd(grp)
		{
		     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 210, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1)
		{
		     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 210, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}

	</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td> 
	    <td>Code</td>
		<td>Domain</td>
		<td>Description</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>

<cfoutput query="SearchResult">
 
    <tr class="navigation_row">
		<td width="5%" align="center">
			  <cf_img icon="open" onclick="recordedit('#GroupCode#')" navigation="Yes">
		</td>		
		<td>#GroupCode#</td>
		<td>#GroupDomain#</td>
		<td>#Description#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

</cfoutput>

</tbody>

</table>

</cf_divscroll>