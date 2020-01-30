
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_PresentationMode
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0">  

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddPresentationMode", "left=80, top=80, width= 500, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditPresentationMode", "left=80, top=80, width= 500, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr>
	<td colspan="2" class="line"></td>
</tr>

<tr><td colspan="2">

	<table width="97%" cellspacing="0" cellpadding="1" align="center">
	
		<tr style="height:20px;">
		    <td></td> 
		    <td class="labelit">Code</td>
			<td class="labelit">Description</td>
			<td class="labelit" align="center">Listing Order</td>
			<td class="labelit">Officer</td>
		    <td class="labelit">Entered</td>
		  
		</tr>
		
		<tr><td colspan="6" class="line"></td></tr>	
		
		<cfoutput query="SearchResult">
		
		    <tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF"> 
			<td width="5%" align="center" style="padding-top:1px;">
			   <cf_img icon="open" onclick="recordedit('#Code#')">
			</td>		
			<td class="labelit">#Code#</td>
			<td class="labelit">#Description#</td>
			<td class="labelit" align="center">#listingOrder#</td>
			<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
			<td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
		    	
			<tr><td class="line" colspan="6"></td></tr>
		
		</cfoutput>
	
	</table>

</td>

</table>

</cf_divscroll>