
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Source
	ORDER  BY Created DESC
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Submission Source">
<cfinclude template = "../HeaderRoster.cfm"> 

 
<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height=390, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	         window.open("RecordEdit.cfm?ID1=" + id1 + "&idmenu=#url.idmenu#", "Edit", "left=80, top=80, width= 550, height=390, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>  

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding">

	<tr class="labelmedium line navigation_row">
	    <td ></td>
	    <td>Source</td>
		<td>Description</td>
		<td>Edit PHP</td>
		<td>PHP Mode</td>
		<td>Assesment</td>
		<td>Enrollment flow</td>		
		<td>Op</td>
	    <td>Entered</td>
	</tr>


	<cfoutput query="SearchResult">
	
		<tr style="height:20px" class="labelmedium navigation_row">
			<td width="10%" style="padding-top:3px" align="center"> <cf_img icon="select" navigation="Yes" onclick="recordedit('#Source#')"> </td>		
			<td><a href="javascript:recordedit('#Source#')">#Source#</a></td>
			<td>#Description#</td>
			<td><cfif AllowEdit eq "1">Yes<cfelse>No</cfif></td>
			<td>#PHPMode#</td>
			<td><cfif AllowAssessment eq "1">Yes<cfelse>No</cfif></td>
			<td>#EntityClass#</td>			
			<td><cfif Operational eq "1">Yes<cfelse>No</cfif></td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
	</cfoutput>
	
</tbody>
  
</table>

</cf_divscroll>
