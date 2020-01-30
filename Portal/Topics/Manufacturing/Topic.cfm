
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
			
	
	<cfquery name="AccountPeriod" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Period
		WHERE    AccountPeriod IN (SELECT AccountPeriod FROM TransactionHeader WHERE Mission = '#mission#')
		ORDER BY PeriodDateStart DESC
	</cfquery>

	<cfset per = "#valueList(AccountPeriod.AccountPeriod)#">
													
	<cf_pane id="WorkOrder_#mission#" search="No">
	
		<cf_paneItem id="WorkOrder_1" 
            systemfunctionid = "#systemfunctionid#" 
			source           = "#session.root#/Portal/Topics/Manufacturing/Manufacturing.cfm?mission=#mission#"
			width            = "95%"
			height           = "auto"
			Mission          = "#mission#"
			Period           = "#per#"	
			DefaultPeriod    = "#ConditionValueAttribute2#"		
			SelectList       = "Accounts Receivable,Materials"	
			DefaultList      = "#ConditionValueAttribute3#"				
			Label            = "#Mission# Manufacturing (in $000)"
			ShowPrint		 = "1">
			
			<!--- SelectList       = "Materials,Accounts Receivable"	--->
										
	</cf_pane>	
	
</cfoutput>


