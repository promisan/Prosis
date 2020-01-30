<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_StockClass
	ORDER BY ListingOrder ASC
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="95%" align="center" cellspacing="0" cellpadding="0" >

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table class="navigation_table" tabindex="1" width="97%" border="0" cellspacing="0" cellpadding="0" align="center" >

<tr>
    <td align="left"></td>
    <td align="left" class="labelit">Code</td>
	<td align="left" class="labelit">Description</td>
	<td align="center" class="labelit">Order</td>
	<td align="left" class="labelit">Officer</td>
    <td align="left" class="labelit">Entered</td>
</tr>

<tr><td height="1" colspan="6" class="line"></td></tr>

<cfoutput query="SearchResult">
   	
    <tr class="navigation_row"> 
		<td align="center" style="padding-top:1px">
		   <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
		</td>
		<td class="labelit">#Code#</td>
		<td class="labelit">#Description#</td>
		<td class="labelit" align="center">#listingOrder#</td>
		<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
		<td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		
    </tr>
	
	<tr><td colspan="6" class="line"></td></tr>

</CFOUTPUT>

</table>

</td>

</table>

</cf_divscroll>