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

<!--- check the access --->

<cfparam name="url.mission"      default="">
<cfparam name="SESSION.Authent"  default="">
<cfparam name="url.mid"          default="">
<cfparam name="url.showLogin" 	 default="0">
<cfparam name="url.tab" 		 default="">
<cfparam name="url.target" 		 default="0">


<!--- check the contextual access for this user --->

<cfinvoke component   = "Service.Process.System.UserController"  
		method            = "RecordSessionTemplate"  		
		Hash              = "#URL.mid#"
		ActionTemplate    = "#CGI.SCRIPT_NAME#"		
		ActionQueryString = "#CGI.QUERY_STRING#"
		AccessValidate    = "Yes"
		AccessMessage     = "No"
		returnvariable    = "AccessRight">		
			
<!--- check if there are any functions to be shown --->
				
<cfquery name="qProcess" 
	datasource="AppsSystem">
		SELECT 	COUNT(*) AS Total
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Process'
		AND		Operational		= 1
</cfquery>


<cfif trim(url.mission) eq "">

    <cfif isDefined("client.mission")>
		<cfset url.mission = client.mission>
	</cfif>
	
	<cfif url.mission eq "">
		
		<cfset url.mission = SelfService.functionCondition>
		
	</cfif>
	
</cfif>

<cfif SESSION.authent neq 1 or qProcess.Total eq 0 or AccessRight eq "DENIED">
	
	<cfoutput>
		<script language="JavaScript">		
			parent.window.location = "public.cfm?id=#url.id#&mission=#url.mission#&showLogin=#url.showLogin#&tab=#url.tab#&target=#url.target#";
		</script>
	</cfoutput>

<cfelse>
	
	<cfset url.mode 						= "default">
	<cfset url.menuClass 					= "process">
	<cfset url.showNavigationOnFirstPage 	= "1">
	<cfset url.showReload					= "1">
		
	<!--- HTML5 --->
	<!DOCTYPE html>

	<html>
		<div style="display:none;"></div>
		<cfinclude template	= "MainPage.cfm">
	</html>
	
</cfif>