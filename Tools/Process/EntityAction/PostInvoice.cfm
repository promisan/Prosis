<!--- ---------------------------- --->
<!--- --determine input parameter- --->
<!--- ---------------------------- --->

<cfparam name="Object.ObjectKeyValue4"  default="#URL.ID#">
<cfparam name="url.invid"               default="#Object.ObjectKeyValue4#">
<cfparam name="url.clear"               default="1">
<cfparam name="form.linesselect"        default="">
<cfparam name="url.wf"                  default="0">

<!--- passed from a direct posting of the invoice --->
<cfparam name="matchreceipt"            default="#Form.linesselect#">

<!--- total amount of related requisitions for the PO's involved for this Invoice (Invoice Purchase)
which we will be used to define a funding posting basis for the amount
so lets say if an invoice is split accross 2 PO, the total amount of the
requisitions is then distributes Pro-rata of the funding for these lines,
refer to line 710
 --->			

<cfif matchreceipt eq "">

		<cfquery name="Receipt" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT ReceiptId
			FROM   Purchase.dbo.PurchaseLineReceipt
			WHERE  ReceiptId IN (SELECT L.ReferenceId 
			                     FROM TransactionLine L, TransactionHeader H
								 WHERE L.Journal = H.Journal
								 AND L.JournalSerialNo = H.JournalSerialNo
								 AND H.ReferenceId = '#URL.INVID#') 
		</cfquery>
		
		<cfloop query="Receipt">
		
		    <cfif matchreceipt eq "">
				<cfset matchreceipt = "'#ReceiptId#'">
			<cfelse>
				<cfset matchreceipt = "#matchreceipt#,'#ReceiptId#'">
			</cfif>
			
		</cfloop>

</cfif>

<cfquery name="Invoice" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	   	SELECT    *
	    FROM      Purchase.dbo.Invoice I
		WHERE     InvoiceId = '#URL.INVID#' 			
</cfquery>

<cfquery name="IncomingInvoice" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	   	SELECT    *
	    FROM      Purchase.dbo.InvoiceIncoming I
		WHERE     Mission       = '#Invoice.Mission#' 			
		AND       OrgUnitOwner  = '#Invoice.OrgUnitOwner#' 
		AND       OrgUnitVendor = '#Invoice.OrgUnitVendor#'
		AND       InvoiceNo     = '#Invoice.InvoiceNo#' 
</cfquery>

<!--- give a list of all PO under this invoice, but with shared currency and purchase type / class --->

<cfquery name="PO" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	   	SELECT    *
	    FROM      Purchase.dbo.InvoicePurchase I, 
		          Purchase.dbo.Purchase P, 
				  Purchase.dbo.Ref_OrderType R
		WHERE     I.PurchaseNo = P.PurchaseNo		  
		AND       R.Code      = P.OrderType
		AND       I.InvoiceId = '#URL.INVID#' 			
</cfquery>

<cfif IncomingInvoice.InvoiceClass neq "Warehouse">

<!--- -------------------------------------------------------------------------------------- --->
<!--- In case of a workflow, 
    check if the PO-type requires receipts and if the amount of the receipt = invoice amount --->
<!--- -------------------------------------------------------------------------------------- --->	


	<cfif url.wf eq "1" and (PO.ReceiptEntry eq "0" or PO.ReceiptEntry eq "1")>
					
		<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#Invoice.Mission#' 
		</cfquery>
				
		<cfquery name="GetLines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM   PurchaseLineReceipt 
			WHERE  InvoiceIdMatched =  '#URL.INVID#' 		
		</cfquery>

		<cfset amt = 0>

		<cfloop query="GetLines">
		
			<cfquery name="Receipt" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    PurchaseLineReceipt 
				WHERE   ReceiptId = '#receiptId#'
			</cfquery>
			
			<cfif Receipt.Currency eq Invoice.DocumentCurrency>
			
			   <cfif parameter.InvoiceMatchPriceActual eq "0">	
				   <cfset amt = amt+Receipt.ReceiptAmount>			   
			   <cfelse>			   			   
				   <cfset amt = amt+Receipt.InvoiceAmount>			   
			   </cfif>
			  
			<cfelse>
					
				<cf_exchangerate datasource   = "AppsPurchase" 
							     currencyFrom = "#Receipt.Currency#" 
								 currencyTo   = "#Invoice.DocumentCurrency#">
				
				<cfif parameter.InvoiceMatchPriceActual eq "0">				
					<cfset amt = amt+(Receipt.ReceiptAmount/exc)> 
				<cfelse>
				    <cfset amt = amt+(Receipt.InvoiceAmount/exc)> 
				</cfif>	
					
			</cfif>
			
			<!--- removed 19/12/2011 
		
			<cfif Receipt.Currency eq Invoice.DocumentCurrency>
			
			   <cfset amt = amt+Receipt.ReceiptAmount>
			  
			<cfelse>
			
				<cfquery name="CheckCurrency" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  *
				    FROM    Currency C
					WHERE   Currency = '#Invoice.DocumentCurrency#' 
				</cfquery>
							
				<cfset amt = amt+(ReceiptAmountBase*CheckCurrency.ExchangeRate)> 
					
			</cfif>
			
			--->

		</cfloop>
		
			
		<cfset amt_dif  = abs(amt-Invoice.DocumentAmount)>
		<cfset perc_dif = abs((amt-Invoice.DocumentAmount)/Invoice.DocumentAmount)>
			
		<!--- percentage or amount allowed --->
		
		<cfset perc_all = Parameter.InvoiceMatchDifference/100> 	
	
		<cfif perc_dif lte perc_all  or 
		      amt_dif lte Parameter.InvoiceMatchDifferenceAmount>
		
		     <!--- within the accepted range --->
				
		<cfelse>
		
			<cf_waitEnd> 						
			<cf_tl id="Invoice Payable amount was not completely mapped to matching receipts" var="vInvoiceMessage">
			<cf_message message = "#vInvoiceMessage#."
					    return  = "no">
		     <cfabort>	
		
		</cfif>	
		
		<cfset matchreceipt = QuotedValueList(GetLines.ReceiptId)> 	
	
	</cfif>
	
</cfif>	

<!--- -----------------------------------  end of check-up  --------------------------- --->
     
<cf_verifyOperational 
     module="Accounting" 
	 datasource="AppsLedger"	 
	 Warning="No">

    <cfif operational eq "1">
	
	    <!--- all purchase lines under this invoice --->
			
		<cfquery name="Issued" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT  PL.*, P.PersonNo, P.OrgUnitVendor, P.OrderClass
			FROM    Purchase.dbo.PurchaseLine PL, 
					Purchase.dbo.Purchase P
			WHERE   PL.PurchaseNo = P.PurchaseNo		
			AND     PL.PurchaseNo IN
                          (SELECT  PurchaseNo
                           FROM    Purchase.dbo.InvoicePurchase
						   WHERE   InvoiceId = '#URL.INVID#')
		</cfquery>					
		
		<!--- retrieve posting information for the currency of the purchase order --->  
		
		<!--- check if Journal exists for invoice currency --->
		
		<cfif Issued.OrgUnitVendor neq "0">
		
			<cfquery name="Journal" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			   	SELECT     J.Journal,J.OrgUnitOwner,J.Currency,JA.GLAccount
				FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
				WHERE     J.Journal = '#Invoice.Journal#' 
			</cfquery>
			
			<cfif Journal.recordcount eq "0">
			
				<cfquery name="Journal" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT     J.Journal,J.OrgUnitOwner,J.Currency,JA.GLAccount
					FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
					WHERE     Mission       = '#Invoice.Mission#' 
					AND       SystemJournal = 'Procurement'
					AND       Currency      = '#Invoice.DocumentCurrency#' 			
				</cfquery>		
				
				<cfif Journal.recordcount eq "0">
						
					<!--- if not then we TAKE the journal for the PO currency --->
			 	
					<cfquery name="Journal" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
						SELECT     J.Journal,J.OrgUnitOwner,J.Currency,JA.GLAccount
						FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
						WHERE     Mission       = '#Invoice.Mission#' 
						AND       SystemJournal = 'Procurement'
						AND       Currency      = '#Issued.Currency#' 
					</cfquery>		
				
				</cfif>
			
			</cfif>
			
			<cfif Journal.recordcount eq "0" or Journal.GLAccount eq "">
				
								
				<cf_message message = "A payable journal or contra-account for currency : <cfoutput>#Issued.Currency#</cfoutput> has not been recorded for <cfoutput>#Invoice.Mission#</cfoutput>. Operation not allowed."
				  return = "no">
				  <cfabort>		  
		  
			</cfif>  
			
		<cfelse>
			
			<cfquery name="Journal" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			   	SELECT     J.Journal,J.OrgUnitOwner,J.Currency,JA.GLAccount
				FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
				WHERE     J.Journal     = '#Invoice.Journal#' 
			</cfquery>
			
			<cfif Journal.recordcount eq "0">		
		
				<cfquery name="Journal" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT    J.Journal,J.OrgUnitOwner,J.Currency,JA.GLAccount
					FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
					WHERE     Mission       = '#Invoice.Mission#' 
					AND       SystemJournal = 'Employee'
					AND       Currency      = '#Invoice.DocumentCurrency#' 			
				</cfquery>		
			
				<cfif Journal.recordcount eq "0">
						
					<!--- if not then we TAKE the journal for the PO currency --->
			 	
					<cfquery name="Journal" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
						SELECT    J.Journal,J.OrgUnitOwner,J.Currency,JA.GLAccount
						FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
						WHERE     Mission       = '#Invoice.Mission#' 
						AND       SystemJournal = 'Employee'
						AND       Currency      = '#Issued.Currency#' 
					</cfquery>		
				
				</cfif>		
			
			</cfif>	
			
			<cfif Journal.recordcount eq "0" or Journal.GLAccount eq "">
											
				<cf_waitEnd> 						
				<cf_message message = "An Employee journal or contra-account for currency : <cfoutput>#Issued.Currency#</cfoutput> has not been recorded for <cfoutput>#Invoice.Mission#</cfoutput>. Operation not allowed."
				  return = "no">
				  <cfabort>		  
		  
			</cfif>  
		
		</cfif>								
		
		<!-- check GL account --->
		<cfquery name="Check" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * 
			FROM Ref_Account WHERE GLAccount = '#Journal.GLAccount#'
		</cfquery>
		
		<cfif check.recordcount eq "0">
		
			<cf_waitEnd> 						
			<cf_message message = "A Procurement journal for currency : <cfoutput>#Issued.Currency#</cfoutput> has not a defined contra-account. Operation not allowed."
			  return = "no">
			  <cfabort>		  
		
		</cfif>
			 
	    <cfquery name="Param" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      Ref_ParameterMission
			WHERE     Mission = '#Invoice.Mission#'
		</cfquery>
			   	
		<!--- reset remove and reset prior receipt entries --->
				
		<cfquery name="ResetReceipt" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    UPDATE Purchase.dbo.PurchaseLineReceipt
			SET    ActionStatus = '1'
			WHERE  ReceiptId IN (SELECT L.ReferenceId 
			                     FROM   TransactionLine L, TransactionHeader H
								 WHERE  L.Journal = H.Journal
								 AND    L.JournalSerialNo = H.JournalSerialNo
								 AND    H.ReferenceId = '#URL.INVID#') 
		</cfquery>
		
		<!--- ---------- --->
		<!--- GL Posting --->
		<!--- ---------- --->
		
		
		
		<cfif url.clear eq "1">
			
				<cfquery name="Check" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT * 
					FROM   TransactionHeader H, 
					       TransactionLine L
					WHERE  H.Journal         = L.ParentJournal
					AND    H.JournalSerialNo = L.ParentJournalSerialNo
					AND    H.ReferenceId     = '#URL.INVID#'
					AND    H.Journal is not NULL			
				</cfquery>
				
				<cfif Check.recordcount gte "1">
				
					<cf_message 
					  message = "Problem, it appears that this invoice was already processed (paid). Operation not allowed. Please contact your administrator."
					  return = "no">
					  <cfabort>
				
				</cfif>				
						
				<cfquery name="ClearLedger" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    DELETE FROM TransactionHeader
					WHERE  ReferenceId = '#URL.INVID#' 
				</cfquery>				
			
		</cfif>
							
		<!--- now post journal --->
				
		<!--- header --->
		
			<cfquery name="Per" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     *
				FROM       Organization.dbo.Ref_MissionPeriod
				WHERE      Mission = '#Invoice.Mission#'
				AND        Period  = '#Invoice.Period#'
			</cfquery> 
			
			<cfif Per.AccountPeriod neq "">
			     <cfset accperiod = "#Per.AccountPeriod#">
			<cfelse>
			     <cfset accperiod = "#Param.CurrentAccountPeriod#">
			</cfif>		
			
			<!--- check if the invoice comes from an institution --->
									
			<cfif Issued.OrgUnitVendor neq "0">
			
				<cfquery name="Organ" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				   	SELECT    *
				    FROM      Organization.dbo.Organization O
					WHERE     OrgUnit = '#Issued.OrgUnitVendor#'
				</cfquery>
			
				<cfset org = Organ.OrgUnit>
				<cfset per = "">
				<cfset nme = Organ.OrgUnitName>
				
				<cfif Organ.recordcount eq "0">
					<cf_message 
				  message = "Problem, vendor [#Issued.OrgUnitVendor#] can not be located. Operation not allowed."
				  return = "no">
				  <cfabort>
			  	</cfif>
				
			<cfelse>
			
				<cfquery name="Person" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				   	SELECT    *
				    FROM      Person
					WHERE     PersonNo = '#Issued.PersonNo#' 
				</cfquery>
			
			    <cfset org = "">
				<cfset per = Person.PersonNo>
				<cfset nme = "#Person.LastName# / #IncomingInvoice.InvoiceIssued#">
				
				<cfif Person.recordcount eq "0">
					<cf_message message = "Problem, Employee can not be located. Operation not allowed." return = "no">
				  <cfabort>
			  	</cfif>
				
			</cfif>	
			
			
			
			<cfquery name="Parameter" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT    *
			    FROM      Purchase.dbo.Ref_ParameterMission
				WHERE     Mission = '#Invoice.Mission#' 
			</cfquery>
						
			<cfif IncomingInvoice.InvoiceSeries neq "">
				<cfset invref = "#IncomingInvoice.InvoiceSeries# #IncomingInvoice.InvoiceNo#">
			<cfelse>
			    <cfset invref = "#IncomingInvoice.InvoiceNo#">
			</cfif>			
						
			<cfif month(Invoice.DocumentDate) gte "10">
				<cfset TransactionPeriod = "#year(Invoice.DocumentDate)##month(Invoice.DocumentDate)#">
			<cfelse>
				<cfset TransactionPeriod = "#year(Invoice.DocumentDate)#0#month(Invoice.DocumentDate)#">
			</cfif>	
												
			<cf_GledgerEntryHeader
				    Mission               = "#Invoice.Mission#"
				    OrgUnitOwner          = "#Invoice.OrgUnitOwner#"
				    Journal               = "#Journal.Journal#"
					JournalTransactionNo  = "#Issued.PurchaseNo#"
					Description           = "#Invoice.InvoiceNo# #Invoice.Description#"
					TransactionSource     = "PurchaseSeries"
					TransactionSourceId   = "#Invoice.InvoiceId#"
					AccountPeriod         = "#accperiod#"
					TransactionCategory   = "Payables"
					MatchingRequired      = "1"
					ActionStatus          = "1" <!--- we consider this entry to be cleared immediately and no workflow needed --->
					ReferenceOrgUnit      = "#org#"
					ReferencePersonNo     = "#per#"
					Reference             = "Invoice"       
					ReferenceName         = "#nme#"
					ReferenceId           = "#Invoice.InvoiceId#"
					ReferenceNo           = "#invref#"
					ActionBefore          = "#DateFormat(Invoice.ActionBefore,CLIENT.DateFormatShow)#"
					ActionTerms           = "#Invoice.ActionTerms#"
					ActionDiscountDays    = "#Invoice.ActionDiscountDays#"
					ActionDiscount        = "#Invoice.ActionDiscount#"
					ActionDiscountDate    = "#DateFormat(Invoice.ActionDiscountDate,CLIENT.DateFormatShow)#"
					DocumentCurrency      = "#Invoice.DocumentCurrency#"
					TransactionDate       = "#DateFormat(now(),CLIENT.DateFormatShow)#"
					TransactionPeriod     = "#TransactionPeriod#"
					DocumentDate          = "#DateFormat(Invoice.DocumentDate,CLIENT.DateFormatShow)#"
					DocumentAmount        = "#Invoice.DocumentAmount#"
					ParentJournal         = ""
					ParentJournalSerialNo = "">
			
				<!--- Lines - invoice itself --->
					 
				<cfset row = "0">
				
				<cf_GledgerEntryLine
					Lines                 = "1"
				    Journal               = "#Journal.Journal#"
					JournalNo             = "#JournalTransactionNo#"
					AccountPeriod         = "#accperiod#"
					TransactionPeriod     = "#transactionperiod#"
					ExchangeRate          = "1"
					Currency              = "#Invoice.DocumentCurrency#"
					
					DataSource			  = "AppsLedger"
					
					TransactionSerialNo1  = "#row#"
					Class1                = "Credit"
					Reference1            = "Invoice"       
					ReferenceName1        = "#nme#"
					Description1          = "Payable"
					GLAccount1            = "#Journal.GLAccount#"
					Costcenter1           = "#Invoice.OrgUnit#"
					ProgramCode1          = ""
					ProgramPeriod1        = ""
					ReferenceId1          = "#Invoice.InvoiceId#"
					ReferenceNo1          = "#Invoice.InvoiceNo#"
					TransactionType1      = "Standard"
					Amount1               = "#Invoice.DocumentAmount#">
					
					<cfquery name="Tax" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      Purchase.dbo.Ref_OrderClass R
						WHERE     Code       = '#Issued.OrderClass#'	
						AND       GLAccountTax IN (SELECT GLAccount
						                           FROM   Accounting.dbo.Ref_Account
												   WHERE  GLAccount = R.GLAccountTax)					
					</cfquery>
					
					<cfif Tax.GLAccountTax neq "">
					
						<cfset taxaccount = Tax.GLAccountTax>					
						
					<cfelse>
					
						<cfquery name="Tax" 
					    datasource="AppsLedger" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Ref_AccountMission
							WHERE     SystemAccount = 'InvoiceTax'
							AND       Mission       = '#Invoice.Mission#'
						</cfquery>
						
						<cfset taxaccount = Tax.GLAccount>	
						
					</cfif>							
										
					<cfif taxaccount eq "" and Parameter.TaxExemption eq "0">
					
						<cf_message message = "Invoice Tax has not been defined for this ordertype nor entity. Operation aborted." return = "no">
						<cfabort>
																					
					</cfif>											
					
					<cfsavecontent variable="LineFunding">
					
						<cfoutput>
							SELECT     LF.RequisitionNo, 
							           LF.FundingId, 
									   LF.Fund, 
									   LF.ProgramPeriod, 
									   LF.ProgramCode, 
									   LA.ActivityId, 
									   LF.ObjectCode, 
									   CASE WHEN LA.Percentage IS NULL THEN LF.Percentage ELSE LF.Percentage * LA.Percentage END AS Percentage
							FROM       Purchase.dbo.RequisitionLineFunding LF LEFT OUTER JOIN
					                   Purchase.dbo.RequisitionLineFundingActivity LA ON LF.RequisitionNo = LA.RequisitionNo AND LF.FundingId = LA.FundingId		
						</cfoutput>
							   						
					</cfsavecontent>	
																	
															
					<cfif matchreceipt neq "">		
								
										
					    <!--- get the lines of the receipt and assign the funding in percentages 
						we have 2 modes on that takes the funding from the requisition and 
						one that equally spreads the funding of the invoice accross the 
						receipt lines, below we addjust the GLAccount if the receipt is for a warehouse item
						--->
						
						<cfif Parameter.InvoicePostingMode eq "0">
						
							 <!--- take the right contra account of the PurchaseLineReceipt items --->
						
							<cfquery name="Check" 
							  datasource="AppsLedger" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT    count(*) as Total
								  FROM      Purchase.dbo.RequisitionLine P,
								            Purchase.dbo.PurchaseLineReceipt R, 
											(#LineFunding#) F  		  			                        
					              WHERE     R.RequisitionNo = F.RequisitionNo
								  AND       P.RequisitionNo = R.RequisitionNo						
								  AND       R.ReceiptId IN (#PreserveSingleQuotes(matchreceipt)#)  <!--- take the function of the lines involved in receipt --->
								  AND       R.ActionStatus IN ('1','2')  
							</cfquery>
						
							<cfquery name="Lines" 
							  datasource="AppsLedger" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT    R.*, 
								  			P.WorkOrderId,
											P.WorkOrderLine,
								            F.ProgramPeriod,
								            F.ProgramCode as ProgramCode, 
											F.ActivityId,
											F.Fund        as Fund,
											F.ObjectCode  as ObjectCode,
								            CV.GLAccount  as GLAccount, 
											F.Percentage  as Percentage,
											F.ObjectCode  as ObjectCode
								  FROM      Purchase.dbo.RequisitionLine P,
								            Purchase.dbo.PurchaseLineReceipt R, 
											(#LineFunding#) F,  
											<!--- mapping --->
					                        Ref_AccountReceipt CV 
					              WHERE     P.RequisitionNo = R.RequisitionNo
								  AND       R.RequisitionNo = F.RequisitionNo      
								  AND       F.Fund          = CV.Fund 
								  AND       F.ObjectCode    = CV.ObjectCode
								  AND       R.ReceiptId IN (#PreserveSingleQuotes(matchreceipt)#)
								  AND       R.ActionStatus IN ('1','2') 
								  
							</cfquery>
							
							<cfif Check.total gt Lines.recordcount>
						
								<cf_message 
								  	message = "Problem: Default GL account mapping for the funding of the underlying requisition(s) is not available. <br><br>Set mapping in under Financials -> Maintenance -> Budget Account conversion."
								    return  = "no">
								  <cfabort>
						
						   </cfif>
						
						<cfelse>
						
							<!--- newly added feature 27/12/2011 in which you may change the matching amounts
							of the receipt as to be take into the Invoice Posting PurchaseLineReceipt.InvoicePrice etc.--->
							
							<cfquery name="Check" 
							  datasource="AppsLedger" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT    count(*) as Total
								  FROM      Purchase.dbo.RequisitionLine P,
								            Purchase.dbo.PurchaseLineReceipt R, 
											Purchase.dbo.InvoiceFunding F  	  			                        
					              WHERE     P.RequisitionNo = R.RequisitionNo						
								  AND       F.InvoiceId     = '#URL.INVID#'  
								  AND       R.ReceiptId IN (#PreserveSingleQuotes(matchreceipt)#)
								  AND       R.ActionStatus IN ('1','2')  
							</cfquery>
						
							<cfquery name="Lines" 
							  datasource="AppsLedger" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT    R.*, 
											P.WorkOrderId,
											P.WorkOrderLine,
								            F.ProgramPeriod,
								            F.ProgramCode as ProgramCode, 
											F.ActivityId,
											F.Fund        as Fund,
											F.ObjectCode  as ObjectCode,
								            CV.GLAccount  as GLAccount, 
											F.Percentage  as Percentage,
											F.ObjectCode  as ObjectCode
								  FROM      Purchase.dbo.RequisitionLine P,
								            Purchase.dbo.PurchaseLineReceipt R, 
											Purchase.dbo.InvoiceFunding F,  <!--- full join --->
											<!--- mapping --->
					                        Ref_AccountReceipt CV 
					              WHERE     P.RequisitionNo = R.RequisitionNo
								  AND       F.InvoiceId     = '#URL.INVID#'   
								  AND       F.Fund          = CV.Fund 
								  AND       F.ObjectCode    = CV.ObjectCode
								  AND       R.ReceiptId IN (#PreserveSingleQuotes(matchreceipt)#)
								  AND       R.ActionStatus IN ('1','2') 
								  
							</cfquery>						
						
						</cfif>												
						
						<cfif Check.total gt Lines.recordcount>
						
							<cf_message 
							  	message = "Problem: Default GL account mapping for the funding of the underlying requisition(s) is not available. <br><br>Set mapping in under Financials -> Maintenance -> Budget Account conversion."
							    return  = "no">
							  <cfabort>
						
						</cfif>
												
					<cfelse> 
										
					    <!--- INVOICE ONLY determine gl accounts, prevent split up by requistion, only by fund/object --->	
												
						<cfquery name="Mapping" 
						    datasource="AppsLedger" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
								SELECT   *
								FROM     Purchase.dbo.InvoicePurchase 
								WHERE    InvoiceId = '#URL.INVID#'
						</cfquery>
						
						<cfif Mapping.recordcount eq "0">
						
							<cf_message message = "Problem: Invoice distribution has not been defined. Please contact your aministrator."
							  return = "no">
							  <cfabort>
						
						</cfif>
																													
						<cfif Parameter.InvoiceRequisition eq "0" or Mapping.RequisitionNo eq "">
						
							<!--- 25/4/2016 mapping on the purchase header level "NON-UN" mode for service items, not receipts
							so we take more lines 
							we likely need to adjust the total request here on the basis of the PO otherwise
							it igetting too small --->	
							
							<cfquery name="TotalRequest" 
								  datasource="AppsLedger" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  	SELECT    IP.PurchaseNo, 
									          SUM(REQ.RequestAmountBase) AS Total
									FROM      Purchase.dbo.InvoicePurchase IP INNER JOIN
								              Purchase.dbo.Purchase P ON IP.PurchaseNo = P.PurchaseNo INNER JOIN
								              Purchase.dbo.PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
								              Purchase.dbo.RequisitionLine REQ ON PL.RequisitionNo = REQ.RequisitionNo
								    WHERE     IP.InvoiceId = '#URL.INVID#' 
									GROUP BY IP.PurchaseNo
							</cfquery>				
																		
							<cfquery name="Lines" 
						    datasource="AppsLedger" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">					
														
							<!--- for each PO involved in this --->
							
							<cfloop query="TotalRequest">																						
													
								SELECT     IP.PurchaseNo,
										   FUN.ProgramPeriod, 
								           FUN.Fund, 
										   FUN.ProgramCode, 
										   FUN.ActivityId,
										   FUN.ObjectCode, 
										   REQ.WorkOrderId,
										   REQ.WorkOrderLine,
						                   SUM(ROUND(FUN.Percentage * (REQ.RequestAmountBase / #Total#) * IP.DocumentAmountMatched, 2)) AS Portion, 
										   C.GLAccount
								
								FROM       Purchase.dbo.Invoice I INNER JOIN
						                   Purchase.dbo.InvoicePurchase IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
						                   Purchase.dbo.PurchaseLine PL ON IP.PurchaseNo = PL.PurchaseNo INNER JOIN
						                   Purchase.dbo.RequisitionLine REQ ON PL.RequisitionNo = REQ.RequisitionNo INNER JOIN
						                   (#LineFunding#) FUN ON REQ.RequisitionNo = FUN.RequisitionNo LEFT OUTER JOIN
						                   Ref_AccountReceipt C ON FUN.Fund = C.Fund AND FUN.ObjectCode = C.ObjectCode
								
								WHERE      I.InvoiceId = '#URL.INVID#' 
								AND        IP.PurchaseNo = '#purchaseno#'
								AND        PL.ActionStatus != '9' <!--- added hanno 25/4/2016 --->
								
								GROUP BY   IP.PurchaseNo,
										   FUN.ProgramPeriod,
								           FUN.Fund, 
										   FUN.ProgramCode,
										   FUN.ActivityId, 
										   FUN.ObjectCode, 
										   REQ.WorkOrderId,
										   REQ.WorkOrderLine,
										   C.GLAccount			
										   
										   <cfif currentrow neq recordcount>
										   
										   UNION ALL									   
										   									   
										   </cfif>
									   
							 </cfloop>									 							   
									   									   		   
							</cfquery>
							
							
						<cfelse>
						
							<cfquery name="check" 
						    datasource="AppsLedger" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">														
								SELECT     *							
								FROM       Purchase.dbo.InvoicePurchase IP 
								WHERE      InvoiceId = '#URL.INVID#'
								AND        (DocumentAmountMatched = 0 or DocumentAmountMatched is NULL)
							</cfquery>
							
							<cfif check.recordcount gte "1">
							
							<cf_message message = "Problem: Your invoice need to be assigned again to one or more requisition lines."
							  return = "no">
							  <cfabort>							
							
							</cfif>
							
							<!--- OICT/CMP UN mode take not that here we link on the requisition line and not on the purchase, there is just one (1)
							purchase order --->
						
							<cfquery name="Lines" 
						    datasource="AppsLedger" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							
								SELECT     FUN.ProgramPeriod,
								           FUN.Fund, 
										   FUN.ProgramCode,
										   FUN.ActivityId, 
										   FUN.ObjectCode, 
										   REQ.WorkOrderId,
										   REQ.WorkOrderLine,										  
										   ROUND(SUM(FUN.Percentage * IP.DocumentAmountMatched),2) AS Portion, 
										   C.GLAccount
								
								FROM       Purchase.dbo.InvoicePurchase IP 
										   INNER JOIN Purchase.dbo.RequisitionLine REQ ON IP.RequisitionNo = REQ.RequisitionNo 
										   INNER JOIN (#LineFunding#) FUN ON REQ.RequisitionNo = FUN.RequisitionNo
										   LEFT OUTER JOIN
						                   Ref_AccountReceipt C ON FUN.Fund = C.Fund AND FUN.ObjectCode = C.ObjectCode
								
								WHERE      IP.InvoiceId = '#URL.INVID#'
								
								GROUP BY   FUN.ProgramPeriod,
								           FUN.Fund, 
										   FUN.ProgramCode, 
										   FUN.ActivityId,
										   FUN.ObjectCode, 
										   REQ.WorkOrderId,
										   REQ.WorkOrderLine,
										   C.GLAccount	
									   					   
							</cfquery>
												
						</cfif>							
						
						 <!--- END INVOICE ONLY --->
						
						
					</cfif>											
					
					<cfif Lines.recordcount eq "0">
					
						<cf_message message = "Purchase Order was not funded. Operation aborted." return = "no">
						<cfabort>
																					
					</cfif>		
					
					<!--- defined if the invoice amount matches in a ratio the amount of the receipts, this is not always 100%
					and means we need to adjust the tax and make a different booking for the goods in order to correctly 
					offset the RI receipts 19/2/2016 --->
										
					<cfif matchreceipt neq "">		
					
						<cfset tot = 0>
					
						<cfoutput query="Lines">						
				
							<cfif Currency neq Invoice.DocumentCurrency>
							
							    <!--- convert to the invoice currency --->
								
								<cf_exchangeRate 
						        CurrencyFrom = "#Currency#" 
						        CurrencyTo   = "#Invoice.DocumentCurrency#">										
																		
								<cfset amtC = ReceiptAmountCost * Percentage / exc>
								<cfset amtT = ReceiptAmountTax  * Percentage / exc>		
					
							<cfelse>
						
								<cfset amtC = ReceiptAmountCost * Percentage>
								<cfset amtT = ReceiptAmountTax  * Percentage>
									
							</cfif>		
							
							<cfset tot = tot + amtC + amtT>
					
						</cfoutput>
						
						<cfset ratio = Invoice.DocumentAmount / tot>
					
					</cfif>					
					
					<!--- --------------------------------------------------------------------- --->			
																							
					<cfoutput query="Lines">						

					    <cfif matchreceipt neq "">
						
						    <cfset acc = GLAccount>	
														
							<!--- ------------------------------------------------------------ --->
							<!--- for asset/whs items in the receipt always take this default contra- account and correct the default account from  
							ref_AccountReceipt this will offset the RI booking for purchases 
							---------------------------- --->
							
						    <cfif GLAccountReceipt neq "" or WarehouseItemNo neq "">								
							
								<cfif GLAccountReceipt neq "">
								
									  <!--- receipt needs contra account booking --->									  
									  <cfset acc = GLAccountReceipt>
																
								<cfelse>
								
									<cfquery name="GLReceipt" 
									   datasource="AppsPurchase" 
									   username="#SESSION.login#" 
									   password="#SESSION.dbpw#">
									     SELECT * 
									     FROM   Materials.dbo.Ref_CategoryGLedger R
									     WHERE  Area       = 'Receipt'
									     AND    Category   = (SELECT Category 
										                      FROM   Materials.dbo.Item 
															  WHERE  ItemNo = '#WarehouseItemNo#')
									     AND    GLAccount IN (SELECT GLAccount 
										                      FROM   Accounting.dbo.Ref_Account
															  WHERE  GLAccount = R.GLAccount)
									</cfquery>
									
									<!--- capture contra account - inkopen --->
									<cfquery name="ReceiptContraAccount" 
								     datasource="AppsPurchase" 
						    		 username="#SESSION.login#" 
								     password="#SESSION.dbpw#">
						    		 	UPDATE PurchaseLineReceipt
										SET    GLAccountReceipt = '#GLReceipt.GLAccount#' 
										WHERE  ReceiptId        = '#ReceiptId#'	
									</cfquery>		
									
									<!--- receipt needs contra account booking --->									  
									<cfset acc = GLReceipt.GLAccount>
								
								</cfif>								
								  
							</cfif>			
							
							<cfif Parameter.InvoiceMatchPriceActual eq "0">
																						   																		
								<cfif Currency neq Invoice.DocumentCurrency>
								
								    <!--- convert to the invoice currency --->
									
									<cf_exchangeRate 
							        CurrencyFrom = "#Currency#" 
							        CurrencyTo   = "#Invoice.DocumentCurrency#">										
																			
									<cfset amtC = ReceiptAmountCost * Percentage / exc>
									<cfset amtT = ReceiptAmountTax  * Percentage / exc>
							
						
								<cfelse>
							
									<cfset amtC = ReceiptAmountCost * Percentage>
									<cfset amtT = ReceiptAmountTax  * Percentage>
										
								</cfif>		
								
								<!--- 18/2/2016 correction in case the invoice is different from the amounts received which we do accept 
									for some threshold values 10% or so --->
								
								<cfset prior   = amtC>																							
									
								<cfset amtC    = ratio * amtC>
								<cfset amtC    = round(amtC*100)/100>
								<cfset amtT    = ratio * amtT>
								<cfset amtT    = round(amtT*100)/100>		
								
								<cfset prdiff  = amtC - Prior>	
								<cfset amtC    = Prior>								
								
							<cfelse>													
							
							      <!--- ---------------------------------------- --->
								  <!--- need to recalculate the tax here as well --->
								  <!--- ---------------------------------------- --->									 
															
							      <cfif Currency neq Invoice.DocumentCurrency>
								
								        <!--- convert to the invoice currency --->																												
									
									    <cf_exchangeRate 
							        		CurrencyFrom = "#Currency#" 
									        CurrencyTo   = "#Invoice.DocumentCurrency#">
										
										<cfset regC = (ReceiptAmountCost * Percentage) / exc>
									    <cfset regT = (ReceiptAmountTax  * Percentage) / exc>	
																			
										<cfset amtC = (InvoiceAmountCost * Percentage) / exc>
										<cfset amtT = (InvoiceAmountTax  * Percentage) / exc>
																				
								   <cfelse>
								   			  							   
								 									   
								   	    <cfset regC = ReceiptAmountCost * Percentage>
										<cfset regT = ReceiptAmountTax  * Percentage>
																										
										<cfset amtC = InvoiceAmountCost * Percentage>
										<cfset amtT = InvoiceAmountTax  * Percentage>
										
								   </cfif>		
								   									   
								   <cfset prdiff = (amtC+amtT) - (regC+regT)>		
								   <cfif prdiff neq "0">
								       <!--- reduce amount C ---> 
									   <cfset amtC   = amtC+prdiff>
								   </cfif>	   
								 							
							
							</cfif>																			
							
							<cfif acc eq "">
							
								<cf_message message = "Accounting code for #ObjectCode# could not be determined. Operation aborted."
										    return = "no">
								<cfabort>
						  
						  	</cfif>																									
														
							<cfif len(ReceiptItem) gte "120">
							   <cfset rcptitem = left(ReceiptItem,120)>
							<cfelse>  
							   <cfset rcptitem = ReceiptItem>
							</cfif>
							
							<cfif workorderid neq "" and workorderline neq "">
							
								<cfquery name="workorder" 
								    datasource="#Attributes.DataSource#" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									SELECT    *
									FROM      Workorder.dbo.WorkOrderLine
									WHERE     workorderid   = '#WorkOrderId#' 
									AND       WorkOrderLine = '#workorderline#'
								</cfquery>
								
								<cfset workorderlineid = workorder.Workorderlineid>
								
							<cfelse>
							
								<cfset workorderlineid = "">	
							
							</cfif>							
							
							<!--- contra booking for materials that were received --->
							
							<cfif prdiff eq "0">													
							
								<cf_GledgerEntryLine
									Lines                 = "2"
								    Journal               = "#Journal.Journal#"
									JournalNo             = "#JournalTransactionNo#"
									AccountPeriod         = "#accPeriod#"
									TransactionPeriod     = "#transactionperiod#"
									Currency              = "#Invoice.DocumentCurrency#"
																			
									DataSource			  = "AppsLedger"
																									
									TransactionSerialNo1  = "#row+1#"
									TransactionAmount1    = "#Round(AmtC*100)/100#" 
									Class1                = "Debit"
									Reference1            = "Receipt"       
									ReferenceName1        = "#nme#"
									Description1          = "#rcptitem#"
									GLAccount1            = "#acc#"
									Costcenter1           = "#Invoice.OrgUnit#"
									Fund1                 = "#Lines.Fund#"
									ProgramCode1          = "#Lines.ProgramCode#"
									ActivityId1           = "#Lines.ActivityId#"
									ObjectCode1           = "#Lines.ObjectCode#"
									ProgramPeriod1        = "#Lines.ProgramPeriod#"
									WorkOrderLineId1      = "#Workorderlineid#"
									ReferenceId1          = "#Lines.ReceiptId#"
									ReferenceNo1          = "#Lines.ReceiptItemNo#"
									TransactionType1      = "Standard"
									Amount1               = "#Round(AmtC*100)/100#"
									
									TransactionSerialNo2  = "#row+2#"
									TransactionAmount2    = "#Round(AmtT*100)/100#" 
									Class2                = "Debit"
									Reference2            = "Tax"       
									ReferenceName2        = "#nme#"
									Description2          = "#ReceiptItem#"
									GLAccount2            = "#taxaccount#"
									Costcenter2           = "#Invoice.OrgUnit#"
									Fund2                 = "#Lines.Fund#"
									ProgramCode2          = "#Lines.ProgramCode#"
									ActivityId2           = "#Lines.ActivityId#"
									ObjectCode2           = "#Lines.ObjectCode#"
									ProgramPeriod2        = "#Lines.ProgramPeriod#"
									WorkOrderLineId2      = "#Workorderlineid#"
									ReferenceId2          = "#Lines.ReceiptId#"
									ReferenceNo2          = "#Lines.ReceiptItemNo#"
									TransactionType2      = "Standard"
									Amount2               = "#Round(AmtT*100)/100#">
								
								<cfset row = row + 2>
								
							<cfelse>							
						
								<cfquery name="PriceDifference" 
							    datasource="AppsLedger" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
								    SELECT    *
								    FROM      Ref_AccountMission
									WHERE     SystemAccount = 'Correction'
									AND       Mission       = '#Invoice.Mission#'
								</cfquery>
								
								<cfif PriceDifference.recordcount eq "0">
								
									<cfquery name="PriceDifference" 
								    datasource="AppsLedger" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									    SELECT    *
									    FROM      Ref_AccountMission
										WHERE     SystemAccount = 'Correction'									
									</cfquery>
								
								</cfif>
								
								<cfif PriceDifference.recordcount eq "0">
								
									<cf_message message = "System Account: A Price correction account has not been defined for #Invoice.Mission#. Operation aborted." return = "no">
									<cfabort>
																								
								</cfif>																		
								
								<cfif prdiff lt 0>
								     <cfset clp = "Credit"> <!--- profit --->
								<cfelse>
								     <cfset clp = "Debit">	<!--- cost ---> 
								</cfif>
								 								
								<cf_GledgerEntryLine
									Lines                 = "3"
								    Journal               = "#Journal.Journal#"
									JournalNo             = "#JournalTransactionNo#"
									AccountPeriod         = "#accPeriod#"
									TransactionPeriod     = "#transactionperiod#"
									Currency              = "#Invoice.DocumentCurrency#"
																									
									TransactionSerialNo1  = "#row+1#"
									TransactionAmount1    = "#Round(AmtC*100)/100#" 
									Class1                = "Debit"
									Reference1            = "Receipt"       
									ReferenceName1        = "#nme#"
									Description1          = "#ReceiptItem#"
									GLAccount1            = "#acc#"
									Costcenter1           = "#Invoice.OrgUnit#"
									Fund1                 = "#Lines.Fund#"
									ProgramCode1          = "#Lines.ProgramCode#"
									ActivityId1           = "#Lines.ActivityId#"
									ObjectCode1           = "#Lines.ObjectCode#"
									ProgramPeriod1        = "#Lines.ProgramPeriod#"
									WorkOrderLineId1      = "#workorderlineid#"
									ReferenceId1          = "#Lines.ReceiptId#"
									ReferenceNo1          = "#Lines.ReceiptItemNo#"
									TransactionType1      = "Standard"
									Amount1               = "#Round(AmtC*100)/100#"
									
									TransactionSerialNo2  = "#row+2#"
									TransactionAmount2    = "#Round(AmtT*100)/100#" 
									Class2                = "Debit"
									Reference2            = "Tax"       
									ReferenceName2        = "#nme#"
									Description2          = "#ReceiptItem#"
									GLAccount2            = "#taxaccount#"
									Costcenter2           = "#Invoice.OrgUnit#"
									Fund2                 = "#Lines.Fund#"
									ProgramCode2          = "#Lines.ProgramCode#"
									ActivityId2           = "#Lines.ActivityId#"
									ObjectCode2           = "#Lines.ObjectCode#"
									ProgramPeriod2        = "#Lines.ProgramPeriod#"
									WorkOrderLineId2      = "#workorderlineid#"
									ReferenceId2          = "#Lines.ReceiptId#"
									ReferenceNo2          = "#Lines.ReceiptItemNo#"
									TransactionType2      = "Standard"
									Amount2               = "#Round(AmtT*100)/100#"
									
									TransactionSerialNo3  = "#row+3#"
									TransactionAmount3    = "#Round(Prdiff*100)/100#" 
									Class3                = "#clp#"
									Reference3            = "Invoice stock receipt difference"       
									ReferenceName3        = "#nme#"
									Description3          = "#ReceiptItem#"
									GLAccount3            = "#PriceDifference.GLAccount#"
									Costcenter3           = "#Invoice.OrgUnit#"
									Fund3                 = "#Lines.Fund#"
									ProgramCode3          = "#Lines.ProgramCode#"
									ActivityId3           = "#Lines.ActivityId#"
									ObjectCode3           = "#Lines.ObjectCode#"
									ProgramPeriod3        = "#Lines.ProgramPeriod#"
									WorkOrderLineId3      = "#workorderlineid#"
									ReferenceId3          = "#Lines.ReceiptId#"
									ReferenceNo3          = "#Lines.ReceiptItemNo#"
									TransactionType3      = "Standard"
									Amount3               = "#abs(Round(prdiff*100)/100)#">
								
								<cfset row = row + 3>
							
							</cfif>											
							
						<cfelse>												
												
						    <!--- INVOICE ONLY only --->
																				
							<cfif Journal.Currency neq Invoice.DocumentCurrency>
								
								 <!--- convert to the invoice currency --->
									
								<cf_exchangeRate 
							       	CurrencyFrom = "#Invoice.DocumentCurrency#" 
								    CurrencyTo   = "#Journal.Currency#">
										
									<cfset amtC = Portion*exc>
									<cfset amtT = 0>
																				
							<cfelse>
																										
									<cfset amtC = Portion>
									<cfset amtT = 0>

							</cfif>									
							
							<cfif Invoice.TaxExemption eq "1">
							
							<cfelse>
							
								<!--- based on the PO, we determine the tax ratio for the purchaseNo lines --->
															
								<cfquery name="Tax" 
								    datasource="AppsLedger" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									SELECT     PurchaseNo, SUM(OrderAmountTax) / Sum(OrderAmount) AS TaxRatio
									FROM       Purchase.dbo.PurchaseLine
									<!--- adjusted as we can now have several purchase no for one invoice --->
									WHERE      PurchaseNo = '#Issued.PurchaseNo#'
									AND        ActionStatus != '9' 
									GROUP BY   PurchaseNo
								</cfquery>							
								
								<cfloop query="Tax">
																																   
										<cfset amtT = amtC*Tax.TaxRatio>
										<cfset amtC = amtC-amtT>							
									
								</cfloop>	
							
							</cfif>
																
							<cfset acc = Lines.GLAccount>
							
							<cfif acc eq "">
							
								<cf_message message = "Accounting code for #Fund# - #ObjectCode# could not be determined. Operation aborted. "
									  return = "no">
									  <cfabort>
						  
						  	</cfif>															

							<!--- added by Armin on 11/02/2014---->
							<cfif workorderid neq "" and workorderline neq "">
							
								<cfquery name="workorder" 
								    datasource="#Attributes.DataSource#" 
								    username="#SESSION.login#" 
								    password="#SESSION.dbpw#">
									SELECT    *
									FROM      Workorder.dbo.WorkOrderLine
									WHERE     workorderid   = '#WorkOrderId#' 
									AND       WorkOrderLine = '#workorderline#'
								</cfquery>
								
								<cfset workorderlineid = workorder.Workorderlineid>
								
							<cfelse>
							
								<cfset workorderlineid = "">	
							
							</cfif>															

							<cf_GledgerEntryLine
								Lines                 = "2"
							    Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								AccountPeriod         = "#accperiod#"
								TransactionPeriod     = "#transactionperiod#"
								Currency              = "#Invoice.DocumentCurrency#"
								
								TransactionSerialNo1  = "#row+1#"
								TransactionAmount1    = "#amtC#" 
								Class1                = "Debit"
								Reference1            = "Receipt"       
								ReferenceName1        = "#nme#"
								Description1          = "Invoice"
								GLAccount1            = "#acc#"
								Fund1                 = "#fund#"
								ObjectCode1           = "#Lines.ObjectCode#" 
								Costcenter1           = "#Invoice.OrgUnit#"
								ProgramCode1          = "#Lines.ProgramCode#"
								ActivityId1           = "#Lines.ActivityId#"
								ProgramPeriod1        = "#Lines.ProgramPeriod#"
								WorkOrderLineId1      = "#workorderlineid#"
								ReferenceId1          = "#Invoice.InvoiceId#"
								ReferenceNo1          = "#org#"
								TransactionType1      = "Standard"
								Amount1               = "#Round(AmtC*100)/100#"								
								
								TransactionSerialNo2  = "#row+2#"
								TransactionAmount2    = "#amtT#" 
								Class2                = "Debit"
								Reference2            = "Tax"       
								ReferenceName2        = "#nme#"
								Description2          = "Invoice"
								GLAccount2            = "#taxaccount#"
								Fund2                 = "#fund#"
								ObjectCode2           = "#Lines.ObjectCode#" 
								Costcenter2           = "#Invoice.OrgUnit#"
								ProgramCode2          = "#Lines.ProgramCode#"
								ActivityId2           = "#Lines.ActivityId#"
								ProgramPeriod2        = "#Lines.ProgramPeriod#"
								WorkOrderLineId2      = "#workorderlineid#"
								ReferenceId2          = "#Invoice.InvoiceId#"
								ReferenceNo2          = "#org#"
								TransactionType2      = "Standard"
								Amount2               = "#Round(AmtT*100)/100#">
							
							<cfset row = row + 2>
																
						</cfif>	
						
					</cfoutput>
																
					<cfquery name="Sum" 
					  datasource="AppsLedger" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  
						  SELECT    SUM(AmountDebit)     - sum(AmountCredit) as diffAmount,
						            SUM(AmountBaseDebit) - sum(AmountBaseCredit) as diffBase
						  FROM      TransactionLine
						  WHERE     Journal         = '#Journal.Journal#'
						  AND       JournalSerialNo = '#JournalTransactionNo#' 
					  
					</cfquery>
										
					<!--- Correction, 31/3/2012 
					it is better to use the correction account for this instead of adjusting the amounts 
					this is pending 
					--->
								
					<cfif sum.diffAmount neq "0" or sum.diffbase neq "0">
					
						<cfquery name="Parameter" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Purchase.dbo.Ref_ParameterMission
							WHERE  Mission = '#Invoice.Mission#' 
						</cfquery>
						
						<cfif Parameter.DifferenceGLAccount neq "">
						
							<cfif sum.diffamount gte "0">
							
								<cfset cls = "Credit">
								<cfset amt = sum.diffamount>
								
							<cfelse>
							
								<cfset cls = "Debit">
								<cfset amt = sum.diffamount*-1>
							
							</cfif>
					
							<cf_GledgerEntryLine
								Lines                 = "1"
							    Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								AccountPeriod         = "#accperiod#"
								TransactionPeriod     = "#transactionperiod#"
								Currency              = "#Invoice.DocumentCurrency#"								
								TransactionSerialNo1  = "#row+1#"
								TransactionAmount1    = "#amt#" 
								Class1                = "#cls#"
								Reference1            = "InvoiceDifference"       								
								Description1          = "Invoice"
								GLAccount1            = "#Parameter.DifferenceGLAccount#"								
								Costcenter1           = "#Invoice.OrgUnit#"																
								ReferenceId1          = "#Invoice.InvoiceId#"								
								TransactionType1      = "Standard"
								Amount1               = "#Round(sum.diffAmount*100)/100#">
					
                         <cfelse>					
					 
							<cfquery name="Line" 
							  datasource="AppsLedger" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  SELECT    TOP 1 *
							  FROM      TransactionLine
							  WHERE     Journal         = '#Journal.Journal#'
							  AND       JournalSerialNo = '#JournalTransactionNo#'
							  AND       AmountDebit > 0
							  ORDER BY  TransactionSerialNo
							</cfquery>
							
							<cfif Line.recordcount neq "0">
							
								<cfquery name="Correction" 
								  datasource="AppsLedger" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  UPDATE    TransactionLine
								  SET       AmountDebit       = AmountDebit     - #sum.diffAmount#,
										    AmountBaseDebit   = AmountBaseDebit - #sum.diffBase#
								  WHERE     TransactionLineId = '#line.TransactionLineId#'		 
								</cfquery>
							
							</cfif>
						
						</cfif>
																				
				   </cfif>
								
				<!--- ---------- --->
				
				<cfif matchreceipt neq "">
				
					<cfquery name="SetReceipt" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    UPDATE    Purchase.dbo.PurchaseLineReceipt
						SET       ActionStatus = '2', 
						          InvoiceIdMatched = '#URL.INVID#'	
						WHERE     ReceiptId IN (#PreserveSingleQuotes(matchreceipt)#)
						<!--- receipt has been cleared = 1 --->
						AND       ActionStatus = '1' 
					</cfquery>	
					
					<cfquery name="SetReceipt" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    UPDATE    Purchase.dbo.Invoice
						SET       ActionStatus = '1'
						WHERE     InvoiceId = '#URL.INVID#'					
					</cfquery>	
					
				<cfelse>
				
					<cfquery name="SetReceipt" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    UPDATE    Purchase.dbo.Invoice
						SET       ActionStatus = '1'
						WHERE     InvoiceId = '#URL.INVID#'				
					</cfquery>	
								
				</cfif>			
				
			<!--- after the booking we are going to populate the liquidation in purchase,cfc --->		
			
			<cfloop query="PO">			
							
				<cfinvoke component = "Service.Process.Procurement.Purchase"  
		   		   method           = "setLiquidation" 
				   datasource       = "appsLedger"
				   purchaseno       = "#PurchaseNo#">	
			   
			</cfloop>   							
					
	</cfif>	


