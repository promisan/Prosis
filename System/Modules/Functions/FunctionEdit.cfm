

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 

<cfparam name="url.scope" default="menu">

<cfoutput>
	<iframe src="FunctionEditForm.cfm?module=#url.module#&scope=#url.scope#&mid=#mid#" height="100%" width="100%" frameborder="0"></iframe>
</cfoutput>