
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    select *, (select count(*) from serviceItemUnit where billingMode = bm.code) as serviceItemUnitOccurrences
	from Ref_BillingMode bm
</cfquery>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Billing mode">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 225, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&OC=" + id2, "Edit", "left=80, top=80, width= 500, height= 225, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>
	
	<table width="93%" align="center" class="navigation_table">
	
		<tr class="labelmedium2 line" style="height:20px;">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td>Units</td>
			<td>Officer</td>
		    <td>Entered</td>
		  
		</tr>
				
		<cfoutput query="SearchResult">
		
		    <tr class="line labelmedium2 navigation_row" height="20" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"> 
			<td width="5%" align="center" style="padding-top:1px;">
					<cf_img icon="open" onclick="recordedit('#code#', '#serviceItemUnitOccurrences#')">
			</td>		
			<td width="20%">#code#</td>
			<td width="30%">#description#</td>
			<td>#serviceItemUnitOccurrences#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
		    
				
		</CFOUTPUT>
	
	</table>
	
	</cf_divscroll>

</td>
</tr>

</table>


