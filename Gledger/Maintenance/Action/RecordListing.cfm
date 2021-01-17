<!--- Create Criteria string for query from data entered thru search form --->


<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Action
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table height="100%" width="97%" align="center" cellspacing="0" cellpadding="0" align="center">

<cfset add          = "1">
<cfset Header       = "Action">

<tr><td style="height:10px">
<cfinclude template = "../HeaderMaintain.cfm"> 
</td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 690, height= 570, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,id2) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 +"&ID2=" + id2, "Edit", "left=80, top=80, width= 690, height= 570, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput>	

<tr><td>
<cf_divscroll>

<table width="95%" class="navigation_table" align="center">

<thead>
<tr class="labelmedium2 line">
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
   	<tr class="labelmedium2 line navigation_row">
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

</td></tr>

</table>
