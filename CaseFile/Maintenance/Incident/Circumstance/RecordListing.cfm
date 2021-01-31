<cfquery name="SearchResult" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Incident
	WHERE  Class = 'Circumstance'
	ORDER BY Code
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfset Header       = "Circumstance">
<tr style="height:10px"><td><cfinclude template = "../../HeaderCaseFile.cfm"> </td></tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 590, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 590, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
		
	<table width="97%" align="center" class="navigation_table">
	
	<thead>
		<tr class="labelmedium2 line fixrow">
		    <td width="5%"></td>
		    <td>&nbsp;<cf_tl id="Code"></td>
			<td><cf_tl id="Description"></td>
			<td><cf_tl id="Officer"></td>
		    <td><cf_tl id="Entered"></td>
		</tr>
	</thead>
	
	<tbody>
		<cfoutput query="SearchResult">
		       
			<tr class="navigation_row line labelmedium2">
				<td>
				  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="yes">
				</td>	
				<td>#Code#</td>
				<td>#Description#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>	 
			
		</cfoutput>
	</tbody>
	
	</table>

</cf_divscroll>

</td>
</tr>

</table>


