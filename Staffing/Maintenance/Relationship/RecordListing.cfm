
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Relationship
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 390, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 390, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td> 
	    <td>Code</td>
		<td>Descriptive</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
	
	    <tr class="navigation_row"> 
			<td width="5%" align="center" style="padding-top:1px;"> 
			 <cf_img icon="open" navigation="Yes" onclick="recordedit('#Relationship#')">
			</td>		
			<td width="20%">#Relationship#</td>
			<td width="40%">#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfoutput>
</tbody>

</table>

</cf_divscroll>

</body>

</html>