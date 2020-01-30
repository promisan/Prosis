<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop 
   	   height="100%"
	   scroll="Yes" 
	   html="No" 
	   menuaccess="yes" 
	   jQuery="Yes"
	   systemfunctionid="#url.idmenu#">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset menu         = "0"> 
<cfinclude template="../../Access/HeaderMaintain.cfm">

<table width="97%" align="center" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" class="navigation_table">
   
<cfquery name="SearchResult"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AuthorizationRoleOwner
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height= 230, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height= 230, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>
	
<tr><td colspan="2">

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr>
    <td></td>
    <TD align="left" class="labelmedium">Code</TD>
	<TD align="left" class="labelmedium">Description</TD>
	<TD align="left" class="labelmedium">eMail</TD>
	<TD align="left" class="labelmedium">Officer</TD>
    <TD align="left" class="labelmedium">Entered</TD>
  
</TR>

<tr><td colspan="6" class="linedotted"></td></tr>

<cfoutput query="SearchResult">
    	
    <TR class="navigation_row"> 
	<td width="30" height="20" style="padding-left:7px;padding-top:1px">
		  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</td>
	<TD class="labelmedium" height="18">#Code#</TD>
	<TD class="labelmedium">#Description#</TD>
	<TD class="labelmedium">#eMailAddress#</TD>
	<TD class="labelmedium">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelmedium">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
	<tr><td colspan="8" class="linedotted"></td></tr>

</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>
