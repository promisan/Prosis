
<HTML><HEAD><TITLE>Roster areas</TITLE></HEAD>

<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Organization
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Bucket Area">
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
	    <td>Area code</td>
		<td>Description</td>
		<td>Officer</td>
	    <td>Entered</td>  
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
		<tr class="navigation_row">
			<td width="5%" align="center">
			<cfif OrganizationCode neq "[ALL]">
				<cf_img icon="open" onclick="recordedit('#Organizationcode#')" navigation="Yes">
			</cfif>			  
			</td>	
			<td><a href="javascript:recordedit('#Organizationcode#')">#Organizationcode#</a></td>
			<td><cfif OrganizationCode eq "[ALL]">Default<cfelse>#OrganizationDescription#</cfif></td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
</tbody>

</table>

</cf_divscroll>

</BODY></HTML>