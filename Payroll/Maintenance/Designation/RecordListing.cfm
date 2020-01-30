<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_Designation
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderPayroll.cfm"> 	
 
 <cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 460, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 460, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
<tr>
    <td width="30"></td>
	<td align="center" width="70">Order</td>
    <td>Code</td>
	<td>Description</td>
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
		<td align="center">#listingOrder#</td>
		<td>#Code#</td>
		<td>#Description#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>
</tbody>

</cf_divscroll>