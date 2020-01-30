<!--- Create Criteria string for query from data entered thru search form --->

<HTML><HEAD><TITLE>Address Type</TITLE></HEAD>

 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_AddressType
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>
	
	<cfset Page         = "0">
	<cfset add          = "1">
	<cfinclude template = "../HeaderMaintain.cfm"> 		
	
	<table width="100%" align="center" cellspacing="0" cellpadding="0">
	
	<cfoutput>
	
	<script LANGUAGE = "JavaScript">
	
	function recordadd(grp) {
	     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 490, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	
	
	</cfoutput>
		
	<tr><td colspan="2">
	
	<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr class="labelmedium line">
	    <td></td>
	    <td>Id</td>
		<td>Description</td>
		<td>Workflow</td>
		<td align="center">Color</td>
		<td align="center">Ope.</td>
		<td>Officer</td>
	    <td>Entered</td>  
	</tr>
	
	<cfoutput query="SearchResult">
	 
	    <tr class="labelmedium navigation_row"> 
		<td height="20" width="5%" align="center">
		 <cf_img icon="open" navigation="Yes" onclick="recordedit('#AddressType#');">
		</td>		
		<td>#AddressType#</a></td>
		<td>#Description#</td>
		<td>#EntityClass#</td>
		<td align="center">
			<table height="16" width="14" cellspacing="0" cellpadding="0" >
				<tr><td bgcolor="#MarkerColor#"></td></tr>
			</table>
		</td>
		<td align="center"><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		
		<tr><td height="1" colspan="8" class="linedotted"></td></tr>	
	
	</CFOUTPUT>
	
	</table>
	
	</td>
	
	</table>
	
</cf_divscroll>

</BODY></HTML>