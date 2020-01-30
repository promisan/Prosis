
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, (SELECT count(*) 
	             FROM   ProgramAllotmentdetail 
				 WHERE  Fund IN (SELECT Code FROM Ref_Fund WHERE Fundtype = R.Code)) as Used	
	FROM     Ref_FundType R
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<cf_divscroll>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Status</td>
		<td>Order</td>
		<td>Officer</td>
	    <td>Entered</td>  
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
		<tr class="navigation_row">
			<td align="center">
				<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
			</td>
			<td>#Code#</a></td>
			<td>#Description#</a></td>
			<td><cfif used gte "1">In Use</cfif></td>
			<td>#ListingOrder#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
</tbody>

</table>

</cf_divscroll>
