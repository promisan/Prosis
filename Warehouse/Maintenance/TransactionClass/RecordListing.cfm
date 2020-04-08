<cf_divscroll>

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_TransactionClass
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%"  border="0" align="center" cellspacing="0" cellpadding="0">  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddTransactionClass", "left=80, top=80, width=550, height= 275, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditTransactionClass", "left=80, top=80, width= 550, height= 275, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="labelmedium line">
    <TD></TD> 
    <TD>Code</TD>
	<td>Description</td>
	<td align="center">Negative</td>
	<td align="center">Listing Order</td>
	<TD>Officer</TD>
    <TD>Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
  
    <TR class="navigation_row line labelmedium" bgcolor="FFFFFF"> 
	<td height="20" width="5%" align="center">
	  <cf_img icon="edit" navigation="yes" onclick="recordedit('#Code#');">
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

</td>
</tr>

</TABLE>

</cf_divscroll>