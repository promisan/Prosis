<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ServiceItemClass
	ORDER BY ListingOrder
</cfquery>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="94%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Service class">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 580, height= 320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=580, height=320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2" style="padding-top:10px">

<cf_divscroll>

	<table width="100%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	   
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
			
	    <tr class="labelmedium2 navigation_row line"> 
			<td align="center" style="padding-top:2px;">
					<cf_img icon="select" navigation="Yes" onclick="recordedit('#Code#')">
			</td>		
			<td>#Code#</td>
			<td>#Description#</td>		
			<td align="center">#ListingOrder#</td>
			<td align="center"><cfif operational eq "No"><b>No</b><cfelse>Yes</cfif></td>
			<td>#officerFirstName# #officerLastName#</td>		
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	
		
	</cfoutput>
	
	</table>
	
</cf_divscroll>	

</td>
</tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

