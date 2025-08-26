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
    <cfset this.name = "Payroll SUN File generation">

    <cffunction name="genSUNFile"
             access="public"
             returntype="string"
             displayname="genSUNFile">
			 
			 <!--- ----------general structure -----------  ----->
			 <!--- builds SUNS structure as follows  		----->
			 <!--- 											----->
			 <!--- Payroll Costs (budget)		XXX			----->
			 <!--- Payroll Costs Misc (budget)	XXX			----->
			 <!--- Provision Payable				XXX		----->
			 <!--- Provision (Misc)					XXX		----->
			 <!--- Provision Insurance				XXX		----->
			 <!--- Provision Pension				XXX		----->
			 <!--- 											----->
 			 <!--- Provision Patable			XXX			----->
 			 <!--- Bank Transfer					XXX		----->
 			 <!--- 											----->
			 <!--- ----------general structure -----------  ----->
		
		<cfargument name="ForTransactionID"    	type="string" required="true">	
		<cfargument name="ForPersonNo"       	type="string" required="true">	

		<cf_screentop html="no" jquery="yes">
		
		<cfset varToReturn = "no html to show">
		
		<cfquery name="getHeader" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *  
			FROM   Accounting.dbo.TransactionHeader  
			WHERE  TransactionId = '#URL.TransactionId#'
		</cfquery>	

		<cfquery name="getSchedule" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT SM.SalarySchedule, SM.GlAccount
			FROM  SalarySchedulePeriod SP INNER JOIN SalaryScheduleMission SM ON SP.SalarySchedule =  SM.SalarySchedule AND SP.Mission = SM.Mission
			WHERE CalculationId = '#getHeader.TransactionSourceId#'
		</cfquery>	

		<cfquery name="qGetMax" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT MAX(_FileNo) as FileNo
			FROM Accounting.dbo.TransactionHeader
		</cfquery>						
					
		<cfif qGetMax.FileNo eq "">
			<cfset vFileNo = 1>
		<cfelse>
			<cfset vFileNo = qGetMax.FileNo+1>
		</cfif>			

		<cfif ForPersonNo neq 0>
		
			<cfquery name="qUpdate" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE Accounting.dbo.TransactionHeader
				SET    _FileNo = '#vFileNo#'
				WHERE  Journal = '#getHeader.Journal#'
				AND    JournalSerialNo = '#getHeader.JournalSerialNo#'
			</cfquery>
			
		</cfif>

		<cfset vFileNo = numberFormat(vFileNo,'0000')>

		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#">	      
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_Misc">		
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_PC_FULL">
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_B4Misc">
			      
		<cffunction access="public" returntype="string" name="getFund"> 
		 	<cfargument required="true" type="string" name="pFund"> 
		 	<cfargument required="true" type="string" name="pPeriod"> 	
		 
			<cfif pFund neq "">
			
				<cfquery name="qFund" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT Reference
					FROM   Accounting.dbo.stFund
					WHERE  Fund = '#pFund#' 
					AND    Period = '#pPeriod#' 
				</cfquery>	
			
				<cfif qFund.recordcount neq 0>
					<cfreturn qFund.Reference>
				<cfelse>
					<cfreturn "<Not configured>">
				</cfif>
			<cfelse>
				<cfreturn "">				
			</cfif>				

		</cffunction>		

		<cffunction access="public" returntype="string" name="getProgramReference"> 
		 	<cfargument required="true" type="string" name="pFund"> 
		 	<cfargument required="true" type="string" name="pProgram"> 
		 
			<cfif pFund neq "">
				<cfif pProgram neq "">
					<cfreturn pProgram>
				<cfelse>
					<cfreturn "<Not configured>">				
				</cfif>		
			<cfelse>
				<cfreturn "">			
			</cfif>

		</cffunction>

		<cffunction access="public" returntype="string" name="getObject"> 
		 	<cfargument required="true" type="string" name="pFund"> 
		 	<cfargument required="true" type="string" name="pObject"> 
		 
			<cfif pFund neq "">
				<cfif pObject neq "">
					<cfreturn pObject>
				<cfelse>
					<cfreturn "<Not configured>">				
				</cfif>		
			<cfelse>
				<cfreturn "">			
			</cfif>

		</cffunction>

		<cfif getHeader.recordcount neq 0>
				
				<!--- generate a tmp table to group the debit using program/fund/objectcode, but for the credits MIP/UNJSPF, it doesn't matter --->
				
				<cfquery name="qPreparation" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT 1 AS type,
						       TH.Journal,
						       TH.JournalSerialNo,
						       (CASE
							   		WHEN TL.GLAccount = (SELECT GLAccount FROM Employee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = TL.memo) /*---- salary withoold-- */
											AND TL.TransactionAmount <0
											THEN
											TL.GLAccount
						            WHEN TL.Reference = 'Payroll cost'
						           		THEN '820000'
									WHEN TL.Reference = 'Liability' AND TL.GLAccount NOT IN ('4021','4022','4023','4024','4025','4026' /*MIP*/
																	,'4041','4042','4043','4044','4045','4046'/**/)  /*the ones that don't need program/fund/OE, all others costs.*/
										THEN '820000'
						            ELSE GLAccount
						        END) AS GLAccount,
						       TH.TransactionDate AS DateDue,
						       TH.Created AS DatePrepared,
							   CASE 
							   		WHEN TL.GLAccount = (SELECT GLAccount FROM Employee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = TL.memo)
									THEN 'Internal'
									ELSE TL.Reference
									END AS Reference,
							   TL.Memo,
							   TL.TransactionAmount,
						       TL.ReferenceName,
						       TL.ReferenceNo AS Program,
						       TL.Fund,
						       TL.ProgramPeriod,
						       TL.ProgramCode,
						       (CASE
						            WHEN TL.Reference = 'Payroll cost'
							            THEN GLAccount 
									WHEN TL.Reference = 'Liability' 
										AND TL.GLAccount NOT IN ('4021','4022','4023','4024','4025','4026' /*MIP*/
																,'4041','4042','4043','4044','4045','4046'/**/) 
										AND TL.GLAccount != (SELECT GLAccount FROM Employee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = TL.memo)
										THEN GLAccount 
									WHEN TL.Reference = 'Liability' 
										AND TL.GLAccount = (SELECT GLAccount FROM Employee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = TL.memo)
										THEN '2111' <!---- misc must be a M30  ----->
						            ELSE ''
						        END) AS ObjectCode,
						       TL.Currency,
						       /*ROUND(SUM(TL.AmountDebit), 2) AS Debit,*/
							   CASE
								 WHEN TL.GLAccount = (SELECT GLAccount FROM EMployee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = TL.memo) /*---- salary withoold-- */
									 AND TL.TransactionAmount <0
								 THEN ROUND(SUM(TL.TransactionAmount), 2)
								 ELSE ROUND(SUM(TL.AmountDebit), 2)
							   END as Debit,
						       	
							   ROUND(SUM(TL.AmountCredit), 2) AS Credit
							   
						INTO Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_PC_FULL
						
						FROM Accounting.dbo.TransactionHeader AS TH
						     INNER JOIN Accounting.dbo.TransactionLine AS TL ON TH.Journal = TL.Journal
						                                                        AND TH.JournalSerialNo = TL.JournalSerialNo
						WHERE  TH.Journal = '#getHeader.Journal#'
						AND    TH.JournalSerialNo = '#getHeader.JournalSerialNo#'
				        AND     (
							 		(TL.Glaccount != '#getSchedule.GlAccount#' 	AND TL.GlAccount != '2161')
						          OR (TL.GLAccount = '2161'						AND TL.TransactionSerialNo != '0')
								  OR (TL.GLAccount = '2161' 					AND TL.TransactionSerialNo = '0' 			AND TL.Reference = 'Liability') <!--- added by Ronmell  --->
								 )
								 
						<!--- special if this is viewed from the Persons profile --->
						<cfif ForPersonNo neq 0>
							AND TL.Memo = '#ForPersonNo#'
						</cfif>
						GROUP BY TH.Journal,
						         TH.JournalSerialNo,
						         TL.GLAccount,
						         TL.AccountPeriod,
						         TL.Reference,
								 TL.Memo,
								 TL.TransactionAmount,
						         TL.Currency,
						         TH.TransactionDate,
						         TH.Created,
						         TL.ReferenceNo,
						         TL.ProgramPeriod,
						         TL.ProgramCode,
						         TL.ObjectCode,
						         TL.ReferenceName,
						         TL.Fund				
				
				</cfquery>
				
				<cfquery name="qPreparation" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						<!--- purely payroll costs --->
						
						SELECT 	type, Journal, JournalserialNo, GLAccount, DateDue, DatePrepared, Reference,ReferenceName,Program,Fund,ProgramPEriod,ProgramCode,
								ObjectCode,Currency,Debit,Credit, Memo as PersonNo, 'XX' as PayrollItem
								
						INTO 	Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#
						FROM 	Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_PC_FULL
						WHERE 	GLAccount = '820000'
						
						<!--- validate the Miscellaneous that are part of the OFFSET --->
						
						AND     Reference != 'Internal'
						
						UNION ALL
						
						SELECT 	'1.11' as type, Journal, JournalserialNo, GLAccount, DateDue, DatePrepared, Reference,REferenceName,Program,Fund,ProgramPEriod,ProgramCode,
								ObjectCode,Currency,Credit Debit,0 Credit, Memo as PersonNo, 'M30' as PayrollItem
						FROM 	Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_PC_FULL
						WHERE 	GLAccount = '820000'
						
						<!--- validate the Miscellaneous that are part of the INTERNAL --->
						
						AND     Reference = 'Internal'
												
						UNION ALL
						
						<!--- now the Credits for the payroll costs, meaning: MIP/UNJSPF --->
						
						SELECT 	 '1.1' type, Journal, JournalSerialNo, GLAccount, DateDue, DatePrepared, Reference,  
								 ReferenceName, ''Program, ''Fund, ''ProgramPeriod, ''ProgramCode, ''ObjectCode, Currency,
								 SUM(Debit) Debit,
								 SUM(Credit) Credit
								 ,'0' as PersonNo
								 ,'XX' as PayrollItem
						FROM 	 Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_PC_FULL 
						WHERE 	 GLAccount != '820000' 
						GROUP BY Journal, JournalSerialNo, GLAccount, DateDue, DatePrepared, Reference, ReferenceName, Currency
						
						UNION ALL

						<!--- MISCELLANEOUS TO INFORM SUN THAT THE RECOVERY HAS BEEN MADE
								Essentially without the below we have:
								
								Staff member payment :    3,000
								Mobile phone                          - 10
								
								==========================
								To pay                                      2,990
								
								Those, 10, must be informed that were collected from the account, so the way it works is that I have to make a credit of 10 to the S/M account.
								
								So the below, is for that purpose.
						--->

						SELECT 
						
							<!--- DISTINCT: it was double for some WHO HAD MORE THAN 2 DISTRIBUTIONS, PERCENTAGE AND CURRENCY
						  	AS PERSON 9240, as this query relates directly by JOURNAL-JOURNALSERIALNO 
							as PARENT and here since the person HAD 2 distributions IN DIFFERENT CURRENCIES
							AND this query is linking AS INNER JOIN does a CARTESIAN PRODUCT for the 2 TransactionLine records
							IN Accounting (1 for journal in USD, 1 for Journal EUR) and thus the misc is double
							as Marian reported in the email with subject 'Reconciliation of Progen and Prosis'
							--->
							
							DISTINCT 
							1.2 AS Type, 
							ESL.Journal, 
							ESL.JournalSerialNo, 
							TL.GlAccount, 
							PaymentDate, 
							PaymentDate,  
							ESL.Source AS Reference,
							'' AS ReferenceName,
							'' AS Program,
							'' AS Fund,
							'' AS ProgramPeriod,
							'' AS ProgramCode,
							'' AS ObjectCode,
							ESL.DocumentCurrency,
							CASE WHEN ESL.DocumentAmount <=0 THEN 0 ELSE ABS(ESL.DocumentAmount) END as Debit,
						    CASE WHEN ESL.DocumentAmount <=0 THEN ABS(ESL.DocumentAmount) ELSE 0 END as Credit, 
							
							<!--- reverted to pass the offset in the document currency : driven by the base in the target
							ESL.Currency,
							CASE WHEN ESL.DocumentAmount <=0 THEN 0 ELSE ABS(ESL.PaymentAmount) END as Debit,
						    CASE WHEN ESL.DocumentAmount <=0 THEN ABS(ESL.PaymentAmount) ELSE 0 END as Credit, 
							--->						
							 
							ESL.PersonNo as PersonNo,
							ESL.PayrollItem 
							
						FROM  Payroll.dbo.EmployeeSettlementLine ESL INNER JOIN Accounting.dbo.TransactionLine TL ON ESL.Journal  = TL.ParentJournal
								AND   ESL.JournalSerialNo = TL.ParentJournalSerialNo
								AND   ESL.PersonNo = TL.ReferenceNo
								AND   TL.TransactionSerialNo = 0 
						WHERE ESL.Source             = 'Offset'
						<!--- hanno added 25/4 --->
						<!--- AND   TL.TansactionAmount > 0 --->
						<!--- ---------------- --->
						AND   ESL.Journal 		     = '#getHeader.Journal#'
						AND   ESL.JournalSerialNo    = '#getHeader.JournalSerialNo#'
						<cfif ForPersonNo neq 0>
						AND   ESL.PErsonNo = '#ForPersonNo#'
						</cfif>
		 
		 			UNION ALL 								 

						/*<!--- NET Payable --->  */               

						SELECT 2 AS type,
						       TH.Journal,
						       TH.JournalSerialNo,
							   (  SELECT GLAccount
								  FROM Employee.dbo.PersonGLedger
								  WHERE PersonNo = TH.ReferencePersonNo 
								  AND   Area = 'Payroll' ) AS GLAccount,						
						       TH.TransactionDate,
						       TH.Created,
						       TL.Reference,
						       TL.ReferenceName,
						       '' AS Program,
						       TL.Fund,
						       TL.ProgramPeriod,
						       TL.ProgramCode,
						       (CASE
						            WHEN TL.Reference = 'Payroll cost'
						            THEN TL.GLAccount
						            ELSE ''
						        END) AS ObjectCode,
						       TL.Currency,
						       ROUND(SUM(TL.AmountDebit), 2) AS Debit,
						       ROUND(SUM(TL.AmountCredit), 2) AS Credit,
							   TH.ReferencePersonNo as PersonNo,
							   'XX' as PayrollItem
							   
						FROM   Accounting.dbo.TransactionHeader AS TH
						       INNER JOIN Accounting.dbo.TransactionLine AS TL ON TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo
						       INNER JOIN Accounting.dbo.Journal J ON J.Journal = TH.Journal
							   
						WHERE  TL.ParentJournal = '#getHeader.Journal#'
						AND    TL.ParentJournalSerialNo = '#getHeader.JournalSerialNo#'
						AND    J.TransactionCategory NOT IN('Memorial')
						AND    EXISTS	( SELECT 'X'
									      FROM    Employee.dbo.PersonGLedger PGL
									      WHERE  PGL.PersonNo = TH.ReferencePersonNo 
										  AND    Area = 'Payroll')
						<cfif ForPersonNo neq 0>
						AND    TH.ReferencePersonNo = '#ForPersonNo#'
						</cfif>
						
						<!--- hanno added 25/4 --->
						
						AND     (TL.Reference != 'Offset' 
						          or (TL.Reference = 'Offset' AND TL.TransactionAmount > 0)
								)
						<!--- ----------------- --->		
						
						GROUP BY TH.Journal,
						         TH.JournalSerialNo,
						         TL.GLAccount,
						         TL.AccountPeriod,
						         TL.Reference,
						         TL.Currency,
						         TH.TransactionDate,
						         TH.Created,
						         TH.ReferencePersonNo,
						         TL.ProgramPeriod,
						         TL.ProgramCode,
						         TL.ObjectCode,
						         TL.ReferenceName,
						         TL.Fund
						/***/
						
						UNION ALL
						
						SELECT Type,
					       Journal,
					       JournalSerialNo,
					       GLAccount,
					       TransactionDate,
					       Created,
					       Reference,
					       ReferenceName,
					       PRogram,
					       Fund,
					       ProgramPeriod,
					       ProgramCode,
						   Objectcode,
					       Currency,
						   ROUND(SUM(Debit),2)  AS Debit,
						   ROUND(SUM(Credit),2) AS Credit,
					       '0' PersonNo,
					       'XX' PayrollItem
						   
					FROM  (
					
						SELECT 2.5 AS type,
						       '' AS Journal,
						       '' AS JournalSerialNo,
						       TL.GLAccount,
						       TH.TransactionDate,
						       NULL AS Created,
						       TL.Reference,
						       '' AS ReferenceName,
						       '' AS Program,
						       TL.Fund,
						       TL.ProgramPeriod,
						       TL.ProgramCode,
							   '' Objectcode,
						       TL.AmountDebit,
						       TL.AmountCredit,
						       B.Currency,
							   
							   ( SELECT TL.AmountBaseDebit *
								 (   SELECT   TOP (1) ExchangeRate
								        FROM     Accounting.dbo.CurrencyExchange
								        WHERE    Currency = B.Currency
							            AND      EffectiveDate <= TH.TransactionDate
								        ORDER BY EffectiveDate DESC
								    ) AS Expr1
							    ) AS Debit,
						     (  SELECT TL.AmountBaseCredit *
						        (   SELECT TOP (1) ExchangeRate
						            FROM     Accounting.dbo.CurrencyExchange 
						            WHERE    Currency = B.Currency
						             AND     EffectiveDate <= TH.TransactionDate
						            ORDER BY EffectiveDate DESC ) AS Expr1
						       ) AS Credit
							  
						FROM Accounting.dbo.TransactionHeader AS TH
						     INNER JOIN Accounting.dbo.TransactionLine AS TL ON TH.Journal = TL.Journal
						                                         AND TH.JournalSerialNo = TL.JournalSerialNo
						     INNER JOIN Accounting.dbo.Journal AS J ON J.Journal = TH.Journal
						     INNER JOIN Accounting.dbo.Ref_Account AS R ON TL.GLAccount = R.GLAccount
						     INNER JOIN Accounting.dbo.Ref_BankAccount AS B ON R.BankId = B.BankId
						WHERE(TL.ParentJournal = '#getHeader.Journal#')
						<cfif ForPersonNo neq 0>
							AND TH.ReferencePersonNo = '#ForPersonNo#'
						</cfif>
						     AND TL.ParentJournalSerialNo = '#getHeader.JournalSerialNo#'
						     AND J.TransactionCategory IN('Memorial')
						     AND TL.Reference = 'Bank Charge'
						     AND EXISTS
						(
						    SELECT 'X' AS Expr1
						    FROM Employee.dbo.PersonGLedger AS PGL
						    WHERE(PersonNo = TH.ReferencePersonNo)
						         AND (Area = 'Payroll')
						)
					) AS BnkLines
					
					GROUP BY Type,
					         Journal,
					         JournalSerialNo,
					         GLAccount,
					         TransactionDate,
					         Created,
					         Reference,
					         ReferenceName,
					         PRogram,
					         Fund,
					         ProgramPeriod,
					         ProgramCode,
							 Objectcode,
					         Currency

					/***/	
					
					UNION ALL
					
						SELECT 3 AS type,
						       TH.Journal,
						       TH.JournalSerialNo,
						       TL.GLAccount,
						       TH.TransactionDate,
						       TH.Created,
						       TL.Reference,
						       TL.ReferenceName,
						       '' AS Program,
						       TL.Fund,
						       TL.ProgramPeriod,
						       TL.ProgramCode,
						       (CASE
						            WHEN TL.Reference = 'Payroll cost'
						            THEN GLAccount
						            ELSE ''
						        END) AS ObjectCode,
						       TL.Currency,
						       ROUND(SUM(TL.AmountDebit), 2) AS Debit,
						       ROUND(SUM(TL.AmountCredit), 2) AS Credit,
							   '0' personNo,
							   'XX' PayrollItem
							   
						FROM Accounting.dbo.TransactionHeader AS TH
						     INNER JOIN Accounting.dbo.TransactionLine AS TL ON TH.Journal = TL.Journal AND TH.JournalSerialNo = TL.JournalSerialNo
						WHERE TL.ParentJournal = '#getHeader.Journal#'
					    AND   TL.ParentJournalSerialNo = '#getHeader.JournalSerialNo#'
					    AND   TL.GlAccount != '#getSchedule.GlAccount#'
					    AND   NOT EXISTS (  SELECT 'X'
										    FROM   Employee.dbo.PersonGLedger PGL
										    WHERE  PGL.PersonNo = TH.ReferencePersonNo
						        			AND    Area = 'Payroll' )						
						
						<cfif ForPersonNo neq 0>
							AND TH.ReferencePersonNo = '#ForPersonNo#'
						</cfif>
											
						GROUP BY TH.Journal,
						         TH.JournalSerialNo,
						         TL.GLAccount,
						         TL.AccountPeriod,
						         TL.Reference,
						         TL.Currency,
						         TH.TransactionDate,
						         TH.Created,
						         TH.ReferencePersonNo,
						         TL.ProgramPeriod,
						         TL.ProgramCode,
						         TL.ObjectCode,
						         TL.ReferenceName,
						         TL.Fund  						 
								 		                                                                                                                               

						/*--- for the checks specifically  ---*/

						UNION ALL
						
						SELECT 4 AS type,
						       TH.Journal,
						       TH.JournalSerialNo,
								(
								    SELECT GLAccount
								    FROM Employee.dbo.PersonGLedger PGL
								    WHERE PGL.PersonNo = TH.ReferencePersonNo
								          AND Area = 'Payroll'
								) GLAccount,
						       TH.TransactionDate,
						       TH.Created,
						       TL.Reference,
						       TL.ReferenceName,
						       '' AS Program,
						       TL.Fund,
						       TL.ProgramPeriod,
						       TL.ProgramCode,
						       (CASE
						            WHEN TL.Reference = 'Payroll cost'
						            THEN GLAccount
						            ELSE ''
						        END) AS ObjectCode,
						       TL.Currency,
						       ROUND(SUM(TL.AmountDebit), 2) AS Debit,
						       ROUND(SUM(TL.AmountCredit), 2) AS Credit,
							   TH.ReferencePersonNo as personNo,
							   'XX' PayrollItem
						FROM Accounting.dbo.TransactionHeader AS TH
						     INNER JOIN Accounting.dbo.TransactionLine AS TL ON TH.Journal = TL.Journal
						                                                        AND TH.JournalSerialNo = TL.JournalSerialNo
						WHERE    TL.ParentJournal         = '#getHeader.Journal#'
						     AND TL.ParentJournalSerialNo = '#getHeader.JournalSerialNo#'
						     AND TL.GlAccount = '60101'
							 
						<cfif ForPersonNo neq 0>
							AND TH.ReferencePersonNo = '#ForPersonNo#'
						</cfif>
												
						GROUP BY TH.Journal,
						         TH.JournalSerialNo,
						         TL.GLAccount,
						         TL.AccountPeriod,
						         TL.Reference,
						         TL.Currency,
						         TH.TransactionDate,
						         TH.Created,
						         TH.ReferencePersonNo,
						         TL.ProgramPeriod,
						         TL.ProgramCode,
						         TL.ObjectCode,
						         TL.ReferenceName,
						         TL.Fund,
								 TH.ReferencePersonNo
								 
						ORDER BY GLAccount,
						         Program,
						         Debit

				</cfquery>
				
				
				
			
				<!--- BEGIN MISCELLANEOUS LOGIC ---->
				
				<cfquery name="getProgramPeriod" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT     *
						INTO       Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_B4Misc
						FROM       Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#
				</cfquery>				
				
				<cfquery name="getProgramPeriod" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT     M.PlanningPeriod
						FROM       Ref_MissionPeriod AS M INNER JOIN
			                       Program.dbo.Ref_Period AS P ON M.Period = P.Period
						WHERE      M.Mission = '#getHeader.Mission#' 
						AND        P.DateEffective  <= '#getHeader.TransactionDate#'
						AND        P.DateExpiration >= '#getHeader.TransactionDate#'
						AND	   	   P.isPlanningPeriod = '1'
				</cfquery>
								
				<cfquery name="qMisc" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT  DISTINCT <!--- read line  278 FROM Marian's email   ---->
								ESL.PersonNo ,
								1.2 AS Type, 
								ESL.Journal, 
								ESL.JournalSerialNo, 
								'820000' AS GlAccount, 
								PaymentDate as DateDue, 
								PaymentDate as DatePrepared,  
								'Offset' AS Reference,
								'' AS ReferenceName,
								'                   ' AS Program,
								(SELECT TOP 1 Fund
								 FROM Payroll.dbo.EmployeeSettlementLineFunding  ESLF
								 WHERE ESLF.PaymentId = ESL.PaymentId ) AS Fund,
								'                   '                   AS ProgramPeriod,
								(SELECT TOP 1 ProgramCode
								 FROM Payroll.dbo.EmployeeSettlementLineFunding  ESLF
								 WHERE ESLF.PaymentId = ESL.PaymentId)  AS ProgramCode,
								ESL.GlAccount                           AS ObjectCode,
								ESL.Currency,
								CASE WHEN ESL.PaymentAmount >=0 THEN 0 ELSE ABS(ESL.PaymentAmount) END as Debit,
								CASE WHEN ESL.PaymentAmount >=0 THEN ABS(ESL.PaymentAmount) ELSE 0 END as Credit
								
						INTO    Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_Misc
						FROM    Payroll.dbo.EmployeeSettlementLine ESL INNER JOIN Accounting.dbo.TransactionLine TL ON ESL.Journal  = TL.ParentJournal
								  	AND ESL.JournalSerialNo = TL.ParentJournalSerialNo
									AND ESL.PersonNo = TL.ReferenceNo
									AND TL.TransactionSerialNo = 0 
									
						WHERE   ESL.Source = 'Offset'
						AND     ESL.Journal 		  = '#getHeader.Journal#'
						AND     ESL.JournalSerialNo   = '#getHeader.JournalSerialNo#'						
						<cfif ForPersonNo neq 0>
						AND     ESL.PersonNo= '#ForPersonNo#'
						</cfif>
						
				</cfquery>
				
				<cfquery name="qMiscUpdate" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					UPDATE MISC
					SET    Program = ISNULL((SELECT  TOP 1 Reference
							         		 FROM       Program.dbo.ProgramPeriod
									         WHERE      ProgramCode = MISC.ProgramCode
									         AND        Period      = '#getProgramPeriod.PlanningPeriod#'),''),
						   ProgramPeriod = '#getProgramPeriod.PlanningPeriod#' 			
					FROM   Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_Misc MISC
					WHERE  Program = '' 
			    </cfquery>
								 
				 <!--- RFUENTES CHANGED on 15Jan2018
				 Accordingto Werner on email with subject Reconciliation of progen and prosis Marian did.
				 NOTHING that came from SUN must return as credit or debit to the budget, so here 
				 we initially collect the miscellaneous as Staff members account, here we DEDUCTED FROM
				 THE BUDGET AND SEND BACK TO SUN which is what he is trying to avoid --->

				 <!---      Marian...   advised to rever, so were are puting back this code --->
				 
				<cfquery name="qUpdateTotals" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					UPDATE TOT
					SET    Debit  = TOT.Debit  + MISC.Debit,
					       Credit = TOT.Credit + MISC.Credit
					FROM (
							SELECT   SUM(Debit)  as DEBIT, 
							         SUM(Credit) as CREDIT,
									 GLAccount,
									 Program,
									 Fund,
									 ProgramPeriod,
									 ProgramCode,
									 ObjectCode,
									 Currency,
									 PersonNo
									
							FROM     Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#_Misc
							GROUP BY GLAccount,
									 Program,
									 Fund,
									 ProgramPeriod,
									 ProgramCode,
									 ObjectCode,
									 Currency,
									 PersonNo
							) MISC	
								 
							INNER JOIN Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo# TOT
									ON MISC.GlAccount      = TOT.GlAccount 
									AND MISC.Program       = TOT.Program
									AND MISC.Fund          = TOT.Fund
									AND MISC.ProgramPeriod = TOT.ProgramPeriod
									AND Misc.ProgramCode   = TOT.ProgramCode
									AND MISC.ObjectCode    = TOT.ObjectCode
									AND MISC.Currency      = TOT.Currency
									AND MISC.PersonNo      = TOT.PersonNo
									
					WHERE   TOT.Reference NOT IN ( 'Internal','Liability')
			    </cfquery>	
				
												
				<!--- END MISCELLANEOUS LOGIC ---->
								
				<cfquery name="qUpdate" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE  TMP
					SET     Debit = Debit*-1 
					FROM    Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo# as TMP
					WHERE   EXISTS(SELECT 'XX' FROM Employee.dbo.PersonGLedger as PG WHERE PG.GLAccount = TMP.GLAccount AND PG.Area = 'Payroll') 
					AND     Type = '1'
				</cfquery>	

				<cfquery name="qUpdate" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE   M
					SET      M.GlAccount  = A.AccountLabel
					FROM     Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo# M
						     INNER JOIN Accounting.dbo.Ref_Account A	ON M.GlAccount = A.GlAccount
					WHERE    A.AccountLabel IS NOT NULL
				</cfquery>					

				<cfquery name="qCheck" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#
					WHERE    GlAccount = '599999999' 
				</cfquery>	
				
				<cfquery name="qFile" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#
						SET    DatePrepared = getDate()
				 </cfquery>
				
				<cfif qCheck.recordcount eq 0>
				
						<!--- Column 6 history, 
							by dev
							17/01/2018, please note the replacement statement 
							SUN expects 2017 as 217, 2018 as 218, 2029 as 229
							The reason for this is unknown at this time
							However, not complying with it creates issues so, PROSIS followed the same format
						--->
							
						<cfquery name="qFile" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT 
								GLAccount 																as Column1
								,CAST(YEAR(DateDue) as VARCHAR(4))
										+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
										+CAST(YEAR(DateDue) AS VARCHAR)
										+RIGHT('0'+cast(MONTH(DateDue)as varchar(2)),2)
										+RIGHT('0'+cast(DAY(DateDue)as varchar(2)),2)				    as Column2
								,'M' 																	as Column3
								,CASE WHEN (Debit - Credit)>=0 THEN 'D' ELSE 'C' END 					as Column4
								,'PAYPR' 																as Column5
								,       CAST(REPLACE(REPLACE(REPLACE(YEAR(DateDue),'201','21'),'202','22'),'203','23') as VARCHAR(4))
										+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			
										+'D#vFileNo#'													as Column6
								,CASE WHEN (Debit - Credit)>=0 THEN 'Salaries Paid by XFR' ELSE 'Salaries Due by XFR' END as column7
								,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
								,CONVERT(VARCHAR, DateDue, 112) 										as Column9
								,Currency 																as Column10
								,REPLACE(REPLACE(CAST((CAST(ABS(Debit - Credit) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') 				as Column11
								,CAST(Fund AS VARCHAR(5))                                               as Fund
								,CAST(Program as VARCHAR(10))                                           as Program
								,CAST(ProgramPeriod as VARCHAR(10))                                     as ProgramPeriod
								,CAST(ObjectCode as VARCHAR(10))                                        as ObjectCode
								,Type
								,PayrollItem
							FROM Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#
						</cfquery>		
																		
						<cfif ForPersonNo eq 0>
												
							<!--- 
							<cfset columnWidth = "15,17,33,2,10,15,25,15,54,5,37,34,11,14"> v0.1
							<cfset columnWidth = "15,17,33,2,10,15,25,15,54,5,40,34,11,14"> v0.2
							<cfset columnWidth = "15,17,33,2,10,15,25,15,54,5,37,35,12,15"> v0.3
							<cfset columnWidth = "15,17,33,2,10,15,25,15,54,5,37,35,12,15"> v0.4 - March 27 2019
							--->
							
							<cfset columnWidth = "15,17,33,2,10,15,25,15,54,5,37, 35,8,5,14,122">
							
							<cfset aWidth = ListToArray(columnWidth)>
							
							<cfsavecontent variable="PPost">
								<cfset crow = 0>
								<cfloop query="qFile"> 
										<cfif crow neq 0>
											<cfoutput>
											#Chr(13)##Chr(10)#
											</cfoutput>
										</cfif>	
										<cfset vColumn = 0>
										<cfset currentLine = "">
								        <cfloop from="1" to="11" index="i">
											<cfset value = Evaluate("Column#i#")>
											<cfif i eq 11>
												<cfset currentLine = "#currentLine##RJustify(value,aWidth[i])#">
											<cfelse>
												<cfset currentLine = "#currentLine##LJustify(value,aWidth[i])#">
											</cfif>
										</cfloop>
										<cfset costCols = "">
										<cfif qFile.Column1 eq "820000">
											<cfquery name="qFund" 
												datasource="AppsPayroll" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT Reference
												FROM Accounting.dbo.stFund
													WHERE Fund = '#qFile.Fund#' 
													AND Period = '#qFile.ProgramPeriod#' 
											</cfquery>
											<cfset costCols = "#RJustify(qFund.Reference,aWidth[12])##LJustify(' ',aWidth[13])##LJustify(qFile.Program,aWidth[14])##RJustify(qFile.ObjectCode,aWidth[15])#">
										</cfif>
										<cfif qFile.Type eq "1.2"> <!--- misc, must send the RSAL/RTEL --->
											<cfquery name="qMisc" 
												datasource="AppsPayroll" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT TOP 1 SunItem
													FROM Payroll.dbo.stMiscellaneous
													WHERE PayrollItem = '#qFile.PayrollItem#' 
											</cfquery>
											<cfset costCols = "#RJustify(qMisc.SunItem,aWidth[16])#">
										</cfif>
										
										<!---- we put all the logic to clean the line as if we call a function it will be out of the context and will spool the CR LF coming from the functin context ---->
										<cfset newLine = currentLine>
										<cfset newLine = replaceNoCase(newLine, chr(13), '','All')>
										<cfset newLine = replaceNoCase(newLine, chr(10), '','All')>
										
										<cfset costCols = replaceNoCase(costCols, chr(13), '','All')>
										<cfset costCols = replaceNoCase(costCols, chr(10), '','All')>
										
										<cfoutput>
											#newLine##costCols#
										</cfoutput>			
										<cfset crow = crow + 1>
								</cfloop>
								
							</cfsavecontent>  
			
							
							<cfif NOT DirectoryExists("#SESSION.rootDocumentPath#\GLTransaction\")>
									<cfset DirectoryCreate("#SESSION.rootDocumentPath#\GLTransaction\")>
							</cfif>
							
							<cfif NOT DirectoryExists("#SESSION.rootDocumentPath#\GLTransaction\#URL.TransactionId#\")>
									<cfset DirectoryCreate("#SESSION.rootDocumentPath#\GLTransaction\#URL.TransactionId#\")>
							</cfif>
			
			
							<cffile action="write" file="#SESSION.rootDocumentPath#\GLTransaction\#URL.TransactionId#\002_#getHeader.Journal#_#getHeader.JournalSerialNo#_PPost.dat" output="#PPost#"/> 
							
							<cffile action="write" file="D:\Xml\Prosis_PPost.txt" output="#PPost#"/> 					
			
							<cffile action="COPY" 
							source="#SESSION.rootDocumentPath#\GLTransaction\#URL.TransactionId#\002_#getHeader.Journal#_#getHeader.JournalSerialNo#_PPost.dat" 
							destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\002_#getHeader.Journal#_#getHeader.JournalSerialNo#_PPost.dat">			
						 	 
							<cf_assignid>	
							<cfset AttachmentId = rowguid>
							
							<cfquery name="qLogAttachment" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								INSERT INTO Attachment (AttachmentId,DocumentPathName, Server, ServerPath, FileName, FileStatus, Reference, OfficerUserId, OfficerLastName, OfficerFirstName)
								VALUES ('#AttachmentId#',
										'GLTransaction', 
										'#SESSION.rootdocumentpath#',
										'GLTransaction/#URL.TransactionId#/',
										'002_#getHeader.Journal#_#getHeader.JournalSerialNo#_PPost.dat',
										1,
										'#URL.TransactionId#', 
										'#SESSION.acc#',
										'#SESSION.last#',
										'#SESSION.first#')
							</cfquery>						
			
							<cfquery dbtype="query" name="qCounter">
								SELECT COUNT(1) as counter
								FROM qFile
							</cfquery>							
			
							<cfquery name="qSum" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   Currency, SUM(Debit) as Debit,SUM(Credit) as Credit
								FROM     Userquery.dbo.#SESSION.acc#SUN_#getHeader.Journal#_#getHeader.JournalSerialNo#
								WHERE    GLAccount like '520%'
								GROUP BY Currency
							</cfquery>							
			
							<cfloop query="qSum">
									<cfquery name="qLogFile" 
										datasource="AppsLedger" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										INSERT INTO stFile (AttachmentId,Records, Currency, Amount)
										VALUES (
										'#AttachmentId#',
										'#qCounter.Counter#', 
										'#qSum.Currency#',
										'#qSum.Debit#')
									</cfquery>		
							</cfloop>
						<cfset varToReturn = "files generated">
						<cfelse>   <!--- must show in the screen as an html output --->

							<cfsavecontent variable = "returnHTML"> 
							
								<table class="formpadding navigation_table" width="100%">
								<tr class="labelmedium line">
								<td>Column01</td>
								<td>Column02</td>
								<td>Column03</td>
								<td>Column04</td>
								<td>Column05</td>
								<td>Column06</td>
								<td>Column07</td>
								<td>Column08</td>
								<td>Column09</td>
								<td>Column10</td>
								<td>Column11</td>
								<td>Fund</td>
								<td>Program</td>
								<td>ProgramPeriod</td>
								<td>ObjectCode</td>
								</tr>
								
								<cfloop query="qFile"> 
									<cfoutput>
										<tr class="labelit navigation_row" >
											<td><cfif Column1 eq "050002N">050002<cfelse>#Column1#</cfif></td>
											<td>#Column2#</td>
											<td>#Column3#</td>
											<td>#Column4#</td>
											<td>#Column5#</td>
											<td>#Column6#</td>
											<td>#Column7#</td>
											<td>#Column8#</td>
											<td>#Column9#</td>
											<td>#Column10#</td>
											<td>#Column11#</td>
											<td>#Fund#</td>
											<td>#Program#</td>
											<td>#ProgramPeriod#</td>
											<td>#ObjectCode#</td>
										</tr>
									</cfoutput>
								</cfloop> 
								</table>
							</cfsavecontent>

						<cfset varToReturn = "#returnHTML#">
						</cfif>
						
				<cfelse>
				
						<cfset varToReturn =""> 
						<cfoutput>
						<table width="100%">
							<tr>
								<td align="center" colspan="6" style="color:red">
									<img src="#client.root#/images/warning.png">
									<br>
									The following transactions are not linked to an account.
									<br>
									File was NOT generated
								</td>
							</tr>
							<tr height="20px">
								<td colspan="6">	
									&nbsp;&nbsp;  
								</td>
							</tr>

							<tr style="font-weight:bold">
								<td width="10%">
									Journal-SerialNo
								</td>			
								<td width="10%">
									Reference
								</td>	
								<td width="10%">
									Reference Name
								</td>	
								<td width="10%">
									Currency
								</td>	
								<td width="10%" align="right">
									Debit
								</td>	
								<td width="10%" align="right">
									Credit
								</td>															
							</tr>
						
							<cfloop query="qCheck">
								<tr>
									<td width="10%">
										#qCheck.Journal#-#qCheck.JournalSerialNo#
									</td>			
									<td width="10%">
										#qCheck.Reference#
									</td>	
									<td width="10%">
										#qCheck.ReferenceName#
									</td>	
									<td width="10%">
										#qCheck.Currency#
									</td>	
									<td width="10%" align="right">
										#NumberFormat(qCheck.Debit,"____,____.__")#
									</td>	
									<td width="10%" align="right">
										#NumberFormat(qCheck.Credit,"____,____.__")#
									</td>															
								</tr>
							</cfloop>
							
						</table>
						</cfoutput>
				</cfif>	
		</cfif>
		<cfreturn varToReturn>
	</cffunction>
	
	<cffunction name="genSUNFileOffCycle"
             access="public"
             returntype="string"
             displayname="genSUNFileOffCycle">
			 
			 <!--- ----------general structure -----------  ----->
			 <!--- builds SUNS structure as follows  		----->
			 <!--- 											----->
			 <!--- Payroll Costs (budget)		XXX			----->
			 <!--- Payroll Costs Misc (budget)	XXX			----->
			 <!--- Provision Payable				XXX		----->
			 <!--- Provision (Misc)					XXX		----->
			 <!--- Provision Insurance				XXX		----->
			 <!--- Provision Pension				XXX		----->
			 <!--- 											----->
 			 <!--- Provision Patable			XXX			----->
 			 <!--- Bank Transfer					XXX		----->
 			 <!--- 											----->
			 <!--- ----------general structure -----------  ----->
		
		<cfargument name="ForPersonNo"       	type="string" required="true">
		<cfargument name="ForPeriod"	       	type="string" required="true">
		<cfargument name="ForMission"       	type="string" required="true">
		<cfargument name="ForSchedule"       	type="string" required="true">
		<cfargument name="ForSettlements"      	type="string" required="true">
		<cfargument name="ForGlAccount"       	type="string" required="true">
		
		<cfset tOwner = "0">
				
		<cfset refno = "Final">
			
		<!---defining the tmp table, as we want to use the same DoSUN logic instead of rewriting it ---->
		
		<cfset tmptbl_PC 	= "tmp_paycost_lines_#SESSION.acc#_FinalPay_#ForPersonNo#">
		<CF_DropTable dbName="AppsQuery" tblName="#tmptbl_PC#">
			
		<cfset tmptbl_AP 	= "tmp_payable_lines_#SESSION.acc#_FinalPay_#ForPersonNo#">
		<CF_DropTable dbName="AppsQuery" tblName="#tmptbl_AP#">
			
		<cfset tmptbl_Off 	= "tmp_offset_lines_#SESSION.acc#_FinalPay_#ForPersonNo#">
		<CF_DropTable dbName="AppsQuery" tblName="#tmptbl_Off#">
		
				
		<!---- preparing the tmp tables for the PC table --->
		
		<cfquery name="PayrollLines" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				
				SELECT Origin,PayrollItem,
				         SalarySchedule,PaymentYear,
						 PaymentMonth, 
						 DateDue, 
						 DatePrepared,
						 Currency,
						 ProgramCode,
						 Fund, 
						 ProgramPeriod,
						 ObjectCode,
						 Glaccount, 
						 PayrollItemSource,
						 PostingAmount as Debit, 
						 0 as Credit,  <!--- credit = always 0 can can simplify this --->
						 PaymentAmount,
						 PersonNo, 
						 GLaccountLiability,
						 ( 	SELECT     TOP 1 Reference
							FROM       Program.dbo.ProgramPeriod
							WHERE      ProgramCode = LineA.ProgramCode
							AND        Period      = LineA.ProgramPeriod		
							AND  	   Status!='9'
							ORDER BY   Created DESC ) as Program,
						 Source

				INTO 	 userQuery.dbo.#tmptbl_PC# 

				FROM	(
					SELECT    'PC' origin,T.SalarySchedule, 							          
							  T.PaymentYear, 
							  T.PaymentMonth, 
							  T.Currency,		
							  PF.ProgramCode, 
							  PF.Fund,
							  '#ForPeriod#' as ProgramPeriod,									   
							  ObjectCode, 
							  CASE WHEN T.PayrollItem IN ('D03')  THEN T.GLaccountLiability ELSE GLAccount END	AS GLAccount,
							  CASE WHEN T.PayrollItem IN ('D03')  THEN GLAccount ELSE T.GLaccountLiability END	AS GLaccountLiability,
							  ESET.PaymentDate as DateDue,
							  CAST(T.Created as DATE) as DatePrepared,
							  T.PayrollItem, 
							  I.Source as PayrollItemSource,
							  T.PersonNo,
							  T.Source,
							  <!--- adjustment for the Ded. dep. gorvernment ---->
							  CASE WHEN T.PayrollItem IN ('D03') THEN ROUND(SUM(PaymentAmount*PF.Percentage), 2) 
							                                     ELSE ROUND(SUM(Amount*PF.Percentage),2) END as PostingAmount,
							  ROUND(SUM(PaymentAmount*PF.Percentage),2) as PaymentAmount							 
							  
					FROM      Payroll.dbo.EmployeeSettlementLine T 
							  INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
							  	ON 	T.PersonNo 				= ESET.PersonNo
								AND T.SalarySchedule 		= ESET.SalarySchedule
								AND T.Mission 				= ESET.Mission
								AND T.PaymentDate 			= ESET.PaymentDate
								AND T.PaymentStatus 		= ESET.PaymentStatus
								AND ESET.PaymentStatus 	 	IN ('1')
							  INNER JOIN Payroll.dbo.EmployeeSettlementLineFunding PF ON PF.PaymentId = T.PaymentId
							  INNER JOIN Payroll.dbo.Ref_PayrollItem I ON T.Payrollitem = I.PayrollItem
							  
					WHERE     T.Mission            = '#ForMission#' 					
					AND       T.SalarySchedule     = '#ForSchedule#'
					AND       ESET.PaymentDate IN (
			  						  SELECT     PaymentDate
								      FROM       Payroll.dbo.EmployeeSettlement ES
									  WHERE      SettlementId IN (#preserveSingleQuotes(ForSettlements)#)
								     ) 
									
					AND       T.SettlementPhase    = 'Final'
					AND 	  T.PersonNo 		   = '#ForPersonNo#'							      
					GROUP BY  T.SalarySchedule, 							          
							  PF.ProgramCode, 
							  PF.Fund, 
							  ObjectCode, 
							  PaymentYear, 
							  Currency,
							  PaymentMonth, 
							  GLAccount,
							  I.Source,
							  T.GLaccountLiability,
							  ESET.PaymentDate,
							  CAST(T.Created as DATE),
							  T.PayrollItem,
							  T.personNo,
							  T.source
							  
					UNION ALL   
					
					<!--- not exist in funding provision --->
	
					SELECT    'PC' origin,
					          T.SalarySchedule, 							          
							  T.PaymentYear, 
							  T.PaymentMonth, 
							  T.Currency,		
							  '' as ProgramCode, 
							  '' as Fund,
							  '' as ProgramPeriod,	 
							  ObjectCode,
							  <!--- switch the accounts for the ded. dep. govnmtn grant. as it has to reduce the salary --->
							  CASE WHEN T.PayrollItem IN ('D03') THEN T.GLaccountLiability ELSE GLAccount END	AS GLAccount,
							  CASE WHEN T.PayrollItem IN ('D03') THEN GLAccount	ELSE T.GLaccountLiability END	AS GLaccountLiability,
							  ESET.PaymentDate as DateDue,
							  CAST(T.Created as DATE) as DatePrepared,
							  T.PayrollItem,
							  I.Source as PayrollItemSource,
							  T.PersonNo,
							  T.Source,
							  CASE WHEN T.PayrollItem IN ('D03') THEN ROUND (SUM(PaymentAmount), 2) ELSE ROUND(SUM(Amount), 2) END AS PostingAmount,
							  ROUND(SUM(Amount),2) as PaymentAmount
							  
					FROM      Payroll.dbo.EmployeeSettlementLine T
							  INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
								ON 	T.PersonNo 			  = ESET.PersonNo
								AND T.SalarySchedule 	  = ESET.SalarySchedule
								AND T.Mission 			  = ESET.Mission
								AND T.PaymentDate 		  = ESET.PaymentDate
								AND T.PaymentStatus 	  = ESET.PaymentStatus
								AND ESET.PaymentStatus IN ('1')
								INNER JOIN Payroll.dbo.Ref_PayrollItem I ON T.Payrollitem = I.PayrollItem
								
					WHERE     T.Mission            = '#ForMission#' 					
					AND       T.SalarySchedule     = '#ForSchedule#'
					AND       ESET.PaymentDate     IN (SELECT     PaymentDate
												       FROM       Payroll.dbo.EmployeeSettlement ES
													   WHERE      SettlementId IN (#preserveSingleQuotes(ForSettlements)#)
					)
					AND       T.SettlementPhase    = 'Final'
					AND 	  T.PersonNo 		   = '#ForPersonNo#'
					AND       T.GLAccount         != '#ForGLAccount#'
					AND       NOT EXISTS (SELECT 'X' 
					                      FROM   Payroll.dbo.EmployeeSettlementLineFunding 
										  WHERE  PaymentId = T.PaymentId)
										  
					GROUP BY  T.SalarySchedule, 							          
							  ObjectCode, 
							  T.PaymentYear, 
							  T.Currency,
							  PaymentMonth, 
							  GLAccount,
							  I.Source,
							  T.GLaccountLiability,
							  ESET.PaymentDate,
							  CAST(T.Created as DATE),
							  T.PayrollItem,
							  T.personNo,
							  T.Source	
						  							  
				   ) as LineA  
				   
				  

		</cfquery>
		
		
		<cfquery name="Persons" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT     P.PersonNo, 
				           LastName, 
						   FirstName, 											   											   
						   '#ForGLAccount#' AS GLAccountLiability,	
						   L.PaymentDAte as DateDue,
						   CAST(L.Created as DATE) as DatePrepared,
						   L.Currency,										
				           ROUND(SUM(PaymentAmount), 2) AS PaymentAmount
					
				INTO 	   userQuery.dbo.#tmptbl_AP#

				FROM       Payroll.dbo.EmployeeSettlementLine as L 									          															
						 	INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
								ON 	L.PersonNo 				= ESET.PersonNo
								AND L.SalarySchedule 		= ESET.SalarySchedule
								AND L.Mission 				= ESET.Mission
								AND L.PaymentDate 			= ESET.PaymentDate
								AND L.PaymentStatus			= ESET.PaymentStatus
								AND ESET.PaymentStatus 	 	IN ('1')
								AND L.PersonNo 				= '#ForPersonNo#'
						   INNER JOIN Employee.dbo.Person P ON P.PersonNo  = L.PersonNo
						   
				WHERE      L.Mission         = '#ForMission#' 					
				AND        L.SalarySchedule  = '#ForSchedule#'
				AND        ESET.PaymentDate      IN (SELECT     PaymentDate
					     							 FROM       Payroll.dbo.EmployeeSettlement ES
						 							 WHERE      SettlementId IN (#preserveSingleQuotes(ForSettlements)#)) 
				
				AND        (L.GLAccount      = '#ForGLAccount#' OR L.GLAccountLiability = '#ForGLAccount#')
				
				AND         L.SettlementPhase = 'Final'
				
				GROUP BY    P.PersonNo,
				            LastName, 
							FirstName,
							L.PaymentDate,
							CAST(L.Created as DATE),
							L.Currency   
		</cfquery>

		<cfquery name="offset" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT     ESD.SalaryScheduleGLAccount, 
				           ESD.PayThroughGLAccount, 
						   ESD.PayThroughBankName, 
						   ESD.PaymentCurrency as Currency, 
						   ESD.PersonNo,
						   ESET.PaymentDate as DateDue,
						   CAST(ESET.Created as DATE)        as  DatePRepared,
						   ROUND(ESD.PaymentExchangeRate, 6) as  ExchRate,
						   ROUND(SUM(ESD.PaymentAmount), 2)  as  PaymentAmount
				INTO 	   userQuery.dbo.#tmptbl_Off#
				FROM       Payroll.dbo.EmployeeSettlementDistribution AS ESD
						   INNER JOIN 	Payroll.dbo.EmployeeSettlement as ESET
							ON 	ESD.PersonNo 			= ESET.PersonNo
							AND ESD.SalarySchedule 		= ESET.SalarySchedule
							AND ESD.Mission 			= ESET.Mission
							AND ESD.PaymentDate 		= ESET.PaymentDate
							AND ESD.PaymentStatus 		= ESET.PaymentStatus
							AND ESET.PaymentStatus 	 	IN ('1')
							AND ESD.PersonNo 			= '#ForPersonNo#'
				
				WHERE      ESD.Mission          = '#ForMission#' 					
				AND        ESD.SalarySchedule   = '#ForSchedule#'
				AND        ESD.PaymentDate     IN (SELECT     PaymentDate
					                               FROM       Payroll.dbo.EmployeeSettlement ES
						                           WHERE      SettlementId IN (#preserveSingleQuotes(ForSettlements)#)) 	
				AND        ESD.SettlementPhase  = 'Final'		
											
				GROUP BY   ESD.SalaryScheduleGLAccount, 
				           ESD.PayThroughGLAccount, 
						   ESD.PayThroughBankName, 
						   ESD.PaymentCurrency,
						   ESD.PersonNo,
						   ESET.PaymentDate,
						   CAST(ESET.Created as DATE),
						   ROUND(ESD.PaymentExchangeRate, 6)	
						   
		</cfquery>
		
		
		<!---- as per Marians request on may 2019 all the lines must be genrated based on the MAX date of the calculations, to avoid many lines ---->
		
		<cfquery name="maxDateUPD" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 UPDATE userQuery.dbo.#tmptbl_Off#
			 SET DatePrepared = (
			 	SELECT MAX(A.DatePrepared) FROM (
					SELECT DatePrepared 	FROM 	userQuery.dbo.#tmptbl_Off#
					UNION
					SELECT DatePrepared 	FROM 	userQuery.dbo.#tmptbl_AP#
					UNION
					SELECT DatePrepared 	FROM 	userQuery.dbo.#tmptbl_PC#
				) as A
			 )
			
			UPDATE userQuery.dbo.#tmptbl_AP#
			 SET DatePrepared = (
			 	SELECT MAX(DatePrepared) DatePrepared 	FROM 	userQuery.dbo.#tmptbl_Off#	
			 )
			 
			 UPDATE userQuery.dbo.#tmptbl_PC#
			 SET DatePrepared = (
			 	SELECT MAX(DatePrepared) DatePrepared 	FROM 	userQuery.dbo.#tmptbl_Off#	
			 )
			
		</cfquery>     
		
		<!----- now getting the last query ---->
		<cfquery name="finalResult" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">

			SELECT ISNULL((SELECT LEFT(PrintDescription,25) FROM Payroll.dbo.Ref_PayrollItem where PayrollItem = tmp1.PayrollItem ),'') as Column0,
				   '1' as order_,
				   CASE WHEN tmp1.PayrollItem IN ('M30','M20')	THEN 
					(SELECT GLAccount FROM EMployee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = tmp1.PErsonNo )
				ELSE '820000'
				END 																    as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				,CASE WHEN (Debit - Credit)>=0 THEN 'D' ELSE 'C' END 					as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			    as Column6
				,CASE WHEN (Debit - Credit)>=0 THEN 'Salaries Paid by XFR' ELSE 'Salaries Due by XFR' END as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(Debit - Credit) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') 				as Column11
				,Fund,
				TMP1.program,
				TMP1.ProgramPeriod,
				TMP1.glaccount as Objectcode 
				
			FROM	  userQuery.dbo.#tmptbl_PC# as tmp1 
			          INNER JOIN Accounting.dbo.Ref_Account as ref ON ref.GlAccount = tmp1.Glaccount
					  
			WHERE 	  Ref.Description NOT LIKE '%of HPE on SEPARATION%'
				AND   	Ref.Description NOT LIKE '%REPATRIATION GRANT%'
				AND     (
							(tmp1.GLaccountLiability NOT IN ('4021','4022','4023','4024','4025','4026') /*prov MIP*/ 
							AND     tmp1.GLAccount NOT IN ('2131','2231','2164','2264')/*MIP Deductions*/
							)
							OR tmp1.GLAccount IN ('2131','2231','2164','2264')/*MIP Deductions*/
						)
				AND     (
							(tmp1.GLaccountLiability NOT IN ('4041','4042','4043','4044','4045','4046')/*prov pens*/
							AND 	tmp1.GLaccount NOT IN ('2125','2225','2162','2262')
							)
							OR tmp1.GLaccount IN ('2125','2225','2162','2262')
						)
				AND tmp1.PayrollItem NOT IN ('M23')

		<!--- portion for the MIP/PENS provision ---->
		
		UNION ALL
		
		SELECT	'MIP Provision' as Column0,
				'1' as order_,
				'530002' 																as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				, CASE WHEN Total >= 0 THEN 'C' ELSE 'D' END          			        as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)				as Column6
				,'Salaries Due by XFR' 													as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(Total) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') 				as Column11
				,'' Fund,
				'' as Program,
				'' ProgramPeriod,
				'' Objectcode
				
		FROM	(SELECT  DateDue,
		                 DatePrepared,
						 Currency,
						 ProgramCode,
						 ProgramPeriod,
						 ObjectCode,
						 SUM(CASE WHEN PayrollItemSource = 'Deduction' THEN PaymentAmount*-1 ELSE PaymentAmount END) as Total
						
						<!--- this code is not correct as it does ABS everywhere and you can have amount 
						SUM(ABS(Debit)-ABS(Credit)) as Total,  <!--- provision for insurance, not sure if this query is correct as you can have corrections --->
						--->
						
				FROM     userQuery.dbo.#tmptbl_PC# as TMP11
				WHERE    tmp11.GLaccount IN ('2131','2231','2264')/*MIP Deductions*/
				OR       tmp11.GLaccountLiability IN ('4021','4022','4023','4024','4025','4026') /*prov MIP*/
				GROUP BY DateDue,
				         DatePrepared,
						 Currency,
						 ProgramCode,
						 ProgramPeriod,
						 ObjectCode ) as TMP1
		
		UNION ALL
		
		SELECT	'PF Provision' as Column0,
				'1' as order_,
				'530001' 																as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				,'C' 																	as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			    as Column6
				,'Salaries Due by XFR'  as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(Total_) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') 				as Column11
				,'' Fund,
				'' Program,
				'' ProgramPeriod,
				'' Objectcode
		FROM	(
					SELECT DateDue,DatePrepared,
						Currency,
						ProgramCode,
						ProgramPeriod,
						ObjectCode,
						SUM(ABS(Debit)-ABS(Credit)) as Total_
				FROM   userQuery.dbo.#tmptbl_PC# as TMP11
				WHERE 1=1
				AND    tmp11.GLaccount IN ('2125','2225','2162','2262')/*PF Deductions*/
				OR     tmp11.GLaccountLiability IN ('4041','4042','4043','4044','4045','4046') /*prov PF*/
				GROUP BY DateDue,DatePrepared,
						Currency,
						ProgramCode,
						ProgramPeriod,
						ObjectCode
		) as tmp1
		<!----specifically to avoid REP. GRANT and Household Personnal Entitlement to be as Cost; must Debit the Personnal account --->
	UNION ALL
	
		SELECT 	'++Personnel Cost: '+LEFT(REf.Description,15) as Column0,
	  			'2' as order_,
				(SELECT GLAccount FROM EMployee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = tmp1.PErsonNo )as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				, 'D'                                                                   as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			    as Column6
				,'Salaries Paid by XFR' as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(tmp1.Debit-tmp1.Credit) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') 				as Column11
				,'' Fund,
				'' Program,
				'' ProgramPeriod,
				'' Objectcode
		FROM	userQuery.dbo.#tmptbl_PC# as tmp1
		INNER JOIN Accounting.dbo.Ref_Account as ref	ON ref.GlAccount = tmp1.Glaccount
		WHERE 			REf.Description LIKE '%of HPE on SEPARATION%'
				OR   	REf.Description LIKE '%REPATRIATION GRANT%'
		
	<!----finishes for Werner on 08Jun2018 --- Rep. Grant, HPE --->	
		
	UNION ALL
	
		SELECT  '' as Column0,
	  			'2' as order_,
				(SELECT GLAccount FROM EMployee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = tmp1.PersonNo )as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				, 'D' as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			    as Column6
				,'Salaries Paid by XFR' as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(PaymentAmount) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') 	as Column11
				,'' Fund,
				'' Program,
				'' ProgramPeriod,
				'' Objectcode
		FROM	userQuery.dbo.#tmptbl_AP# as tmp1

		UNION ALL
		
		SELECT 	'' as Column0,
	  			'2' as order_,
				(SELECT GLAccount FROM Employee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = tmp1.PErsonNo )as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				, 'C' as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			    as Column6
				,'Salaries Due by XFR' as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(PaymentAmount) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') as Column11
				,'' Fund,
				'' Program,
				'' ProgramPeriod,
				'' Objectcode
		FROM	userQuery.dbo.#tmptbl_AP# as tmp1

		UNION ALL
		
		SELECT 
				'@'+STR(ExchRate, 9, 7)  as Column0,
	  			'3' as order_,
				PayThroughGLAccount as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				, 'C' as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			    as Column6
				,'Salaries Paid by XFR' as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(PaymentAmount) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') as Column11
				,'' Fund,
				 '' Program,
				 '' ProgramPeriod,
				 '' Objectcode
		FROM	userQuery.dbo.#tmptbl_off#
				
		UNION ALL
		
		SELECT  CASE WHEN tmp1.Source = 'Internal' THEN
					ISNULL((SELECT LEFT(PrintDescription,25)+' [Reg. Misc]' FROM Payroll.dbo.Ref_PayrollItem where PayrollItem = tmp1.PayrollItem ),'') 
				ELSE
					ISNULL((SELECT LEFT(PrintDescription,25)+' [Rcvry. Misc]' FROM Payroll.dbo.Ref_PayrollItem where PayrollItem = tmp1.PayrollItem ),'')
				END as Column0,
				'3' as order_,
				CASE WHEN tmp1.Source ='Internal' THEN
					<!--- misc that is manually, not coming from SUN  must be cost reducted--->
						'820000'
					ELSE
					<!--- means this is offset from SUN ---->
						(SELECT GLAccount FROM EMployee.dbo.PersonGLedger WHERE Area ='Payroll' and PersonNo = tmp1.PErsonNo )				
					END 																											as Column1
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+'-'+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)
						+CAST(YEAR(DatePrepared) AS VARCHAR)
						+RIGHT('0'+cast(MONTH(DatePrepared)as varchar(2)),2)
						+RIGHT('0'+cast(DAY(DatePrepared)as varchar(2)),2)				as Column2
				,'M' 																	as Column3
				,CASE WHEN (Debit - Credit)>=0 THEN 'D' ELSE 'C' END 					as Column4
				,'PAYPR' 																as Column5
				,CAST(YEAR(DateDue) as VARCHAR(4))
						+RIGHT('0'+CAST(MONTH(DateDue) as VARCHAR(2)),2)			as Column6
				,CASE WHEN (Debit - Credit)>=0 THEN 'Salaries Paid by XFR' ELSE 'Salaries Due by XFR' END as column7
				,CONVERT(VARCHAR, DatePrepared, 112) 									as Column8
				,CONVERT(VARCHAR, DateDue, 112) 										as Column9
				,Currency 																as Column10
				,REPLACE(REPLACE(CAST((CAST(ABS(Debit - Credit) as DECIMAL(25,2))) as VARCHAR(25))+'02',',',''),'.','') 				as Column11
				,Fund,
				TMP1.program,
				TMP1.ProgramPeriod,
				TMP1.glaccount as Objectcode
		FROM	userQuery.dbo.#tmptbl_PC# as tmp1 INNER JOIN Accounting.dbo.Ref_Account as ref ON ref.GlAccount = tmp1.Glaccount
		WHERE 	1=1
		AND     TMP1.PayrollItem IN ('M23')

		ORDER BY 14,15,16 ASC, 2 DESC	

		</cfquery>
		
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE  Payroll.dbo.PersonOvertime
		    SET     Status = '5'
		    FROM    Payroll.dbo.PersonOvertime T	
			WHERE   OvertimeId IN (SELECT ReferenceId 
			                       FROM   Payroll.dbo.EmployeeSalaryLine
								   WHERE  ReferenceId = T.OvertimeId)
			AND     OvertimePayment = 1				   	
		</cfquery>
		
		<!--- now preparing the file, once the above query contains the details for the ppost file
		columnWidth = "15,17,33,2,10,15,25,15,54,5,37,35,12,15 -  May 10 2019
		--->
		
		<cfset columnWidth = "15,17,33,2,10,15,25,15,54,5,37,35,8,5,14,122">
		<cfset aWidth = ListToArray(columnWidth)>
		
		<cfsavecontent variable="PPost">
		
			<cfset crow = 0>
		
			<cfloop query="FinalResult"> 
				<cfif crow neq 0>
					<cfoutput>
						#Chr(13)##Chr(10)#
					</cfoutput>
				</cfif>	
				<cfset vColumn = 0>
				<cfset currentLine = "">
				
				<cfloop from="1" to="11" index="i">
				
						<cfset value = Evaluate("Column#i#")>						
						<cfif i eq "1" and value eq "050002N">
							<cfset value = "050002">						
						</cfif>
						
						<cfif i eq 11>
							<cfset currentLine = "#currentLine##RJustify(value,aWidth[i])#">
						<cfelse>
							<cfset currentLine = "#currentLine##LJustify(value,aWidth[i])#">
						</cfif>
						
				</cfloop>
					<cfset costCols = "">
					<cfif FinalResult.Column1 eq "820000">
						<cfquery name="qFund" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT Reference
							FROM Accounting.dbo.stFund
							WHERE Fund = '#FinalResult.Fund#' 
							AND Period = '#FinalResult.ProgramPeriod#' 
						</cfquery>
						<!---  <cfset costCols = "#RJustify(qFund.Reference,aWidth[12])##RJustify(FinalResult.Program,aWidth[13])##RJustify(FinalResult.ObjectCode,aWidth[14])#"> 
						costCols = "#RJustify(qFund.Reference,aWidth[12])##RJustify(FinalResult.Program,aWidth[13])##RJustify(FinalResult.ObjectCode,aWidth[14])#" May 10 2019
						--->
						<cfset costCols = "#RJustify(qFund.Reference,aWidth[12])##LJustify(' ',aWidth[13])##LJustify(FinalResult.Program,aWidth[14])##RJustify(FinalResult.ObjectCode,aWidth[15])#">
					</cfif>
						
						<!---- we put all the logic to clean the line as if we call a function it will be out of the context and will spool the CR LF coming from the functin context ---->
					<cfset newLine = currentLine>
					<cfset newLine = replaceNoCase(newLine, chr(13), '','All')>
					<cfset newLine = replaceNoCase(newLine, chr(10), '','All')>
					
					<cfset costCols = replaceNoCase(costCols, chr(13), '','All')>
					<cfset costCols = replaceNoCase(costCols, chr(10), '','All')>
						
					<cfoutput>
						#newLine##costCols#
					</cfoutput>			
					<cfset crow = crow + 1>
			</cfloop>
			</cfsavecontent>  
			
		<!---- producing the html to send back --->
		<cfsavecontent variable="varToReturn">
		
		<!--- showing the details ---->
		<table width="96%" align="center">
		<tr><td height="14px"></td></tr>
		<tr class="line">
			<td></td>
			<td>Column1</td>
			<td>Column2</td>
			<td>Column3</td>
			<td>Column4</td>
			<td>Column5</td>
			<td>Column6</td>
			<td>Column7</td>
			<td>Column8</td>
			<td>Column9</td>
			<td>Column10</td>
			<td>Column11</td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<cfloop query ="finalResult" >
			<cfoutput>
				<tr class="line">
				<td width="18%" align="left">#Column0#</td>
				<td align="left"><cfif Column1 eq "050002N">050002<cfelse>#Column1#</cfif></td>
				<td align="left">#Column2#</td>
				<td>#Column3#</td>
				<td>#Column4#</td>
				<td>#Column5#</td>
				<td>#Column6#</td>
				<td>#Column7#</td>
				<td>#Column8#</td>
				<td>#Column9#</td>
				<td>#Column10#</td>
				<td align="right" style="padding-right:10px">#Column11#</td>
				<cfif FinalResult.Column1 eq "820000">
					<cfquery name="qFund" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT Reference
						FROM Accounting.dbo.stFund
						WHERE Fund = '#FinalResult.Fund#' 
						AND Period = '#FinalResult.ProgramPeriod#' 
					</cfquery>
						<td>#qFund.Reference#</td>
						<td>#Program#</td>
						<td>#ObjectCode#</td>
					<cfelse>
						<td></td>
						<td></td>
						<td></td>
				</cfif>
				</tr>
			</cfoutput>
		</cfloop>
		</table>
		
		</cfsavecontent>
		
		<cfif NOT DirectoryExists("#SESSION.rootDocumentPath#\FinalPaySun\")>
			<cfset DirectoryCreate("#SESSION.rootDocumentPath#\FinalPaySun\")>
		</cfif>
		<cffile action="write" file="#SESSION.rootDocumentPath#\FinalPaySun\Prosis_PPost_#ForSchedule#_#ForPersonNo#.txt" output="#PPost#"/>
			
		<cfreturn varToReturn>
	</cffunction>
	
</cfcomponent>
