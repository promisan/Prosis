 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_AddressBuilding
</cfquery>

<cf_divscroll>
	
	<cfset Page         = "0">
	<cfset add          = "1">
	<cfinclude template = "../HeaderMaintain.cfm"> 		
	
	<table width="100%" align="center" cellspacing="0" cellpadding="0">
	
	<cfoutput>
	
	<script LANGUAGE = "JavaScript">
	
	function recordadd(grp) {
	     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height=275, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	
	
	</cfoutput>
		
	<tr><td colspan="2">
	
	<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr class="labelmedium line">
	    <td></td>
	    <td><cf_tl id="Code"></td>
		<td><cf_tl id="Name"></td>
		<td><cf_tl id="Description"></td>
		<td align="center"><cf_tl id="Levels"></td>  
	</tr>
	
	<cfoutput query="SearchResult">
	 
	    <tr class="labelmedium navigation_row"> 
		<td height="20" width="5%" align="center">
		 <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
		</td>		
		<td>#Code#</td>
		<td>#Name#</td>
		<td>#Description#</td>
		<td align="center">#Levels#</td>
	    </tr>
		
		<tr><td height="1" colspan="8" class="linedotted"></td></tr>	
	
	</CFOUTPUT>
	
	</table>
	
	</td>
	
	</table>
	
</cf_divscroll>
