
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ProgramEvent
	ORDER BY ListingOrder
</cfquery>

	
<cfset Header = "Project Events">
<cfset page   = "0">
<cfinclude template="../HeaderMaintain.cfm">  

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	      window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=800, height=500, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	      window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=800,height=500, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	</script>	
	
</cfoutput>	

<cf_divscroll>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelmedium line">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>		
		<td>Enabled to</td>
		<td align="center">Sort</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>

	<cfoutput query="SearchResult">    
	
		<tr class="navigation_row line labelmedium">
		    <td align="center" style="padding-top:3px"><cf_img icon="select" onclick="recordedit('#Code#')" navigation="yes"> </td>	
			<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>	
			<td>#Description#</td>
			
			<td>
			
			<cfquery name="Mission"
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM Ref_ProgramEventMission
				WHERE ProgramEvent = '#Code#'	
			</cfquery>
			
			<cfset vMission = "">
			<cfloop query="Mission">
				<cfset vMission = vMission & "#mission#, ">
			</cfloop>
			<cfif len(vMission) gt 0>
				<cfset vMission = mid(vMission, 1, len(vMission) - 2)>
			</cfif>
			
			#vMission#
			
			</td>
			<td  align="center">#ListingOrder#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		
	</cfoutput>

</table>

</cf_divscroll>
