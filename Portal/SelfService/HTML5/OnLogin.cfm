<cf_param name="url.id" default="" type="string">

<cfquery name="qOnLogin" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'OnLogin'
		AND		Operational		= 1
</cfquery>

<cfset vLogIn_ValidationMethod = "none"> <!--- none, confirm, alert --->
<cfset vLogIn_AfterAlertAction = "login"> <!--- login, logout --->
<cfset vLogIn_CallbackTrue = ""> <!--- callback when true --->
<cfset vLogIn_CallbackFalse = ""> <!--- callback when false --->
<cfset vLogIn_Message = "">

<cfif qOnLogin.recordCount gt 0>
	<cfif trim(qOnLogin.FunctionPath) neq "">
		<cfinclude template="../../../#qOnLogin.FunctionDirectory##qOnLogin.FunctionPath#">
	</cfif>
</cfif>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>
	<script>
		switch('#vLogIn_ValidationMethod#') {
			case 'none':				
				parent.window.location = "default.cfm?id=#url.id#&mid=#mid#";
				break;
			case 'confirm':
				if (confirm('#vLogIn_Message#')) {
					<cfif trim(vLogIn_CallbackTrue) neq "">
						ptoken.navigate('#vLogIn_CallbackTrue#','_processAjax', function(){
							parent.window.location = "default.cfm?id=#url.id#&mid=#mid#";
						});
					<cfelse>
						parent.window.location = "default.cfm?id=#url.id#&mid=#mid#";
					</cfif>
				}else{
					<cfif trim(vLogIn_CallbackFalse) neq "">
						ptoken.navigate('#vLogIn_CallbackFalse#','_processAjax', function(){
							ptoken.navigate('#SESSION.root#/Portal/selfservice/HTML5/Logoff.cfm?host=#CGI.HTTP_HOST#','_processAjax');
						});
					<cfelse>
						ptoken.navigate('#SESSION.root#/Portal/selfservice/HTML5/Logoff.cfm?host=#CGI.HTTP_HOST#','_processAjax');
					</cfif>
				}	
				break;
			case 'alert':
				alert('#vLogIn_Message#');
				if ('#vLogIn_AfterAlertAction#' === 'login') {
					parent.window.location = "default.cfm?id=#url.id#&mid=#mid#";
				}
				if ('#vLogIn_AfterAlertAction#' === 'logout') {
					ptoken.navigate('#SESSION.root#/Portal/selfservice/HTML5/Logoff.cfm?host=#CGI.HTTP_HOST#&id=#url.id#','_processAjax');
				}
				break;
			default:
				ptoken.navigate('#SESSION.root#/Portal/selfservice/HTML5/Logoff.cfm?host=#CGI.HTTP_HOST#&id=#url.id#','_processAjax');
		}
	</script>
</cfoutput>