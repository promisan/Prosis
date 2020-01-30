
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

	
	<cfsavecontent variable="mysettlement">  
		
	   SELECT *
	   FROM (
	   
	   SELECT      S.PersonNo, 
	               P.Indexno,
				   P.FullName,				 
	               S.Mission, 
				   
				   CAST(SL.PaymentYear as varchar)+'/'+(CASE WHEN LEN(CAST(SL.PaymentMonth as VARCHAR)) = 1 THEN '0'+CAST(SL.PaymentMonth as VARCHAR) ELSE CAST(SL.PaymentMonth as VARCHAR) END) as Period,
				   	   
				   S.PaymentDate, 
				   S.SalarySchedule, 
				   S.PaymentFinal, 
				   SL.PaymentId,
				   S.PaymentStatus,
				   SL.SettlementPhase, 
				   SL.PayrollItem, 
				   SL.GLAccount,
				   SL.GLAccountLiability,
                   I.PayrollItemName, 
				   SL.DocumentCurrency, 
				   SL.Amount / SL.DocumentExchangeRate AS DocumentAmount, 
				   SL.Journal, 
				   SL.JournalSerialNo,
				   
				   (SELECT Transactionid
				    FROM   Accounting.dbo.TransactionHeader
					WHERE  Journal = SL.Journal
					AND    JournalSerialNo = SL.JournalSerialNo) as TransactionId
				   
		FROM        EmployeeSettlementLine AS SL INNER JOIN
                    EmployeeSettlement AS S ON SL.PersonNo = S.PersonNo AND SL.SalarySchedule = S.SalarySchedule AND SL.Mission = S.Mission AND SL.PaymentDate = S.PaymentDate INNER JOIN
                    Ref_PayrollItem AS I ON SL.PayrollItem = I.PayrollItem INNER JOIN 
					Employee.dbo.Person P ON P.Personno = SL.PersonNo
						 
		WHERE       SL.PositionParentId = '#Position.PositionParentId#'
		AND         I.Source != 'Deduction'
		AND         EXISTS (SELECT 'X' 
		                    FROM   SalarySchedulePeriod 
		                    WHERE  Mission        = SL.Mission 
							AND    SalarySchedule = SL.SalarySchedule
							AND    PayrollEnd     = SL.PaymentDate
							AND    CalculationStatus IN ('1','2','3'))
		-- AND         SL.Journal is not NULL
	   	
				) as H
				
		WHERE 1=1
		-- condition		
	</cfsavecontent>	
		  
</cfoutput>


<cfset fields=ArrayNew(1)>

<cfset itm = "0">
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Period",                  			
					field        = "Period",	
					filtermode   = "2", 							 
					search       = "text"}>							
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Date",                  			
					field        = "PaymentDate",		
					formatted    = "dateformat(PaymentDate,CLIENT.DateFormatShow)"}>		
					
												
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "S",                   				
                    labelfilter  = "Status", 
					field        = "PaymentStatus",
					filtermode   = "2",  
					search       = "text"}>	
										
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Schedule",                   				
					field        = "SalarySchedule",
					filtermode   = "2",  
					search       = "text"}>	
									
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Item",                    			
					field        = "PayrollItemName",
					filtermode   = "2",  
					searchalias  = "H",
					searchfield  = "PayrollItemName",
					search       = "text"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Debit",                    			
					field        = "GLAccount",
					filtermode   = "2",  					
					search       = "text"}>		
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Credit",                    			
					field        = "GLAccountLiability",
					filtermode   = "2",  					
					search       = "text"}>												
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Beneficiary",                   				
					field        = "FullName",
					functionscript = "EditPerson",
					functionfield = "PersonNo",
					filtermode   = "2",  
					search       = "text"}>	

<!---					
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Journal",                     				
					field        = "Journal",		
					alias        = "H",
					searchalias  = "H",	
					filtermode   = "2",  										
					search       = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "SerialNo",                   
					field        = "JournalSerialNo",			
					alias        = "H",
					searchalias  = "H"}>										
					
--->
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Currency",                    			
					field        = "DocumentCurrency",					
					searchalias  = "H"}>																					
							
<cfset itm = itm+1>														
<cfset fields[itm] = {label      = "Amount",    					
					field        = "DocumentAmount",
					align        = "right",
					aggregate    = "sum",					
					formatted    = "numberformat(DocumentAmount,',__.__')"}>		
							
	
<table width="100%" height="100%" align="center">
<tr>
<td valign="top" style="padding-left:10px;padding-right;10px;padding-bottom:10px">
									
<cf_listing
    header        = "lsPayroll"
    box           = "lsPayroll"
	link          = "#SESSION.root#/Staffing/Application/Position/Funding/PositionPayrollSettlement.cfm?systemfunctionid=#url.systemfunctionid#&positionno=#url.positionno#"	
    html          = "No"
	show          = "30"
	datasource    = "AppsPayroll"
	listquery     = "#mysettlement#"	
	listkey       = "PaymentId"		
	listorder     = "PaymentDate"	
	listorderdir  = "DESC"
	listgroup     = "Period"
	listgroupdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	annotation    = "GLTransaction"
	drillmode     = "window"	
	drillargument = "930;1300;false;false"
	drilltemplate = "Gledger/Application/Transaction/View/TransactionViewDetail.cfm?id="
	drillkey      = "TransactionId">

</td>
</tr>
</table>

