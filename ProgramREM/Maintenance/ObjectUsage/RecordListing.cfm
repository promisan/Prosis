
<cfquery name="SearchResult"
datasource="appsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ObjectUsage
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
 <cfoutput>

<script>

function recordadd(grp) {
         ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height=325, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
         ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height=325, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>


<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">

	<tr class="labelmedium2 line fixrow">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>## OE</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>

	<cfoutput query="SearchResult">
	    <tr class="navigation_row line labelmedium2"> 
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
	
	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>