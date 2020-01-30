<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ScheduleClass
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
   window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
   window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>	

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td> 
	    <td>Code</td>
		<td>Description</td>
		<td>Sort</td>
		<td>Officer</td>
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
	    <tr height="20" class="navigation_row">
		<td width="5%" align="center"> <cf_img navigation="Yes" icon="open" onclick="recordedit('#Code#')"> </td>		
		<td>#Code#</td>
		<td>#Description#</td>
		<td>#ListingOrder#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
	    </tr>
	</cfoutput>
</tbody>	

</table>

</cf_divscroll>