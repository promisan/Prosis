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

<cfset vAmount = trim(replace(url.amount, ",", "", "ALL"))>

<cfset vMessage = "">

<cfquery name="Param" 
	datasource="AppsProgram"  
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.mission#'		
</cfquery>

<cf_exchangeRate 
	    DataSource    = "AppsProgram"
		CurrencyFrom  = "#url.cur#" 
		CurrencyTo    = "#Param.BudgetCurrency#">

<cfif Exc eq "0" or Exc eq "">
	<cfset exc = 1>
</cfif>			
		
<cfset vAmountBase = vAmount / exc>

<cfoutput>

	#numberformat(vAmountBase,',.__')# 
	<input type="Hidden" id="AmountBase" name="AmountBase" value="#vAmountBase#">	
	<script language="JavaScript">
		 ColdFusion.navigate('ContributionLineDialogPeriod.cfm?contributionlineid=#url.contributionlineid#&amountbase=#vAmountBase#','amountperiod') 
	</script>

</cfoutput>