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
		AND     P.DateEffective < GETDATE() + 300
		AND     P.DateEffective > GETDATE() - 1600
		ORDER BY P.DateEffective DESC	
	</cfquery>	
					
	<cf_pane id="Requirement_#mission#" search="No">
				
		<cf_paneItem id="Requirement_#mission#_1" 
		        systemfunctionid = "#systemfunctionid#"  
				source           = "#session.root#/Portal/Topics/Requirement/RequirementView.cfm?mission=#mission#"
				customFilter	 = "#session.root#/Portal/Topics/Requirement/CustomFilter.cfm?mission=#mission#"
				width            = "99%"
				height           = "auto"
				Mission          = "#mission#"
				Option           = "Parent"
				Period           = "#valuelist(PeriodList.PlanningPeriod)#"
				DefaultOrgUnit   = "#ConditionValueAttribute1#"
				DefaultPeriod    = "#ConditionValueAttribute2#"		
				Label            = "#mission# HR and other requirements (in $000)"
				filterValue      = "Staffing"
				ShowPrint		 = "1"
				PrintCallback 	 = "$('##requirementMainContainer').attr('style','width:100%;'); $('##requirementMainContainer').parent('div').attr('style','width:100%;');">		
		
	</cf_pane>
	
</cfoutput>

