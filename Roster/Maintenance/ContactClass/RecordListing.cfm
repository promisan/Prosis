
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ContactClass
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">
	
	<cfset Page         = "0">
	<cfset add          = "1">
	<cfset Header       = "Background Contact Class">
	<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="formpadding navigation_table">
		
		<thead>
			<tr  class="labelmedium2 line">
			    <td></td>
			    <td>Code</td>
				<td>Description</td>	
				<td align="center">Order</td>
			    <td>Entered</td>  
			</tr>
		</thead>
		
		<tbody>
			<cfoutput query="SearchResult">
				<tr class="labelmedium2 line navigation_row">
					<td width="5%" align="center">
					  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
					</td>	
					<td>#Code#</td>
					<td>#Description#</td>	
					<td align="center">#ListingOrder#</td>
					<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			    </tr>
			</cfoutput>
		</tbody>
	   
	</table>
	
	</cf_divscroll>

</td>
</tr>

</table>