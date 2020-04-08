<!--- Create Criteria string for query from data entered thru search form --->


<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_UoM
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
 	

<table width="99%" height="100%" align="center" cellspacing="0" cellpadding="0">

<tr><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>

</cfoutput> 

<tr><td style="height:100%">

	<cf_divscroll>
	
	<table align="center" width="97%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<tr class="labelmedium fixrow">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Order</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	
	<cfoutput query="SearchResult">
	 		
	    <tr class="navigation_row line labelmedium"> 
			<td align="center" style="padding-left:4px;padding-top:2px;padding-right:4px">
			   <cf_img icon="edit" navigation="yes" onclick="recordedit('#Code#');">
			</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td>#ListingOrder#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>			
	    </tr>
			
	</CFOUTPUT>
	
	</table>
	
	</cf_divscroll>
	
	</td>
</tr>

</table>

