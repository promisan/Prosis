
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    select *, (select count(*) from customer where terms = t.code) as customerOccurrences
	from Ref_Terms t
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0">  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&OC=" + id2, "Edit", "left=80, top=80, width= 500, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2" class="line"></td></tr>

<tr><td colspan="2">

	<table width="97%" cellspacing="0" cellpadding="1" align="center">
	
		<tr class="labelmedium" style="height:20px;">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td>Payment Days</td>
			<td>Discount</td>
			<td>Discount Days</td>
			<td>Operational</td>
			<td>Customer Occurrences</td>
			<td>Officer</td>
		    <td>Entered</td>
		  
		</tr>
		
		<tr><td colspan="10" class="line"></td></tr>	
		
		<cfoutput query="SearchResult">
		
		    <tr height="20" class="labelmedium"> 
			<td width="5%" align="center" style="padding-top:3px;">
				  <cf_img icon="open" onclick="recordedit('#code#', '#customerOccurrences#')">
			</td>		
			<td>#code#</td>
			<td>#description#</td>
			<td>#paymentDays#</td>
			<td>#discount#</td>
			<td>#discountDays#</td>
			<td><cfif #operational# eq 1>Yes<cfelse>No</cfif></td>
			<td>#customerOccurrences#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
		    	
			<tr><td class="line" colspan="10"></td></tr>
		
		</cfoutput>
	
	</table>

</td>

</table>

</cf_divscroll>

</BODY></HTML>