
<cfquery name="SearchResult"
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_StatusReason
	Order by ListingOrder
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<cfset add          = "1">
<cfset Header       = "Requisition decision reasons">
<cfinclude template="../HeaderMaintain.cfm">  

<cfoutput>
  
<script>

function recordadd(grp) {
    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=500, top=300, width= 500, height= 550, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 550, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td height="1" colspan="10" class="linedotted"></td></tr>

<tr>
    <TD height="20" width="6%"></TD>
    <TD width="5%" class="labelit">Code</TD>
	<TD width="25%" class="labelit">Description</TD>
	<TD width="10%" class="labelit">Entity</TD>
	<td width="10%" class="labelit" align="Center">Trigger</td>
	<TD width="10%" class="labelit" align="Center">Text</TD>
	<TD width="5%" class="labelit" align="Center">Sort</TD>
	<TD width="5%" class="labelit" align="Center">Oper.</TD>
	<TD width="20%" class="labelit">Officer</TD>
    <TD width="10%" class="labelit">Entered</TD>  
</TR>

<tr><td height="1" class="linedotted" colspan="10"></td></tr>

<cfoutput query="SearchResult">
    
	<tr class="navigation_row">
		<td align="center"><cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')"></td>			
		<TD class="labelit">#Code#</TD>
		<TD class="labelit">#Description#</TD>
		<td class="labelit">#Mission#</td>
		<TD class="labelit" align="Center"><cfif Status eq "2i">Accept<cfelse>Deny</cfif></TD>
		<TD class="labelit" align="Center"><cfif IncludeSpecification>Yes<cfelse>No</cfif></TD>
		<TD class="labelit" align="Center">#ListingOrder#</TD>
		<TD class="labelit" align="Center"><cfif Operational>Yes<cfelse>No</cfif></TD>
		<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
		<td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </TR>
	
	<tr><td height="1" class="linedotted" colspan="10"></td></tr>
	
</CFOUTPUT>
  
</TABLE>

</td>
</tr>

</TABLE>
