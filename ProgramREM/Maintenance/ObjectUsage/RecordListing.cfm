
<cfquery name="SearchResult"
datasource="appsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ObjectUsage
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 
 
 <cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height=225, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height=225, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>## OE</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
    <tr class="navigation_row"> 
		<td align="center">
		  <cf_img icon="open" onclick="recordedit('#code#')" navigation="yes">
		</td>
		<td>#Code#</td>
		<td>#Description#</td>
		<td>
			<cfquery name="count"
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*
				FROM 	Ref_Object
				WHERE	ObjectUsage = '#Code#'
			</cfquery>
			#count.recordCount#
		</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

</cfoutput>
</tbody>

</table>

</cf_divscroll>