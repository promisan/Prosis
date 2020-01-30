<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<HTML><HEAD></HEAD>

<cfquery name="SearchResult" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Rank
	ORDER  BY Code
</cfquery>

<body>

<cfset add          = "1">
<cfset Header       = "Award">
<cfinclude template = "../../HeaderCaseFile.cfm"> 

<cfoutput>

<script LANGUAGE = "JavaScript">

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<cf_divscroll>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">
	
	<thead>
		<tr>
		    <td width="5%"></td>
		    <td ><cf_tl id="Code"></td>
			<td ><cf_tl id="Description"></td>
			<td ><cf_tl id="Officer"></td>
		    <td ><cf_tl id="Entered"></td>
		</tr>
	</thead>
	
	<tbody>
		<cfoutput query="SearchResult">
			<tr class="navigation_row">
				<td align="center">
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
