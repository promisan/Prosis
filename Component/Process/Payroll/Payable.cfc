
<!---  Name: /Component/Process/Procurement/PurchaseLine.cfc
       Description: Purchase Line procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Payroll Routines">
	
	<cffunction name="setDistribution"
             access="public"
             returntype="string"
             displayname="setDistribution">
		
		<cfargument name="Mission"         type="string" required="true"   default="">	
		<cfargument name="SalarySchedule"  type="string" required="false"  default="">	
		<cfargument name="PaymentDate"     type="string" required="true"   default="">	
		<cfargument name="PaymentStatus"   type="string" required="true"   default="0">	
		<cfargument name="SettlementPhase" type="string" required="true"   default="final">	
		<cfargument name="PersonNo"        type="string" required="true"   default="">	
		
		<cfquery name="Period" 
		    datasource="appsOrganization"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Payroll.dbo.SalaryScheduleMission P
			WHERE    P.Mission        = '#Mission#'	
			AND      P.SalarySchedule = '#SalarySchedule#'
			AND      P.GLAccount IN (SELECT GLAccount
			                         FROM   Accounting.dbo.Ref_Account 
									 WHERE  GLAccount = P.GLAccount) 
		</cfquery>
								
		<!--- -------------------------------------------------------------- --->
		<!--- ----------------staff settlement distribution----------------- --->
		<!--- -------------------------------------------------------------- --->
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#PaymentDate#">
		<cfset DTE = dateValue>
				 
		<cfquery name="DeleteSettlementDistribution" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			DELETE FROM  Payroll.dbo.EmployeeSettlementDistribution
		   	WHERE     Mission         = '#Mission#' 
		    AND       SalarySchedule  = '#SalarySchedule#' 
			AND       PaymentDate     = #DTE#
			AND       PaymentStatus   = '#PaymentStatus#'
			AND       SettlementPhase = '#SettlementPhase#'
			<cfif personNo neq "">
			AND 	  PersonNo 		  = '#personno#'
			</cfif>
		
		</cfquery>	
		
		<!--- percentage based --->		 
		
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
			                       WHERE      DateEffective <= #DTE#
			                       GROUP BY   PersonNo) L ON D.PersonNo = L.PersonNo AND D.DateEffective = L.LastDate 
										
									INNER JOIN
										
			                          (SELECT     Mission, SalarySchedule, PaymentDate, PaymentStatus, SettlementPhase, PersonNo, Currency, SUM(PaymentAmount) AS Amount
			                            FROM      Payroll.dbo.EmployeeSettlementLine S INNER JOIN 
										          Payroll.dbo.Ref_PayrollItem P ON S.PayrollItem    = P.PayrollItem
										
			                            WHERE     Mission          = '#Mission#' 
										AND       SalarySchedule   = '#SalarySchedule#' 
										AND       PaymentDate      = #DTE# 
										AND       PaymentStatus    = '#PaymentStatus#'
										AND       SettlementPhase  = '#SettlementPhase#'
										AND       P.PrintGroup IN (SELECT PrintGroup 
											                       FROM   Payroll.dbo.Ref_SlipGroup 
																   WHERE  NetPayment = 1)
			                            GROUP BY  Mission, 
										          SalarySchedule, 
												  PaymentDate, 
												  PaymentStatus,
												  SettlementPhase, 
												  PersonNo, 
												  Currency) S ON D.PersonNo = S.PersonNo
												  
				WHERE      D.DistributionMethod = 'Percentage' 
				
				<cfif personNo neq "">
				AND 	  D.PersonNo 		  = '#personno#'
				</cfif>
				
			
		</cfquery>
		
		<cfloop query="getSettleDistPercentage">
						
			<cf_ExchangeRate 
			     Datasource="AppsOrganization" 
				 CurrencyFrom="#Currency#" 
				 CurrencyTo="#DistributionCurrency#" 
				 EffectiveDate="#dateFormat(PaymentDate, client.DateFormatShow)#">					 
			
			<cfset vAmountToPost        = round((Amount / exc)*100)/100>
			<cfset vAmountToPostControl = round((Amount / exc)*100000)/100000>
				
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
					WHERE    AM.PersonNo  = '#getSettleDistPercentage.personno#' 
					AND      AM.AccountId = '#accountid#' 
					AND      AM.Mission   = '#Mission#'
					
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
									PaymentStatus,
									SettlementPhase, 
									AccountId, 
									SalaryScheduleDistribution,
									SalaryScheduleCurrency, 
									SalaryScheduleGLAccount,
									PayThroughBankName,
									PayThroughGLAccount,
									PaymentExchangeRate, PaymentMode, PaymentCurrency, PaymentAmount, PaymentControlAmount, 
									OfficerUserId, OfficerLastName, OfficerFirstName)
						 	
						VALUES   (	'#getSettleDistPercentage.PersonNo#',
									'#Mission#',
									'#SalarySchedule#',
									#DTE#,
									'#PaymentStatus#',
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
									'#vAmountToPostControl#',
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
									PaymentStatus,
									SettlementPhase, 
									-- AccountId, 
									SalaryScheduleDistribution,
									SalaryScheduleCurrency, 
									SalaryScheduleGLAccount,
									-- PayThroughBankName,
									PayThroughGLAccount,
									PaymentExchangeRate, PaymentMode, PaymentCurrency, PaymentAmount, PaymentControlAmount, 
									OfficerUserId, OfficerLastName, OfficerFirstName)
						 	
						VALUES   (	'#getSettleDistPercentage.PersonNo#',
									'#Mission#',
									'#SalarySchedule#',
									#DTE#,
									'#PaymentStatus#',
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
									'#vAmountToPostControl#',
									'#session.acc#',
								   	'#session.last#',
								   	'#session.first#' )					  
							
					</cfquery>
			
			</cfif>	
			
		</cfloop>
		
		
		 
		 <!--- -------------------------------------------------------------- --->	 
		 <!--- -------- 2 of 2 amount based distribution -------------------- --->
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
		                       WHERE     DateEffective <= #DTE#
		                       GROUP BY  PersonNo) L ON D.PersonNo = L.PersonNo AND D.DateEffective = L.LastDate 
									
							   INNER JOIN
									
		                          (SELECT     Mission, 
								              SalarySchedule, 
											  PaymentDate, 
											  PaymentStatus,
											  SettlementPhase, 
											  PersonNo, 
											  Currency,
											  SUM(PaymentAmount) AS Amount
											  
		                            FROM      Payroll.dbo.EmployeeSettlementLine S INNER JOIN 
									          Payroll.dbo.Ref_PayrollItem P ON S.PayrollItem    = P.PayrollItem
									
		                            WHERE     Mission          = '#Mission#' 
									AND       SalarySchedule   = '#SalarySchedule#' 
									AND       PaymentDate      = #DTE# 
									AND       SettlementPhase  = '#SettlementPhase#'
									AND       PaymentStatus    = '#PaymentStatus#'
									
									AND       P.PrintGroup IN (SELECT PrintGroup 
										                       FROM   Payroll.dbo.Ref_SlipGroup 
															   WHERE  NetPayment = 1)
		                            GROUP BY  Mission, 
									          SalarySchedule, 
											  PaymentDate, 
											  PaymentStatus,
											  SettlementPhase, 											  
											  PersonNo, 
											  Currency) S ON D.PersonNo = S.PersonNo
											  
			WHERE      	D.DistributionMethod = 'Amount'		
			<cfif personNo neq "">
				AND 	  D.PersonNo 		  = '#personno#'
			</cfif>
			
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
									
				 	<cfset vSettleDistToPay = round(DistributionNumber/exc*100000)/100000>
				 	<cfif (round(vSettleDistPending*100000)/100000) lte vSettleDistToPay>				
						<cfset vSettleDistToPay = round(vSettleDistPending*100000)/100000>
				 	</cfif>
		
				 	<cfset vSettleDistPending = vSettleDistPending - vSettleDistToPay>
		
				 	<cfif vSettleDistToPay gt 0>
		
						<cf_ExchangeRate 
						      Datasource     = "AppsOrganization"
						      CurrencyFrom   = "#Currency#" 
							  CurrencyTo     = "#DistributionCurrency#" 
							  EffectiveDate  = "#dateFormat(PaymentDate, client.DateFormatShow)#">
						
						<cfset vAmountToPost = round((vSettleDistToPay / exc)*100)/100>
						<cfset vAmountToPostControl = round((vSettleDistToPay / exc)*100000)/100000>
													
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
									WHERE    AM.PersonNo  = '#getSettleDistAmount.personno#' 
									AND      AM.AccountId = '#accountid#' 
									AND      AM.Mission   = '#Mission#'
									
									
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
													PaymentStatus,
													SettlementPhase, 
													AccountId, 
													SalaryScheduleDistribution,
													SalaryScheduleCurrency, 
													SalaryScheduleGLAccount,
													PayThroughBankName,
													PayThroughGLAccount,
													PaymentExchangeRate, PaymentMode, PaymentCurrency, 
													PaymentAmount, PaymentControlAmount,
													OfficerUserId, OfficerLastName, OfficerFirstName)
										 	
										VALUES   (	'#getSettleDistAmount.PersonNo#',
													'#Mission#',
													'#SalarySchedule#',
													#DTE#,
													'#PaymentStatus#',
													'#SettlementPhase#',
													'#AccountId#',
													'#SalarySchedule#',
													'#Currency#',
													'#Period.GLAccount#',
													'#getPayThrough.BankName#',
													'#getPayThrough.GLAccount#',									
													'#exc#','#PaymentMode#','#DistributionCurrency#',
													'#vAmountToPost * vsign#','#vAmountToPostControl#',
													'#session.acc#','#session.last#','#session.first#' )					  
											
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
													PaymentStatus,
													SettlementPhase, 
													<!--- AccountId, --->
													SalaryScheduleDistribution,
													SalaryScheduleCurrency, 
													SalaryScheduleGLAccount,
													<!--- PayThroughBankName, --->
													PayThroughGLAccount,
													PaymentExchangeRate, PaymentMode, PaymentCurrency, PaymentAmount, PaymentControlAmount,
													OfficerUserId, OfficerLastName, OfficerFirstName)
										 	
										VALUES   (	'#getSettleDistAmount.PersonNo#',
													'#Mission#',
													'#SalarySchedule#',
													#DTE#,
													'#PaymentStatus#',
													'#SettlementPhase#',
													<!--- '#AccountId#', --->
													'#SalarySchedule#',
													'#Currency#',
													'#Period.GLAccount#',
													<!--- '#getPayThrough.BankName#', --->
													'#Period.GLAccountDistribution#',									
													'#exc#',
													'#PaymentMode#',
													'#DistributionCurrency#',
													'#vAmountToPost#','#vAmountToPostControl#',
													'#session.acc#',
												   	'#session.last#',
												   	'#session.first#' )					  
											
									</cfquery>
							
							</cfif>
											
					</cfif>	
		
				</cfoutput>
		
			 </cfoutput>
		
		 </cfif>
		 
		 <!--- new  the salaryscheduledistribution if this is different in the settlement record --->
		 
		 <cfquery name="setSettlementDistribution" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		 
				UPDATE  Payroll.dbo.EmployeeSettlementDistribution
				SET     SalaryScheduleDistribution = ES.SettlementSchedule
				FROM    Payroll.dbo.EmployeeSettlementDistribution AS ESD INNER JOIN
	                    Payroll.dbo.EmployeeSettlement AS ES ON ESD.PersonNo = ES.PersonNo AND ESD.SalarySchedule = ES.SalarySchedule AND ESD.Mission = ES.Mission AND 
	                    ESD.PaymentDate = ES.PaymentDate AND ESD.PaymentStatus = ES.PaymentStatus 
						AND ESD.SalarySchedule <> ES.SettlementSchedule
				WHERE   ESD.Mission     = '#Mission#' 
				AND     ESD.PaymentDate = #DTE#
		 </cfquery>	
		 
   </cffunction>		
   
   
   <cffunction name="setFunding"
             access="public"
             returntype="string"
             displayname="setFunding">
		
		<cfargument name="AMission"         type="string" required="true"   default="">	
		<cfargument name="ASalarySchedule"  type="string" required="false"  default="">	
		<cfargument name="APaymentDate"     type="string" required="true"   default="">	
		<cfargument name="APaymentStatus"   type="string" required="true"   default="0">	
		<cfargument name="ASettlementPhase" type="string" required="true"   default="final">	
		<cfargument name="APersonNo"        type="string" required="true"   default="">	
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#PaymentDate#">
		<cfset DTE = dateValue>
		
		<cfquery name="DeleteSettlementFunding" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			DELETE 
			FROM   Payroll.dbo.EmployeeSettlementLineFunding
			WHERE  PaymentId IN (SELECT PaymentId 
			                     FROM   Payroll.dbo.EmployeeSettlementLine as ESLL
			                     		INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
											ON 	ESLL.PersonNo 				= ESET.PersonNo
											AND ESLL.SalarySchedule 		= ESET.SalarySchedule
											AND ESLL.Mission 				= ESET.Mission
											AND ESLL.PaymentDate 			= ESET.PaymentDate
											AND ESET.PaymentStatus 	 	IN ('#PaymentStatus#')
					 	    	 WHERE  ESLL.Mission         = '#Mission#' 
							     AND    ESLL.SalarySchedule  = '#SalarySchedule#' 
								 AND    ESLL.PaymentDate     = #DTE#
								 <cfif PersonNo neq "0">
								 	AND 	ESLL.PersonNo 		 = '#PersonNo#'
								 </cfif>
								 AND    ESLL.SettlementPhase = 'Final') 
		
		</cfquery>
		
		<cfquery name="planPeriod" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT  *
				FROM    Program.dbo.Ref_Period
				WHERE   isPlanningPeriod = 1
				AND     DateEffective   <= #DTE#
				AND     DateExpiration  >= #DTE#
		</cfquery>
		
		<cfquery name="InsertSettlementLineFunding" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				
				INSERT INTO Payroll.dbo.EmployeeSettlementLineFunding 
				            (PaymentId,Fund,FundClass,ProgramCode,Period,Percentage)
				
				SELECT      S.PaymentId, 
				            PF.Fund, 
							PF.FundClass,
						    PF.ProgramCode, 
							'#PlanPeriod.Period#',
						    ROUND(SUM(PF.Percentage), 2) AS Percentage
							
				FROM        Employee.dbo.PositionParentFunding PF 
				
				            INNER JOIN (SELECT    PF.PositionParentId, 							             
												  MAX(PF.DateEffective) AS LastDate
			                            FROM      Employee.dbo.PositionParentFunding PF 
			                            WHERE     PF.DateEffective <= #DTE#
										
										<!--- Attention --->
										<!--- Hanno 22/7 only programs that belong to this mission, maybe we should even add the ProgramPeriod here 
										as otherwise it might not show in the budget execution view if it is not enabled for that year --->
										
										AND       PF.ProgramCode IN (SELECT ProgramCode 
													                 FROM   Program.dbo.Program 
														     	     WHERE  Mission = '#Mission#')
										
			                            GROUP BY  PF.PositionParentId) L 
										
							ON  PF.PositionParentId = L.PositionParentId 
							AND PF.DateEffective    = L.LastDate 
			
					        INNER JOIN  (SELECT    SL.PaymentId, SL.PositionParentId
			                             FROM      Payroll.dbo.EmployeeSettlementLine as SL 
			                             		   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
														ON 	SL.PersonNo 			= ESET.PersonNo
														AND SL.SalarySchedule 		= ESET.SalarySchedule
														AND SL.Mission 				= ESET.Mission
														AND SL.PaymentDate 			= ESET.PaymentDate
														AND SL.PaymentStatus		= ESET.PaymentStatus
														AND SL.PaymentStatus = '#PaymentStatus#'
														
			                             WHERE     SL.Mission         = '#Mission#' 
										 AND       SL.SalarySchedule  = '#SalarySchedule#' 
										 AND       SL.PaymentDate     = #DTE#
										 AND       SL.PaymentStatus   = '#PaymentStatus#'
										 <cfif PersonNo neq "0">
										 	AND 	   SL.PersonNo 		  = '#PersonNo#'
										 </cfif>
										 AND       SL.SettlementPhase = 'Final') S 
										 
							ON S.PositionParentId = L.PositionParentId
										
				GROUP BY    S.PaymentId, 
				            PF.Fund, 
						    PF.ProgramCode,	
						    PF.FundClass     
			</cfquery>
		
   
 </cffunction>	
</cfcomponent>	 