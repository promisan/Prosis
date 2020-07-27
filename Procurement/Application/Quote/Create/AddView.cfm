
<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<table width="100%" height="100%">
<tr><td style="height:99%;width:100%" valign="top">
<iframe src="#session.root#/Procurement/Application/Quote/Create/AddLine.cfm?id=#url.id#&mid=#mid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>