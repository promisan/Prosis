
<!--- Salary
    	I.	 Clean unnneeded records based on final payment that were revoked
		II.  Create data set of rates (DAY, HOUR
		III. Create data set with rates to be used
--->

<!--- if a record is reset we better also reset the associated records of the final payment --->
				
<cfquery name="UpdateFinalPaymentRecords" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  Payroll.dbo.PersonMiscellaneous
		FROM    Payroll.dbo.PersonMiscellaneous M	
		WHERE   Source = 'Final'
		
		<!--- remove FP records that are not related to a FP settlement process --->
		
		AND     NOT EXISTS (SELECT 'X' 
		                    FROM   Payroll.dbo.EmployeeSettlement 
							WHERE  SettlementId = M.SourceId
							<!--- AND    PaymentFinal = 1 : hanno 22/8 removed to prevent that if in-clycle is run after the FP it would get removed --->)	
		AND     Status != '5'					 						 
</cfquery>	

<!--- 14/10/2019 

if an entitlement is calculated for a later month but potentially does qualify 
to be processed earlier (affecting the exchange rate) we clean it 

--->

<cfif processmodality eq "PersonalNormal">	
	
	<cfquery name="resetentitlement" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		     DELETE EmployeeSalaryLine
			 WHERE  PersonNo       = '#Form.PersonNo#'			
			 AND    PayrollCalcNo  = '1'
			 AND    SalarySchedule = '#Form.Schedule#'		
			 AND    Mission        = '#form.mission#'
			 AND    PayrollStart > 	#SALEND#	 
			 AND    ReferenceId IN (SELECT CostId
			 						FROM   PersonMiscellaneous Cost
									WHERE  Cost.PersonNo = '#Form.PersonNo#' 
									AND    DateEffective <= #SALEND# )		
														
			 
	</cfquery>

</cfif>

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#Cost">	

<cfif processmodality eq "InCycleBatch" or processmodality eq "PersonalNormal">	

		<cfquery name="Cost" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT DISTINCT 
		       Cost.PersonNo, 
			   Cost.CostId,
			   #SALSTR# as DatePayroll,
			   Cost.DocumentDate, 
			   Cost.Quantity, 
			   Cost.EntitlementClass, 
			   Cost.Status, 
			   Cost.Source,
			   Cost.SourceId,
			   Pay.Line,
			   R.Source as PayrollItemSource, <!--- added by Hanno to handle correctly 3rd party payment corrections --->
			   R.PayrollItem, 
			   R.PaymentMultiplier,
			   Cost.Currency     as DocumentCurrency,
			   Cost.Amount       as DocumentAmount, 
			   '#Form.Currency#' as PaymentCurrency,
			   Exch.ExchangeRate,
			   99999999.999 as EntitlementAmount,
			   99999999.999 as PaymentAmount
			   
		INTO   userTransaction.dbo.sal#SESSION.thisprocess#Cost   
		
		FROM   PersonMiscellaneous Cost,
		       Ref_PayrollItem R,
			   userTransaction.dbo.sal#SESSION.thisprocess#Exchange Exch,
			   userTransaction.dbo.sal#SESSION.thisprocess#PayrollLine Pay 
			   
		WHERE  Cost.PayrollItem   = R.PayrollItem
		AND    Cost.PersonNo      = Pay.PersonNo 
		AND    Cost.Currency      = Exch.Currency
		
		<!--- is not processed already in payroll entitlements --->
		AND    NOT EXISTS (SELECT 'X'
		                   FROM   EmployeeSalaryLine 
						   WHERE  ReferenceId = Cost.CostId)
								   
		AND    Cost.Status >= '1' AND Cost.Status != '9'  <!--- approved --->
		
		<!--- we pickup any costs that fall within the calculation period --->   	
		<cfif processmodality eq "PersonalNormal">	
			   AND  Cost.PersonNo = '#Form.PersonNo#'		   			     
			   AND  Cost.DateEffective <= #SALEND#			
		<cfelse>
			   AND  Cost.PersonNo NOT IN (#preservesingleQuotes(selper)#)  	
			   AND  Cost.DateEffective <= #SALEND# 
		</cfif>
		 AND  Cost.DateEffective >= #SALSTR#
		
		</cfquery>

<cfelse>

		<!--- we take ALL costs if they were not posted we remove the condition
		userTransaction.dbo.sal#SESSION.thisprocess#PayrollLine Pay
		 --->

		<cfquery name="Cost" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT DISTINCT 
			       Cost.PersonNo, 
				   Cost.CostId,
				   #SALSTR# as DatePayroll,
				   Cost.DocumentDate, 
				   Cost.Quantity, 
				   Cost.EntitlementClass, 
				   Cost.Status, 
				   Cost.Source,
				   Cost.SourceId,
				   '1' as Line,
				   R.Source as PayrollItemSource, <!--- added by Hanno to handle correctly 3rd party payment corrections --->
				   R.PayrollItem, 
				   R.PaymentMultiplier,
				   Cost.Currency     as DocumentCurrency,
				   Cost.Amount       as DocumentAmount, 
				   '#Form.Currency#' as PaymentCurrency,
				   Exch.ExchangeRate,
				   99999999.999 as EntitlementAmount,
				   99999999.999 as PaymentAmount
				   
			INTO   userTransaction.dbo.sal#SESSION.thisprocess#Cost   
			
			FROM   PersonMiscellaneous Cost,
			       Ref_PayrollItem R,
				   userTransaction.dbo.sal#SESSION.thisprocess#Exchange Exch			  
				   
			WHERE  Cost.PayrollItem   = R.PayrollItem		
			AND    Cost.Currency      = Exch.Currency
			
			<!--- is not processed already in payroll entitlements --->
			AND    NOT EXISTS (SELECT 'X'
			                   FROM   EmployeeSalaryLine 
							   WHERE  ReferenceId = Cost.CostId)
									   
			AND    Cost.Status >= '1' AND Cost.Status != '9'  <!--- approved --->
					
			AND    Cost.PersonNo = '#Form.PersonNo#'		
			<!--- we pickup any miscellaneous costs --->   	
			AND    Cost.DateEffective <= #SALEND#		
			<!---
			---	AND    Cost.DateEffective >= #SALSTR#	  		
			--->
		
		</cfquery>
		
		<!--- special provision to capture the cost even if the person is not around anymore
		 check if parent record exist --->
		
		<cfquery name="getCosts" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM userTransaction.dbo.sal#SESSION.thisprocess#Cost	
		</cfquery>
		
		<cfif getCosts.recordcount gte "1">
		
			<cfquery name="check" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			     SELECT *
		         FROM   EmployeeSalary
				 WHERE  PersonNo       = '#Form.PersonNo#'
				 AND    PayrollCalcNo  = '1'
				 AND    SalarySchedule = '#Form.Schedule#'
				 AND    PayrollStart   = #SALSTR# 
				 
			</cfquery>
		
			<cfif check.recordcount eq "0"> 
					
				<cfquery name="Insert" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO EmployeeSalary
				
						(SalarySchedule,
						 PersonNo, 
						 PayrollStart, 
						 PayrollEnd, 
						 PayrollCalcNo,
						 Mission, 		
						 OrgUnit,	
						 ServiceLevel,	ServiceStep, ServiceLocation, SalaryCalculatedStart,SalaryCalculatedEnd,
						 PaymentCurrency,
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
					 
				VALUES ( '#Form.Schedule#',
				         #Form.PersonNo#, 
						 #SALSTR#, 
						 #SALEND#, 
						 '1',
						 '#Form.mission#', 	
						 '0',		
						 '',
						 '',	
						 '', 
						 #CALCSTR#, 
						 #CALCEND#,
						 '#Schedule.PaymentCurrency#',
						 '#SESSION.acc#', 
						 '#SESSION.last#', 
						 '#SESSION.first#') 
						 
						
			     </cfquery>
			 
			 </cfif>	
		 
		 </cfif>
		
</cfif>

<!--- ------------------------------------ --->
<!--- ------sign correctionl currency----- --->
<!--- ------------------------------------ --->

<cfquery name="DefaultSignCorrectionForDeductions" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Cost
	SET     DocumentAmount    = DocumentAmount * -1
	WHERE   EntitlementClass  = 'Deduction'
</cfquery>

<!--- ------------------------------------ --->
<!--- apply conversion to payroll currency --->
<!--- ------------------------------------ --->

<cfquery name="ExchangeRate" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Cost
	SET     EntitlementAmount = DocumentAmount/ExchangeRate,
		    PaymentAmount     = DocumentAmount/ExchangeRate
	WHERE   EntitlementClass != 'Contribution'		
	
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Cost
	SET     EntitlementAmount = DocumentAmount/ExchangeRate,
		    PaymentAmount     = DocumentAmount * -1/ExchangeRate
	WHERE   EntitlementClass = 'Contribution'		
	
	<!--- the amount is a deduction, the entitlement amount is the reverse --->
	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#Cost
	SET     EntitlementAmount = DocumentAmount * -1/ExchangeRate
	WHERE   EntitlementClass  = 'Deduction'		
	AND     PayrollItemSource = 'Deduction' <!--- this is only applied for payroll items that are set as deduction and HAVE a third party --->
	
</cfquery>

<cfquery name="InsertLine" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	INSERT INTO EmployeeSalaryLine
		  (SalarySchedule,
   		   PersonNo, 
		   PayrollStart, 
		   Mission,
		   PayrollCalcNo,
		   PayrollItem, 
		   EntitlementPeriod,
		   EntitlementPeriodUoM,
		   DocumentCurrency,
		   DocumentAmount,
		   Currency, 
		   AmountCalculationFull,
		   AmountCalculationBase, 
		   AmountCalculation, 
		   AmountPayroll, 
		   PaymentCurrency, 
		   PaymentCalculation,
		   PaymentAmount, 
	       Reference, 
		   ReferenceId, 
		   Source,
		   SourceId,
		   CalculationSource,
		   OfficerUserId, 
		   OfficerLastName, 
		   OfficerFirstName)
		 
	SELECT '#Form.Schedule#',
	       PersonNo, 
		   DatePayroll, 
		   '#Form.Mission#',
		   Line,
		   PayrollItem,
		   '1',
		   'EACH',
		   DocumentCurrency,
		   DocumentAmount,
		   DocumentCurrency,
		   DocumentAmount,
		   DocumentAmount,
		   DocumentAmount, 
		   DocumentAmount,
		   PaymentCurrency, 
		   ROUND(EntitlementAmount, #roundsettle#), 
		   ROUND(PaymentAmount, #roundsettle#), 
		   'Cost',
	       CostId, 
		   (CASE 
		       WHEN Source = 'SUN'    THEN 'Offset' 
			   WHEN Source = 'Ledger' THEN 'Offset' ELSE 'Internal' END) as Source,
		   (CASE WHEN P.SourceId IS NULL THEN '00000000-0000-0000-0000-000000000000' ELSE P.SourceId END) as SourceId,		   		      
		   'Miscellaneous',
		   '#SESSION.acc#', 
		   '#SESSION.last#', 
		   '#SESSION.first#'
		 
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#Cost P
	
	WHERE  EXISTS (SELECT 'X' 
	               FROM  EmployeeSalary
				   WHERE PersonNo       = P.PersonNo
				   AND   PayrollCalcNo  = P.Line
				   AND   SalarySchedule = '#Form.Schedule#'
				   AND   PayrollStart   = P.DatePayroll )				  
	
</cfquery>

<!--- -------------------------------------------------------------------------------------------- --->
<!--- if this is an offset we ALSO post the personal offset against the transaction of the advance 

hereto we loop through the advance transaction and book a debit offset for the same account as was
taken for the master transaction account

--->
<!--- -------------------------------------------------------------------------------------------- 

SELECT        H.Journal, H.JournalSerialNo, L.GLAccount
FROM            TransactionHeader AS H INNER JOIN
                         TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
WHERE        (H.TransactionId = 'f2b96247-a24b-4d97-8fe4-6232828d4a54') AND (L.TransactionSerialNo = '1')

--->






