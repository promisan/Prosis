<!--- Create Criteria string for query from data entered thru search form --->

<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_LossClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="99%" align="center" cellspacing="0" cellpadding="0">
 
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

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="labelit line">
    <TD align="left"></TD>
    <TD align="left"><cf_tl id="Code"></TD>
	<TD align="left"><cf_tl id="Description"></TD>
	<TD align="left"><cf_tl id="Officer"></TD>
    <TD align="left"><cf_tl id="Entered"></TD>
</TR>

<cfoutput query="SearchResult">
    
    <TR class="labelit line navigation_row"> 
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

</td>
</tr>

</TABLE>

</cf_divscroll>