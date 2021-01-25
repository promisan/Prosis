
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    select *, (select count(*) from customer where terms = t.code) as customerOccurrences
	from Ref_Terms t
</cfquery>


<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="98%" height="100%" align="center" class="formpadding">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Terms">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1, id2) {
	          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&OC=" + id2, "Edit", "left=80, top=80, width= 500, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>

	<table width="97%" align="center" class="navigation_table">
	
		<tr class="labelmedium2 line" style="height:20px;">
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
				
		<cfoutput query="SearchResult">
		
		    <tr height="20" class="labelmedium2 line navigation_row"> 
			<td width="5%" align="center" style="padding-top:1px;">
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
		    		
		</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td>

</tr?

</table>



