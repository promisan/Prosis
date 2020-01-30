
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ApplicantClass
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Candidate Class">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Class</td>
		<td>Description</td>	
		<td>Usage Scope</td>	
		<td>IndexNo</td>
	    <td>Entered</td>  
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
		<tr class="navigation_row">
			<td width="5%" align="center">
			<cfif ApplicantClassId neq "0">
				  <cf_img icon="open" onclick="recordedit('#ApplicantClassId#')" navigation="Yes">
			</cfif>			  
			</td>	
			<td><a href="javascript:recordedit('#ApplicantClassId#')">#ApplicantClassId#</a></td>
			<td>#Description#</td>	
			<td>#Scope#</td>
			<td><cfif IndexNo eq "1">Required</cfif></td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
</tbody>
   
</table>

</cf_divscroll>