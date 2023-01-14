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