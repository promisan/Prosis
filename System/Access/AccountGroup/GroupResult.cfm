
<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_AccountGroup
</cfquery>

<cfset Page         = "1">
<cfset add          = "1">
<cfset save         = "0"> 
<cfset menu         = "0">
<cfinclude template="../HeaderMaintain.cfm">

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Group">	
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Group1">	
<cfparam name="URL.Page" default="1">

<cfoutput>
<script>

function reloadForm(page) {
     ptoken.location("GroupResult.cfm?idmenu=#URL.idmenu#&Page=" + page); 
}

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=600, height=320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function purge(acc) {
	if (confirm("Do you want to remove this account group ?")) {
	ptoken.location("GroupPurge.cfm?idmenu=#URL.idmenu#&page=#URL.Page#&id=" + acc)
	}	
}	

</script>	
</cfoutput>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td height="4"></td></tr>
<tr><td colspan="2">

<table width="95%" align="center" border="0" class="navigation_table" cellspacing="0" cellpadding="0">
	
<TR class="line labelmedium">
    <TD width="2%"></TD>
	<td width="10%">Code</td>
    <TD width="25%">Description</TD>
    <TD width="10%">Interface</TD>
    <TD width="20%">Officer</TD>	
	<TD width="10%" align="center">Active</TD>
	<TD width="10%" align="center">Disabled</TD>
	<TD width="5%"></TD>
</TR>

<CFOUTPUT query="SearchResult" startrow="#first#" maxrows="#No#">
		
	<cfquery name="Enabled" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT count(*) as Total
		FROM  UserNames WHERE Disabled = 0
		AND AccountGroup = '#AccountGroup#'
	</cfquery>
	
	<cfquery name="Disabled" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT count(*) as Total
		FROM  UserNames WHERE Disabled = 1
		AND AccountGroup = '#AccountGroup#'
	</cfquery>

	<TR class="navigation_row line labelmedium">
	
		<td width="30">&nbsp;#CurrentRow#</td>		
		<td height="20"><a class="navigation_action" href="javascript:recordedit('#AccountGroup#')">#AccountGroup#</a></TD>
		<TD>#Description#</TD>
		<TD>#UserInterface#</TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<td align="center">#Enabled.Total#</td>
		<td align="center">#Disabled.Total#</td>
		<td align="center">
		    <cfif Enabled.Total gt "0" or Disabled.Total gt "0">
			<cfelse>
				<cf_img icon="delete" onclick="purge('#accountgroup#')">
			</cfif>	
			</td>
		</TR>
		
</CFOUTPUT>
</TABLE>
</td>
</tr>
</table>
