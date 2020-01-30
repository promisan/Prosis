 
<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_ProgramGroup
	ORDER BY Mission, ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<cf_divscroll>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelheader line">
    <td></td>
    <td>Code</td>
	<td>Description</td>	
	<td>Period</td>
	<td>Color</td>
	<td>Officer</td>
    <td>Entered</td>
</tr>

<cfoutput query="SearchResult" group="Mission">

<tr class="linedotted">
	<td colspan="7" style="padding-left;4px" height="28"><b><font face="Calibri" size="3"><cfif mission eq "">Any<cfelse>#Mission#</cfif></font></td>
</tr>

<cfoutput>
 
	<tr class="cellcontent linedotted navigation_row">	
	    <td align="center" height="19" style="padding-top:1px">
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