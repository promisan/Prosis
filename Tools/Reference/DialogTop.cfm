
<cfoutput>

<cfparam name="attributes.Text" default="Add">

<cfif findNoCase("Add",attributes.Text)>
	<cfparam name="attributes.Icon" default="insert.gif">
<cfelseif findNoCase("Register",attributes.Text)>
	<cfparam name="attributes.Icon" default="insert.gif">	
<cfelseif findNoCase("Print",attributes.Text)>
	<cfparam name="attributes.Icon" default="print.gif">	
<cfelseif findNoCase("Copy",attributes.Text)>
	<cfparam name="attributes.Icon" default="documents.gif">	
<cfelse>
    <cfparam name="attributes.Icon" default="insert3.gif">
</cfif>	

<table width="100%" cellspacing="0" cellpadding="0">
    <tr><td height="10"></td></tr>
	<td width="25"><img src="#SESSION.root#/Images/#Attributes.Icon#" alignb="absmiddle" alt=""></td>
	<TD><font face="Verdana" size="2"><b>#attributes.Text#</b></font></TD>
	<TD></TD>
</table>

<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td height="4"></td></tr>
	<tr><td height="1" bgcolor="silver"></td></tr>
	<tr><td height="4"></td></tr>
</table>

</cfoutput>
