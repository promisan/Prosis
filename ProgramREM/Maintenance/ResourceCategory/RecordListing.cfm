
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #CLIENT.LanPrefix#Ref_Resource
	ORDER BY ListingOrder
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height=380, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=550, height= 380, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>
	
	<cf_divscroll>

		<table width="95%" align="center" class="navigation_table">
		
		<tr class="labelmedium2 line fixrow">
		    <td></td>
		    <td><cf_tl id="Code"></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="Execution"></td>
			<td><cf_tl id="Order"></td>	
			<td><cf_tl id="Officer"></td>
		    <td><cf_tl id="Entered"></td>  
		</tr>
		
		<cfoutput query="SearchResult">
			<tr class="navigation_row labelmedium2 line" style="padding-top:3px">	
				<td align="center" style="padding-top:3px">	
					<cf_img icon="select" navigation="Yes" onclick="recordedit('#Code#')">	
				</td>	
				<td>#Code#</td>
				<td>#Description#</td>
				<td><cfif executiondetail eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif></td>
				<td>#ListingOrder#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
		</cfoutput>
		
		</table>
	
	</cf_divscroll>

</td></tr></table>

