<cfparam name="calcprocessmode" default="entitlement">

	<CF_DropTable dbName = "AppsTransaction" 
	              tblName= "sal#SESSION.thisprocess#CalculationBase#Code#">		  

	<cfquery name="baseamount" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
					
		SELECT   PersonNo, 
		         PayrollCalcNo, 
				 ROUND(SUM(AmountCalculationFull),3) AS AmountCalculationFull,
				 ROUND(SUM(AmountCalculationDays),3) AS AmountCalculationDays,	
				 ROUND(SUM(AmountCalculationBase),3) AS AmountCalculationBase,	
				 ROUND(SUM(AmountCalculationWork),3) AS AmountCalculationWork,		
				 ROUND(SUM(AmountCalculation),3)     AS AmountCalculation
		
		INTO     userTransaction.dbo.sal#SESSION.thisprocess#CalculationBase#code#
		
		FROM    (
		
				SELECT   PersonNo, 
				         PayrollCalcNo, 
						 
						 AmountCalculationFull,		
						 AmountCalculationDays,
						 AmountCalculationBase,
						 AmountCalculationWork,
						 						 
						 <cfif BaseAmount eq "1">
							AmountCalculationFull AS AmountCalculation
						 <cfelseif BaseAmount eq "3">
						  	AmountCalculationDays AS AmountCalculation
						 <cfelseif BaseAmount eq "2">	
							AmountCalculationBase AS AmountCalculation 
						 <cfelseif BaseAmount eq "0">							 
							AmountCalculationWork AS AmountCalculation 						
						 </cfif>							 						 
										
				FROM     EmployeeSalaryLine L
				
				WHERE    PayrollItem IN (SELECT PayrollItem 
				                         FROM   Ref_CalculationBaseItem 
										 WHERE  Code           = '#Code#'
										 AND    SalarySchedule = '#mySchedule#') 
										  
				AND      PayrollStart = #SALSTR#
				<cfif Form.PersonNo neq "">
			    AND      PersonNo = '#Form.PersonNo#'
				<cfelse>
			    AND      PersonNo NOT IN (#preservesingleQuotes(selper)#)	   
				</cfif>
				<!--- reset by Hanno 11/12 -as it had -- in front to disable it
				 for unknwon reasons when i checked this but maybe for SPA --->
				 
				 <cfif calcprocessmode neq "overtime">
		 		 AND      SalarySchedule IN 	(			
				
									SELECT DISTINCT SalarySchedule
									FROM            userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
									WHERE           PersonNo =  L.PersonNo )			
				</cfif>
								
				<!--- we include calculations already made for percentage based items, 
				which are included in the base --->
				
				<cfif orderprocess eq "1">
				
					UNION ALL
					
					SELECT   PersonNo, 
						 	 Line,
							 
							 AmountCalculationFull * percentage/100,		
						 	 AmountCalculationDays * percentage/100,
							 AmountCalculationBase * percentage/100, 
							 AmountCalculationWork * percentage/100,
							 
							 <cfif BaseAmount eq "1">
								EntitlementAmountFull AS AmountCalculation
							 <cfelseif BaseAmount eq "3">	
							 	EntitlementAmountDays AS AmountCalculation 	 
							 <cfelseif BaseAmount eq "2">	
							 	EntitlementAmountBase AS AmountCalculation 					
							 <cfelseif BaseAmount eq "0">
								EntitlementAmountWork AS AmountCalculation							 				
							 </cfif>							 		
																					 
					FROM     userTransaction.dbo.sal#SESSION.thisprocess#EntitlementRatePercentage
				
					WHERE    PayrollItem IN (SELECT PayrollItem 
					                        FROM   Ref_CalculationBaseItem 
									        WHERE  Code           = '#Code#'
										    AND    SalarySchedule = '#mySchedule#') 																						  
					
				</cfif>
				
				) as Derrived
		
		GROUP BY PersonNo, PayrollCalcNo
		
		
										
	</cfquery>