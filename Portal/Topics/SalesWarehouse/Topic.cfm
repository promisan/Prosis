
<cfquery name="WarehouseList" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   C.*, W.Mission, W.Warehouse, W.WarehouseName
	FROM     UserModuleCondition C, Materials.dbo.Warehouse W
	WHERE    C.Account   = '#SESSION.acc#'
	AND      C.ConditionValue = W.Warehouse
	AND      C.SystemFunctionId = '#SystemFunctionId#'  
	AND      C.ConditionClass = 'Filter'
	AND      C.ConditionField = 'Warehouse'
	ORDER BY W.Mission, W.WarehouseName
</cfquery>

<cfoutput query="WarehouseList" group="Mission">

	<cfset per = "#year(now())#,#year(now())-1#,#year(now())-2#">
											
		<cf_pane id="StoreSale_#mission#" search="No" height="auto">		
						
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
				source           = "#session.root#/Warehouse/Application/SalesOrder/POS/Inquiry/DayTotalBase.cfm?mission=#mission#&systemfunctionid=#systemfunctionid#"
				width            = "95%"
				height           = "auto"
				Mission          = "#mission#"								
				Label            = "Aggregated #get.MissionName# Sales (in $)"
				ShowPrint		 = "1">			
											
		</cf_pane>	

	<cfoutput>					
					
			<cfset per = "#year(now())#,#year(now())-1#,#year(now())-2#">
											
			<cf_pane id="StoreSale_#warehouse#" search="No" height="auto">
					
				<cf_paneItem id="WorkOrder#currentrow#" 
		            systemfunctionid = "#systemfunctionid#" 
					source           = "#session.root#/Warehouse/Application/SalesOrder/POS/Inquiry/DayTotalBase.cfm?warehouse=#warehouse#&systemfunctionid=#systemfunctionid#"
					width            = "95%"
					height           = "auto"
					Mission          = "#mission#"								
					Label            = "#Mission# #WarehouseName# Sales (in $)"
					ShowPrint		 = "1">			
												
			</cf_pane>	
			
	</cfoutput>
	
</cfoutput>



