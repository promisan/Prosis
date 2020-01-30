<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_PriceSchedule
	ORDER BY ListingOrder ASC
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="97%" align="center" cellspacing="0" cellpadding="0" >

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddPriceSchedule", "left=80, top=80, width= 550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditPriceSchedule", "left=80, top=80, width= 550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="labelmedium line">
    <TD align="left"></TD>
    <TD align="left">Code</TD>
	<TD align="left">Description</TD>
	<TD align="left">Acronym</TD>
	<TD align="center">Order</TD>
	<td align="center">Default</td>
	<TD align="left">Officer</TD>
    <TD align="left">Entered</TD>
</TR>

<cfoutput query="SearchResult">
    
    <TR class="navigation_row labelmedium line" bgcolor=""> 
	<td align="center" height="20">
	   <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
	</td>
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<TD>#Acronym#</TD>
	<TD align="center">#ListingOrder#</TD>
	<td align="center"><cfif fieldDefault eq 0>No<cfelse><b>Yes</b></cfif></td>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>