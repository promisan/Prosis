<cf_divscroll>


<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ShipToMode
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%" border="0" align="center" cellspacing="0" cellpadding="0">  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddShipToMode", "left=80, top=80, width= 650, height=350, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditShipToMode", "left=80, top=80, width=950, height=500, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td colspan="6" height="30" class="labelit" style="color:gray;">
	The modes under which requested items may be tasked. The mode also defines the print of the tasked requests on a per entity basis.
</td></tr>

<tr>
    <TD></TD> 
    <TD class="labelmedium">Code</TD>
	<td class="labelmedium">Description</td>
	<td class="labelmedium" align="center">Order</td>
	<TD class="labelmedium">Officer</TD>
    <TD class="labelmedium">Entered</TD>
  
</TR>

<cfoutput query="SearchResult">

    <tr><td class="line" colspan="6"></td></tr>	

    <TR class="navigation_row"> 
	<td width="5%" align="center" style="padding-top:1px">
	 <cf_img icon="open"  navigation="Yes" onclick="recordedit('#Code#');">
	</td>		
	<TD class="labelmedium">#Code#</TD>
	<TD class="labelmedium">#Description#</TD>
	<TD align="center" class="labelmedium">#listingOrder#</TD>
	<TD class="labelmedium">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelmedium">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>    	

</CFOUTPUT>

<tr><td class="line" colspan="6"></td></tr>

</TABLE>

</td>

</tr>

</TABLE>

</cf_divscroll>