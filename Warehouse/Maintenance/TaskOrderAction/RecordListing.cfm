<cf_divscroll>

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	T.*,
			(SELECT Description FROM Ref_ShipToMode WHERE Code = T.ShipToMode) as ShipToModeDescription
	FROM 	Ref_TaskOrderAction T
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="99%"  border="0" align="center" bordercolor="silver" cellspacing="0" cellpadding="0"  >  

<cfoutput>

<script>

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddTaskOrderClass", "left=80, top=80, width= 500, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditTaskOrderClass", "left=80, top=80, width= 535, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table"">

<tr class="labelit">
    <TD></TD> 
    <TD>Code</TD>
	<td>Description</td>
	<td>Mode of Shipment</td>
	<td>Order</td>
	<TD>Officer</TD>
    <TD>Entered</TD>  
</TR>
<tr ><td colspan="7" class="line"></td></tr>	

<cfoutput query="SearchResult">
    
    <TR class="navigation_row line labelit" bgcolor="FFFFFF"> 
	<td width="5%" align="center">
	   <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
	</td>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<td>#ShipToModeDescription#</td>
	<TD>#listingOrder#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	    	
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>