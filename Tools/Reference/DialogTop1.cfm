<cfparam name="attributes.Text" default="Add">

<cfoutput>

<cfif findNoCase("Add",attributes.Text)>
	<cfparam name="attributes.Icon" default="insert.gif">
<cfelseif findNoCase("Register",attributes.Text)>
	<cfparam name="attributes.Icon" default="insert.gif">	
<cfelse>
    <cfparam name="attributes.Icon" default="insert3.gif">
</cfif>	

<table width="100%" cellspacing="0" cellpadding="0">
	<td height="24" width="30" align="left"><img src="#SESSION.root#/Images/#Attributes.Icon#" alt=""></td>
	<TD><font face="Verdana" size="2"><b>#attributes.Text#</b></font></TD>
	<TD></TD>
</table>

<table width="100%">
	<tr><td height="4"></td></tr>
	<tr><td height="1" bgcolor="silver"></td></tr>
	<tr><td height="4"></td></tr>
</table>

</cfoutput>