
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

<!--- testing only --->


<cf_pane id="Production_xxxx" search="No" height="auto">		

<cf_paneItem id="WorkOrderProduction#Mission#" 
    systemfunctionid = "#systemfunctionid#" 
	source           = "#session.root#/Portal/Topics/WorkOrderproduction/TopicDetail.cfm?systemfunctionid=#systemfunctionid#"
	width            = "95%"
	height           = "auto"
	Mission          = "Fomtex"								
	Label            = "xxxxxx"
	ShowPrint		 = "1">			
	
</cf_pane>	


<!---

<cfoutput query="UnitList" group="Mission">

											
		<cf_pane id="Production_#mission#" search="No" height="auto">		
						
			<cfquery name="get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Mission
				WHERE    Mission = '#mission#'	
			</cfquery>
				
			<cf_paneItem id="WorkOrderProduction#Mission#" 
	            systemfunctionid = "#systemfunctionid#" 
				source           = "#session.root#/Portal/Topics/WorkOrderproduction/Topic.cfm?mission=#mission#&systemfunctionid=#systemfunctionid#"
				width            = "95%"
				height           = "auto"
				Mission          = "#mission#"								
				Label            = "Aggregated #get.MissionName# Income (in $)"
				ShowPrint		 = "1">			
											
		</cf_pane>	

	<cfoutput>					
																
			<cf_pane id="Production_#orgunit#" search="No" height="auto">
					
				<cf_paneItem id="WorkOrderProduction#currentrow#" 
		            systemfunctionid = "#systemfunctionid#" 
					source           = "#session.root#/WorkOrder/Application/Settlement/Inquiry/DayTotalBase.cfm?mission=#mission#&orgunitimplementer=#orgunitid#&systemfunctionid=#systemfunctionid#"
					width            = "95%"
					height           = "auto"
					Mission          = "#mission#"								
					Label            = "#Mission# #OrgUnitName# Income (in $)"
					ShowPrint		 = "1">			
												
			</cf_pane>	
			
	</cfoutput>
	
</cfoutput>

--->



