
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

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Unit class">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script LANGUAGE = "JavaScript">

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 600, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1, id2) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&OC=" + id2, "Edit", "left=80, top=80, width= 600, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>

	<table width="95%" align="center" class="navigation_table">
	
		<tr class="labelmedium2 line fixrow">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td>Sort</td>	
			<td>Officer</td>
		    <td>Entered</td>
			<td align="right">Units</td>  
		</tr>
		
		<cfoutput query="SearchResult">
				   
		    <tr class="navigation_row line labelmedium2"> 
			<td width="5%" align="center" style="padding-top:1px;">
				  <cf_img icon="open" navigation="Yes" onclick="recordedit('#code#', '#serviceItemUnitOccurrences#')">
			</td>		
			<td width="20%">#code#</td>
			<td width="40%">#description#</td>
			<td align="center">#listingOrder#</td>	
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			<td width="10%" align="right">#serviceItemUnitOccurrences#</td>
		    </tr>	    	
		
		</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td>
</tr>

</table>


<cfset AjaxOnLoad("doHighlight")>