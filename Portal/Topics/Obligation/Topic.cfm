
<cfquery name="MissionList" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     UserModuleCondition C
	WHERE    C.Account   = '#SESSION.acc#'
	AND      C.SystemFunctionId = '#SystemFunctionId#' 
	AND      C.ConditionField   = 'Mission' 
</cfquery>

<cfoutput query="MissionList">

	<cfset mission = ConditionValue>
		
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
				
		<cf_paneItem id="Obligation" 
		    systemfunctionid = "#systemfunctionid#"  
			source           = "#session.root#/Portal/Topics/Obligation/ObligationClass.cfm?mission=#mission#"
			width            = "95%"
			height           = "auto"			
			Mission          = "#mission#"
			Period           = "#valuelist(PeriodList.PlanningPeriod)#"
			Option           = "Parent"
			DefaultOrgUnit   = "#ConditionValueAttribute1#"
			DefaultPeriod    = "#ConditionValueAttribute2#"			
			Label            = "#Mission# Obligations by class (in $000)">
						
	</cf_pane>
	
</cfoutput>
