
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset caller.mid = oSecurity.gethash()/>
