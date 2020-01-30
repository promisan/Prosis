<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Language 
	ORDER  BY LanguageName
</cfquery>

<cfset add          = "1">
<cfset Header       = "Language">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>
	
</cfoutput>

<cf_divscroll>

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<thead>
	<tr class="labelmedium linedotted">
	    <td></td>
	    <td>Id</td>
		<td>Language name</td>
		<td>Class</td>
		<td>Officer</td>
	    <td align="right">Entered</td>
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult"> 
		<tr style="height:20px" class="labelmedium navigation_row linedotted"> 
			<td width="7%" align="center">
				  <cf_img icon="open" navigation="Yes" onclick="recordedit('#LanguageId#')">
			</td>	
			<td>#LanguageId#</td>
			<td>#LanguageName#</td>
			<td>#LanguageClass#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td align="right" style="padding-right:4px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
</tbody>
	
</table>

</cf_divscroll>