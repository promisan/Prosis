<!--- Create Criteria string for query from data entered thru search form --->
<cf_screentop html="No" jquery="Yes">
<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Disposal
</cfquery>

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0" >

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

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr>
    <TD align="left"></TD>
    <TD align="left" class="labelit"><cf_tl id="Code"></TD>
	<TD align="left" class="labelit"><cf_tl id="Description"></TD>
	<TD align="left" class="labelit"><cf_tl id="Officer"></TD>
    <TD align="left" class="labelit"><cf_tl id="Entered"></TD>
</TR>

<cfoutput query="SearchResult">

	<tr><td height="1" class="line" colspan="5"></td></tr>
    
    <TR class="navigation_row"> 
	<td align="center" style="padding-top:0px">
	   <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
	</td>
	<TD class="labelit"><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
	<TD class="labelit">#Description#</TD>
	<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>