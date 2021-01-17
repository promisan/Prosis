<!--- Create Criteria string for query from data entered thru search form --->
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_AddressType
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
	
	<cfoutput>
	
	<script LANGUAGE = "JavaScript">
	
	function recordadd(grp) {
	     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 590, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 590, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	
	
	</cfoutput>

<tr><td colspan="2">
	
	<cf_divscroll>
	
	<table width="96%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
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
	 
	    <tr class="labelmedium2 navigation_row line"> 
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
			
	</CFOUTPUT>
	
	</table>
	
	</cf_divscroll>
	
</td></tr>	
</table>