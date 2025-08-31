<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

