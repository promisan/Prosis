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


<cfquery name="UnitList" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   C.SystemFunctionId,
	         O.Mission,
	         O.MissionOrgUnitId, 	         
			 MAX(O.OrgUnitName) as OrgUnitName
			 
	FROM     UserModuleCondition C, Organization.dbo.Organization O
	WHERE    C.Account   = '#SESSION.acc#'
	AND      C.ConditionValue = O.MissionorgUnitId
	AND      C.SystemFunctionId = '#SystemFunctionId#'  
	AND      C.ConditionClass = 'Filter'
	AND      C.ConditionField = 'Implementer'
	GROUP BY C.SystemFunctionId,
	         O.Mission,
	         O.MissionOrgUnitId
			 
	ORDER BY O.Mission, 
			 O.MissionOrgUnitId
			 
</cfquery>

<cfoutput query="UnitList" group="Mission">

	<cfset per = "#year(now())#,#year(now())-1#,#year(now())-2#">
											
		<cf_pane id="Workorder_#mission#" search="No" height="auto">		
						
			<cfquery name="get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Mission
				WHERE    Mission = '#mission#'	
			</cfquery>
				
			<cf_paneItem id="WorkOrder#Mission#" 
	            systemfunctionid = "#systemfunctionid#" 
				source           = "#session.root#/Workorder/Application/Settlement/Inquiry/DayTotalBase.cfm?mission=#mission#&systemfunctionid=#systemfunctionid#"
				width            = "95%"
				height           = "auto"
				Mission          = "#mission#"								
				Label            = "Aggregated #get.MissionName# Income (in $)"
				ShowPrint		 = "1">			
											
		</cf_pane>	

	<cfoutput>					
					
			<cfset per = "#year(now())#,#year(now())-1#,#year(now())-2#">
											
			<cf_pane id="WorkOrder_#orgunit#" search="No" height="auto">
					
				<cf_paneItem id="WorkOrder#currentrow#" 
		            systemfunctionid = "#systemfunctionid#" 
					source           = "#session.root#/WorkOrder/Application/Settlement/Inquiry/DayTotalBase.cfm?mission=#mission#&missionorgunitid=#missionOrgUnitId#&systemfunctionid=#systemfunctionid#"
					width            = "95%"
					height           = "auto"
					Mission          = "#mission#"								
					Label            = "#Mission# #OrgUnitName# Income (in $)"
					ShowPrint		 = "1">			
												
			</cf_pane>	
			
	</cfoutput>
	
</cfoutput>



