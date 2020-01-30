

<!--- apply payment date and reload --->

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
		WHERE  PersonNo = '#get.PersonNo#'
		AND    SalarySchedule = '#get.SalarySchedule#'
		AND    Mission        = '#get.Mission#'
		AND    PaymentDate    = '#url.paymentdate#'
		AND    PaymentStatus  = '1' 							
</cfquery>

<cfif getsettlement.recordcount eq "0">
	
	<cfquery name="setPeriod" 
		datasource="appsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			UPDATE EmployeeSettlement
			SET    PaymentDate  = '#url.paymentdate#'
			WHERE  SettlementId = '#url.settlementid#'						
	</cfquery>

<cfelse>

	<cfquery name="setPeriod" 
		datasource="appsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			UPDATE EmployeeSettlementLine
			SET    PaymentDate    = '#url.paymentdate#'
			WHERE  PersonNo       = '#get.PersonNo#'
		    AND    SalarySchedule = '#get.SalarySchedule#'
		    AND    Mission        = '#get.Mission#'
		    AND    PaymentDate    = '#get.paymentdate#'
		    AND    PaymentStatus  = '1' 							
	</cfquery>

</cfif>

<script>
	history.go()
</script>

