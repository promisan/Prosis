<!--
    Copyright © 2025 Promisan B.V.

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


