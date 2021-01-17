<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_DiscountType
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddDiscountType", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditDiscountType", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<cf_divscroll>

<table width="95%" align="center" class="formpadding">

<tr class="line labelmedium2">
    <TD></TD>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>
</TR>

<cfif SearchResult.recordCount eq 0>
<tr><td height="25" colspan="5" align="center" class="labelit" style="color:808080; font-weight:bold;">[No discount types recorded]</td></tr>
<tr><td height="1" colspan="5" class="line"></td></tr>
</cfif>

<cfoutput query="SearchResult">
    
    <TR class="navigation_row line labelmedium2"> 
		<td align="center" style="padding-top:1px">
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
