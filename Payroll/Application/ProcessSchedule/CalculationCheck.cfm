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

<cfquery name="Schedule"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT *
	  FROM   SalarySchedulePeriod 
	  WHERE  CalculationId = '#URL.Id#'
</cfquery>	

<cfquery name="Payroll"
	   datasource="AppsPayroll" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT     COUNT(DISTINCT S.PersonNo) as Count
	   FROM       EmployeeSalary S
	   WHERE      S.Mission        = '#Schedule.Mission#'		   
	   AND        S.SalarySchedule = '#Schedule.SalarySchedule#'
	   AND		   S.PayrollStart   = '#dateformat(schedule.PayrollStart,client.dateSQL)#' 
</cfquery>
			 		
<cfquery name="Total"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     SUM(PaymentAmount) AS Amount
		FROM       EmployeeSalaryLine L INNER JOIN
                   EmployeeSalary S ON L.PersonNo = S.PersonNo 
				      AND L.SalarySchedule  = S.SalarySchedule 
					  AND L.PayrollStart    = S.PayrollStart 
					  AND L.Mission         = S.Mission
					  AND L.PayrollCalcNo   = S.PayrollCalcNo 
		WHERE      S.Mission        = '#Schedule.Mission#'		   
	    AND        S.SalarySchedule = '#Schedule.SalarySchedule#'
	    AND		   S.PayrollStart   = '#dateformat(schedule.PayrollStart,client.dateSQL)#'    
</cfquery>

<cfquery name="Payment"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     ISNULL(SUM(PaymentAmount),0) AS Amount, 
		           ISNULL(SUM(Amount),0) AS PostingAmount
		FROM       EmployeeSettlementLine
		WHERE      Mission        = '#Schedule.Mission#'		   
	    AND        SalarySchedule = '#Schedule.SalarySchedule#'
	    AND		   PaymentDate    = '#dateformat(schedule.PayrollEnd,client.dateSQL)#'    			
</cfquery>

<cfif schedule.transactionpaymentfinal neq "0">
				
	<cfif abs(Payment.Amount - schedule.transactionpaymentfinal) gte 0.1>					
		<cfset set = "0">
	<cfelse>
		<cfset set = "1">	
	</cfif>
		
<cfelse>
				
	<cfset set = "1">
		
</cfif>

<cfoutput>

<cfif total.amount neq "">
	
	<cfif schedule.TransactionCount neq Payroll.Count or
	      abs(schedule.TransactionValue - Total.Amount) gte 0.01 or
		  set eq "0">			 

		<table>
		<tr>
		<td class="labelmedium" style="padding-right:4px">
		
			<cf_tl id="Entitlement data not consistent with calculation process log" var="1" Class="Text">			
			<cfset msg1="#lt_text#">
			
			<img src="#SESSION.root#/Images/abort.gif" alt="" border="0" align="absmiddle">
			<cf_tl id="Attention">:&nbsp;#msg1#
			
		</td>		
		</tr>		
		</table>
	
	<cfelse>
	
		<table>
			<tr>
			<td class="labelit" style="padding-right:4px">
			<img src="#SESSION.root#/Images/validate.gif" alt="" border="0" align="absmiddle">
			
			OK, <cf_tl id="Entitlement and Settlement data is consistent with log"></td>
			</tr>
		</table>
	  	  
	 </cfif>
	 
</cfif>
 
</cfoutput>