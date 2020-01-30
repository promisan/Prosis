

<HTML><HEAD><TITLE>Event category</TITLE></HEAD>

<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_RosterDecision
</cfquery>

<table width="100%" border="1" cellspacing="0" cellpadding="0" rules="rows" >

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Roster decision">
<cfinclude template="../HeaderRoster.cfm">  
  
<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width= 480, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width= 480, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
<tr><td colspan="2">

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr>
    <TD></TD>
    <TD class="labelit">Code</TD>
	<TD class="labelit">Description</TD>
	<TD class="labelit" width="20%">Explanation</TD>
	<TD class="labelit">Officer</TD>
    <TD class="labelit">Entered</TD>
  
</TR>

<tr><td height="1" colspan="6" class="line"></td></tr>

<cfoutput query="SearchResult">
   
	<tr class="labelmedium navigation_row lineditted">
	<td width="5%" align="center">
		  <cf_img navigation="Yes" icon="edit" onClick="javascript:recordedit('#Code#')">
	</td>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<TD>#DescriptionMemo#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<td align="right">#Dateformat(Created, "#CLIENT.DateFormatShow#")#&nbsp;</td>
    </TR>
	
</CFOUTPUT>

<tr><td colspan="6" class="labelit" align="center"><font color="gray"><i>Please refer to Roster Parameters to associate a checkbox to a roster processing status for an owner</td></tr>

</TABLE>