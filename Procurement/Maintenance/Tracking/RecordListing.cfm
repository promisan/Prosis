 
<cfquery name="SearchResult"
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Tracking
	ORDER BY ListingOrder
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfset Header = "Tracking">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 450, toolbar=no, status=no, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 450, toolbar=no, status=no, scrollbars=no, resizable=no");
	}
	
	</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>

		<table width="96%" align="center">
		
		<tr class="labelmedium2 line">
		   
		    <TD></TD>
		    <TD>Code</TD>
			<TD>Description</TD>
			<TD>Sort</TD>
			<TD>Officer</TD>
		    <TD>Entered</TD>
		  
		</TR>
		
		<cfoutput query="SearchResult">
		      
			<TR bgcolor="white" class="line navigation_row labelmedium2">
		    <td align="center" width="5%" style="padding-top:1px;">
				  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
			</td>	
			<TD>#Code#</TD>
			<TD>#Description#</TD>
			<TD>#ListingOrder#</TD>
			<TD>#OfficerFirstName# #OfficerLastName#</TD>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
				
		</cfoutput>
		
		</table>
	
	</cf_divscroll>

</td>
</tr>

</TABLE>
