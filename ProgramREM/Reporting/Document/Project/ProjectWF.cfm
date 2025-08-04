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

<!--- pass true to geenrate the document --->

<cfset vCFR = "../Project2/project.cfr">

<cfquery name="getPeriod"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM  	ProgramPeriodReview
		WHERE 	ReviewId = '#Object.ObjectKeyValue4#'
</cfquery>

<cfquery name="getGroup"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM  	ProgramGroup
		WHERE 	ProgramCode = '#getPeriod.ProgramCode#'
</cfquery>

<cfif getGroup.ProgramGroup eq "D02">
	<cfset vCFR = "../RapidResponse/RapidResponse.cfr">
	<cfif getPeriod.Period gte 'F20'>
		<cfset vCFR = "../RapidResponse2/RapidResponse.cfr">
	</cfif>
</cfif>

<cfif getGroup.ProgramGroup eq "D03">
	<cfset vCFR = "project.cfr">
	<cfif getPeriod.Period gte 'F20'>
		<cfset vCFR = "../Project2/project.cfr">
	</cfif>
</cfif>



<cfreport 
	template     = "#vCFR#" 
	format       = "PDF" 
	overwrite    = "yes" 
	encryption   = "none"
	filename     = "#SESSION.rootDocumentPath#\WFObjectReport\#URL.ActionID#\#Format.DocumentCode#.pdf">
		<cfreportparam name = "ID"  value="#Object.ObjectKeyValue4#"> 
</cfreport>