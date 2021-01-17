
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ProgramEvent
	ORDER BY ListingOrder
</cfquery>

<cfset Header = "Project Events">

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>


<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=800, height=500, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=800,height=500, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	</script>	
	
</cfoutput>	

<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">

	<tr class="labelmedium2 line">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>		
		<td>Enabled to</td>
		<td align="center">Sort</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>

	<cfoutput query="SearchResult">    
	
		<tr class="navigation_row line labelmedium2">
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

</td>
</tr>
</table>

