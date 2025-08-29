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
<cfparam name="attributes.appId"				default="">
<cfparam name="attributes.mission"				default="">
<cfparam name="attributes.functionId"			default="">

<cfquery name="getElement" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT  M.*,
				ISNULL((
					SELECT 	COUNT(*)
					FROM	Ref_ModuleControlSection
					WHERE	SystemFunctionId = M.SystemFunctionId
				), 0) as HasSections
		FROM    #client.lanPrefix#Ref_ModuleControl M 
		WHERE	M.SystemFunctionId = '#attributes.functionId#'
</cfquery>

<cfoutput query="getElement">

	<cfset vParams= "">
	<cfif trim(functionCondition) neq "">
		<cfset vParams= "&#functionCondition#">
	</cfif>
	
	<cfset vBaseURL = "#session.root#/#functionDirectory##functionPath#">
	<cfif HasSections gt 0>
		<cfset vBaseURL = "#session.root#/Portal/Mobile/Dashboard/Dashboard.cfm">
	</cfif>

	<cfinvoke component="Service.Access"  
		method="function"  
		SystemFunctionId="#attributes.functionId#" 
		Mission="#attributes.mission#"
		returnvariable="access">

	<cfset vURL = "#session.root#/portal/mobile/noaccess.cfm">
	<cfif access eq "GRANTED">
		<cfset vURL = "#vBaseURL#?mission=#attributes.mission#&appId=#attributes.appId#&systemfunctionId=#attributes.functionId##vParams#">
	</cfif>
	
	<cf_mobileMenuItem 
		description="#FunctionMemo#"
		systemfunctionId = "#attributes.functionId#"
		reference="javascript:ptoken.navigate('#vURL#','mainContainer');">
	</cf_mobileMenuItem>

</cfoutput>