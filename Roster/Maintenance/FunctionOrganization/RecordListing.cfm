

<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Organization
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Bucket Area">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>

	<table width="97%" align="center" class="navigation_table">
	
		<tr class="labelmedium2 line">
		    <td></td>
		    <td>Area code</td>
			<td>Description</td>
			<td>Officer</td>
		    <td>Entered</td>  
		</tr>
	</thead>
	
	<tbody>
		<cfoutput query="SearchResult">
			<tr class="navigation_row labelmedium2 line">
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
	
</td>
</tr>
</table>	
