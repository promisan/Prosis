<!--- Create Criteria string for query from data entered thru search form --->

<cf_divscroll>

<cfset Header = "Competency">
<cfinclude template="../HeaderRoster.cfm">  
 
<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT CC.Description AS Category, C.*
	FROM  Ref_Competence C
	INNER JOIN Ref_CompetenceCategory CC
	ON C.CompetenceCategory = CC.Code
	ORDER BY CompetenceCategory, ListingOrder
</cfquery>

<cfoutput>

	<script language = "JavaScript">
	
	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=460, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 460, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	

</cfoutput>
	

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
<tr class="labelmedium linedotted">
    <td></td>
    <td>Id</td>
	<td>Description</td>
	<td>Order</td>
	<td>Oper.</td>
	<td>Officer</td>
    <td>Entered</td>
</tr>

<cfoutput query="SearchResult" group="Category">
	
	<tr class="linedotted"><td colspan="7" style="height:40px" class="labellarge">#Category#</b></td></tr>
	
	<cfoutput>
	    <tr height="20px" class="labelmedium linedotted navigation_row">
			<td align="center" width="35" style="padding-top:1px;">
				  <cf_img icon="open" onclick="recordedit('#CompetenceId#')" navigation="Yes">
			</td>	
			<td>#CompetenceId#</td>
			<td>#Description#</td>
			<td>#ListingOrder#</td>
			<td><cfif Operational eq "0">No</cfif></td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>

</cfoutput>
	
</table>


</cf_divscroll>