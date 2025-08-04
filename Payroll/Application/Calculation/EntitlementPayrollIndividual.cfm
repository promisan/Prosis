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

<!--- this component might be paid in different currency, so there is need to convert currencies here !! --->

<CF_DropTable dbName="AppsTransaction" tblName="sal#SESSION.thisprocess#EntitlementIndividual">	

<cfquery name="RateAmount" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT 
	       Ent.PersonNo, 
		   Ent.EntitlementId,
		   Ent.SalarySchedule,
		   Ent.DateEffective, 
		   Ent.DateExpiration, 
		   Ent.EntitlementDays,
		   Ent.EntitlementLWOP, 
		   Ent.EntitlementSuspend,
		   Ent.Status, 
		   Ent.ContractTime,
		   Ent.Line,
		   Ent.PayrollItem, 
		   Ent.Currency,
		   Ent.Amount, 
		   Exch.ExchangeRate,
		   Ent.Amount/Exch.ExchangeRate as EntitlementAmount, 
		   Ent.Amount/Exch.ExchangeRate as PaymentAmount, 
		   Ent.Period,
		   '1' as SalaryMultiplier,
		   getDate() as TimeStamp
	INTO   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#Entitlements Ent,
	       userTransaction.dbo.sal#SESSION.thisprocess#Exchange Exch
	WHERE  Ent.EntitlementClass = 'Amount'
	AND    Exch.Currency = Ent.Currency  
		
</cfquery>


<cfset dim = daysInMonth(SALSTR)>

<cfquery name="MonthContract" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	SET    Amount            = (EntitlementDays/#Form.SalaryDays#)*Amount,
     	   PaymentAmount     = (EntitlementDays/#Form.SalaryDays#)*PaymentAmount,
		   EntitlementAmount = (EntitlementDays/#Form.SalaryDays#)*EntitlementAmount 
	WHERE  Period = 'MONTH' 
	
</cfquery>

<cfquery name="MonthBase" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	SET    Amount            = ((EntitlementDays-EntitlementLWOP)/#Form.SalaryDays#)*Amount,
		   PaymentAmount     = ((EntitlementDays-EntitlementLWOP)/#Form.SalaryDays#)*PaymentAmount,
		   EntitlementAmount = ((EntitlementDays-EntitlementLWOP)/#Form.SalaryDays#)*EntitlementAmount
	WHERE  Period = 'MONTHN' 
	
</cfquery>

<cfquery name="MonthWork" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	SET    Amount            = ((EntitlementDays-EntitlementLWOP-EntitlementSuspend)/#Form.SalaryDays#)*Amount,
		   PaymentAmount     = ((EntitlementDays-EntitlementLWOP-EntitlementSuspend)/#Form.SalaryDays#)*PaymentAmount,
		   EntitlementAmount = ((EntitlementDays-EntitlementLWOP-EntitlementSuspend)/#Form.SalaryDays#)*EntitlementAmount
	WHERE  Period = 'MONTHW' 
	
</cfquery>

<cfquery name="MonthFixed" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	
	SET    Amount            = 0, PaymentAmount = 0, EntitlementAmount = 0 
	
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual P	   
	
	WHERE  Period = 'MONTHF' 
	
	<!--- added to apply the fixed rate only to the last line found for a person --->
	
	AND    Line < (SELECT MAX(Line) as Line
			       FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual 
				   WHERE  PersonNo = P.PersonNo)  
	
</cfquery>

<cfquery name="DayRates" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	SET     Amount            = (DateDiff(dd,DateEffective,DateExpiration)+1)*Amount,
		    PaymentAmount     = (DateDiff(dd,DateEffective,DateExpiration)+1)*PaymentAmount,
			EntitlementAmount = (DateDiff(dd,DateEffective,DateExpiration)+1)*EntitlementAmount
	WHERE   Period = 'DAY'
	
</cfquery>

<cfquery name="WorkdayRates" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	SET     Amount            = (EntitlementDays-EntitlementLWOP-EntitlementSuspend)*Amount,
		    PaymentAmount     = (EntitlementDays-EntitlementLWOP-EntitlementSuspend)*PaymentAmount,
			EntitlementAmount = (EntitlementDays-EntitlementLWOP-EntitlementSuspend)*EntitlementAmount
	WHERE   Period = 'WORKDAY'
	
</cfquery>

<!--- ------------------------------------ --->
<!--- apply conversion to payroll currency --->
<!--- ------------------------------------ --->

<cfquery name="MultiplierCorrection" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE  userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual   
	SET     PaymentAmount   = -1*PaymentAmount
	WHERE   PayrollItem IN (SELECT PayrollItem FROM Ref_PayrollItem WHERE PaymentMultiplier = '-1')
	
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
			 EntitlementSalarySchedule,
			 EntitlementPeriod,
			 EntitlementPeriodUoM,
			 Currency, 
			 AmountCalculationFull, 
			 AmountCalculationDays,
			 AmountCalculationBase, 
			 AmountCalculationWork, 
			 AmountCalculation, 
			 AmountPayroll, 
			 PaymentCurrency, 
			 PaymentCalculation,
			 PaymentAmount, 
		     Reference, 
			 ReferenceId, 
			 CalculationSource,
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
		SELECT '#Form.Schedule#',
		     PersonNo, 
			 #SALSTR#, 
			 '#Form.Mission#',
			 Line,
			 PayrollItem,
			 SalarySchedule,
			 EntitlementDays-EntitlementLWOP,
			 Period,
			 Currency,
			 ROUND(Amount,6),
			 ROUND(Amount,6),
			 ROUND(Amount,6),			 
			 ROUND(Amount,6),
			 ROUND(Amount,6), 
			 ROUND(Amount,6), 
			 '#Form.Currency#', 
			 ROUND(EntitlementAmount, #roundsettle#), 
			 ROUND(PaymentAmount, #roundsettle#), 
			 'Individual',
		     EntitlementId, 
			 'RateIndividual',
			 '#SESSION.acc#', 
			 '#SESSION.last#', 
			 '#SESSION.first#'
	FROM   userTransaction.dbo.sal#SESSION.thisprocess#EntitlementIndividual P 
	WHERE  EXISTS (SELECT 'X' 
	               FROM  EmployeeSalary
				   WHERE PersonNo       = P.PersonNo
				   AND   PayrollCalcNo  = P.Line
				   AND   SalarySchedule = '#Form.Schedule#'
				   AND   PayrollStart   = #SALSTR# )
				   
</cfquery>
