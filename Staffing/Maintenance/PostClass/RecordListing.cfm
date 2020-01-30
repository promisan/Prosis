<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostClass
	Order by ListingOrder
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
   window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
   window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height=350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>	

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelmedium line">
	    <td></td> 
	    <td>Code</td>
		<td>Description</td>
		<td>Grouping</td>
		<td>Color</td>
		<td>Order</td>
	</tr>
	
	<cfoutput query="SearchResult">
	   
	    <tr height="20" class="labelmedium linedotted navigation_row">
			<td width="5%" align="center" style="padding-top:1px"> <cf_img navigation="Yes" icon="open" onclick="recordedit('#PostClass#')"> </td>		
			<td class="cellcontent">#PostClass#</td>
			<td class="cellcontent">#Description#</td>
			<td class="cellcontent">#PostClassGroup#</td>
			<td>
				<table height="16" border="0" style="border:1px solid silver" width="14" cellspacing="0" cellpadding="0" >
					<tr><td bgcolor="#PresentationColor#"></td></tr>
				</table>
			</td>
			<td class="cellcontent">#ListingOrder#</td>
	    </tr>
		
	</cfoutput>
	
</table>

</cf_divscroll>

</BODY></HTML>