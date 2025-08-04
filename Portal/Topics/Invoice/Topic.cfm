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

<cfquery name="MissionList" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserModuleCondition C
	WHERE    C.Account   = '#SESSION.acc#'
	AND      C.SystemFunctionId = '#SystemFunctionId#'  
</cfquery>

<cfoutput query="MissionList">

	<cfset mission = "#MissionList.ConditionValue#">
	
	<cfquery name="PeriodList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  DISTINCT M.PlanningPeriod, P.DateEffective
		FROM    Ref_MissionPeriod AS M INNER JOIN
	            Program.dbo.Ref_Period AS P ON M.PlanningPeriod = P.Period
		WHERE   M.Mission = '#mission#' 
		AND     P.DateEffective < GETDATE() 
		AND     P.DateEffective > GETDATE() - 1600
		ORDER BY P.DateEffective DESC	
	</cfquery>	
				
	<cf_pane id="Invoice_#mission#" search="No">
				
		<cf_paneItem          id = "Invoice_#mission#" 
		        systemfunctionid = "#systemfunctionid#"  
				source           = "#session.root#/Portal/Topics/Invoice/IncomingInvoices.cfm?mission=#mission#"
				width            = "95%"
				height           = "auto"
				Mission          = "#mission#"
				Option           = "Parent"
				Period           = "#valuelist(PeriodList.PlanningPeriod)#"
				DefaultOrgUnit   = "#ConditionValueAttribute1#"
				DefaultPeriod    = "#ConditionValueAttribute2#"		
				Label            = "#mission# Procurement Payables (in $000)"
				filterValue      = "Staffing">		
		
	</cf_pane>
	
</cfoutput>

