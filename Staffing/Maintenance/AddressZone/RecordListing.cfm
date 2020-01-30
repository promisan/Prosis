<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_AddressZone 
	ORDER BY mission, code
</cfquery>

<cf_divscroll>

<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0">

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelheader line">

    <td></td>
	<td width="5%">&nbsp;</td>
    <td>Code</td>
	<td>Description</td>	
	<td>Officer</td>
    <td>Entered</td>
</tr>

<cfoutput query="SearchResult" group="mission">

   <tr><td colspan="6" class="labelmedium"><b>#mission#</b></td></tr>
   <tr><td height="5"></td></tr>		   
   <tr><td height="1" colspan="6" class="linedotted"></td></tr>
   
   <cfoutput>

	<cfset row = currentrow>		
    <tr class="cellcontent linedotted navigation_row"> 
		<td></td>
		<td height="20" style="padding-left:4px"><cf_img icon="open" navigation="Yes" onclick="recordedit('#code#')"></td>		
		<td>#Code#</td>
		<td>#Description#</td>		
		<td>#officerFirstName# #officerLastName#</td>		
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

	</cfoutput>
	<tr><td height="10"></td></tr>
</CFOUTPUT>

</table>

</td>
</tr>

</table>

</cf_divscroll>