
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<cfoutput>
<iframe src="#SESSION.root#/Tools/EntityAction/ProcessAction.cfm?windowmode=#url.windowmode#&ajaxid=#url.ajaxid#&process=#url.process#&id=#url.id#&myentity=#url.myentity#&mid=#mid#"
width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
</cfoutput>