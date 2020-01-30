
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, 
	      (SELECT count(*) 
		   FROM ServiceItemUnit 
		   WHERE UnitClass = U.Code) as ServiceItemUnitOccurrences			
	FROM  Ref_UnitClass U
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0">  

<cfoutput>

<script LANGUAGE = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 400, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&OC=" + id2, "Edit", "left=80, top=80, width= 400, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr> <td class="line" colspan="2"></td></tr>

<tr><td colspan="2">

	<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
		<tr style="height:20px;">
		    <td></td> 
		    <td class="labelit">Code</td>
			<td class="labelit">Description</td>
			<td class="labelit">Sort</td>	
			<td class="labelit">Officer</td>
		    <td class="labelit">Entered</td>
			<td align="right" class="labelit">Units</td>  
		</tr>
		
		<cfoutput query="SearchResult">
		
		    <tr><td height="1" colspan="7" class="line"></td></tr>	
		    <tr class="navigation_row"> 
			<td width="5%" align="center" style="padding-top:1px;">
				  <cf_img icon="open" navigation="Yes" onclick="recordedit('#code#', '#serviceItemUnitOccurrences#')">
			</td>		
			<td class="labelit" width="20%">#code#</td>
			<td class="labelit" width="40%">#description#</td>
			<td class="labelit" align="center">#listingOrder#</td>	
			<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
			<td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			<td width="10%" class="labelit" align="right">#serviceItemUnitOccurrences#</td>
		    </tr>	    	
		
		</cfoutput>
	
	</table>

</td>

</table>

</cf_divscroll>

<cfset AjaxOnLoad("doHighlight")>