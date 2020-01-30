

<cfoutput> 

	<!--- 24/8/2017 contribution base can be different from financial base like in
	STL budget is prepared in EUR, but the base financial currency is USD, so
	we need a different conversion for execution --->

	<cfsavecontent variable="myquery">  
		
	   SELECT *
	   FROM (

		SELECT  
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
		AND    S.PositionNo = '#url.positionno#'
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
<cfset fields[itm] = {label      = "Date",                  			
					field        = "PayrollEnd",		
					formatted    = "dateformat(PayrollEnd,CLIENT.DateFormatShow)",
					search       = "date"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Schedule",                   				
					field        = "SalaryScheduleDescription",
					filtermode   = "2",  
					search       = "text"}>	
									

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Beneficiary",                   				
					field        = "FullName",
					functionscript = "EditPerson",
					functionfield = "PersonNo",
					filtermode   = "2",  
					search       = "text"}>											
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Net Days",                    			
					field        = "SalaryDaysNet",					
					searchalias  = "S"}>																					

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Currency",                    			
					field        = "PaymentCurrency",					
					searchalias  = "S"}>
							
<cfset itm = itm+1>														
<cfset fields[itm] = {label      = "Amount",    					
					field        = "PaymentAmount",
					align        = "right",
					aggregate    = "sum",					
					formatted    = "numberformat(PaymentAmount,',__.__')"}>		
							
	
<table width="100%" height="100%" align="center">
<tr>
<td valign="top" style="padding-left:10px;padding-right;10px;padding-bottom:10px">
									
<cf_listing
    header        = "ls2Payroll"
    box           = "ls2Payroll"
	link          = "#SESSION.root#/Staffing/Application/Position/Funding/PositionPayrollCosts.cfm?systemfunctionid=#url.systemfunctionid#&positionno=#url.positionno#"	
    html          = "No"
	show          = "30"
	datasource    = "AppsPayroll"
	listquery     = "#myquery#"	
	listorder     = "PayrollEnd"	
	listorderdir  = "DESC"
	listgroup     = "Period"
	listgroupdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes">

</td>
</tr>
</table>

