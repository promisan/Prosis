
<HTML><HEAD>
<TITLE>Applicant - Entry Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" leftmargin="3" topmargin="3" rightmargin="3">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<script language="JavaScript">
javascript:window.history.forward(1);
</script>

<cfquery name="GroupAll" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT F.GroupCode, F.Description, S.*
	FROM PositionGroup S, Ref_Group F 
	WHERE S.PositionNo = '#URL.ID#'
	 AND S.PositionGroup = F.GroupCode
	 AND S.Status <> '9'
</cfquery>

<form action="../Group/GroupEntry.cfm?ID=<cfoutput>#URL.ID#</cfoutput>" method="POST" name="groupentry">

<!---
<cfinclude template="../Position/PositionViewHeader.cfm">  do we need this here?
--->
 
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
 
<tr><td>

<table border="0" cellpadding="0" cellspacing="0" width="100%">

<TR>
    <td height="20" class="top3n"></td>
    <td class="top3n">Description</td>
    <TD class="top3n">Officer</TD>
	<TD class="top3n">Entered</TD>
</TR>

<tr><td height="4" colspan="4"></td></tr>

<cfoutput query="GroupAll">

<TR>
    <TD></TD>
	<TD class="regular">#Description#</TD>
	<TD class="regular">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="regular">#DateFormat(Created,CLIENT.DateFormatShow)#</TD>
	
</TR>
</CFOUTPUT>

<tr><td height="4" colspan="4"></td></tr>

</table>

</td></tr>

<tr><td align="center">

    <input type="submit" name="Submit" value="Update" class="button10g">
    <input type="hidden" name="positionno" value="<cfoutput>#URL.ID#</cfoutput>">

</td></tr>

</table>
  

</form>


</BODY></HTML>

