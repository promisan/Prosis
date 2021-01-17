

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_LossClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
 <cfoutput>

<script>

	function recordadd(grp) {
	          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<tr><td colspan="2">

<cf_divscroll>
	
	<table width="97%" align="center" class="formpadding navigation_table">
	
	<tr class="labelmedium2 line">
	    <TD></TD>
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Description"></TD>
		<TD><cf_tl id="Officer"></TD>
	    <TD><cf_tl id="Entered"></TD>
	</TR>
	
	<cfoutput query="SearchResult">
	    
	    <TR class="labelmedium2 line navigation_row"> 
		<td align="center">
		    <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
		</td>
		<TD>#Code#</TD>
		<TD>#Description#</TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>
		
	</CFOUTPUT>
	
	</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>

