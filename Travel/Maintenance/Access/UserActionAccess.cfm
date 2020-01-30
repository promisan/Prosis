<!--- Query returning detail information for selected item --->

<HTML><HEAD>
    <TITLE>Search Result</TITLE>
</HEAD><body>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cfset CLIENT.DataSource = "AppsTravel">

<cfinclude template="../../../System/Access/User/UserDetailIdentification.cfm">

<cfquery name="SearchResult" 
datasource="#Client.DataSource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*, U.Created as Entered, U.AccessLevel, U.Mission, U.UserAccount, U.OfficerLastName, U.OfficerFirstName, C.Description as ActionClassDescription
FROM   FlowAction A, ActionAuthorization U, FlowClass C
WHERE  A.ActionId = U.ActionId
AND    U.UserAccount = '#URL.ID#'	   
AND    A.ActionClass = C.ActionClass
ORDER BY Mission, A.ActionClass, A.ActionOrder
</cfquery>

<SCRIPT LANGUAGE = "JavaScript">
function showprofile(ACC)
{
	window.open("UserActionAdd.cfm?ID=" + ACC, "DialogWindow", "width=500, height=600, scrollbars=yes, resizable=yes");
}

function cancel(acc,mission)

{
	if (confirm("Do you want to remove this mission ?")) {
       window.open("MissionAccessDeleteSubmit.cfm?ID=" + acc + "&ID1=" + mission, "actionsubmit", "width=100, height=100, toolbar=no, scrollbars=no, resizable=no");
	}
		
}	

</script>


</SCRIPT>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
    <td width="100%" height="24" bgcolor="002350" class="bannerXL">&nbsp;
	<b><u>Action authorization</u></b>
	</td>
	
    <td align="right" bgcolor="002350">
	<cfoutput>
	<input type="button" name="Add" value="  Manage access " class="input.button1" onClick="javascript:showprofile('#URL.ID#')">&nbsp;
     </cfoutput>
	
    </td>
  </tr>

<td width="100%" colspan="2">

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">

<TR bgcolor="6688aa">
    <TD>&nbsp;</TD>
	<TD class="top">Class</font></TD>
	<TD class="top">Order</font></TD>
    <TD class="top">Description</font></TD>
    <TD class="top">Area</font></TD>
	<TD class="top">Access</font></TD>
    <TD class="top">Officer</font></TD>
    <TD class="top">Created</font></TD>
</TR>
<cfoutput query="SearchResult" group="Mission">

<tr>
   <td colspan="3" class="regular">&nbsp;<b>#Mission#</b></td>
   <td colspan="4" align="right" class="regular">&nbsp;<b><a href="javascript:cancel('#UserAccount#','#Mission#')">[remove access]&nbsp;</a></b></td>
</tr>

<cfoutput group="ActionClass">

<tr><td colspan="7" class="regular">&nbsp;&nbsp;<b>#ActionClass# #ActionClassDescription#</b></td></tr>

<CFOUTPUT>
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffcf'))#">
    <TD></TD>
    <TD><font size="1" face="Tahoma">&nbsp;</font></TD>
	<TD><font size="1" face="Tahoma">#ActionOrderSub#</font></TD>
<TD><font size="1" face="Tahoma">#ActionDescription#</font></TD>
<td><font size="1" face="Tahoma">#ActionArea#</font></td>
<td><font size="1" face="Tahoma">
<cfif #AccessLevel# eq "0">View
<cfelseif #AccessLevel# eq "1">Edit
<cfelse>Hide
</cfif></font></td>
<TD><font size="1" face="Tahoma">#OfficerFirstName# #OfficerLastName#</font></TD>
<TD><font size="1" face="Tahoma">#DateFormat(Entered,CLIENT.DateFormatShow)#</font></TD>
</TR>
</CFOUTPUT>

</cfoutput>

</cfoutput>

</TABLE>

</BODY></HTML>
