<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	L.*,
			(SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = L.OrgUnitVendor) as OrgUnitVendorName
	FROM 	ProductionLot L
	WHERE   TransactionLot != '0' and TransactionLot != ''
	ORDER BY Mission
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">

<table width="99%" height="100%" align="center">

<tr><td style="height:10px" colspan="2"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd() {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(mis, lot) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&mission=" + mis + "&lot=" + lot, "Edit", "left=80, top=80, width= 500, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

<cf_listingScriptNavigation>

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2" style="height:100%">

<cf_divscroll>

<table id="myListing" tabindex="1" width="97%" align="center" class="navigation_table">
	
	<tr class="labelmedium fixrow line">
	    <td></td>
		<td></td>
	    <td><cf_tl id="Lot"></td>
		<td><cf_tl id="Date"></td>
		<td><cf_tl id="Vendor"></td>
		<td><cf_tl id="Reference"></td>
		<td><cf_tl id="Memo"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>
	
	<cfoutput query="SearchResult" group="Mission">
	
	    <td colspan="8" class="labellarge">#Mission#</td>
		
		<cfoutput>
				
		    <tr class="cellcontent navigation_row line"> 
				<td></td>
				<td align="center" style="padding-left:10px">			   
				   <cf_img icon="edit" navigation="Yes"  onclick="recordedit('#Mission#', '#TransactionLot#');">
				</td>
				<td><cfif TransactionLot neq '0'>#TransactionLot#</cfif></td>
				<td>#Dateformat(TransactionLotDate, "#CLIENT.DateFormatShow#")#</td>
				<td>#OrgUnitVendorName#</td>
				<td>#Reference#</td>
				<td>#Memo#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
				
		</cfoutput>
		
		<tr><td height="10"></td></tr>
		
	</cfoutput>

</table>

</cf_divscroll>

</td>
</tr>

</table>

