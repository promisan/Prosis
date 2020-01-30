<!--- default client parameters --->
<cfinclude template="LogonClient.cfm">

<cf_param name="url.mission" 	default=""  type="String">
<cf_param name="url.mid"        default=""  type="String">  <!--- type="GUID" --->
<cf_param name="url.showLogin" 	default="0" type="Numeric">

<!--- check the contextual access for this user --->

<cfinvoke component   = "Service.Process.System.UserController"  
		method            = "ValidateFunctionAccess"  
		SessionNo         = "#client.SessionNo#" 
		ActionTemplate    = "#CGI.SCRIPT_NAME#"
		Hash              = "#URL.mid#"
		ActionQueryString = "#CGI.QUERY_STRING#"		
		AccessMessage     = "No"
		returnvariable    = "AccessRight">		

<cfquery name="qPrivate" 
	datasource="AppsSystem">
		SELECT 	COUNT(*) AS Total
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Process'
		AND		Operational		= 1
</cfquery>

<cfif url.mission eq "">

	<cfquery name="getDefaultMission" 
		datasource="AppsSystem">
			SELECT *
			FROM   Ref_ModuleControl
			WHERE  SystemModule   = 'SelfService'
			AND    FunctionClass  = 'SelfService'
			AND    (MenuClass     = 'Main' or MenuClass = 'Mission')
			AND    FunctionName   = '#URL.ID#'
	</cfquery>
	<cfif isDefined("client.mission")>
		<cfset url.mission = client.mission>
	</cfif>
	<cfif url.mission eq "">
		<cfset url.mission = getDefaultMission.functionCondition>
	</cfif>
	
</cfif>

<cfif SESSION.authent eq 1 and qPrivate.Total gt 0 and AccessRight eq "GRANTED">

	<cfoutput>
		<script>
			parent.window.location = "default.cfm?id=#url.id#&mission=#url.mission#&showLogin=#url.showLogin#";
		</script>
	</cfoutput>

<cfelse>
	
	<cfset url.mode 						= "login">
	<cfset url.menuClass 					= "menu">
	<cfset url.showNavigationOnFirstPage 	= "1">
	<cfset url.showReload					= "0">

	<!--- HTML5 --->
	<!DOCTYPE html>

	<html>
		<div style="display:none;"></div>
		<cfinclude template = "HTML5/MainPage.cfm">
	</html>
	
</cfif>
