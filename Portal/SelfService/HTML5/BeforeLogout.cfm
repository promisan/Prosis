
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