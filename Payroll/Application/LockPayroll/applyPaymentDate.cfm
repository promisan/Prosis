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


<!--- apply payment date and reload --->

<cfparam name="form.paymentdate" default="">
<cfparam name="form.settlementId" default="">

<cfquery name="get" 
	datasource="appsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT * FROM EmployeeSettlement		
		WHERE SettlementId = '#url.settlementid#'						
</cfquery>

<cfquery name="getsettlement" 
	datasource="appsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT *
		FROM   EmployeeSettlement
		WHERE  PersonNo       = '#get.PersonNo#'
		AND    SalarySchedule = '#get.SalarySchedule#'
		AND    Mission        = '#get.Mission#'
		AND    PaymentDate    = '#form.paymentdate#'
		AND    PaymentStatus  = '1' 							
</cfquery>

<cfif getsettlement.recordcount eq "0">
	
	<cfquery name="setPeriod" 
		datasource="appsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			UPDATE EmployeeSettlement
			SET    PaymentDate  = '#form.paymentdate#'
			WHERE  SettlementId = '#url.settlementid#'						
	</cfquery>

<cfelse>

	<!--- reconnect other lines to this payment date --->
	
	<cfquery name="getSettlement" 
	datasource="appsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT    *
		FROM      EmployeeSettlement
		WHERE     Mission        = '#get.Mission#' 
		AND       SalarySchedule = '#get.SalarySchedule#'
		AND       PersonNo       = '#get.PersonNo#'
		AND       PaymentStatus  = '1'
		AND       PaymentDate >= '#get.PaymentDate#'											     				

		
	</cfquery>
	
	<cfloop query="getSettlement">

		<cfquery name="setPeriod" 
			datasource="appsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				UPDATE EmployeeSettlementLine
				SET    PaymentDate    = '#form.paymentdate#'
				WHERE  PersonNo       = '#PersonNo#'
			    AND    SalarySchedule = '#SalarySchedule#'
			    AND    Mission        = '#Mission#'
			    AND    PaymentDate    = '#paymentdate#'
			    AND    PaymentStatus  = '1' 							
		</cfquery>
	
	</cfloop>

</cfif>

<script>
	history.go()
</script>

