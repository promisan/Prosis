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
<!--- default client parameters --->
<cfinclude template="../SelfService/LogonClient.cfm">

<cfquery name="qCustomLogin" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'PMobile'
		AND		FunctionClass	= '#url.appId#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'CustomLogin'
		AND		Operational		= 1
</cfquery>

<cfif qCustomLogin.recordCount eq 0>
	<cfoutput>
		<script>
			window.location.href = "#session.root#/portal/mobile/doLogin.cfm?appId=#url.appId#";
		</script>
	</cfoutput>
<cfelse>
	<cfdiv bind="url:#session.root#/#qCustomLogin.functionDirectory##qCustomLogin.FunctionPath#?appId=#url.appId#">
</cfif>