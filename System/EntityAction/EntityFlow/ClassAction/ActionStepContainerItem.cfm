
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<cfoutput>
	<iframe src="#SESSION.root#/system/entityAction/EntityFlow/ClassAction/ActionStepEdit.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&ActionCode=#URL.ActionCode#&PublishNo=#URL.PublishNo#&mid=#mid#" 
	width="100%" height="840" scrolling="no" frameborder="0">
	</iframe>
</cfoutput>

