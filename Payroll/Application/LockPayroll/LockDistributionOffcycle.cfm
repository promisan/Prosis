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

<!--- -------------------------------------------------------------- --->
<!--- ----------------staff settlement distribution----------------- --->
<!--- -------------------------------------------------------------- --->
<cfparam name="url.personno" default="0">
<!--- percentage based --->	 
 
<cfquery name="DeleteSettlementDistribution" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	DELETE FROM  Payroll.dbo.EmployeeSettlementDistribution
   	WHERE     Mission         = '#Period.Mission#' 
    AND       SalarySchedule  = '#Period.SalarySchedule#' 
	AND       PaymentDate     IN (
					 			  SELECT     PaymentDate
							      FROM       Payroll.dbo.EmployeeSettlement ES
								  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)
	)
	AND       SettlementPhase = 'Final'
	AND 	  PersonNo 		  = '#url.personno#'

</cfquery>	

<cfquery name="getSettleDistPercentage" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT     S.PersonNo, 
		           S.Mission, 
				   S.SalarySchedule, 
				   S.PaymentDate, 
				   S.SettlementPhase, 
				   D.AccountId, 
				   D.PaymentMode, 
				   D.DistributionCurrency,							   
				   S.Currency, 
	               ROUND(S.Amount * (D.DistributionNumber / 100), 2) AS Amount							   			   
				   
		FROM       Payroll.dbo.PersonDistribution D INNER JOIN
	               
				          (SELECT     PersonNo, MAX(DateEffective) AS LastDate
	                       FROM       Payroll.dbo.PersonDistribution
	                       WHERE      DateEffective <= (
						   	SELECT     MIN(PaymentDate)
							      FROM       Payroll.dbo.EmployeeSettlement ES
								  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)
						   )
	                       AND		  PersonNo = '#url.personno#'
	                       GROUP BY   PersonNo) L ON D.PersonNo = L.PersonNo AND D.DateEffective = L.LastDate 
								
							INNER JOIN
								
	                          (SELECT     S.Mission, S.SalarySchedule, ES.PaymentDate, SettlementPhase, S.PersonNo, Currency, SUM(PaymentAmount) AS Amount
	                            FROM      Payroll.dbo.EmployeeSettlementLine S 
	                            			INNER JOIN Payroll.dbo.EmployeeSettlement as ES
							 					ON S.PErsonNo = ES.PersonNo
							 					AND S.SalarySchedule = ES.SalarySchedule
							 					AND S.Mission = ES.Mission
							 					AND S.PaymentDate = ES.PaymentDate
	                            			INNER JOIN 
								          Payroll.dbo.Ref_PayrollItem P ON S.PayrollItem    = P.PayrollItem
								
	                            WHERE     S.Mission          = '#Period.Mission#' 
								AND       S.SalarySchedule   = '#Period.SalarySchedule#' 
								AND       ES.PaymentDate       IN (SELECT     PaymentDate
							      FROM       Payroll.dbo.EmployeeSettlement ES
								  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#))
								AND       S.SettlementPhase  = '#RefNo#'
								AND 	  S.PersonNo 		   = '#url.personno#'
								AND       P.PrintGroup IN (SELECT PrintGroup 
									                       FROM   Payroll.dbo.Ref_SlipGroup 
														   WHERE  NetPayment = 1)
	                            GROUP BY  S.Mission, 
								          S.SalarySchedule, 
										  ES.PaymentDate, 
										  S.SettlementPhase, 
										  S.PersonNo, 
										  Currency) S ON D.PersonNo = S.PersonNo
										  
		WHERE      D.DistributionMethod = 'Percentage' 
	
</cfquery>

<cfoutput query="getSettleDistPercentage">
				
	<cf_ExchangeRate 
	     Datasource="AppsOrganization" 
		 CurrencyFrom="#Currency#" 
		 CurrencyTo="#DistributionCurrency#" 
		 EffectiveDate="#dateFormat(PaymentDate, client.DateFormatShow)#">					 
	
	<cfset vAmountToPost = round((Amount / exc)*100)/100>
		
	<!--- obtain distribution --->
	
	<cfif accountid neq "">
	
		<cfquery name="getPayThrough" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 B.BankId, 
			         B.BankName, 
					 B.AccountNo, 
					 R.GLAccount, 
					 AM.PersonNo, 
					 AM.AccountId, 
					 AM.Mission
			FROM     Accounting.dbo.Ref_BankAccount AS B INNER JOIN
	                 Accounting.dbo.Ref_Account AS R ON B.BankId = R.BankId INNER JOIN
	                 Payroll.dbo.PersonAccountMission AS AM ON B.BankId = AM.BankId
			WHERE    AM.PersonNo  = '#personno#' 
			AND      AM.AccountId = '#accountid#' 
			AND      AM.Mission   = '#Period.Mission#'
			
		</cfquery>
	
		<cfif getPayThrough.recordcount gte "1">					
	
			<cfquery name="InsertSettlementDistribution" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				INSERT INTO Payroll.dbo.EmployeeSettlementDistribution 
				
				           (PersonNo, 
						    Mission, 
							SalarySchedule, 
							PaymentDate, 
							SettlementPhase, 
							AccountId, 
							SalaryScheduleDistribution,
							SalaryScheduleCurrency, 
							SalaryScheduleGLAccount,
							PayThroughBankName,
							PayThroughGLAccount,
							PaymentExchangeRate, PaymentMode, PaymentCurrency, PaymentAmount, PaymentStatus,
							OfficerUserId, OfficerLastName, OfficerFirstName)
				 	
				VALUES   (	'#PersonNo#',
							'#Mission#',
							'#SalarySchedule#',
							'#getSettleDistPercentage.PaymentDate#',
							'#SettlementPhase#',
							'#AccountId#',
							'#SalarySchedule#',
							'#Currency#',
							'#Period.GLAccount#',
							'#getPayThrough.BankName#',
							'#getPayThrough.GLAccount#',									
							'#exc#',
							'#PaymentMode#',
							'#DistributionCurrency#',
							'#vAmountToPost#',
							'#url.typeCycle#',
							'#session.acc#',
						   	'#session.last#',
						   	'#session.first#' )					  
					
			</cfquery>
			
		</cfif>	
		
	<cfelse>
	
		<cfquery name="InsertSettlementDistribution" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				INSERT INTO Payroll.dbo.EmployeeSettlementDistribution 
				
				           (PersonNo, 
						    Mission, 
							SalarySchedule, 
							PaymentDate, 
							SettlementPhase, 
							-- AccountId, 
							SalaryScheduleDistribution,
							SalaryScheduleCurrency, 
							SalaryScheduleGLAccount,
							-- PayThroughBankName,
							PayThroughGLAccount,
							PaymentExchangeRate, PaymentMode, PaymentCurrency, PaymentAmount, PaymentStatus,
							OfficerUserId, OfficerLastName, OfficerFirstName)
				 	
				VALUES   (	'#PersonNo#',
							'#Mission#',
							'#SalarySchedule#',
							'#PaymentDate#',
							'#SettlementPhase#',
							-- '#AccountId#',
							'#SalarySchedule#',
							'#Currency#',
							'#Period.GLAccount#',
							-- '#getPayThrough.BankName#',
							'#Period.GLAccountDistribution#',									
							'#exc#',
							'#PaymentMode#',
							'#DistributionCurrency#',
							'#vAmountToPost#',
							'#url.typeCycle#',
							'#session.acc#',
						   	'#session.last#',
						   	'#session.first#' )					  
					
			</cfquery>
	
	</cfif>	
	
</cfoutput>
 
 <!--- -------------------------------------------------------------- --->	 
 <!--- --------2 of 2 amount based distribution : pending 22/7------- --->
 <!--- -------------------------------------------------------------- --->

<cfquery name="getSettleDistAmount" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 	
	SELECT     S.PersonNo, 
	           S.Mission, 
			   S.SalarySchedule, 
			   S.PaymentDate, 
			   S.SettlementPhase, 
			   D.AccountId, 
			   D.PaymentMode,
			   D.DistributionCurrency, 
			   S.Currency, 
			   S.Amount,						  
			   D.DistributionNumber				   	   
			   
	FROM       Payroll.dbo.PersonDistribution D INNER JOIN
               
			          (SELECT    PersonNo, MAX(DateEffective) AS LastDate
                       FROM      Payroll.dbo.PersonDistribution
                       WHERE     DateEffective <= (SELECT     MIN(PaymentDate)
							      FROM       Payroll.dbo.EmployeeSettlement ES
								  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#))
                       AND       PersonNo = '#url.personno#'
                       GROUP BY  PersonNo) L ON D.PersonNo = L.PersonNo AND D.DateEffective = L.LastDate 
							
					   INNER JOIN
							
                          (SELECT     S.Mission, 
						              S.SalarySchedule, 
									  ES.PaymentDate, 
									  SettlementPhase, 
									  S.PersonNo, 
									  Currency,
									  SUM(PaymentAmount) AS Amount
									  
                            FROM      Payroll.dbo.EmployeeSettlementLine S 
                            		INNER JOIN Payroll.dbo.EmployeeSettlement as ES
							 					ON S.PErsonNo = ES.PersonNo
							 					AND S.SalarySchedule = ES.SalarySchedule
							 					AND S.Mission = ES.Mission
							 					AND S.PaymentDate = ES.PaymentDate

                            		INNER JOIN 
							          Payroll.dbo.Ref_PayrollItem P ON S.PayrollItem    = P.PayrollItem
							
                            WHERE     S.Mission          = '#Period.Mission#' 
							AND       S.SalarySchedule   = '#Period.SalarySchedule#' 
							AND       ES.PaymentDate      IN (SELECT     PaymentDate
							      FROM       Payroll.dbo.EmployeeSettlement ES
								  WHERE      SettlementId IN (#preserveSingleQuotes(Settlements)#)) 
							AND       S.SettlementPhase  = 'Final'
							AND       S.personno         = '#url.personno#'
							AND       P.PrintGroup IN (SELECT PrintGroup 
								                       FROM   Payroll.dbo.Ref_SlipGroup 
													   WHERE  NetPayment = 1)
                            GROUP BY  S.Mission, 
							          S.SalarySchedule, 
									  ES.PaymentDate, 
									  S.SettlementPhase, 
									  S.PersonNo, 
									  S.Currency) S ON D.PersonNo = S.PersonNo
									  
	WHERE      	D.DistributionMethod = 'Amount'		
	ORDER BY 	S.PersonNo, D.distributionOrder ASC						  

</cfquery>

<cfif getSettleDistAmount.recordCount gt 0>

	 <cfoutput query="getSettleDistAmount" group="PersonNo">

	 	<cfset vSettleDistPending = Amount>
		
		<cfset vsign= 1>
		<cfif Amount lt 0>
			<cfset vsign = -1>
			<cfset vSettleDistPending = vSettleDistPending * -1>
		</cfif>

	 	<cfoutput>
	 						
			<cf_ExchangeRate 
			      Datasource    = "AppsOrganization"
			      CurrencyFrom  = "#DistributionCurrency#" 
				  CurrencyTo    = "#Currency#" 
				  EffectiveDate = "#dateFormat(PaymentDate, client.DateFormatShow)#">
							
		 	<cfset vSettleDistToPay = round(DistributionNumber/exc*100)/100>
		 	<cfif (round(vSettleDistPending*100)/100) lte vSettleDistToPay>				
				<cfset vSettleDistToPay = round(vSettleDistPending*100)/100>
		 	</cfif>

		 	<cfset vSettleDistPending = vSettleDistPending - vSettleDistToPay>

		 	<cfif vSettleDistToPay gt 0>

				<cf_ExchangeRate 
				      Datasource     = "AppsOrganization"
				      CurrencyFrom   = "#Currency#" 
					  CurrencyTo     = "#DistributionCurrency#" 
					  EffectiveDate  = "#dateFormat(PaymentDate, client.DateFormatShow)#">
				
				<cfset vAmountToPost = round((vSettleDistToPay / exc)*100)/100>
											
						<cfif accountid neq "">
					
						<cfquery name="getPayThrough" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   TOP 1 B.BankId, 
							         B.BankName, 
									 B.AccountNo, 
									 R.GLAccount, 
									 AM.PersonNo, 
									 AM.AccountId, 
									 AM.Mission
							FROM     Accounting.dbo.Ref_BankAccount AS B INNER JOIN
					                 Accounting.dbo.Ref_Account AS R ON B.BankId = R.BankId INNER JOIN
					                 Payroll.dbo.PersonAccountMission AS AM ON B.BankId = AM.BankId
							WHERE    AM.PersonNo  = '#personno#' 
							AND      AM.AccountId = '#accountid#' 
							AND      AM.Mission   = '#Period.Mission#'
							
						</cfquery>
					
						<cfif getPayThrough.recordcount gte "1">					
					
							<cfquery name="InsertSettlementDistribution" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
								INSERT INTO Payroll.dbo.EmployeeSettlementDistribution 
								
								           (PersonNo, 
										    Mission, 
											SalarySchedule, 
											PaymentDate, 
											SettlementPhase, 
											AccountId, 
											SalaryScheduleDistribution,
											SalaryScheduleCurrency, 
											SalaryScheduleGLAccount,
											PayThroughBankName,
											PayThroughGLAccount,
											PaymentExchangeRate, PaymentMode, PaymentCurrency, PaymentAmount, PaymentStatus,
											OfficerUserId, OfficerLastName, OfficerFirstName)
								 	
								VALUES   (	'#PersonNo#',
											'#Mission#',
											'#SalarySchedule#',
											'#getSettleDistAmount.PaymentDate#',
											'#SettlementPhase#',
											'#AccountId#',
											'#SalarySchedule#',
											'#Currency#',
											'#Period.GLAccount#',
											'#getPayThrough.BankName#',
											'#getPayThrough.GLAccount#',									
											'#exc#',
											'#PaymentMode#',
											'#DistributionCurrency#',
											'#vAmountToPost * vsign#',
											'#url.typeCycle#',
											'#session.acc#',
										   	'#session.last#',
										   	'#session.first#' )					  
									
							</cfquery>
							
						</cfif>	
						
					<cfelse>
					
						<cfquery name="InsertSettlementDistribution" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
								INSERT INTO Payroll.dbo.EmployeeSettlementDistribution 
								
								           (PersonNo, 
										    Mission, 
											SalarySchedule, 
											PaymentDate, 
											SettlementPhase, 
											-- AccountId, 
											SalaryScheduleCurrency, 
											SalaryScheduleGLAccount,
											-- PayThroughBankName,
											PayThroughGLAccount,
											PaymentExchangeRate, PaymentMode, PaymentCurrency, PaymentAmount, PaymentStatus,
											OfficerUserId, OfficerLastName, OfficerFirstName)
								 	
								VALUES   (	'#PersonNo#',
											'#Mission#',
											'#SalarySchedule#',
											'#PaymentDate#',
											'#SettlementPhase#',
											-- '#AccountId#',
											'#Currency#',
											'#Period.GLAccount#',
											-- '#getPayThrough.BankName#',
											'#Period.GLAccountDistribution#',									
											'#exc#',
											'#PaymentMode#',
											'#DistributionCurrency#',
											'#vAmountToPost#',
											'#url.typeCycle#',
											'#session.acc#',
										   	'#session.last#',
										   	'#session.first#' )					  
									
							</cfquery>
					
					</cfif>
									
			</cfif>	

		</cfoutput>

	 </cfoutput>

 </cfif>
