<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_DiscountType
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="94%" align="center" cellspacing="0" cellpadding="0" >

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddDiscountType", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditDiscountType", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="line">
    <TD align="left"></TD>
    <TD align="left" class="labelit">Code</TD>
	<TD align="left" class="labelit">Description</TD>
	<TD align="left" class="labelit">Officer</TD>
    <TD align="left" class="labelit">Entered</TD>
</TR>

<cfif SearchResult.recordCount eq 0>
<tr><td height="25" colspan="5" align="center" class="labelit" style="color:808080; font-weight:bold;">[No discount types recorded]</td></tr>
<tr><td height="1" colspan="5" class="line"></td></tr>
</cfif>

<cfoutput query="SearchResult">
    
    <TR class="navigation_row line labelit"> 
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

</td>

</tr>

</TABLE>

</cf_divscroll>