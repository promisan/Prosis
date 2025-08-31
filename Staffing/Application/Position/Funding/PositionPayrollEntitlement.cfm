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
<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Position 
	WHERE  PositionNo = '#URL.PositionNo#'
</cfquery>

<cfoutput> 

	<!--- 24/8/2017 contribution base can be different from financial base like in
	STL budget is prepared in EUR, but the base financial currency is USD, so
	we need a different conversion for execution --->

		
	<cfsavecontent variable="myquery">  
		
	   SELECT * --,PayrollEnd
	   FROM (

		SELECT newid() as Id, 
			   S.Mission,	
			   S.PayrollEnd,
			   S.SalarySchedule,
			   SS.Description as SalaryScheduleDescription,
			   S.ServiceLocation,
			   PL.Description as ServiceLocationDescription,
			  
			  
			   P.PersonNo,
			   P.IndexNo,
			   P.FullName,
			   S.FunctionDescription,
			   S.PostClass,
			   S.PostType,
			   S.ServiceLevel,
			   S.ServiceStep,
			   S.PaymentCurrency,
			   S.SalaryDays,
			   S.SalarySLWOP,
			   S.SalarySuspend,
			   S.SalaryDaysNet,
			   SUM(L.PaymentCalculation) as PaymentAmount
		FROM   EmployeeSalary S
			   INNER JOIN EmployeeSalaryLine L
				  ON S.SalarySchedule = L.SalarySchedule
				  AND S.PayrollStart = L.PayrollStart
				  AND S.PersonNo = L.PersonNo
				  AND S.PayrollCalcNo = L.PayrollCalcNo
			   INNER JOIN Ref_PayrollItem PIt
				  ON L.PayrollItem = PIt.PayrollItem
			   INNER JOIN Ref_PayrollLocation PL
				  ON S.ServiceLocation = PL.LocationCode
			   INNER JOIN Employee.dbo.Person P
				  ON S.PersonNo = P.PersonNo
			   INNER JOIN SalarySchedule SS
			   	  ON S.SalarySchedule = SS.SalarySchedule
		WHERE  PIt.Source != 'Deduction'
		AND    PIt.Settlement = '1'
		AND    S.PositionParentId = '#Position.PositionParentId#'
		
		GROUP BY
			   S.Mission,	
			   S.PayrollEnd,
			   S.SalarySchedule,
			   SS.Description,
			   S.ServiceLocation,
			   PL.Description,
			   P.PersonNo,
			   P.IndexNo,
			   P.FullName,
			   S.FunctionDescription,
			   S.PostClass,
			   S.PostType,
			   S.SalaryDays,
			   S.SalarySLWOP,
			   S.SalarySuspend,
			   S.ServiceLevel,
			   S.ServiceStep,
			   S.PaymentCurrency,
			   S.SalaryDaysNet
	   	
				) as H
				
		WHERE 1=1
		-- condition		
	</cfsavecontent>	
			  
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = "0">						
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Date",                  			
					field          = "PayrollEnd",	
					column         = "month", 		
					formatted      = "dateformat(PayrollEnd,CLIENT.DateFormatShow)",
					search         = "date"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Schedule",                   				
					field          = "SalaryScheduleDescription",
					filtermode     = "2",  
					search         = "text"}>										

<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Beneficiary",                   				
					field          = "FullName",
					functionscript = "EditPerson",
					functionfield  = "PersonNo",
					filtermode     = "2",  
					search         = "text"}>											
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Net Days",                    			
					field          = "SalaryDays"}>	
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "SLWOP",                    			
					field          = "SalarySLWOP"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Suspend",                    			
					field          = "SalarySuspend"}>																																

<cfset itm = itm+1>					
<cfset fields[itm] = {label        = "Currency",                    			
					field          = "PaymentCurrency"}>
							
<cfset itm = itm+1>														
<cfset fields[itm] = {label        = "Amount",    					
					field          = "PaymentAmount",
					align          = "right",
					aggregate      = "sum",					
					formatted      = "numberformat(PaymentAmount,',.__')"}>									
								
<cf_listing
    header        = "ls2Payroll"
    box           = "ls2Payroll_#url.positionNo#"
	link          = "#SESSION.root#/Staffing/Application/Position/Funding/PositionPayrollEntitlement.cfm?systemfunctionid=#url.systemfunctionid#&positionno=#url.positionno#"	
    html          = "No"
	show          = "100"
	datasource    = "AppsPayroll"
	listquery     = "#myquery#"	
	listorder     = "PayrollEnd"	
	listorderdir  = "DESC"	
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillkey      = "Id">


