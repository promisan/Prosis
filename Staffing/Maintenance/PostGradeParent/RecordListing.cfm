<!--- Create Criteria string for query from data entered thru search form --->
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostGradeParent P
	ORDER BY ViewOrder
</cfquery>

<cf_divscroll>
	
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	
	
<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height=320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height=320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="line labelmedium">
	    <td></td> 
	    <td>Code</td>
		<td>Description</td>
		<td>Order</td>
		<td>Show</td>
		<td>Post type</td>
		<td>Category</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>


<cfoutput query="SearchResult">
 
    <tr class="navigation_row line labelmedium">  
		<td width="5%" align="center" style="padding-top:4px">
			 <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
		</td>		
		<td>#Code#</td>
		<td>#Description#</td>
		<td>#ViewOrder#</td>
		<td>#ViewTotal#</td>
		<td>#Posttype#</td>
		<td>#Category#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>	

</cfoutput>

</table>
	
</cf_divscroll>
