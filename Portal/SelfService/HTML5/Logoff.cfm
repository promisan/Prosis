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
			window.location = "public.cfm?id=#url.id#&mission=#url.mission#";
		</script>
	</cfoutput>
</cfif>