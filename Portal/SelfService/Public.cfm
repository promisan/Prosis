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
<cfinclude template="LogonClient.cfm">

<cf_param name="url.mission" 	default=""  type="String">
<cf_param name="url.mid"        default=""  type="String">  <!--- type="GUID" --->
<cf_param name="url.showLogin" 	default="0" type="Numeric">
<cf_param name="url.tab" 		default="">
<cf_param name="url.target" 	default="0">

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

    <cfif isDefined("client.mission")>
		<cfset url.mission = client.mission>
	</cfif>
	
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
		
		<cfset url.mission = getDefaultMission.functionCondition>
		
	</cfif>
	
</cfif>


<cfif SESSION.authent eq 1 and qPrivate.Total gt 0 and AccessRight eq "GRANTED">

	<cfoutput>
		<script>		    
			parent.window.location = "default.cfm?id=#url.id#&mission=#url.mission#&showLogin=#url.showLogin#&tab=#url.tab#&target=#url.target#";
		</script>
	</cfoutput>

<cfelse>
	
	<cfset url.mode 						= "login">
	<cfset url.menuClass 					= "menu">
	<cfset url.showNavigationOnFirstPage 	= "1">
	<cfset url.showReload					= "0">
	<cfset url.target			    		= "1">
	
	<!--- HTML5 --->
	<!DOCTYPE html>

	<html>
		<div style="display:none;"></div>				
		<cfinclude template = "HTML5/MainPage.cfm">
	</html>
	
</cfif>
