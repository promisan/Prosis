<!--- Create Criteria string for query from data entered thru search form --->


<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Terms
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Payment Terms">

<table height="100%" width="94%" align="center" align="center">

<tr><td style="height:10px">
<cfinclude template = "../HeaderMaintain.cfm"> 
</td></tr>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=490, height=290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id, "Edit", "left=80, top=80, width= 490, height=290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
	
	<table width="97%" align="center" class="navigation_table">
	
	<thead>
		<tr class="line labelmedium2">
		    <td></td>
		    <td>Description</font></td>
			<td>Net days</font></td>
			<td>Discount days</font></td>
			<td>Percentage</font></td>
			<td>Officer</font></td>
		    <td>Entered</font></td>
		</tr>
	</thead>
	
	<tbody>
	<cfoutput query="SearchResult">
	    <tr class="navigation_row labelmedium2 line">
			<td align="center" style="padding-top:1px;width:30">
		 	   <cf_img icon="open" onclick="recordedit('#Code#')" navigation="yes">
			</td>
			<td>#Description#</a></td>
			<td>#NumberFormat(Paymentdays,'____')#</td>
			<td>#NumberFormat(Discountdays,'____')#</td>
			<td>#NumberFormat(Discount*100,'____._')#%</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
	</tbody>
	
	</table>
	
	</cf_divscroll>

</td></tr>

</table>
