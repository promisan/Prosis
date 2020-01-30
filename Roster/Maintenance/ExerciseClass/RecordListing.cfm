
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_ExerciseClass
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Roster Exercise Class">
<cfinclude template = "../HeaderRoster.cfm"> 
  
<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height=440, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	    window.open("RecordEdit.cfm?ID1=" + id1 + "&idmenu=#url.idmenu#", "Edit", "left=80, top=80, width= 550,height=440, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>  

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<thead>
	<tr class="line labelmedium">
	    <td></td>
	    <td>Class</td>
		<td>Description</td>
		<td>Roster search</td>
		<td>Publish Tree</td>
		<td>Source</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
		<tr class="navigation_row labelit">
			<td width="10%" style="padding-top:3px" align="center" > <cf_img icon="select" navigation="Yes" onclick="recordedit('#ExcerciseClass#')"> </td>		
			<td class="labelmedium"><a href="javascript:recordedit('#ExcerciseClass#')">#ExcerciseClass#</a></td>
			<td class="labelmedium">#Description#</td>
			<td class="labelmedium"><cfif Roster eq "1">Enabled</cfif></td>
			<td class="labelmedium">#TreePublish#</td>
			<td class="labelmedium">#Source#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
</tbody>

</table>

</cf_divscroll>
