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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Payables Queries">	

	<cffunction name="getPayables"
             access="public"
             displayname="get the Payables as of a certain date">
						
		<cfargument name="Mission"        	  type="string"  required="true"   default="">				
		<cfargument name="AccountPeriod"  	  type="string"  required="false"   default="">		  <!--- originated --->				
		<cfargument name="SelectionDate"  	  type="date"    required="false"  default="#now()#">
		<cfargument name="BalanceDate"  	  type="date"    required="false"  default="#now()#">
		<cfargument name="SelectionPeriod" 	  type="string"  required="false"   default="">
		<cfargument name="Currency"       	  type="string"  required="false"  default="USD">	  	  <!--- originated --->			
		<cfargument name="TransactionSource"  type="string"  required="false"  default="">
		<cfargument name="Journal"		  	  type="string"  required="false"  default="">
		<cfargument name="IncludeCreditNotes" type="string"  required="false"   default="No">
		<cfargument name="TableName"      	  type="string"  required="true"   default="">
		<cfargument name="Mode"			  	  type="string"  required="false"  default="table" >
		
		<cfquery name 		= "Payables" 
				 datasource = "AppsLedger"
				 username 	= "#SESSION.login#"
				 password 	= "#SESSION.dbpw#">
		
		<cfif trim(Mode) eq "view">
				CREATE VIEW UserQuery.dbo.#TableName#
				AS
		</cfif>

		SELECT 	Data.Mission,
				Data.Journal, 
				Data.JournalSerialNo, 
				Data.TransactionSourceId, 
				Data.JournalTransactionNo, 
				Data.Reference, 
				Data.ReferenceName, 
				Data.ReferenceNo, 
				Data.ReferenceOrgUnit,
				Data.DocumentCurrency, 
				Data.DocumentAmount, 
				Data.DocumentDate,
				Data.TransactionDate,
				Data.TransactionCategory,
				Data.TransactionReference,
				Data.ActionBefore,
				Data.ActionStatus,
				Data.RecordStatus,
				Data.GLAccount,
				Data.GLAmount,
				Data.Currency, 
				Data.Amount,
				Data.TransactionSource,
				Data.AccountPeriod,
				Data.SettledOnSale,
				Data.SettledOnAR,
				Data.SettledOnAdvance,
				Data.TransactionPeriod,
				(Data.Amount - ABS(Data.SettledOnSale + Data.SettledOnAR + Data.SettledOnAdvance)) as AmountOutstanding

		<cfif trim(Mode) eq "table">
		INTO 	UserQuery.dbo.#TableName#
		</cfif>	

		FROM 
			(

				SELECT	H.Mission,
						H.Journal, 
						H.JournalSerialNo, 
						H.TransactionSourceId, 
						H.JournalTransactionNo, 
						H.Reference, 
						H.ReferenceName, 
						H.ReferenceNo, 
						H.ReferenceOrgUnit,
						H.DocumentCurrency, 
						H.DocumentAmount, 
						H.DocumentDate,
						H.TransactionDate,
						H.TransactionCategory,
						H.TransactionReference,
						H.ActionBefore,
						H.ActionStatus,
						H.RecordStatus,
						
						
						(SELECT TOP 1 GLAccount
						 FROM   TransactionLine 
						 WHERE  Journal = H.Journal 
						 AND    JournalSerialNo = H.JournalSerialNo 
						 AND    TransactionSerialNo = '0') as GLAccount,
						 
						(SELECT SUM(AmountDebit-AmountCredit)
						 FROM   TransactionLine 
						 WHERE  Journal = H.Journal 
						 AND    JournalSerialNo = H.JournalSerialNo 
						 AND    TransactionSerialNo = '0') as GLAmount,
						 
						H.Currency, 
						H.Amount,
						H.TransactionSource,
						H.AccountPeriod,
						H.TransactionPeriod,
						
						<!--- 2. POS sale --->
						
						(
							SELECT	ISNULL(SUM(L.AmountDebit*L.ExchangeRate - L.AmountCredit*L.ExchangeRate), 0) 
							FROM	TransactionLine AS L 
									INNER JOIN TransactionHeader AS TH ON L.Journal = TH.Journal AND L.JournalSerialNo = TH.JournalSerialNo
							WHERE	TH.TransactionSourceId IS NOT NULL 
							AND		L.ParentJournal         = H.Journal 
							AND		L.ParentJournalSerialNo = H.JournalSerialNo 
							
							AND     TH.RecordStatus != '9'
							AND     TH.ActionStatus IN ('0','1')
							
							<cfif SelectionPeriod eq "">
								AND		TH.TransactionDate <= #BalanceDate#
							<cfelse>
								AND		TH.TransactionPeriod IN (#preservesingleQuotes(SelectionPeriod)#)
							</cfif>
							
							AND     L.GLAccount = (SELECT TOP 1 GLAccount
							                       FROM   TransactionLine
												   WHERE  Journal         = H.Journal 
											       AND    JournalSerialNo = H.JournalSerialNo 
										 		   AND    TransactionSerialNo = '0' )
												   
						) AS SettledOnSale,  
						
						<!--- ------------------------------------------------------------------------------------- --->
						<!--- 2. Accounts receivables-------------------------------------------------------------- --->
						<!--- ------------------------------------------------------------------------------------- --->
														
						(
							SELECT	ISNULL(SUM(L.AmountDebit*L.ExchangeRate - L.AmountCredit*L.ExchangeRate), 0) 
							FROM	TransactionLine AS L 
									INNER JOIN TransactionHeader AS TH 
										ON L.Journal = TH.Journal 
										AND L.JournalSerialNo = TH.JournalSerialNo INNER JOIN Ref_Account R ON R.GLAccount = L.GLAccount
							WHERE	TH.TransactionSourceId IS NULL 
							AND     L.Reference <> 'Offset AR'
							AND		L.ParentJournal         = H.Journal 
							AND		L.ParentJournalSerialNo = H.JournalSerialNo 

							<cfif SelectionPeriod eq "">
								AND		TH.TransactionDate <= #BalanceDate#
							<cfelse>
								AND		TH.TransactionPeriod IN (#preservesingleQuotes(SelectionPeriod)#)
							</cfif>
							
							AND     TH.RecordStatus != '9'
							AND     TH.ActionStatus IN ('0','1')
							
							<!--- changed 22/7/2016 based on observation Ronmell and based on the
							query we have for TransactionOutstanding.cfm, as the old code
							did not work in case the offset is in different currecny as the invoice  --->
							
							AND     L.GLAccount = (SELECT TOP 1 GLAccount
							                       FROM   TransactionLine
												   WHERE  Journal         = H.Journal 
											       AND    JournalSerialNo = H.JournalSerialNo 
										 		   AND    TransactionSerialNo = '0' )
							
							<!--- disabled on 22/7/2016
							AND		L.TransactionSerialNo   = '0'
							AND     R.BankReconciliation    = 0
							--->
							
							<!---  to avoid those that are  discounts or returns 
							AND		not exists (
									SELECT 1 from Accounting.dbo.Ref_AccountMission
									WHERE SystemAccount in ('Correction','Discount') AND GLAccount = L.GLAccount AND Mission = TH.Mission
							)
							--->
							
						) AS SettledOnAR,
						
						<!--- ------------------------------------------------------------------------------------------- --->
						<!--- 3. 7/6/2015 in case an AR is offset by an advance  which we need to recheck as for point 2. --->
						<!--- ------------------------------------------------------------------------------------------- --->
						
						(
							SELECT	ISNULL(SUM(L.AmountDebit*L.ExchangeRate - L.AmountCredit*L.ExchangeRate), 0) 
							FROM	TransactionLine AS L 
									INNER JOIN TransactionHeader AS TH 
										ON L.Journal = TH.Journal 
										AND L.JournalSerialNo = TH.JournalSerialNo INNER JOIN Ref_Account R ON R.GLAccount = L.GLAccount
							WHERE	TH.TransactionSourceId IS NULL 
							AND     L.Reference = 'Offset AR'
							AND		L.ParentJournal         = H.Journal 
							AND		L.ParentJournalSerialNo = H.JournalSerialNo 
							
							AND     TH.RecordStatus != '9'
							AND     TH.ActionStatus IN ('0','1')

							<cfif SelectionPeriod eq "">
								AND		TH.TransactionDate <= #BalanceDate#
							<cfelse>
								AND		TH.TransactionPeriod IN (#preservesingleQuotes(SelectionPeriod)#)
							</cfif>
							
							AND     L.GLAccount = (SELECT TOP 1 GLAccount
							                       FROM   TransactionLine
												   WHERE  Journal         = H.Journal 
											       AND    JournalSerialNo = H.JournalSerialNo 
										 		   AND    TransactionSerialNo = '0' )
							<!---					   
							AND		L.TransactionSerialNo   = '0'
							AND     R.BankReconciliation    = 1
							--->
							
						) AS SettledOnAdvance
						
						FROM	TransactionHeader AS H
						WHERE	H.TransactionCategory = 'Payables' 
						AND		H.ActionStatus IN ('0','1')
						AND		H.RecordStatus != '9'

						AND  	H.Journal IN 
								(
									SELECT 	jl.Journal 
									FROM   	Journal as jl 
									WHERE  	jl.GLCategory = 'Actuals'
								)

						AND    	H.Journal IN 
								(
									SELECT 	tl.Journal 
									FROM   	TransactionLine as tl
									WHERE  	tl.Journal         = H.Journal 
									AND    	tl.JournalSerialNo = H.JournalSerialNo
									AND 	tl.GLAccount IN
											(
												SELECT  Rx.GLAccount
												FROM    Ref_Account Rx  
														INNER JOIN Ref_AccountMission Mx 
															ON Rx.GLAccount = Mx.GLAccount
												WHERE   Mx.Mission IN (#preserveSingleQuotes(Mission)#) 
												
												AND     Rx.AccountClass       = 'Balance' <!--- balance --->
												AND     Rx.AccountType        = 'Credit' 
												AND     Rx.AccountCategory    = 'Customer'
											)
									AND    	tl.TransactionSerialNo = '0'
								)

						<cfif trim(IncludeCreditNotes) eq "No" or trim(IncludeCreditNotes) eq "0">
							AND 	H.Amount > 0 <!--- No Credit notes --->
						</cfif>
								
						<cfif trim(AccountPeriod) neq "">
						AND		H.AccountPeriod IN (#preserveSingleQuotes(AccountPeriod)#)
						</cfif>
							
						<cfif trim(Mission) neq "">
						AND		H.Mission IN (#preserveSingleQuotes(Mission)#) 
						</cfif>
						
						<cfif trim(TransactionSource) neq "">
						AND		H.TransactionSource IN (#preserveSingleQuotes(TransactionSource)#)
						</cfif>
						
						<cfif trim(Journal) neq "">
						AND 	H.Journal IN  (#preserveSingleQuotes(Journal)#)
						</cfif>
						
						<cfif SelectionPeriod eq "">
							AND		H.TransactionDate <= #SelectionDate#
						<cfelse>
							AND		H.TransactionPeriod IN (#preservesingleQuotes(SelectionPeriod)#)
						</cfif>
												
						<!----As this query is to be stored in a tmp table, when retrieven data from this last table, must order it as you wish--->
			) AS Data
	
		</cfquery>	
					
	</cffunction>
	
</cfcomponent>