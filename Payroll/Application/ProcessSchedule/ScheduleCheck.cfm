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
<cfparam name="currentCalcId" default="00000000-0000-0000-0000-000000000000">		
<cfparam name="currentCalcId" default="0D81DD85-CE71-4099-8D14-C8CF6C008BC5">	

<cfquery name="getValid"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 'X' as Validation
	FROM 	Payroll.dbo.SalarySchedulePeriod as SSP
	INNER JOIN Payroll.dbo.SalaryScheduleMission as SSM
	ON SSP.SalarySchedule = SSM.SalarySchedule
     AND SSP.PayrollStart >=ISNULL(SSM.DateEffectivePosting,SSM.DateEffective)
	WHERE   CalculationId = '#currentCalcId#'
</cfquery>

<cfif getValid.recordCount gte 1>

	<cfquery name="SettlementBalance"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT 	A.glaccount,
		       		A.Currency,
		       		A.CalculationId,
		       		A.PaymentDate,
		       		ROUND(SUM(A.PaymentAmount),2) AS PaymentAmount
			FROM
				(
					<!--- get the Debit sum ---->
				    SELECT SUM(ESL.Amount) PaymentAmount,
				           ISNULL(ESL.GLAccount, '9999') AS glaccount,
				           ESL.Currency,
				           SSP.CalculationId,
				           ESL.PaymentDate,
				           ESL.SalarySchedule,
				           'Cost' AS Origin
				    FROM Payroll.dbo.EmployeeSettlementLine AS ESL
				         INNER JOIN Payroll.dbo.EmployeeSettlement AS ES ON ESL.PersonNo = ES.PersonNo
				                                                            AND ESL.PaymentDate = ES.PaymentDate
				                                                            AND ESL.SalarySchedule = ES.SalarySchedule
				         INNER JOIN Payroll.dbo.SalarySchedulePeriod AS SSP ON ES.Mission = SSP.Mission
				                                                               AND ES.SalarySchedule = SSP.SalarySchedule
				                                                               AND ES.PaymentDate = SSP.PayrollEnd
				    WHERE 1 = 1
				          AND SSP.CalculationId = '#currentCalcId#'
				          AND ES.ActionStatus IN ('1')
				          AND SSP.calculationStatus = '3'
				    GROUP BY ESL.Currency,
				             SSP.CalculationID,
				             ESL.PaymentDate,
				             ESL.SalarySchedule,
				             ISNULL(ESL.GLAccount, '9999')
				    UNION ALL
				    <!---- get the Credit sum ---->
				    SELECT SUM(-1 * TMP1.Amount) PaymentAmount,
			  				ISNULL(TMP1.GLAccount, '9991'),
			  				TMP1.Currency,
	           				TMP1.CalculationId,
	           				TMP1.PaymentDate,
	           				TMP1.SalarySchedule,
	           				'Provision' AS Origin
	    			FROM (
		   					SELECT ESL.Amount,
			  						CASE WHEN esl.PayrollItem IN (SELECT PayrollItem 
									FROM Payroll.dbo.Ref_PayrollGroupItem as PGI 
									WHERE PGI.PayrollItem = esl.PayrollItem AND  Code = 'Retention') THEN
										ISNULL((SELECT PG.GLAccount FROM Employee.dbo.PersonGLedger as PG WHERE PG.PersonNo = esl.PersonNo  AND Area= 'Payroll'),'9992')
									ELSE
									 	ISNULL(ESL.GLAccountLiability, '9991')
									END as glAccount,
	           						ESL.Currency,
	           						SSP.CalculationId,
	           						ESL.PaymentDate,
	           						ESL.SalarySchedule,
	           						'Provision' AS Origin
	    						FROM Payroll.dbo.EmployeeSettlementLine AS ESL 
	    									INNER JOIN Payroll.dbo.EmployeeSettlement AS ES 
	    										ON ESL.PersonNo = ES.PersonNo
	                                        	AND ESL.PaymentDate = ES.PaymentDate
	                                        	AND ESL.SalarySchedule = ES.SalarySchedule
	         								INNER JOIN Payroll.dbo.SalarySchedulePeriod AS SSP ON ES.Mission = SSP.Mission
	                                            AND ES.SalarySchedule = SSP.SalarySchedule
	                                            AND ES.PaymentDate = SSP.PayrollEnd
	    						WHERE 	1 = 1
	          					AND 	SSP.CalculationId = '#currentCalcId#'
								AND 	ES.ActionSTatus = '1'
								AND     SSP.calculationStatus = '3'
	    				) as TMP1
	    			GROUP BY TMP1.Currency,
	             			TMP1.CalculationID,
	             			TMP1.PaymentDate,
	             			TMP1.SalarySchedule,
	             			ISNULL(TMP1.GLAccount, '9991')
				) AS A
			GROUP BY 
			A.glaccount,
			A.Currency,
			A.CalculationId,
			A.PaymentDate
			HAVING ROUND(SUM(A.PaymentAmount),2)  >0.05
	</cfquery>	

	<cfquery name="AccountingBalance"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ROUND(SUM(AmountDebit-AmountCredit),2) as PostedTotal, GLAccount, TH.TransactionSourceId
		FROM 	Accounting.dbo.TransactionLine as TL INNER JOIN Accounting.dbo.TransactionHeader as TH
				ON TH.Journal = TL.Journal
				AND TH.JournalSerialNo = TL.JournalSerialNo
		WHERE 1=1
		AND TH.TransactionSourceID = TH.ReferenceId 
		AND TH.TransactionSourceId = '#currentCalcId#'
		GROUP BY GLAccount, TH.TransactionSourceId
		HAVING ROUND(SUM(AmountDebit-AmountCredit),2)> 0.05
	</cfquery>	

	<cfset repost = "No">
	<cfset currentGLaccount = "">
	<cfset settlementAmount ="">
	<cfset accountingAmount ="">
	<cfloop query="SettlementBalance">
		<cfset currentGLaccount = SettlementBalance.glaccount>
		<!---get the amount for this glaccount from the TransactionLine ---->
		<cfquery dbtype="query" name="getAmount">
			SELECT PostedTotal FROM AccountingBalance WHERE glaccount = '#currentGLaccount#'
		</cfquery>
		<cfif getAmount.recordCount eq 1>
			<cfset settlementAmount =  SettlementBalance.PaymentAmount>
			<cfset accountingAmount =  GetAmount.PostedTotal>
			<cfif ABS(ABS(SettlementBalance.PaymentAmount) - ABS(GetAmount.PostedTotal)) gt 1>
				<cfset repost  =  "Yes">
				<cfbreak>
			<cfelse>
				<cfset repost  =  "no">
			</cfif>
		<cfelse>
			<cfset settlementAmount =  SettlementBalance.PaymentAmount>
			<cfset accountingAmount =  0>
			<cfset repost  =  "Yes">
			<cfbreak>
		</cfif>
	</cfloop>
	<cfif repost neq "yes"> <!--- to check on the reverse --->
		<cfloop query="AccountingBalance">
			<cfset currentGLaccount = AccountingBalance.glaccount>
			<!---get the amount for this glaccount from the TransactionLine ---->
			<cfquery dbtype="query" name="getAmount">
				SELECT PaymentAmount  FROM SettlementBalance WHERE glaccount = '#currentGLaccount#'
			</cfquery>
			<cfif getAmount.recordCount eq 1>
				<cfset settlementAmount =  getAmount.PaymentAmount>
				<cfset accountingAmount =  AccountingBalance.PostedTotal>
				<cfif ABS(ABS(GetAmount.PaymentAmount) - ABS(AccountingBalance.PostedTotal)) gt 1>
					<cfset repost  =  "Yes">
					<cfbreak>
				<cfelse>
					<cfset repost  =  "no">
				</cfif>
			<cfelse>
				<cfset settlementAmount =  0>
				<cfset accountingAmount =  AccountingBalance.PostedTotal>
				<cfset repost  =  "Yes">
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>

	<table>
		<tr>
			<td class="labelit" style="padding-right:4px">
				<img src="#SESSION.root#/Images/validate.gif" alt="" border="0" align="absmiddle">
	<cfif repost eq "yes">
				<td class="labelit"><cf_tl id="attention! consider this schedule/payroll for a re-lock"></td>
		<cfelse>
			<td class="labelit"><cf_tl id="schedule/payroll is balanced"></td>
	</cfif>
		</tr>
	</table>

	<cfelse>
	<table>
		<tr>
			<td class="labelit" style="padding-right:4px">
				<img src="#SESSION.root#/Images/validate.gif" alt="" border="0" align="absmiddle">
				<td class="labelit"><cf_tl id="Effective Posting is higher than this Payroll Start"></td>
		</tr>
	</table>

</cfif>



