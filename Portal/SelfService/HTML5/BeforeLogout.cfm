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

<cfquery name="qBeforeLogout" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'BeforeLogout'
		AND		Operational		= 1
</cfquery>

<cf_tl id="Do you want to logout the system ?" var="1">
<cfset vLogOutMessage = lt_text>
<cfset vLogOutPopQuestion = false>

<cfif qBeforeLogout.recordCount gt 0>
	<cfif trim(qBeforeLogout.FunctionPath) neq "">
		<cfinclude template="../../../#qBeforeLogout.FunctionDirectory##qBeforeLogout.FunctionPath#">
	</cfif>
</cfif>

<cfoutput>
	<script>
		if (#vLogOutPopQuestion#) {
			if (confirm('#vLogOutMessage#')) {
				ptoken.navigate('#SESSION.root#/Portal/selfservice/HTML5/Logoff.cfm?host=#CGI.HTTP_HOST#','_processAjax');
			}
		}else {
			ptoken.navigate('#SESSION.root#/Portal/selfservice/HTML5/Logoff.cfm?host=#CGI.HTTP_HOST#&id=#url.id#','_processAjax');
		}
	</script>
</cfoutput>