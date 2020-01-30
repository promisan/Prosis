<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

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
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="99%" align="center" cellspacing="0" cellpadding="0" >

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

<tr><td colspan="2">

<table id="myListing" tabindex="1" width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelit">
    <td align="left"></td>
	<td align="left"></td>
    <td align="left"><cf_tl id="Lot"></td>
	<td align="left"><cf_tl id="Date"></td>
	<td align="left"><cf_tl id="Vendor"></td>
	<td align="left"><cf_tl id="Reference"></td>
	<td align="left"><cf_tl id="Memo"></td>
    <td align="left"><cf_tl id="Entered"></td>
</tr>

<tr><td colspan="8" class="line"></td></tr>

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

</td>
</tr>

</table>

</cf_divscroll>