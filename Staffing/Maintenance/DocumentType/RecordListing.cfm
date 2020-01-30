
<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *  
	FROM Ref_DocumentType
</cfquery>
 
<cfoutput>
 
<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 480, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 480, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">


	<tr class="labelmedium line">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Removal</td>
		<td>Edit</td>
		<td>Validation</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	

	<cfoutput query="SearchResult">
	    <tr class="navigation_row line labelmedium"> 
			<td width="5%" align="center" style="padding-top:4px">
			   <cf_img icon="open" navigation="Yes" onclick="recordedit('#DocumentType#');">
			</td>			
			<td>#DocumentType#</td>
			<td>#Description#</td>
			<td><cfif EnableRemove eq "1">Yes</cfif></td>
			<td><cfif EnableEdit eq "1">Yes</cfif></td>
			<td><cfif VerifyDocumentNo eq "0">Optional<cfelseif VerifyDocumentNo eq "1">Obligatory<cfelse>Validate</cfif></td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	
	</cfoutput>

</table>

</cf_divscroll>