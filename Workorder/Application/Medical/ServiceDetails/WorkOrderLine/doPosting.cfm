
<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *, C.PersonNo as ApplicantNo
		FROM   WorkOrder W, 
		       WorkOrderLine WL,
			   Customer C
		WHERE  W.WorkOrderId   = WL.WorkOrderId
		AND    WorkOrderLineId = '#url.workorderlineid#'				
		AND    C.CustomerId = W.CustomerId
</cfquery>	

<!--- set status of the line as billed, so it can no longer be edited for its provisioing --->

<!--- gives the first period which is open of which the expiration date is higer or equest to the encounter --->

<cfquery name="Parameter" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	 TOP 1 *
		FROM 	 Ref_ParameterMission
		WHERE 	 Mission = '#get.mission#'		
</cfquery>	

<cfquery name="Posting" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
		FROM      ServiceItemMissionPosting  		     
		WHERE     ServiceItem = '#get.ServiceItem#'
		AND       Mission     = '#get.Mission#'
		ORDER BY SelectionDateExpiration DESC
</cfquery>	

<cfquery name="getPeriod" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	 TOP 1 *
		FROM 	 Period
		WHERE 	 ActionStatus   = '0'
		AND		 PeriodDateEnd >= '#get.DateEffective#'
		ORDER BY PeriodDateStart
</cfquery>	

<cfquery name="getService" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	  M.*,
				  S.Description 
		FROM      ServiceItem S INNER JOIN ServiceItemMission M ON M.ServiceItem = S.Code  		
		WHERE     M.ServiceItem = '#get.ServiceItem#'
		AND 	  M.Mission     = '#get.mission#'		
		AND       M.Operational = 1		
		AND       (M.DateChargesCalculate is NULL OR DateChargesCalculate < '#get.DateEffective#')		
</cfquery>	
		
<cfif getService.recordcount eq "0">
	
		<table><tr><td class="labelmedium">Receivable posting has been disabled for this service. Please contact your administrator</td></tr></table>
		
		<cfabort>
	
</cfif>		

<!--- Generate billing --->

<cftransaction>

	<!--- reprocess the COGS --->

	<cfinclude template="doCOGS.cfm">

	<!--- Generate different invoices by owner and destination --->
		
	<cfquery name="Parameter" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	 TOP 1 *
			FROM 	 Ref_ParameterMission
			WHERE 	 Mission = '#get.mission#'		
	</cfquery>	
		
	<cfquery name="ListBilling" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    Currency,
		          OrgUnitOwner, 
		          OrgUnitCustomer, 
				  TransactionDate,
				  ROUND(SUM(SalePayable),2) AS Total
				  
		FROM      WorkOrder.dbo.WorkOrderLineCharge C
		WHERE     C.WorkOrderid   = '#get.WorkOrderid#' 
		AND       C.WorkOrderLine = '#get.WorkOrderLine#' 
		AND       C.Journal   is NULL
		AND       EXISTS (SELECT 'X' 
		                  FROM   Accounting.dbo.Ref_Account 
						  WHERE  GLAccount = C.GLAccountCredit)
						  
		GROUP BY  Currency,
		          OrgUnitOwner, 
				  OrgUnitCustomer,
				  TransactionDate	
				  
		HAVING    ROUND(SUM(SalePayable),2) != 0	
		 	 	
	</cfquery>	
	
	<cfquery name="crossBilling" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
		UPDATE    WorkOrder.dbo.WorkOrderLineCharge						
		SET       Journal         = 'InProcess'								  
		WHERE     WorkOrderid     = '#get.WorkOrderid#' 
		AND       WorkOrderLine   = '#get.WorkOrderLine#' 				
		AND       Journal is NULL		
					
	</cfquery>	

	<cfif month(now()) gte "10">
		<cfset ThisTransactionPeriod = "#year(now())##month(now())#">
	<cfelse>
		<cfset ThisTransactionPeriod = "#year(now())#0#month(now())#">
	</cfif>	

	<cfloop query="ListBilling">
						
			<cfquery name="getJournal" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	 TOP 1 *
					FROM 	 Accounting.dbo.Journal
					WHERE 	 Mission        = '#get.Mission#'
					
					<cfif Parameter.administrationLevel eq "Parent">
					AND      OrgUnitOwner   = '#orgunitowner#'
					</cfif>
					
					AND      Currency       = '#currency#'
					AND      SystemJournal  = 'WorkOrder'				
			</cfquery>				
							
			<cfif getJournal.recordcount eq "0">
				
				<cfoutput>
				<table align="center"><tr><td align="center" class="labelmedium">A Journal has not been set for this currency (#currency#) and owner (#orgunitowner#). Please contact your administrator</td></tr></table>		
				</cfoutput>
				
				<cfabort>
				
			</cfif>		
				
			<cfquery name="getContraAccount" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	 TOP 1 *
					FROM 	 Accounting.dbo.JournalAccount
					WHERE 	 Journal = '#getJournal.journal#'
					AND      Mode    = 'Contra'
					ORDER BY ListDefault DESC
			</cfquery>	
			
			<cfif getContraAccount.GLAccount eq "">
				
				<cfoutput>
				<table><tr><td class="labelmedium">A contra-account has not been set for this journal (#getJournal.journal#). Please contact your administrator</td></tr></table>		
				</cfoutput>
				
				<cfabort>
				
			</cfif>		
			
			<cfset vBatchDate= createDate(year(get.DateEffective),month(get.DateEffective),daysinmonth(get.DateEffective))>		
			
			<!--- we check if for this customer	and for this batch date we already have an entry if
			we have an entry we update the record and add
			--->
			
			<cfif orgunitcustomer neq "0">
			
				<cfquery name="check" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    TOP 1 *
						FROM      TransactionHeader
						WHERE     Journal             = '#getJournal.journal#' 
						AND       OrgUnitOwner        = '#OrgunitOwner#' 
						AND       JournalBatchDate    = '#dateformat(vBatchDate,client.dateSQL)#' 
						AND       ReferenceOrgUnit    = '#orgunitCustomer#' 
						AND       TransactionSource   = 'WorkOrderSeries' 
		                AND       TransactionSourceNo = 'Medical'
						AND       DocumentCurrency    = '#currency#'
						AND       ActionStatus        = '0'
						ORDER BY  Created DESC
				</cfquery>	
				
				<cfif check.recordcount eq "1">								
					<cfset action = "update">				
				<cfelse>				
					<cfset action = "addheader">				
				</cfif>
					
			<cfelse>
			
				<!--- patient mode allwasy add header --->
						
				<cfset action = "addheader">
			
			</cfif>		
			
			<!--- cluster by class, accountcode --->
							
			<cfquery name="Lines" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
				SELECT     WC.UnitClass, 
				           R.Description, 
						   WC.GLAccountCredit, 
						   WC.OrgUnit,
						   WC.TransactionDate,
						   WC.TaxCode,
						   WC.BillingReference,
						   WC.BillingName,
						   SUM(WC.SaleAmountIncome) AS Income, 
						   SUM(WC.SaleAmountTax) AS Tax
				FROM       Workorder.dbo.WorkOrderLineCharge WC INNER JOIN
	                       WorkOrder.dbo.Ref_UnitClass R ON WC.UnitClass = R.Code
				WHERE      WorkOrderid        = '#get.WorkOrderid#' 
				AND        WorkOrderLine      = '#get.WorkOrderLine#'				   
				AND        Currency           = '#currency#'									   
				AND        WC.OrgUnitCustomer = '#orgunitcustomer#' 		
				AND        WC.OrgUnitOwner    = '#orgunitowner#' 	
				AND        WC.TransactionDate = '#transactiondate#'	
				AND        WC.Journal = 'InProcess'
												
	            GROUP BY   WC.UnitClass, 
				           WC.GLAccountCredit, 
						   WC.TransactionDate,
						   R.Description,
						   WC.TaxCode,
						   WC.BillingReference,
						   WC.BillingName,
						   WC.OrgUnit							   
						  
			</cfquery>		
			
			<cfif lines.recordcount gt "0">  
			
			<cfif action eq "addheader">
												
				<cfif Posting.EntityClass neq "">
				
				    <cfset wf = "Yes">
					<cfset st = "0">
					<cfset cl = "#Posting.EntityClass#">
				<cfelse>
				
					<cfset wf = "No">
					<cfset st = "1">
					<cfset cl = "">
				
				</cfif>
				
				<!-----<cfset dte = dateformat(TransactionDate,"YYYYMMDD")> ----->
				<cfset dte = DateTimeFormat(TransactionDate,"YYYYMMDD_HH_nn_ss")>
				
				<cfparam name="Form.#orgunitOwner#_#OrgUnitCustomer#_#dte#_invoiceseries" default="">
				<cfparam name="Form.#orgunitOwner#_#OrgUnitCustomer#_#dte#_invoiceno" default="">
				
				<cfset ser = evaluate("Form.#orgunitOwner#_#OrgUnitCustomer#_#dte#_invoiceseries")>
				<cfset inv = evaluate("Form.#orgunitOwner#_#OrgUnitCustomer#_#dte#_invoiceno")>
				
				<cfif ser neq "">
					<cfset trano = "#ser#-#inv#">
				<cfelse>
					<cfset trano = "#inv#">
				</cfif>		
				
								
				<cf_GledgerEntryHeader
				    DataSource            = "AppsLedger"
					Mission               = "#get.Mission#"
					OrgUnitOwner          = "#OrgunitOwner#"
					AccountPeriod         = "#getPeriod.AccountPeriod#"
					Journal               = "#getJournal.journal#"	
					TransactionPeriod	  =	"#ThisTransactionPeriod#"
						
					JournalTransactionNo  = "#TraNo#"		
									
					Description           = "#getService.description#"
					TransactionSource     = "WorkOrderSeries"	
					TransactionSourceNo   = "Medical"	
					TransactionSourceId   = "#url.workorderlineid#"		
					TransactionCategory   = "Receivables"
					MatchingRequired      = "1"
					WorkFlow              = "#wf#"					
					ActionStatus		  = "#st#"  <!--- 0= no workflow --->
					EntityClass           = "#cl#"  <!--- pass the workflow based on the type of service --->
					ReferenceOrgUnit      = "#orgunitCustomer#"			
					Reference             = "#get.Reference#"       
					ReferenceId           = "#get.CustomerId#"			
					ReferencePersonNo     = "#get.ApplicantNo#"		
					ReferenceName         = "#get.customername#"
					DocumentCurrency      = "#Currency#"			
					DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#" 
					TransactionDate       = "#DateFormat(now(),CLIENT.DateFormatShow)#"
					JournalBatchDate      = "#DateFormat(vBatchDate,CLIENT.DateFormatShow)#"
					DocumentAmount        = "#Total#"
					ActionCode            = "Invoice"
					ActionReference1      = "#ser#"
					ActionReference2      = "#inv#">	
					
			<cfelse>
			
				<!--- Header for Insurance portion--->
			
				<cfquery name="ResetHeader" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE    TransactionHeader
					SET       DocumentAmount    = DocumentAmount + '#total#', 
					          Amount            = Amount+'#total#', 
							  AmountOutstanding = AmountOutstanding + '#total#'					
					WHERE     TransactionId     = '#check.transactionid#'
			    </cfquery> 
			
				<cfset JournalTransactionNo = check.JournalSerialNo>
												
			</cfif>	
	
			<cf_GledgerEntryLine
		        DataSource            = "AppsLedger"
				Lines                 = "1"
			    Journal               = "#getJournal.journal#"		
				JournalNo             = "#JournalTransactionNo#"	
				AccountPeriod         = "#getPeriod.AccountPeriod#"	
				TransactionPeriod	  =	"#ThisTransactionPeriod#"	
				TransactionDate       = "#DateFormat(TransactionDate,CLIENT.DateFormatShow)#" 
				Currency              = "#Currency#"	
								
				TransactionSerialNo1  = "0"
				Class1                = "Debit"
				Reference1            = "Standard"       
				ReferenceName1        = "#getService.description#"
				Description1          = "Receivable"
				GLAccount1            = "#getContraAccount.GLAccount#"					
				ReferenceId1          = "#url.WorkOrderLineId#"
				ReferenceNo1          = "#get.Reference#"
				TransactionType1      = "Standard"
				Amount1               = "#total#">		
	
				<cfloop query="Lines">
	
					<!--- Lines for each Unit clas.--->
					<cf_GledgerEntryLine
					    DataSource            = "AppsLedger"
						Lines                 = "1"
					    Journal               = "#getJournal.journal#"			
						JournalNo             = "#JournalTransactionNo#"	
						TransactionDate       = "#DateFormat(TransactionDate,CLIENT.DateFormatShow)#" 
						AccountPeriod         = "#getPeriod.AccountPeriod#"
						TransactionPeriod	  =	"#ThisTransactionPeriod#"

						Currency              = "#getJournal.Currency#"										
						TransactionSerialNo1  = "1"
						Class1                = "Credit"
						Reference1            = "Charges"       
						ReferenceName1        = "#getService.description#"
						ReferenceId1          = "#get.WorkOrderLineId#"
						ReferenceNo1          = "#UnitClass#"						
						GLAccount1            = "#GLAccountCredit#"
						Description1          = "#BillingReference# #BillingName#"
						Costcenter1           = "#OrgUnit#"
						ProgramCode1          = ""
						ProgramPeriod1        = ""		
						ContributionLineId1   = ""			
						TransactionType1      = "Standard"
						Amount1               = "#Income#">		
						
					<cfif abs(tax) gte "0.05">
					
						<cfquery name="getTax" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Ref_Tax
							WHERE  TaxCode = '#taxCode#'
						</cfquery>
						
						<cfset taxaccount = getTax.GLAccountReceived>
					
						<!--- 10/4/2016 obtain the tax account for received taxes --->
							
						<!--- Lines for each Unit class/glaccount/cost center --->
						
						<cf_GledgerEntryLine
						    DataSource            = "AppsLedger"
							Lines                 = "1"
						    Journal               = "#getJournal.journal#"			
							JournalNo             = "#JournalTransactionNo#"	
							TransactionDate       = "#DateFormat(TransactionDate,CLIENT.DateFormatShow)#" 
							AccountPeriod         = "#getPeriod.AccountPeriod#"
							TransactionPeriod	  =	"#ThisTransactionPeriod#"

							Currency              = "#getJournal.Currency#"										
							TransactionSerialNo1  = "1"
							Class1                = "Credit"
							Reference1            = "Sales Tax"       
							ReferenceName1        = "#getService.description#"
							ReferenceId1          = "#get.WorkOrderLineId#"
							ReferenceNo1          = "#UnitClass#"										
							GLAccount1            = "#taxaccount#"
							Description1          = "#BillingReference# #BillingName#"
							Costcenter1           = "#OrgUnit#"									
							TransactionType1      = "Standard"
							Amount1               = "#Tax#">	
						
					</cfif>			
					
				</cfloop>
				
				<cfquery name="crossBilling" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						UPDATE    WorkOrder.dbo.WorkOrderLineCharge
						
						SET       Journal         = '#getJournal.journal#',
								  JournalSerialNo = '#JournalTransactionNo#',
								  InvoiceSeries   = '#ser#',
								  InvoiceNo       = '#Inv#'			
								  
						WHERE     WorkOrderid     = '#get.WorkOrderid#' 
						AND       WorkOrderLine   = '#get.WorkOrderLine#' 
						AND       OrgUnitOwner    = '#OrgUnitOwner#'
						AND       OrgUnitCustomer = '#OrgUnitCustomer#'
						AND       TransactionDate = '#TransactionDate#'
						AND       Currency        = '#Currency#'		
						AND       Journal = 'InProcess'		
					
				</cfquery>	

				
				<!--- ------------------------------------------- --->
				<!--- get the settlements of the client per owner --->
				
				<cfif orgunitcustomer eq "0"> 
				
					<cfset parentJournalSerialNo = JournalTransactionNo>
				
					<!-- we enforce the same currency as the one of the workorder here --->
				
					<cfquery name="Settlement" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT     SUM(S.SettleAmount) AS Total
								   
						FROM       WorkOrder.dbo.Ref_SettlementMission M INNER JOIN
					               Workorder.dbo.WorkOrderLineSettlement S ON M.Code = S.SettleCode AND M.Mission = '#get.mission#'
							   
						WHERE      WorkOrderid     = '#get.WorkOrderid#' 
						AND        WorkOrderLine   = '#get.WorkOrderLine#' 	
						AND        OrgUnitOwner    = '#OrgUnitOwner#' 		
						AND        TransactionDate = '#TransactionDate#'					
					
					</cfquery>							
					
					<cfif Settlement.Total gt "0">
																
						<cfquery name="getPerson"
							 datasource="AppsLedger" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT TOP 1 * 
								 FROM   WorkOrder.dbo.WorkOrderLineSettlement		 
								 WHERE  WorkOrderId     = '#get.WorkOrderId#'
								 AND    WorkorderLine   = '#get.WorkOrderLine#'
								 AND    OrgUnitOwner    = '#orgunitowner#'									 
								 AND    TransactionDate = '#TransactionDate#'	
						</cfquery> 	
																	
						<!--- Header for settlement --->
				
						<cf_GledgerEntryHeader
						    DataSource            = "AppsLedger"
							Mission               = "#get.Mission#"
							OrgUnitOwner          = "#OrgunitOwner#"
							AccountPeriod         = "#getPeriod.AccountPeriod#"
							TransactionPeriod	  =	"#ThisTransactionPeriod#"
							Journal               = "#getJournal.journal#"			
							JournalTransactionNo  = ""						
							Description           = "#getService.description#"
							TransactionSource     = "WorkOrderSeries"	
							TransactionSourceNo   = "Medical"	
							TransactionSourceId   = "#url.workorderlineid#"		
							TransactionCategory   = "Receipt"
							MatchingRequired      = "0"
							ActionStatus		  = "1"  <!--- no workflow --->
							ReferenceOrgUnit      = "#orgunitCustomer#"			
							ReferencePersonNo     = "#getPerson.SettlePersonNo#"      
							Reference             = "#getPerson.SettleReference#"   
							ReferenceId           = "#get.WorkOrderLineId#"				
							ReferenceName         = "#getPerson.SettleCustomername#"
							DocumentCurrency      = "#getJournal.Currency#"			
							DocumentDate          = "#DateFormat(get.DateEffective,CLIENT.DateFormatShow)#" 						
							DocumentAmount        = "#Settlement.total#">						
						
						<!--- settlement offset contra-account --->
						
						<cf_GledgerEntryLine
					        DataSource            = "AppsLedger"
							Lines                 = "1"
						    Journal               = "#getJournal.journal#"		
							JournalNo             = "#JournalTransactionNo#"	
							AccountPeriod         = "#getPeriod.AccountPeriod#"	
							TransactionPeriod	  =	"#ThisTransactionPeriod#"	
							Currency              = "#getJournal.Currency#"	
							ParentJournal         = "#getJournal.journal#"
							ParentJournalSerialNo =	"#parentJournalSerialNo#"		
																	
							TransactionSerialNo1  = "0"
							Class1                = "Credit"
							Reference1            = "Standard"       
							ReferenceName1        = "#getService.description#"
							Description1          = "Settlement"
							GLAccount1            = "#getContraAccount.GLAccount#"					
							ReferenceId1          = "#url.WorkOrderLineId#"
							ReferenceNo1          = "#get.Reference#"
							TransactionType1      = "Standard"
							Amount1               = "#Settlement.total#">		
						
							<cfquery name="ListSettlement" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
								SELECT     M.GLAccount, 								  
										   S.SettleCurrency,
										   S.SettleCode,
										   SUM(S.SettleAmount) AS Amount
										   
								FROM       WorkOrder.dbo.Ref_SettlementMission M INNER JOIN
							               WorkOrder.dbo.WorkOrderLineSettlement S ON M.Code = S.SettleCode AND M.Mission = '#get.mission#'
								   
								WHERE      WorkOrderid     = '#get.WorkOrderid#' 
								AND        WorkOrderLine   = '#get.WorkOrderLine#' 	
								AND        OrgUnitOwner    = '#OrgUnitOwner#' 		
								AND        TransactionDate = '#TransactionDate#'		   
								
								GROUP BY   M.GLAccount, 								  
										   S.SettleCurrency,
										   S.SettleCode
							
							</cfquery>		
						
							<cfloop query="ListSettlement">
							
								<!--- cash lines --->
														
								<cf_GledgerEntryLine
								    DataSource            = "AppsLedger"
									Lines                 = "1"
								    Journal               = "#getJournal.journal#"			
									JournalNo             = "#JournalTransactionNo#"	
									AccountPeriod         = "#getPeriod.AccountPeriod#"	
									TransactionPeriod	  =	"#ThisTransactionPeriod#"	
									Currency              = "#getJournal.Currency#"		
									ParentJournal         = "#getJournal.journal#"
									ParentJournalSerialNo =	"#parentJournalSerialNo#"									
									TransactionSerialNo1  = "1"
									Class1                = "Debit"
									Reference1            = "Settlement" 
									ReferenceNo1		  = "#SettleCode#"     											
									Description1          = "#get.CustomerName#"
									GLAccount1            = "#GLAccount#"							
									TransactionType1      = "Standard"
									Amount1               = "#Amount#">								
							
							</cfloop>												
					
					</cfif>		
					
					<!---
					
					<cfquery name="getPerson"
							 datasource="AppsLedger" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 DELETE FROM WorkOrder.dbo.WorkOrderLineSettlement		 
								 WHERE  WorkOrderId     = '#get.WorkOrderId#'
								 AND    WorkorderLine   = '#get.WorkOrderLine#'
								 AND    OrgUnitOwner    = '#orgunitowner#'			
								 AND    TransactionDate = '#DateFormat(TransactionDate,CLIENT.DateSQL)#'							 
					</cfquery> 	
					
					--->
					
					<cf_TransactionOutstanding Journal="#getJournal.journal#" 
					                           JournalSerialNo = "#parentJournalSerialNo#">
										
				</cfif>		
				
			</cfif>									
				
	</cfloop>
		
	<!--- --------------------------------- --->	
	<!--- now we continue making the offset --->
	<!--- --------------------------------- --->
	
	<cfquery name="checkActionCovered" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    WorkActionId
		FROM      Workorder.dbo.WorkOrderLineAction W INNER JOIN
			                  Workorder.dbo.Ref_Action R ON W.ActionClass = R.Code
		WHERE     W.WorkOrderId   = '#get.WorkOrderid#' 
		AND       W.WorkOrderLine = '#get.WorkOrderLine#'
		AND       W.ActionStatus <> '9' 
		AND       R.EntryMode != 'System'
		AND       NOT EXISTS  (SELECT  'X' 
							   FROM   Workorder.dbo.WorkOrderLineBillingAction
			                   WHERE  WorkOrderId   = W.WorkOrderid 
							   AND    WorkOrderLine = W.WorkOrderLine
							   AND    WorkActionId  = W.WorkActionId)
	</cfquery>
	
	<cfif checkActionCovered.recordcount eq "0">
	
	<!--- but only if all actions are associated to a provisioing --->
				
		<cfquery name="close" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			UPDATE  WorkOrder.dbo.WorkOrderLine  
			SET     ActionStatus = '3'
			WHERE   WorkOrderLineId = '#url.workorderlineid#'				
		</cfquery>		
	
	</cfif>
	
</cftransaction>	

<!--- Close the line so next time it will show the charges and the posted amounts --->

<table width="100%">
		
		<!---
		<tr><td>
			<table><tr><td>
			<img src="<cfoutput>#session.root#</cfoutput>/images/go.png" height="23" width="25px" alt="" border="0">
			</td>
			<td style="padding-left:10px;padding-top:3px;height:50px;font-size:25px" class="labellarge"><font color="0080C0"><cf_tl id="Posted charges"></td>
			</tr>
			</table>
		</td>
		</tr>
		--->	

		<tr class="line">
		   <td colspan="3" style="height:40px">
			<cfinclude template="WorkOrderLinePosting.cfm">
		 </td>
		</tr>
		
</table>		
