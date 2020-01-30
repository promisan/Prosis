<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Actions">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Action
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 570, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,id2) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 +"&ID2=" + id2, "Edit", "left=80, top=80, width= 590, height= 570, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput>	

<table width="95%" cellpadding="0" cellspacing="0" class="navigation_table" align="center">

<thead>
<tr class="labelmedium line">
    <td></td>
    <td>Code</td>
	<td>Description</td>
	<td>Template</td>
	<td>Listing Order</td>
	<td>Lead Days</td>
	<td>Body Text</td>
    <td>Open</td>
	<td>Oper.</td> 
</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
   	<tr class="labelmedium line navigation_row">
		<td align="center" style="height:20px;width:30px;padding-top:1px;">
		    <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#')">
		</td>
	   	<td>#Code#</td>
		<td>#Description#</td>
		<td>#Template#</td>
		<td>#ListingOrder#</td>
		<td>#LeadDays#</td>
		<td>#MailTextBody#</td>
		<td><cfif isOpen eq "1">Yes<cfelse>No</cfif></td>
		<td><cfif Operational eq "1">Yes<cfelse>No</cfif></td>
    </tr>
</cfoutput>
</tbody>

</table>

</cf_divscroll>
