
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AssignmentType
</cfquery>



<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>
<cf_divscroll>

<table width="97%" align="center" class="navigation_table">

	<tr class="labelmedium line">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>		
		<td>Officer</td>
	    <td>Entered</td>
	</tr>

<cfoutput query="SearchResult">
    <tr class="navigation_row labelmedium line"> 
		<td width="5%" align="center" style="padding-top:1px">
		 <cf_img icon="open" onclick="recordedit('#AssignmentType#')" navigation="Yes">
		</td>		
		<td>#AssignmentType#</td>
		<td>#Description#</td>		
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>

</table>

</cf_divscroll>

</td></tr>

</table>
