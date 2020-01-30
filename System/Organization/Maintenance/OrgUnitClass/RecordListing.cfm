<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" scroll="Yes" jQuery="Yes" html="No">

<cfquery name="SearchResult"
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_OrgUnitClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template="../../../Parameter/HeaderParameter.cfm"> 	

<table width="97%" align="center" cellspacing="0" cellpadding="0">
 
<cfoutput>
 
<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 390, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 390, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="line labelmedium">
    <TD></TD>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD colspan="2">Icon</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>
</TR>

<cfoutput query="SearchResult">
 
    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#" style="height:35px" class="navigation_row line labelmedium"> 
	<td align="center" style="width:40;padding-top:4px;height:21">
		  <cf_img icon="edit" navigation="Yes" onClick="recordedit('#OrgUnitClass#')">
	</td>	
	<TD>#OrgUnitClass#</TD>
	<TD>#Description#</TD>
	<td>#ListingIcon#</td>
	<td><cfif listingIcon neq "">
	<img src="#session.root##listingicon#" height="25" alt="" border="0">	
	</cfif></td>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

