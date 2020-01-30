
<HTML><HEAD><TITLE>Event category</TITLE></HEAD>

<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_EventCategory
</cfquery>

<cf_divscroll>

<cfset Page = "0">
<cfset Header = "Event Category">
<cfinclude template="../HeaderRoster.cfm">  
 
<cfoutput>

<script LANGUAGE = "JavaScript">
	
	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<table width="97%" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Operational</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>
	
<tbody>
	<cfoutput query="SearchResult">
		<tr class="navigation_row">
			<td width="5%" align="center">
				  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
			</td>		
			<td>#Code#</td>
			<td>#Description#</td>
			<td><cfif #Operational# eq "1">Yes</cfif></td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
</tbody>
  
</table>


</cf_divscroll>
