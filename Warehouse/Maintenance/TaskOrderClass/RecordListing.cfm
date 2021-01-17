
<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	 *
	FROM 	 Ref_TaskOrderClass
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
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddTaskOrderClass", "left=80, top=80, width= 490, height= 290, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditTaskOrderClass", "left=80, top=80, width= 490, height= 290, toolbar=no, status=no, scrollbars=no, resizable=yes");
	}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>
	
		<table width="95%" align="center" class="navigation_table formpadding">
		
		<tr><td class="labelmedium2" colspan="6" height="30" style="color:808080;">		
			The class assigned to a classification a taskorder header.		
		</td></tr>
		
		<tr class="labelmedium2 line">
		    <TD></TD> 
		    <TD>Code</TD>
			<td>Description</td>
			<td align="center">Listing Order</td>
			<TD>Officer</TD>
		    <TD>Entered</TD>
		  
		</TR>
		
		<cfoutput query="SearchResult">
		   
		    <TR class="labelmedium2 line navigation_row"> 
			<td width="5%" align="center" style="padding-top:1px">
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
	
	</cf_divscroll>

	</td>
</tr>

</TABLE>

