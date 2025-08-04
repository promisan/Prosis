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

<script>

	function doChangeFund(link,mis,cfund,cpost,ccat) {			   
		_cf_loadingtexthtml='';	   			
		ColdFusion.navigate(link+'&fund='+cfund.value+'&postclass='+cpost.value+'&category='+ccat.value,'pane_1_Staffing_'+mis);											
	}		
		
</script>			
			
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
	
	<!--- define relevant periods for the mission to pass --->
	
	<cfset mission = MissionList.ConditionValue>
	
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
						
		<cf_pane id="#currentrow#" search="No">
						
							
				<cf_paneItem id="Procurement_#mission#" 
				        systemfunctionid = "#systemfunctionid#"   
						source           = "#session.root#/Portal/Topics/BudgetExecution/Procurement.cfm?mission=#mission#"
						width            = "99%"
						height           = "auto"
						Mission          = "#mission#"
						Period           = "#valuelist(PeriodList.PlanningPeriod)#"
						Option           = "Parent"
						DefaultOrgUnit   = "#ConditionValueAttribute1#"
						DefaultPeriod    = "#ConditionValueAttribute2#"	
						Label            = "#mission# Budget Execution (in $000)"
						filterValue      = "Budget"
						ShowPrint		 = "1">	
					
			
			
		</cf_pane>
	

</cfoutput>

