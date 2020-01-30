
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_Contact
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Background Call Sign">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 475, height= 270, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 475, height= 270, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>	
		<td>Mask</td>	
		<td align="center">Order</td>
	    <td>Entered</td>  
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
		<tr class="navigation_row">
			<td width="5%" align="center">
			  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
			</td>	
			<td><a href="javascript:recordedit('#code#')">#Code#</a></td>
			<td>#Description#</td>	
			<td>#CallsignMask#</td>
			<td align="center">#ListingOrder#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	</cfoutput>
</tbody>
   
</table>

</cf_divscroll>