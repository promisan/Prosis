

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_TransactionClass
	ORDER BY ListingOrder	
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table height="100%" width="98%" align="center">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddTransactionClass", "left=80, top=80, width=550, height= 275, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditTransactionClass", "left=80, top=80, width= 550, height= 275, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<cf_divscroll>

<table width="95%" border="0" align="center" class="formpadding navigation_table">

<tr class="labelmedium2 line">
    <TD></TD> 
    <TD>Code</TD>
	<td>Description</td>
	<td align="center">Negative</td>
	<td align="center">Listing Order</td>
	<TD>Officer</TD>
    <TD>Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
  
    <TR class="navigation_row line labelmedium2" bgcolor="FFFFFF"> 
	<td height="20" width="5%" align="center">
	  <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
	</td>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<TD align="center"><cfif quantityNegative eq 0>No<cfelse><b>Yes</b></cfif></TD>
	<TD align="center">#listingOrder#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>

</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>

