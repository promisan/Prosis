<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_WarehouseClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="94%" align="center" cellspacing="0" cellpadding="0">
	 
	 <cfoutput>
		
		<script>
		
		function recordadd(grp) {
		          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		</script>	
	
	</cfoutput>
	
	<tr><td colspan="2">
		
		<table width="100%" align="center" class="formpadding navigation_table">
		
		<tr class="labelmedium fixrow">
		    <TD></TD>
		    <TD><cf_tl id="Code"></TD>
			<TD><cf_tl id="Description"></TD>
			<TD align="center"><cf_tl id="Enforce TO Attachment"></TD>
			<TD><cf_tl id="Officer"></TD>
		    <TD><cf_tl id="Entered"></TD>
		</TR>
		
		<cfoutput query="SearchResult">
				    
		    <TR class="labelmedium line navigation_row"> 
				<td align="center" height="20">
					  <cf_img icon="open" onclick="recordedit('#Code#');">
				</td>
				<TD>#Code#</TD>
				<TD>#Description#</TD>
				<td align="center"><cfif TaskOrderAttachmentEnforce eq 1>Yes<cfelse><b>No</b></cfif></td>
				<TD>#OfficerFirstName# #OfficerLastName#</TD>
				<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
		
		</CFOUTPUT>
		
		</table>
	
	</td>
	</tr>

</table>

</cf_divscroll>