
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ServiceItemDomain
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0"  >  

<cfoutput>

<script>
	
	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#&id=", "AddDomain", "left=80, top=80, width= 700, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
		var vWidth = $(window).width() - 50;
	   	var vHeight = $(window).height() - 50;
	    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditDomain", "left=80, top=80, width="+vWidth+", height="+vHeight+", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}

</script>	

</cfoutput>

<tr><td colspan="2" class="line"></td></tr>

<tr><td colspan="2">

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="line labelmedium" style="height:20px;">

    <TD></TD> 
    <TD>Code</TD>
	<td>Description</td>	
	<td>Display Format</td>
	<td align="center">Concur</td>
	<td align="center">Sort</td>
	<TD>Officer</TD>
    <TD>Entered</TD>
	
</TR>

<cfoutput query="SearchResult">

    <TR style="height:20px" class="labelmedium line navigation_row"> 
	
		<td width="5%" align="center" style="padding-top:1px;">
		   <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
		</td>		
		<TD>#Code#</TD>
		<TD>#Description#</TD>	
		<TD>#displayFormat#</TD>
		<TD align="center"><cfif AllowConcurrent eq 1><b><cf_tl id="Yes"></b><cfelse><cf_tl id="No"></cfif></TD>
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

<cfset AjaxOnLoad("doHighlight")>