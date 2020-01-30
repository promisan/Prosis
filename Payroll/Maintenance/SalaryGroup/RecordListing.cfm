<!--- Create Criteria string for query from data entered thru search form --->

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Salary Entitlement Trigger Groups">
<cfinclude template = "../HeaderPayroll.cfm"> 
 
<cfquery name="SearchResult"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
		FROM 	Ref_SlipGroup
		ORDER BY PrintGroupOrder ASC
</cfquery>

<cfoutput>

	<script LANGUAGE = "JavaScript">
	
		function recordadd(grp) {
			
		}
		
		function recordedit(id1) {
			window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=150, top=150, width=600, height=250, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
	
	</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium linedotted">
    <td></td>
	<td><cf_tl id="Code"></td>
	<td><cf_tl id="Description"></td>
	<td align="center"><cf_tl id="Order"></td>
	<td align="center"><cf_tl id="Net Payment"></td>
</tr>

<cfoutput query="SearchResult">
	<tr class="labelmedium navigation_row linedotted">
		<td width="6%" align="center" style="padding-top:2px;">
			<cf_img icon="select" navigation="Yes" onclick="recordedit('#PrintGroup#')">
		</td>	
		<td>#PrintGroup#</td>
		<td>#Description#</td>
		<td align="center">#PrintGroupOrder#</td>
		<td align="center">
			<cfif NetPayment eq 1>
				<cf_tl id="Yes">
			<cfelse>
				<cf_tl id="No">
			</cfif>
		</td>
	</tr>
</cfoutput>

</table>

</cf_divscroll>
