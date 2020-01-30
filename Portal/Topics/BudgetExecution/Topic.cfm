
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

