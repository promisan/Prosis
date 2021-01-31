
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_ExerciseClass
</cfquery>
   
<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">
	
	<cfset Page         = "0">
	<cfset add          = "1">
	<cfset Header       = "Roster Exercise Class">
	<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>
			
	<cfoutput>
	
	<script language = "JavaScript">
	
		function recordadd(grp) {
		    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height=440, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		    ptoken.open("RecordEdit.cfm?ID1=" + id1 + "&idmenu=#url.idmenu#", "Edit", "left=80, top=80, width= 550,height=440, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	
	
	</cfoutput> 
	
	<tr><td>
	
		<cf_divscroll>
	
			<table width="97%" align="center" class="navigation_table">
			
			<thead>
				<tr class="line labelmedium fixrow">
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
					<tr class="navigation_row labelmedium2 line">
						<td width="10%" style="padding-top:3px" align="center" > <cf_img icon="select" navigation="Yes" onclick="recordedit('#ExcerciseClass#')"> </td>		
						<td><a href="javascript:recordedit('#ExcerciseClass#')">#ExcerciseClass#</a></td>
						<td>#Description#</td>
						<td><cfif Roster eq "1">Enabled</cfif></td>
						<td>#TreePublish#</td>
						<td>#Source#</td>
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
