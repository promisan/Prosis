
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Group
</cfquery>

<cfset add          = "1">
<cfset Header       = "Group">

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<cfoutput>
 
	<script language = "JavaScript">

		function recordadd(grp)	{
		     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height= 310, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 490, height= 310, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}

	</script>	

</cfoutput>

<tr><td style="height:100%">

	<cf_divscroll>
	
	<table width="97%" align="center" class="navigation_table">
	
	<thead>
		<tr class="fixrow labelmedium2 line">
		    <td></td> 
		    <td>Code</td>
			<td>Domain</td>
			<td>Description</td>
			<td>Officer</td>
		    <td>Entered</td>
		</tr>
	</thead>
	
	<tbody>
	
	<cfoutput query="SearchResult">
	 
	    <tr class="navigation_row labelmedium2 line">
			<td width="5%" align="center">
				  <cf_img icon="open" onclick="recordedit('#GroupCode#')" navigation="Yes">
			</td>		
			<td>#GroupCode#</td>
			<td>#GroupDomain#</td>
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