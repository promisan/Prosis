<!--
    Copyright © 2025 Promisan

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
<cf_param name="url.id" 	default="" type="string">
<cf_param name="url.tab" 	default="" type="string">

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

<cfset vLogIn_ValidationMethod = "none"> <!--- none, confirm, alert, redirect --->
<cfset vLogIn_AfterAlertAction = "login"> <!--- login, logout --->
<cfset vLogIn_CallbackTrue = ""> <!--- callback when true --->
<cfset vLogIn_CallbackFalse = ""> <!--- callback when false --->
<cfset vLogIn_Message = "">
<cfset vLogIn_RedirectURL = "default.cfm?ts=#getTickCount()#">

<cfif qOnLogin.recordCount gt 0>
	<cfif trim(qOnLogin.FunctionPath) neq "">
		<cfinclude template="../../../#qOnLogin.FunctionDirectory##qOnLogin.FunctionPath#">
	</cfif>
</cfif>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>
	<script>
		var vURL = window.location.href.split("?");	
		var vParams = "";
		if (vURL.length == 2) {
			vParams = "&" + vURL[1];
		}

		switch('#vLogIn_ValidationMethod#') {
			case 'redirect':
				parent.window.location =  "#vLogIn_RedirectURL#&mid=#mid#"+vParams;
				break;
			case 'none':				
				parent.window.location = "default.cfm?mid=#mid#"+vParams;
				break;
			case 'confirm':
				if (confirm('#vLogIn_Message#')) {
					<cfif trim(vLogIn_CallbackTrue) neq "">
						ptoken.navigate('#vLogIn_CallbackTrue#','_processAjax', function(){
							parent.window.location = "default.cfm?mid=#mid#"+vParam;
						});
					<cfelse>
						parent.window.location = "default.cfm?mid=#mid#"+vParam;
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
					parent.window.location = "default.cfm?mid=#mid#"+vParam;
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