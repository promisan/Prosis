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
<!--- Preparation of the closing --->
<!--- -------------------------- --->

<CF_DropTable dbName="AppsQuery" tblName="object#SESSION.acc#Salary">	
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Program">

<!--- clean prior version of this log file --->

<cfquery name="ClearLog"
 datasource="AppsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	DELETE FROM CalculationLog
	WHERE  ProcessNo = '#url.processno#'	
</cfquery>

<cfquery name="schedulePeriod" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   SalarySchedulePeriod
	WHERE  CalculationId = '#URL.CalculationID#'
</cfquery>

<!--- create log container --->
	
<cfquery name="InsertProcessBatch"
 datasource="AppsPayroll" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	INSERT INTO CalculationLog
		(ProcessNo,
		 ProcessClass,
		 ProcessBatchId,	
		 Mission,
		 SalarySchedule,
		 PayrollStart,	
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
	VALUES
		('#url.processno#',
		 'closing',
		 '#url.calculationid#',		
		 '#SchedulePeriod.Mission#',
		 '#SchedulePeriod.SalarySchedule#',
		 '#SchedulePeriod.PayrollStart#',		
		 '#SESSION.acc#',
		 '#SESSION.last#',
		 '#SESSION.first#')			
</cfquery>



<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   SalarySchedulePeriod
	WHERE  SalarySchedule = '#SchedulePeriod.SalarySchedule#'
	 AND   Mission        = '#SchedulePeriod.Mission#'
	 AND   PayrollStart   < '#SchedulePeriod.PayrollStart#'
	 AND   CalculationStatus < '2'
</cfquery>

<!--- salary calculation ---> 	

<cfif check.recordcount gte "1">
								 
	<cf_CalculationLockProgressInsert
        ProcessNo      = "#url.processno#"
	   	ProcessBatchId = "#url.calculationid#"				
		ActionStatus   = "9"
		StepStatus     = "9"
		StepException  = "A prior period was not closed yet!">		
		
		<cfabort>
		
</cfif>			

<cfquery name="Schedule" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   SalarySchedule
	WHERE  SalarySchedule = '#SchedulePeriod.SalarySchedule#'	
</cfquery> 

<cfquery name="Param" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Program.dbo.Ref_ParameterMission
	WHERE  Mission = '#SchedulePeriod.Mission#'	
</cfquery> 

<!--- -------------------- --->
<!--- determine the period --->
<!--- -------------------- --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_MissionPeriod
	WHERE    Mission = '#SchedulePeriod.Mission#' 
	AND      Period IN
    	        (SELECT  Period
        	     FROM    Program.dbo.Ref_Period
            	 WHERE   DateEffective  <= '#SchedulePeriod.PayrollStart#' 
				 AND     DateExpiration >= '#SchedulePeriod.PayrollStart#')
</cfquery>

<cfoutput>

	<cfif check.Period eq "">
								 
		<cf_CalculationLockProgressInsert
        	ProcessNo      = "#url.processno#"
		   	ProcessBatchId = "#url.calculationid#"				
			StepStatus     = "9"
			StepException  = "Please check if a #SchedulePeriod.Mission# Period exists for date : #dateformat(SchedulePeriod.PayrollStart,CLIENT.DateFormatShow)#">			 
	
		<cfabort>
		
	<cfelse>
	
	    <cfset per = check.Period>	
		
	</cfif>		
	
</cfoutput>	

 
<cf_tl id="REQ017" var="1">
<cfset vReq017=#lt_text#>	
				 			 
<!--- ------------------------------------------- ---> 
<!--- ------------------------------------------- ---> 
<!--- --------------we start here---------------- --->
<!--- ------------------------------------------- ---> 
<!--- ------------------------------------------- --->
 
<cftransaction isolation="READ_UNCOMMITTED">
	
	<cfquery name="schedule" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Payroll.dbo.SalarySchedule
		WHERE  SalarySchedule = '#SchedulePeriod.SalarySchedule#'	
	</cfquery>
	
	<!--- ------------------------------------- --->
	<!--- ---Step 1. convert to base currency-- --->
	<!--- ------------------------------------- --->
	
	<cf_CalculationLockProgressInsert
		ProcessNo      = "#url.processno#"
		ProcessBatchId = "#url.calculationid#"				
		Description    = "Initializing">
		
	<cf_verifyOperational 
	  datasource= "appsOrganization"
	  module    = "Accounting" 
	  Warning   = "No">
	  
	<cfif operational eq "1">  	
	
		<cfquery name="getDates" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT DISTINCT PayrollEnd
			FROM       Payroll.dbo.EmployeeSettlementLine
			WHERE      Mission        = '#SchedulePeriod.Mission#' 
			AND        SalarySchedule = '#SchedulePeriod.SalarySchedule#' 
			AND        PaymentDate    = '#SchedulePeriod.PayrollEnd#'
			ORDER BY   PayrollEnd
		</cfquery>	
		
		<cfloop query="getDates">
	
		    <!--- to document exchange rate --->
			
			<cf_exchangeRate 
			       datasource    = "AppsOrganization"       
			       CurrencyFrom  = "#Schedule.PaymentCurrency#" 
			       CurrencyTo    = "#param.BudgetCurrency#"
				   EffectiveDate = "#dateformat(PayrollEnd,client.dateformatshow)#">
					
			<cfif Exc eq "0" or Exc eq "">
				<cfset dexc = 1>
			<cfelse>
				<cfset dexc = exc>	
			</cfif>			
			
			<!--- to be base exchange rate --->
		
			<cf_exchangeRate 
			       datasource = "AppsOrganization"       
			       CurrencyFrom = "#Schedule.PaymentCurrency#" 
			       CurrencyTo   = "#APPLICATION.BaseCurrency#"
				   EffectiveDate = "#dateformat(PayrollEnd,client.dateformatshow)#">
					
			<cfif Exc eq "0" or Exc eq "">
				<cfset bexc = 1>
			<cfelse>
				<cfset bexc = exc>		
			</cfif>		
			
			<cfquery name="setbaseamount" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					UPDATE Payroll.dbo.EmployeeSettlementLine
					
					SET    <!--- secundary payslip --->
						   DocumentCurrency     = '#param.BudgetCurrency#',
					       DocumentExchangeRate = '#dexc#',
						   DocumentAmount       = round(PaymentAmount/#dexc#,3),
						   
						   <!--- for posting purposes --->			
					       ExchangeRate         = '#bexc#',
					       AmountBase           = round(Amount/#bexc#,2)	
						   
					WHERE  SalarySchedule       = '#SchedulePeriod.SalarySchedule#'
					AND    Mission              = '#SchedulePeriod.Mission#'
					AND    PayrollEnd           = '#PayrollEnd#'
					AND    PaymentDate          = '#SchedulePeriod.PayrollEnd#' 
					
				</cfquery>
			
		 </cfloop>			
		
	<cfelse>
	
		<cfset dexc = 1>
		<cfset bexc = 1>
		
		<cfquery name="setbaseamount" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				UPDATE Payroll.dbo.EmployeeSettlementLine
				
				SET    <!--- secundary payslip --->
					   DocumentCurrency     = '#param.BudgetCurrency#',
				       DocumentExchangeRate = '#dexc#',
					   DocumentAmount       = round(PaymentAmount/#dexc#,3),
					   
					   <!--- for posting purposes --->			
				       ExchangeRate         = '#bexc#',
				       AmountBase           = round(Amount/#bexc#,2)	
					   
				WHERE  SalarySchedule       = '#SchedulePeriod.SalarySchedule#'
				AND    Mission              = '#SchedulePeriod.Mission#'
				AND    PaymentDate          = '#SchedulePeriod.PayrollEnd#'
				
			</cfquery>			
		
	</cfif>					
	
	
	
	<!--- --------------------------------------------------------------- --->
	<!--- --- Step 2 Post the calculation as an obligation / financials-- --->
	<!--- --------------------------------------------------------------- --->
		
	<cfset stop = "0">
	
	<cfif Schedule.ProcessMode eq "Procurement">
	
		<!--- old SAT mode to post through the Procurement module, disabled 
	
		<cf_verifyOperational 
		  datasource= "appsOrganization"
		  module    = "Procurement" 
		  Warning   = "No">
		  
		<cfif operational eq "1">
		
			<cfinclude template="CalculationLockObligation.cfm">		
		
		</cfif> 	
		
		--->
		
	<cfelse>
		
		<!--- ------------------------------------------------------------------------------- --->
		<!--- --- BB Post the calculation as an financials posting : CICIG and others ------- --->
		<!--- ------------------------------------------------------------------------------ --->
			
		<cf_verifyOperational 
		  datasource= "appsOrganization"
		  module    = "Accounting" 
		  Warning   = "No">
			
		<cfif operational eq "1">
		
			<cfinclude template="CalculationLockFinancials.cfm">	
							
				<!--- update GL account schedule --->
				<!--- update GL account item --->
				<!--- update exchangerate + amount --->
				<!--- posting in GLLedger : summarised --->
		
		</cfif>  	
		
	</cfif>	
	
	<cfif stop eq "0">	
			
		<!--- --------------------------------------------------------------- --->
		<!--- --- Step 3 Prepare and send PDF-------------------------------- --->
		<!--- --------------------------------------------------------------- --->
			
		<CF_DropTable dbName="AppsQuery" tblName="object#SESSION.acc#Salary">		
			
		<cfquery name="createObject" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   DISTINCT S.PayrollItem, 
				         R.PayrollItemName,
				         O.ObjectCode, 
						 O.ItemMaster,
						 O.GLAccount
				INTO     userQuery.dbo.object#SESSION.acc#Salary		 
				FROM     Payroll.dbo.EmployeeSettlementLine S LEFT OUTER JOIN
				         Payroll.dbo.SalarySchedulePayrollItem O ON S.SalarySchedule = O.SalarySchedule 
						 			AND S.Mission = O.Mission 
									AND S.PayrollItem = O.PayrollItem INNER JOIN Payroll.dbo.Ref_PayrollItem R ON R.PayrollItem = O.PayrollItem							 	
				WHERE    S.SalarySchedule = '#SchedulePeriod.SalarySchedule#'
				AND      S.Mission        = '#SchedulePeriod.Mission#'
				AND      S.PayrollStart   = '#SchedulePeriod.PayrollStart#'									
		</cfquery>  		
		
		<cfparam name="Reference" default="Standard">
		
		<!--- -------------------------------------------------------------- --->
		<!--- ------Step 4 Audit Log---------------------------------------- --->
		<!--- -------------------------------------------------------------- --->
					
		<cfquery name="auditlog" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Payroll.dbo.EmployeeSettlementAudit
					 (ProcessNo,
					  ProcessBatchId,
					  PaymentId, 
					  Mission, 
					  SalarySchedule, 
					  PersonNo, 
					  PayrollStart, 
					  PayrollEnd, 
					  PaymentDate, 
					  SettlementPhase,
					  PayrollItem, 
					  PositionParentId, 					  
					  Period, 
					  OrgUnit, 
					  ObjectCode, 
					  GLAccount, 
					  Currency, 
					  PaymentAmount, 
					  Amount, 
					  ExchangeRate, 
					  AmountBase, 
					  PaymentYear, 
		              PaymentMonth, 
					  Journal, 
					  JournalSerialNo, PaymentStatus, OfficerUserId, OfficerLastName, OfficerFirstName, 
		              Created)			
						
			SELECT    '#url.ProcessNo#',
			          '#url.calculationid#',			         
					  S.PaymentId, 
					  S.Mission, 
					  S.SalarySchedule, 
					  S.PersonNo, 
					  S.PayrollStart, 
					  S.PayrollEnd, 
					  S.PaymentDate, 
					  S.SettlementPhase,
					  S.PayrollItem, 
					  S.PositionParentId, 					 
					  '#per#', 
					  S.OrgUnit, 
					  S.ObjectCode, 
					  S.GLAccount, 
					  S.Currency, 
					  S.PaymentAmount, 
					  S.Amount, 
					  S.ExchangeRate, 
					  S.AmountBase, 
					  S.PaymentYear, 
		              S.PaymentMonth, 
					  S.Journal, 
					  S.JournalSerialNo, S.PaymentStatus, S.OfficerUserId, S.OfficerLastName, S.OfficerFirstName, 
		              S.Created
		    FROM      Payroll.dbo.EmployeeSettlementLine S
			WHERE     SalarySchedule = '#SchedulePeriod.SalarySchedule#'
			AND       Mission        = '#SchedulePeriod.Mission#'
			AND       PaymentDate    = '#SchedulePeriod.PayrollEnd#'
			<cfif url.actionstatus eq "2">
			AND        S.SettlementPhase = 'Initial'
			<cfelse>
			AND        S.SettlementPhase = 'Final'
			</cfif>   		
		</cfquery>	
			
		<!--- ------------------------------------ --->
		<!--- ---STEP 5 -close the period status-- --->
		<!--- ------------------------------------ --->
			
		<cfquery name="reset" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Payroll.dbo.SalarySchedulePeriod
			SET    CalculationStatus = '#url.actionstatus#' 
			
				   <cfif Schedule.ProcessMode eq "Procurement">
			
					   <cfif url.actionstatus eq "2">
				       ,Reference      = '#Reference#'
					   <cfelse>
					   ,ReferenceFinal = '#Reference#'
					   </cfif>
				   		   
				   
				   </cfif>
				   
			WHERE  CalculationId  = '#url.calculationid#'
					
		</cfquery>		
		
		<cf_CalculationLockProgressInsert
			    ProcessNo      = "#url.processno#"
			   	ProcessBatchId = "#url.calculationid#"	
				ActionStatus   = "2"	
				StepStatus	   = "1"
				Description    = "Completed">	
		
	</cfif>	
	
</cftransaction>
