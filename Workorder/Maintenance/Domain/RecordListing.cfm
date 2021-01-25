
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ServiceItemDomain
	ORDER BY ListingOrder
</cfquery>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Domain class">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script>
	
	function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#&id=", "AddDomain", "left=80, top=80, width= 700, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {		
	    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditDomain");
	}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>
	
		<table width="96%" align="center" class="formpadding navigation_table">
		
		<tr class="line labelmedium2" style="height:20px;">
		
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
		
		    <TR style="height:20px" class="labelmedium2 line navigation_row"> 
			
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
	
	</cf_divscroll>

</td>
</tr>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>