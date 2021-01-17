<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Bank Institution">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>
	
	<cfquery name="SearchResult"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_Bank	
	</cfquery>
	
	<cfoutput>
	
	<script language = "JavaScript">
	
		function recordadd(grp) {
		      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=490, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id) {
		      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id, "Edit", "left=80, top=80, width=490, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	
	
	</cfoutput>
	
<tr><td>
	
	<cf_divscroll>
		
	<table width="97%" align="center" class="navigation_table">
		
		<thead>
			<tr class="line labelmedium2">   
			    <td></td>
			    <td><cf_tl id="Code"></td>
				<td><cf_tl id="Description"></td>
				<td>Op</td>		
			</tr>
		</thead>
		
		<tbody>
			<cfoutput query="SearchResult">
			    <tr class="navigation_row labelmedium line">
					<td align="center" height="20" style="padding-top:1px;">
					   <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
					</td>
					<td>#Code#</td>
					<td>#Description#</td>
					<td><cfif Operational eq "0"><cf_tl id="No"></cfif></td>			
			    </tr>	
			</cfoutput>
		</tbody>
		
	</table>

	</cf_divscroll>

</td>
</tr>

</table>
