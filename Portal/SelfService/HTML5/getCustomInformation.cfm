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