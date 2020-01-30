
<cfquery name="get" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   *
		FROM     TransactionHeader
		WHERE    TransactionId = '#URL.TransactionId#'  
</cfquery>	

<cfif get.referenceNo eq "">

	<cfset settlementPhase = "Final">
		
<cfelse>

	<cfset settlementPhase = get.ReferenceNo>
			
</cfif>

<cfquery name="getCalculationPeriod" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   *
	FROM     SalarySchedulePeriod
	WHERE    CalculationId = '#get.ReferenceId#'   
</cfquery>	

<cfloop query="getCalculationPeriod">
			
	<cfset per = dateformat(PayrollEnd,"YYYYMM")>
	
	<cfif get.referenceNo neq "">	
		<cfset path = "#Mission#_#SalarySchedule#\#per#_#get.referenceNo#">		
	<cfelse>	
		<cfset path = "#Mission#_#SalarySchedule#\#per#">	
	</cfif>	
	
	<!--- we create the directory first --->	
		
	<cfif not DirectoryExists("#SESSION.rootDocumentPath#\Payslip\#path#\")>
								  
			 <cfdirectory 
				 action   = "CREATE" 
				 directory= "#SESSION.rootDocumentPath#\Payslip\#path#\">
			 
	</cfif>
		
	<cfquery name="Schedule" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   *
		FROM     SalarySchedule
		WHERE    SalarySchedule = '#SalarySchedule#'   	
	</cfquery>	
	
	<cfquery name="MissionSchedule" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   *
		FROM     SalaryScheduleMission
		WHERE    SalarySchedule = '#SalarySchedule#'   	
		AND      Mission        = '#Mission#'
	</cfquery>	
	
						  
	<cfquery name="Settlement" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   SettlementId,
		         Mission,
				 SalarySchedule,
				 PaymentDate,
				 S.PersonNo,
				 LastName, 
				 FirstName
		FROM     EmployeeSettlement S INNER JOIN
                 Employee.dbo.Person P ON S.PersonNo = P.PersonNo
		WHERE    Mission        = '#Mission#'
		AND      SalarySchedule = '#SalarySchedule#'
		AND      PaymentDate    = '#PayrollEnd#'	
		
		AND      NOT EXISTS (SELECT 'X'
							 FROM   EmployeeSettlementAction 
							 WHERE  Mission        = '#Mission#'
							 AND    SalarySchedule = '#SalarySchedule#'
							 AND    PaymentDate    = '#PayrollEnd#'	
							 AND    PersonNo       = S.PersonNo
							 AND    ActionCode     = '#settlementPhase#' 
							 )	
		ORDER BY PersonNo		
		
	</cfquery>	
			
	<cfloop query="Settlement">
									
			<cfset result = "0">			
			<cfset serial = "0">
					
			<cfloop condition="#result# eq 0">	
					
				<cftry>
														
					<cfquery name="getSettlement" 
						datasource="AppsPayroll">
						 SELECT   *
					     FROM     EmployeeSettlement
					     WHERE 	  settlementid = '#settlementid#' 
					</cfquery>
					
					<cfset url.settlementId    = settlementid>
					<cfset url.settlementphase = settlementPhase>
					<cfset url.serial          = serial>
					<cfset url.sendemail       = "1">										
					
					<cfinclude template="SalarySlipPrintDocument.cfm">				
										
					<cfset result = "1">
				 				 
				 <cfcatch>
				 				 
				 	 <cfset result = "1">				
					 <cfset serial = serial+1>
				 
				 </cfcatch>
				 
				 </cftry>
				
				 				 	
			</cfloop> 
								
	</cfloop>

</cfloop>

<cfif Settlement.recordcount eq "0">
<table><tr class="labelmedium"><td><cf_tl id="Nothing to send"></td></tr></table>
<cfelse>
<table><tr class="labelmedium"><td><cf_tl id="Completed"></td></tr></table>
</cfif>