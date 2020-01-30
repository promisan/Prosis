<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AddressType
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="95%" align="center" cellspacing="0" cellpadding="0">
	 
	 <cfoutput>
		
		<script>
		
		function recordadd(grp) {
		          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		</script>	
	
	</cfoutput>
	
	<tr><td colspan="2">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
		
		<tr class="labelit line">
		    <TD align="left"></TD>
		    <TD align="left"><cf_tl id="Code"></TD>
			<TD align="left"><cf_tl id="Description"></TD>
			<TD align="left"><cf_tl id="Operational"></TD>
			<TD align="left"><cf_tl id="Officer"></TD>
		    <TD align="left"><cf_tl id="Entered"></TD>
		</TR>
		
		<cfif searchresult.recordcount eq "0">
		
		<tr><td colspan="6" class="line"></td></tr>
		<tr><td colspan="6" height="30" align="center">There are not record to show in this view</td></tr>
		
		</cfif>
		
		<cfoutput query="SearchResult">
							    
		    <TR class="navigation_row labelit line"> 
			<td align="center" height="20">
				  <cf_img icon="open" navigation="Yes" onclick="recordedit('#AddressType#');">
			</td>
			<TD>#AddressType#</TD>
			<TD>#Description#</TD>
			<td><cfif operational eq "0">No</cfif></td>
			<TD>#OfficerFirstName# #OfficerLastName#</TD>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
		
		</CFOUTPUT>
		
		</TABLE>
	
	</td>
	</tr>

</TABLE>

</cf_divscroll>