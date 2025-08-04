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
<cfparam name="url.autoReload"	default="1">

<cfquery name="getDefaultMission" 
	datasource="AppsSystem">
		SELECT *
		FROM   Ref_ModuleControl
		WHERE  SystemModule   = 'SelfService'
		AND    FunctionClass  = 'SelfService'
		AND    (MenuClass     = 'Main' or MenuClass = 'Mission')
		AND    FunctionName   = '#URL.ID#'
</cfquery>

<cfset url.mission = "">
<cfif isDefined("client.mission")>
	<cfset url.mission = client.mission>
</cfif>
<cfif url.mission eq "">
	<cfset url.mission = getDefaultMission.functionCondition>
</cfif>

<cfset url.autoRedirect = "false">
<cfinclude template="../../../Tools/Control/LogoutExit.cfm">

<cfif url.autoReload eq 1>
	<cfoutput>
		<script>
			var vURL = window.location.href.split("?");	
			var vTab = "";
			if (vURL.length == 2) {
				var vParams = vURL[1].split("&");
				for (var i = 0; i < vParams.length; i++) {
					var vThisParam = vParams[i].split("=");
					if (vThisParam.length == 2 && vThisParam[0].trim().toLowerCase() == 'tab') {
						vTab = vThisParam[1].trim().toLowerCase();
					}
				}
			}

			window.location = "public.cfm?id=#url.id#&mission=#url.mission#&tab="+vTab;
		</script>
	</cfoutput>
</cfif>