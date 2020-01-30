<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_Metric
	ORDER BY Measurement
</cfquery>


<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 
 
 <cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

<cf_listingScriptNavigation>

</cfoutput>

<table id="myListing" width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding">

<tr class="labelit line">
    <TD align="left"></TD>
    <TD align="left">Code</TD>
	<TD align="left">Description</TD>
	<td>UoM</td>
	<TD align="center">Operational</TD>
	<TD align="left">Officer</TD>
    <TD align="left">Entered</TD>
</TR>

<cfoutput query="SearchResult" group="Measurement">

	<tr><td colspan="7" class="labelmedium" height="25"><b><i>#Measurement#</i></b></td></tr>
	<tr><td colspan="7" class="line"></td></tr>
	<cfoutput>    	
		
    <TR class="navigation_row labelit line"> 
		<td align="center">
			  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
		</td>
		<TD>#Code#</TD>
		<TD>#Description#</TD>
		<td>#MeasurementUoM#</td>
		<TD align="center"><cfif operational eq 0><b>No</b><cfelse>Yes</cfif></TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>	
	</cfoutput>

</CFOUTPUT>

<tr><td height="20"></td></tr>

</TABLE>

</cf_divscroll>