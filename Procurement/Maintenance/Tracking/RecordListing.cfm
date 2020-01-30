 
<cfquery name="SearchResult"
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Tracking
	ORDER BY ListingOrder
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center">

<cfset Header = "Tracking">

<cfinclude template="../HeaderMaintain.cfm">  

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=no");
	}
	
	</script>	

</cfoutput>

<tr><td colspan="2">

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td colspan="6" class="linedotted" height="1"></td></tr>
<tr>
   
    <TD></TD>
    <TD class="labelit">Code</TD>
	<TD class="labelit">Description</TD>
	<TD class="labelit">Sort</TD>
	<TD class="labelit">Officer</TD>
    <TD class="labelit">Entered</TD>
  
</TR>

<tr><td colspan="6" class="linedotted" height="1"></td></tr>

<cfoutput query="SearchResult">
      
	<TR bgcolor="white" class="navigation_row">
    <td align="center" width="5%" style="padding-top:1px;">
		  <cf_img icon="edit" navigation="Yes" onclick="recordedit('#Code#')">
	</td>	
	<TD class="labelit">#Code#</TD>
	<TD class="labelit">#Description#</TD>
	<TD class="labelit">#ListingOrder#</TD>
	<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	<tr><td height="1" colspan="6" class="linedotted"></td></tr>

</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>
