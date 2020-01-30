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