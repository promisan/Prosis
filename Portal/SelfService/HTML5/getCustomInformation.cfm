<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="qCustomInformation" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Function'
		AND		FunctionName	= 'CustomInformation'
		AND		Operational		= 1
</cfquery>

<cfif qCustomInformation.recordCount eq 1>
	<cfif trim(qCustomInformation.FunctionDirectory) neq "" and trim(qCustomInformation.FunctionPath) neq "">
		<cfset vCondition = "">
		<cfif trim(qCustomInformation.FunctionCondition) neq "">
			<cfset vCondition = "&#qCustomInformation.FunctionCondition#">
		</cfif>
		<!--- <cfoutput>
			#session.root#/#qCustomInformation.FunctionDirectory#/#qCustomInformation.FunctionPath#?id=#url.id#&mission=#url.mission##vCondition#
		</cfoutput> --->
		<cfdiv bind="url:#session.root#/#qCustomInformation.FunctionDirectory#/#qCustomInformation.FunctionPath#?id=#url.id#&mission=#url.mission##vCondition#">
	</cfif>
</cfif>