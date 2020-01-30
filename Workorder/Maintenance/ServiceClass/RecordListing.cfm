<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ServiceItemClass
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="97%" align="center" cellspacing="0" cellpadding="1">

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 480, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=480, height=290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2" style="padding-top:10px">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr style="height:20px;" class="labelmedium">
   
	<td width="5%">&nbsp;</td>
    <td>Code</td>
	<td>Description</td>	
	<td align="center">Sort</td>	
	<td align="center">Oper.</td>
	<td>Officer</td>
    <td>Entered</td>
  
</tr>

<cfoutput query="SearchResult">

	<cfset row = currentrow>
		
    <tr height="18" style="height:15px" class="labelmedium navigation_row line"> 
		<td align="center" style="padding-top:2px;">
				<cf_img icon="select" navigation="Yes" onclick="recordedit('#Code#')">
		</td>		
		<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
		<td>#Description#</td>		
		<td align="center">#ListingOrder#</td>
		<td align="center"><cfif operational eq "No"><b>No</b><cfelse>Yes</cfif></td>
		<td>#officerFirstName# #officerLastName#</td>		
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>	
	
</cfoutput>

</table>

</td>
</tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

</cf_divscroll>