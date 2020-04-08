
<cfparam name="PeriodPrior"    default="2006">
<cfparam name="PeriodCurrent"  default="2007">

<!---

Approach A.

1. Takes PL balance prior period, generate record under Account capital in new period
2. Transfer balance of all balance accounts of prior year to new year, under opening balance new year

allow to undo, by simply putting transactions in one journal : Opening.

Approach B.

1. Run a PTL (ProsisTranslateLoad) that undo/redoes the above on a daily basisor the prior and current, so books could be always open, with the
exception that you can close a period.

No transactions allowed for prior to the prior period, so in 2007, no transaction are entered in 2005

--->

<cfquery name="Period"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Period
	WHERE    PeriodDateStart < getDate() 
	ORDER BY PeriodDateStart 
</cfquery>

<cfset prior = Period.AccountPeriod>

<!--- exclude the first --->

<cfloop query="Period" startrow="2">

	<cfset dte = dateformat(PeriodDateStart,client.dateformatshow)>

    <cfif Period.actionStatus eq "0">
	
		<!--- prepare opening transaction --->
		<cfquery name="Tree"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   DISTINCT Mission 
			FROM     TransactionHeader
			WHERE    AccountPeriod = '#prior#' 		
			AND      Journal IN (SELECT Journal 
			                     FROM   Journal 
								 WHERE  GLCategory = 'Actuals')								 
				 
			ORDER BY Mission
		</cfquery>
		
		<cfset new = AccountPeriod>	
				
		<cfloop query="tree">
	
			<cfquery name="Param"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_ParameterMission
				WHERE    Mission = '#Mission#'
			</cfquery>			
			
			<!--- remove generated transaction --->
			<cfquery name="Clear"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   * 
				FROM     TransactionHeader
				WHERE    AccountPeriod     = '#new#' 
				AND      Mission           = '#Mission#'
				AND      TransactionSource = 'Opening'
			</cfquery>
			
			<cfloop query="Clear">
			
				<cfquery name="Delete"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    	DELETE FROM TransactionHeader
					WHERE       TransactionId = '#TransactionId#' 
				</cfquery>
			
			</cfloop>
				
			<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Closing">
			
			<!--- prepare opening transaction for the new period by summing the prior period --->
			
			<cfquery name="getTransaction"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   Hdr.Mission, 
						<cfif Param.AdministrationLevel neq "Tree">
				         Hdr.OrgUnitOwner, 
						 <cfelse>
						 '0' as OrgUnitOwner,
						 </cfif>
						 Line.GLAccount, 
						 Line.Currency, 
						 Acc.MonetaryAccount,
						 Acc.RevaluationMode,
						 SUM(Line.AmountDebit)      AS AmountDebit, 
						 SUM(Line.AmountCredit)     AS AmountCredit, 
				         SUM(Line.AmountBaseDebit)  AS AmountBaseDebit, 
						 SUM(Line.AmountBaseCredit) AS AmountBaseCredit
				INTO     userQuery.dbo.#SESSION.acc#Closing		 
				FROM     TransactionLine Line INNER JOIN
				         Ref_Account Acc ON Line.GLAccount = Acc.GLAccount INNER JOIN
				         TransactionHeader Hdr ON Line.Journal = Hdr.Journal AND Line.JournalSerialNo = Hdr.JournalSerialNo
				WHERE    Acc.AccountClass   = 'Balance'
				AND      Line.AccountPeriod = '#prior#' 
				AND      Hdr.Mission        = '#Mission#'
				AND      Hdr.RecordStatus    IN('0','1')
				AND      Hdr.ActionStatus IN ('0','1')				
				AND      Hdr.Journal IN (SELECT Journal 
			                             FROM   Journal 
								         WHERE  GLCategory = 'Actuals')
				GROUP BY Hdr.Mission, <cfif Param.AdministrationLevel neq "Tree">Hdr.OrgUnitOwner, </cfif> Line.Currency, Line.GLAccount, Acc.MonetaryAccount,
						 Acc.RevaluationMode
						
			</cfquery>

			<!--- prepare data --->
			<cfquery name="Transaction2"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE    #SESSION.acc#Closing	
				SET       AmountDebit      = round(AmountDebit - AmountCredit,2), 
				          AmountCredit     = 0,
						  AmountBaseDebit  = round(AmountBaseDebit - AmountBaseCredit,2),
						  AmountBaseCredit = 0 
				WHERE     AmountDebit >= AmountCredit
			</cfquery>
			
			<!--- prepare data --->
			<cfquery name="Transaction3"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE    #SESSION.acc#Closing	
				SET       AmountCredit = round(AmountCredit - AmountDebit,2),
				          AmountDebit = 0,
						  AmountBaseCredit = round(AmountBaseCredit - AmountBaseDebit,2),
						  AmountBaseDebit = 0 
				WHERE     AmountDebit < AmountCredit
			</cfquery>
			
			<!--- record opening balance header --->
			<!--- 6/5 correction for the amount presentation --->
			
			<cfquery name="Header"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   Mission,
						 OrgUnitOwner,
				         Currency,				         
					     ROUND(SUM(AmountDebit + AmountCredit),2) as DocumentAmount
				FROM     #SESSION.acc#Closing	
				WHERE    Mission = '#mission#'
				GROUP BY Mission, 
				         OrgUnitOwner,
						 Currency 
				ORDER BY Mission, 
				         OrgUnitOwner,
						 Currency 		 
			</cfquery>
														
				<cfloop query="header">
				
					<cfquery name="Account"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   Ref_AccountMission
						WHERE  Mission       = '#Mission#'
						AND    SystemAccount = 'Capital'
						AND    GLAccount IN (SELECT GLAccount 
						                     FROM   Ref_Account 
											 WHERE  AccountClass = 'Balance'
											 AND    AccountType  = 'Credit')
					</cfquery>
					
					<cfif Account.recordcount eq "0">
					
						<cf_ScheduleLogInsert   
							    ScheduleRunId  = "#schedulelogid#"
							    Description    = "Missing Closing Account [Capital] for #Mission# -#OrgUnitOwner#- #Currency#"
							    StepStatus     = "9"
								Datasource     = "AppsLedger"
							    Abort          = "No">
					
					<cfelse>
					
						<cfquery name="Journal"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Journal
							WHERE  Mission       = '#Mission#'
							AND    SystemJournal = 'Opening'
							AND    Currency      = '#Currency#'
						</cfquery>
										
						<cfif Journal.recordcount eq 0>
						
							<cf_ScheduleLogInsert   
							    ScheduleRunId  = "#schedulelogid#"
							    Description    = "Missing Journal [Opening] for #Mission# -#OrgUnitOwner#- #currency#"
							    StepStatus     = "9"
								Datasource     = "AppsLedger"
							    Abort          = "No">
						
						<cfelse>	
						
							<cftransaction>		
																						
								<CF_DateConvert Value="#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#">
								
								<cfset dte = dateValue>
								
								<cfif month(dte) gte "10">
									<cfset TransactionPeriod = "#year(dte)##month(dte)#">
								<cfelse>
									<cfset TransactionPeriod = "#year(dte)#0#month(dte)#">
								</cfif>		
																	
								<cf_GledgerEntryHeader
								    Mission               = "#Mission#"
								    OrgUnitOwner          = "#OrgUnitOwner#"
								    Journal               = "#Journal.Journal#"
									JournalTransactionNo  = "Opening #new#"
									Description           = "Opening Balance #OrgUnitOwner# #new#"
									TransactionSource     = "Opening"
									AccountPeriod         = "#new#"		
									TransactionDate       = "#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#"		
									TransactionPeriod     = "#TransactionPeriod#"					
									TransactionCategory   = "Memorial"
									MatchingRequired      = "0"
									DocumentCurrency      = "#Currency#"
									DocumentDate          = "#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#"
									DocumentAmount        = "#round(Header.DocumentAmount*100)/100#">
																	
								<cfquery name="toInsertLines"
									datasource="AppsLedger" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT GLAccount,
									       MonetaryAccount,
										   RevaluationMode,
										   Currency,
										   AmountDebit, 
										   AmountCredit, 
							   	           AmountBaseDebit, 
										   AmountBaseCredit
								    FROM   userQuery.dbo.#SESSION.acc#Closing
									WHERE  Mission      = '#mission#'
									AND    OrgUnitOwner = '#OrgUnitOwner#'
									AND    Currency     = '#Currency#'
									ORDER BY GLAccount
								</cfquery>	
								
								<cfset cJournalTransactionNo = JournalTransactionNo>
								<cfset own = OrgUnitOwner>
								<cfset mis = Mission>							
								
								<cfloop query="toInsertLines">
																	
									<cfif toInsertLines.AmountDebit eq 0>
										<cfset vClass      = "Credit">
										<cfset vAmount     = AmountCredit> 
										<cfset vAmountBase = AmountBaseCredit>
									<cfelse>
										<cfset vClass      = "Debit">
										<cfset vAmount     = AmountDebit>	
										<cfset vAmountBase = AmountBaseDebit>
									</cfif>		
									
									<cfif abs(vAmount) gte "0.005">
									
										<cfif vAmountBase eq "0" or vAmountBase eq "" or vAmountBase eq "''">
											<cfset baseexc = "">
										<cfelse>
										    <cfset baseexc = vAmount/vAmountBase>
										</cfif>	
										
										<cfif baseexc neq "" AND 
										    Currency neq Application.BaseCurrency AND
										    MonetaryAccount eq "1" AND
											RevaluationMode eq "1">
										
											<cfquery name="DocumentCurr" 
											     datasource="AppsLedger" 
											     username="#SESSION.login#" 
											     password="#SESSION.dbpw#">
											     SELECT   TOP 1 *
											     FROM     Accounting.dbo.CurrencyExchange
												 WHERE    Currency  = '#Currency#'
												 AND      EffectiveDate <= '#Period.PeriodDateStart#'
												 ORDER BY EffectiveDate DESC
											</cfquery>
											
											<!--- --------------------------------------- --->
											<!--- we observed an exchange rate difference --->
											<!--- --------------------------------------- --->
											
											<cfoutput>#prior#-#baseexc#</cfoutput>
										
											<cfif abs(baseexc-DocumentCurr.ExchangeRate) gte "0.001">
											
												<!--- apply a currency correction --->
												
												<cfquery name="eJournal"
													datasource="AppsLedger" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT * 
														FROM   Journal
														WHERE  Mission       = '#mis#' 
														AND    SystemJournal = 'ExchangeRate'
												</cfquery>	
												
												<!--- -------------------------------------------- --->
												<!--- define the corrected amount in base currency --->
												<!--- -------------------------------------------- --->
												
												<cfset camt = vAmountBase - (vAmount / DocumentCurr.ExchangeRate)> 												
												<cfset camt = round(camt*1000)/1000>
												
												<CF_DateConvert Value="#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#">																						
												<cfset dte = dateAdd("d",-1,dateValue)>
												
												<cfif abs(camt) gte 0.2>
												
												<cf_GledgerEntryHeader
												    Mission               = "#Mis#"
												    OrgUnitOwner          = "0"
												    Journal               = "#eJournal.Journal#"
													JournalTransactionNo  = "Exchange Rate"
													Description           = "Revaluation #DateFormat(dte,CLIENT.DateFormatShow)#"
													TransactionSource     = "ExchangeRate"
													AccountPeriod         = "#prior#"
													TransactionCategory   = "Memorial"
													MatchingRequired      = "0"
													DocumentCurrency      = "#application.baseCurrency#"
													TransactionDate       = "#DateFormat(dte,CLIENT.DateFormatShow)#"
													DocumentDate          = "#DateFormat(dte,CLIENT.DateFormatShow)#"
													DocumentAmount        = "#camt#">	
													
													<cfquery name="ExchangeResult"
														datasource="AppsLedger" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															SELECT * 
															FROM   Ref_AccountMission
															WHERE  Mission = '#Mis#'
															AND    SystemAccount = 'ExchangeDifference'
													</cfquery>			
													
													<!--- line exchange rate --->										
																																					
													<cfquery name="ExchangeResult"
														datasource="AppsLedger" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															INSERT INTO TransactionLine
																 (Journal, 
																  JournalSerialNo, 
																  GLAccount, 
																  Memo,
																  JournalTransactionNo,
																  TransactionSerialNo, 
																  AccountPeriod, 
																  TransactionDate, 
																  TransactionPeriod,
																  TransactionType, 
																  TransactionCurrency,
																  Currency,
																  AmountDebit,
																  AmountCredit,
														          AmountBaseDebit,AmountBaseCredit,
																  OfficerUserId,
																  OfficerLastName,
																  OfficerFirstName)
															VALUES
																('#eJournal.Journal#',
																 '#JournalTransactionNo#',
																 '#ExchangeResult.GLAccount#', 
																 'Revaluation #DateFormat(dte,CLIENT.DateFormatShow)#',
																 '#Journal.Journal#-#JournalTransactionNo#',
																 '0',
																 '#prior#',
																 '#DateFormat(dte,CLIENT.DateSQL)#',
																 <cfif month(dte) lt 10>
																 '#year(dte)#0#month(dte)#',
																 <cfelse>
																 '#year(dte)##month(dte)#',
																 </cfif>								 
																 'Revaluation',
																 '#Currency#',
																 '#Currency#',
																 0,0,
																 
																 <cfif vAmount gte "0">
																 
																	 <cfif vclass eq "Credit">																	 
																	 <!--- this is a loss/cost --->																	 
																	 0,#camt#,																	 
																	 <cfelse>																	 
																	 #camt#,0,																	 
																	 </cfif>
																 																 
																 <cfelse>
																 
																     <cfif vclass eq "Credit">																	 
																	 <!--- this is a profiy --->																	 
																	 #camt#,0,<cfelse>0,#camt#,</cfif>		
																
																 </cfif>
																  
																 '#SESSION.acc#',
																 '#SESSION.last#',
																 '#SESSION.first#')							
														</cfquery>	
																											
																								
														<cfquery name="BalanceCorrection"
														datasource="AppsLedger" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															INSERT INTO TransactionLine
																 (Journal, 
																  JournalSerialNo, 
																  GLAccount, 
																  Memo,
																  JournalTransactionNo,
																  TransactionSerialNo, 
																  AccountPeriod, 
																  TransactionDate, 
																  TransactionPeriod,
																  TransactionType, 
																  TransactionCurrency,								  
																  Currency,
																  AmountDebit,
																  AmountCredit,
														          AmountBaseDebit,
																  AmountBaseCredit,
																  OfficerUserId,
																  OfficerLastName,
																  OfficerFirstName)
																  																  
															VALUES ( '#eJournal.Journal#',
																   '#JournalTransactionNo#',
																   '#GLAccount#',
																   'Revaluation #DateFormat(dte,CLIENT.DateFormatShow)#',
																   '#Journal.Journal#-#JournalTransactionNo#',
																   '1',
																   '#prior#',
																   '#DateFormat(dte,CLIENT.DateSQL)#',
																   <cfif month(dte) lt 10>
																   '#year(dte)#0#month(dte)#',
																   <cfelse>
																   '#year(dte)##month(dte)#',
																   </cfif>			
																   'Revaluation',
																   '#Currency#',
																   '#Currency#', 
																    0,0,
																	
																   <cfif vAmount gte "0">
																 
																	 <cfif vclass eq "Credit">																	 
																	 <!--- this is a loss/cost --->																	 
																	 #camt#,0,																	 
																	 <cfelse>																	 
																	 0,#camt#,																	 
																	 </cfif>
																 																 
																 <cfelse>
																 
																     <cfif vclass eq "Credit">																	 																	 
																	 0,#camt#,
																	 <cfelse>
																	 #camt#,0,
																	 </cfif>
																															 
																 </cfif>			
																 
																   '#SESSION.acc#',
																   '#SESSION.last#',
																   '#SESSION.first#')
														    			
														</cfquery>		
														
												</cfif>																									
												
												<cfset baseexc = DocumentCurr.ExchangeRate>
											
											</cfif>																						
											
										</cfif>	
																									
										<cf_GledgerEntryLine
											Lines                 = "1"
										    Journal               = "#Journal.Journal#"
											JournalNo             = "#cJournalTransactionNo#"
											AccountPeriod         = "#new#"
											Currency              = "#toInsertLines.Currency#"
											BaseExchangeRate      = "#baseexc#" 
											TransactionDate       = "#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#"		
											DocumentDate          = "#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#"													
											TransactionSerialNo1  = "0"
											Class1                = "#vClass#"
											Description1          = "Opening Balance #Own# #new#"
											GLAccount1            = "#ToInsertLines.GLAccount#"
											TransactionType1      = "Opening"
											Amount1               = "#vAmount#">	
										
									</cfif>																									
								
								</cfloop>															
													
								<cfquery name="Capital"
								datasource="AppsLedger" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">								    
									SELECT round(ISNULL(sum(AmountDebit)     - sum(AmountCredit),0),2)     as Capital,
										   round(ISNULL(sum(AmountBaseDebit) - sum(AmountBaseCredit),0),2) as CapitalBase
								    FROM   TransactionHeader H, TransactionLine L
									WHERE  H.Journal           = L.Journal
									AND    H.JournalSerialNo   = L.JournalSerialNo 
									AND    H.Mission           = '#mission#'
									AND    H.OrgUnitOwner      = '#OrgUnitOwner#' 
									AND    H.AccountPeriod     = '#new#'
									AND    H.TransactionSource = 'Opening'									
									AND    H.Currency          = '#Currency#'
									
								</cfquery>		
										
								<!--- capital transaction --->
								
								<cfif Capital.Capital neq "0">
																
									<cfoutput>
										#Currency#-#Capital.Capital/Capital.CapitalBase#
									</cfoutput>
								
									<cf_GledgerEntryLine
										Lines                 = "1"
									    Journal               = "#Journal.Journal#"
										JournalNo             = "#cJournalTransactionNo#"
										AccountPeriod         = "#new#"
										Currency              = "#Currency#"	
										ExchangeRate          = "#Capital.Capital/Capital.CapitalBase#" 
										BaseExchangeRate      = "#Capital.Capital/Capital.CapitalBase#" 
										TransactionDate       = "#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#"		
										DocumentDate          = "#DateFormat(Period.PeriodDateStart,CLIENT.DateFormatShow)#"								
										TransactionSerialNo1  = "1"
										Class1                = "Credit"
										Description1          = "Opening Balance #Own# #new#"
										GLAccount1            = "#Account.GLAccount#"
										TransactionType1      = "Opening"
										Amount1               = "#Capital.Capital#">								
																														
								</cfif>	
								
							</cftransaction>
							
							<cf_ScheduleLogInsert   
							    ScheduleRunId  = "#schedulelogid#"
							    Description    = "Opening recorded for #New# #Mission# #currency#"
								Datasource     = "AppsLedger"
							    StepStatus     = "1">
						
						</cfif>
						
					</cfif>	
					
				</cfloop>	
															
		</cfloop>
		
	</cfif>	
	
	<cfset prior = accountPeriod>

</cfloop>