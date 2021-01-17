 
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_ProgramGroup
	ORDER BY Mission, ListingOrder
</cfquery>


<cfoutput>

<script>
	function recordadd(grp) {
    	 ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	function recordedit(id1) {
	     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
</script>	

</cfoutput>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	    <td></td>
	    <td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>	
		<td><cf_tl id="Period"></td>
		<td><cf_tl id="Color"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>
	
	<cfoutput query="SearchResult" group="Mission">
	
	<tr class="line">
		<td colspan="7" style="padding-left;4px" height="28"><font size="4"><cfif mission eq "">Any<cfelse>#Mission#</cfif></font></td>
	</tr>
	
	<cfoutput>
	 
		<tr class="labelmedium3 line navigation_row">	
		    <td align="center" style="padding-top:3px">
				<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
			</td>
			<td>#Code#</a></td>
			<td>#Description#</td>	
			<td><cfif period eq "">Any<cfelse>#Period#</cfif></td>
			<td>#ViewColor#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		
	</cfoutput>
	
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td>

</tr>

</table>