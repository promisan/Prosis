
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_PresentationMode
	ORDER BY ListingOrder
</cfquery>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Billing mode">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddPresentationMode", "left=80, top=80, width= 500, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditPresentationMode", "left=80, top=80, width= 500, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>

	<table width="97%" class="formpadding" align="center">
	
		<tr class="labelmedium2 line">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td align="center">Listing Order</td>
			<td>Officer</td>
		    <td>Entered</td>
		  
		</tr>
				
		<cfoutput query="SearchResult">
		
		    <tr class="labelmedium2 line navigation_row"> 
			<td width="5%" align="center" style="padding-top:1px;">
			   <cf_img icon="open" onclick="recordedit('#Code#')">
			</td>		
			<td>#Code#</td>
			<td>#Description#</td>
			<td align="center">#listingOrder#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
		    			
		</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td>

</tr>

</table>
