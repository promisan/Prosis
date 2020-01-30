<cf_divscroll>

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_TaskOrderClass
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%" border="0" align="center" bordercolor="silver" cellspacing="0" cellpadding="0">  

<cfoutput>

<script>

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddTaskOrderClass", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditTaskOrderClass", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td class="labelit" colspan="6" height="30" style="color:808080;">

	The class assigned to a classification a taskorder header.

</td></tr>

<tr class="labelMEDIUM">
    <TD></TD> 
    <TD>Code</TD>
	<td>Description</td>
	<td align="center">Listing Order</td>
	<TD>Officer</TD>
    <TD>Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
   
    <TR class="labelmedium" height="20" bgcolor="FFFFFF"> 
	<td width="5%" align="center" style="padding-top:3px">
    	<cf_img icon="open" onclick="recordedit('#Code#');">
	</td>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<TD align="center">#listingOrder#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>    	

</CFOUTPUT>

</TABLE>

</td>

</TABLE>

</cf_divscroll>