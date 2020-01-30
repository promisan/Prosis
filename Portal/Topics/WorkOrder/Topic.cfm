
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

	<cfset mission = ConditionValue>
		
	<cfset per = "#year(now())#,#year(now())-1#,#year(now())-2#">
									
	<cf_pane id="WorkOrder" search="No">
	
		<cf_paneItem id="WorkOrder_1" 
            systemfunctionid = "#systemfunctionid#" 
			source           = "#session.root#/Portal/Topics/WorkOrder/ServiceCharge.cfm?mission=#mission#"
			width            = "95%"
			height           = "auto"
			Mission          = "#mission#"
			Period           = "#per#"	
			DefaultPeriod    = "#ConditionValueAttribute2#"		
			SelectList       = "Charges,Accounts Receivable"					
			Label            = "#Mission# Service Charges (in $000)"
			ShowPrint		 = "1">
										
	</cf_pane>	
	
</cfoutput>


