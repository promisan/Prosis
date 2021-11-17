<!--- Create Criteria string for query from data entered thru search form --->
 
<cfquery name="SearchResult"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
		FROM 	Ref_SlipGroup
		ORDER BY PrintGroupOrder ASC
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0">
<cfset Header       = "Salary Entitlement Trigger Groups">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>

<cfoutput>

	<script LANGUAGE = "JavaScript">
	
		function recordadd(grp) {}
		
		function recordedit(id1) {
			ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=150, top=150, width=600, height=290, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
	
	</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
	
	<table width="97%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line fixlengthlist">
	    <td></td>
		<td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>
		<td align="center"><cf_tl id="Order"></td>
		<td align="center"><cf_tl id="Net Payment"></td>
	</tr>
	
	<cfoutput query="SearchResult">
		<tr class="labelmedium2 navigation_row line fixlengthlist">
			<td align="center" style="padding-top:1px;">
				<cf_img icon="open" navigation="Yes" onclick="recordedit('#PrintGroup#')">
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

</td></tr>

</table>
