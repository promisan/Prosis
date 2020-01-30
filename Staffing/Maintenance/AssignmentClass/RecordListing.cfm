
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AssignmentClass
	ORDER BY Listingorder 
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfoutput>

<script>

function recordadd() {
       window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 280, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
       window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 280, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium line">
    <td></td>
    <td>Code</td>
	<td width="30%">Label</td>
	<td>Oper.</td>
	<td>Incumb</td>
	<td>Sort</td>
	<td>Officer</td>
    <td align="right">Entered</td>
</tr>

<cfoutput query="SearchResult">
    <tr height="20" class="navigation_row line labelmedium"> 
		<td width="5%" align="center" style="padding-top:4px">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#AssignmentClass#')">
		</td>			
		<td>#AssignmentClass#</td>
		<td>#Description#</td>
		<td><cfif operational eq "1">Yes<cfelse>No</cfif></td>
		<td>#Incumbency#%</td>
		<td>#Listingorder#</td>
		<td>#OfficerLastName#</td>
		<td align="right">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>

</table>
