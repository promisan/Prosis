<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AddressType
	ORDER BY ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
	 <cfoutput>
		
		<script>
		
			function recordadd(grp) {
			          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=490, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
			}
			
			function recordedit(id1) {
			          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=490, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
			}
		
		</script>	
	
	</cfoutput>
			
	<tr><td colspan="2">
	
		<cf_divscroll>
		
		<table width="100%" align="center" class="formpadding navigation_table">
		
		<tr class="fixrow labelmedium2 line">
		    <TD></TD>
		    <TD><cf_tl id="Code"></TD>
			<TD><cf_tl id="Description"></TD>
			<TD><cf_tl id="Operational"></TD>
			<TD><cf_tl id="Officer"></TD>
		    <TD><cf_tl id="Entered"></TD>
		</TR>
		
		<cfif searchresult.recordcount eq "0">
		
		<tr><td colspan="6" class="line"></td></tr>
		<tr><td colspan="6" height="30" align="center">There are not record to show in this view</td></tr>
		
		</cfif>
		
		<cfoutput query="SearchResult">
							    
		    <TR class="navigation_row labelmedium2 line"> 
				<td align="center" height="20"><cf_img icon="open" navigation="Yes" onclick="recordedit('#AddressType#')"></td>
				<TD>#AddressType#</TD>
				<TD>#Description#</TD>
				<td><cfif operational eq "0">No</cfif></td>
				<TD>#OfficerFirstName# #OfficerLastName#</TD>
				<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
		
		</CFOUTPUT>
		
		</TABLE>
		
		</cf_divscroll>
	
	</td>
	</tr>

</TABLE>
