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
<cfoutput>
<cfsavecontent variable="myquery">

  SELECT * 
  FROM (
		
		SELECT    newid() as MyId, Mission, OrgUnitName, PersonNo, IndexNo, FullName, 
		          PaymentDate, YearMonth,
		          ContractLevel, ContractStep, 
		          SalarySchedule,
		
		         (SELECT    TOP (1) SCL.Amount
		          FROM      SalaryScaleLine AS SCL INNER JOIN
		                    SalaryScale AS SC ON SCL.ScaleNo = SC.ScaleNo
		          WHERE        (SCL.SalarySchedule = B.SalarySchedule) AND (SCL.ServiceLevel = B.ContractLevel) AND (SCL.ServiceStep = B.ContractStep) 
		                     AND (SCL.ComponentName = 'Salario') AND (SalaryEffective <= B.PaymentDate)
		          ORDER BY SCL.ScaleNo DESC) AS SalaryBase, 
		
		          Days, SLWOP, Suspend,
		
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       (SalarySchedule = B.SalarySchedule) AND (PaymentDate = B.PaymentDate) AND (PayrollItem = 'A00')) AS SalaryMonth,
		
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       (SalarySchedule = B.SalarySchedule) AND (PaymentDate = B.PaymentDate) AND (PayrollItem IN ('A01','A15','A16'))) AS SalaryOther, 
		
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       (SalarySchedule = B.SalarySchedule) AND (PaymentDate = B.PaymentDate) AND (PayrollItem IN ('D01'))) AS SalaryIGSS, 
		
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       (SalarySchedule = B.SalarySchedule) AND (PaymentDate = B.PaymentDate) AND (PayrollItem IN ('D02'))) AS SalaryISR, 
		
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       SalarySchedule = B.SalarySchedule AND PaymentDate = B.PaymentDate AND PayrollItem IN ('D03','D04','D08','D10','D11','D12','D13','D14','D15','M02')) AS SalaryPrestamo, 
		
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       SalarySchedule = B.SalarySchedule AND PaymentDate = B.PaymentDate AND PayrollItem IN ('D01','D02','D03','D04','D08','D10','D11','D12','D13','D14','D15','M02')) AS SalaryDeduction, 
		
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       (SalarySchedule = B.SalarySchedule) AND (PaymentDate = B.PaymentDate) AND (PayrollItem IN ('A11'))) AS SalaryBono,
				   
		 (SELECT   SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       (SalarySchedule = B.SalarySchedule) AND (PaymentDate = B.PaymentDate) AND (PayrollItem IN ('M01'))) AS SalaryBonoAdditional, 
		
		           ROUND(SUM(PaymentAmount), 2) AS NetPayment,
		
		 (SELECT    SUM(PaymentAmount) AS Amount
		           FROM      vwPayroll
		           WHERE     (Mission = B.Mission) AND (PersonNo = B.PersonNo) 
		           AND       (SalarySchedule = B.SalarySchedule) AND (PaymentDate = B.PaymentDate) AND (PayrollItem LIKE 'C%')) AS SalaryContribution 
		
		FROM     vwPayroll AS B
		WHERE    (PayrollItemSource <> 'Contribution') 
		AND      PersonNo = '#url.Id#' 
		GROUP BY PersonNo, IndexNo, Mission, OrgUnitName, YearMonth, SalarySchedule, PaymentDate, FullName, Days, SLWOP, Suspend, ContractLevel, ContractStep

		) as D
		
		WHERE 1= 1
		--condition
</cfsavecontent>	
</cfoutput>


<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cfset itm = itm+1>								
<cf_tl id="Period" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
					width             = "0", 
					field             = "YearMonth",							
					filtermode        = "3",    
					search            = "text"}>						
				
<cfset itm = itm+1>		
<cf_tl id="Entity" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "Mission",
					filtermode        = "2",
					search            = "text"}>							
									
<cfset itm = itm+1>			
<cf_tl id="Level" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "ContractLevel",
					filtermode        = "2",
					search            = "text"}>				
					
<cfset itm = itm+1>								
<cf_tl id="SalarySchedule" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
					width             = "0", 
					field             = "SalarySchedule",							
					filtermode        = "3",    
					search            = "text"}>	
					
<cfset itm = itm+1>			
<cf_tl id="Days" var="1">
<cfset fields[itm] = {label           = "#lt_text#",
					width             = "0", 
					field             = "Days",
					align             = "right",
					aggregate         = "sum",					
					formatted         = "numberformat(Days,'__')"}>												
					
<cfset itm = itm+1>			
<cf_tl id="Salary" var="1">
<cfset fields[itm] = {label           = "#lt_text#",
					width             = "0", 
					field             = "SalaryMonth",
					align             = "right",
					aggregate         = "sum",					
					formatted         = "numberformat(SalaryMonth,'.__')"}>	
					
<cfset itm = itm+1>			
<cf_tl id="Other" var="1">
<cfset fields[itm] = {label           = "#lt_text#",
					width             = "0", 
					field             = "SalaryOther",
					align             = "right",
					aggregate         = "sum",					
					formatted         = "numberformat(SalaryOther,'.__')"}>											
					
<cfset itm = itm+1>			
<cf_tl id="Deduction" var="1">
<cfset fields[itm] = {label           = "#lt_text#",
					width             = "0", 
					field             = "SalaryDeduction",
					align             = "right",
					aggregate         = "sum",					
					formatted         = "numberformat(SalaryDeduction,'.__')"}>	
					
<cfset itm = itm+1>			
<cf_tl id="Bono" var="1">
<cfset fields[itm] = {label           = "#lt_text#",
					width             = "0", 
					field             = "SalaryBono",
					align             = "right",
					aggregate         = "sum",					
					formatted         = "numberformat(SalaryBono,'.__')"}>		
					
<cfset itm = itm+1>			
<cf_tl id="BonoA" var="1">
<cfset fields[itm] = {label           = "#lt_text#",
					width             = "0", 
					field             = "SalaryBonoAdditional",
					align             = "right",
					aggregate         = "sum",					
					formatted         = "numberformat(SalaryBonoAdditional,'.__')"}>	
					
<cfset itm = itm+1>			
<cf_tl id="Payment" var="1">
<cfset fields[itm] = {label           = "#lt_text#",
					width             = "0", 
					field             = "NetPayment",
					align             = "right",
					aggregate         = "sum",					
					formatted         = "numberformat(NetPayment,'.__')"}>						
										
		
    <cfset s = "Hide"> 
	<cfset f = "">
											
	<cf_listing
    	header        = "lsPayrollLocal"
    	box           = "lsPayrollLocal"
		link          = "#SESSION.root#/Staffing/Application/Employee/Payroll/LocalisedListingContent.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#"
		linkform      = "#f#"
    	html          = "No"
		show	      = "60"
		datasource    = "AppsPayroll"
		listquery     = "#myquery#"
		listkey       = "MyId"		
		listorder     = "YearMonth"		
		listorderdir  = "ASC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"		
		filterShow    = "#s#"
		excelShow     = "Yes">
		
		<!---drillmode     = "embed"	
		drillstring   = "mode=list"
		drilltemplate = "Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchHeader.cfm"
		drillkey      = "PurchaseNo"
		--->

