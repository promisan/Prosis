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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_systemscript>

<cfparam name="url.html" default="Yes">

<cfif ParameterExists(Form.Schedule)>
	
	<cfif form.entityclass neq "">
	
		<cfset dateValue = "">
		<cfif Form.schedule eq "Later" and Form.workflowdate neq "">
		    <CF_DateConvert Value="#Form.WorkFlowDate#">
		    <cfset dte = dateValue>
		<cfelse>
			<cfset d = dateformat(now(),CLIENT.DateFormatShow)>
			<CF_DateConvert Value="#d#">
		    <cfset dte = dateValue>
		</cfif>	
	
	 	<cfquery name="UpdateInvoice" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE Invoice
		 SET    EntityClass       = '#Form.EntityClass#', 
		        WorkflowDate       = #dte#
	 	 WHERE  InvoiceId = '#URL.ID#'   
		</cfquery> 
				
		<cf_workflowTrigger>			
		
	</cfif>	
	
	<cfoutput>
	<script language="JavaScript1.1">
		ptoken.location("InvoiceMatch.cfm?id=#url.id#&html=#url.html#")
	</script>		
	</cfoutput>

</cfif>

<cfif ParameterExists(Form.MatchReceipt)>

		<cfquery name="SetReceipt" 
		    datasource="AppsLedger" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    UPDATE    Purchase.dbo.PurchaseLineReceipt
				SET       ActionStatus = '2', 
				          InvoiceIdMatched = '#URL.ID#'	
				WHERE     ReceiptId IN (#PreserveSingleQuotes(selected)#)
				<!--- receipt has been cleared = 1 --->
				AND       ActionStatus = '1' 
		</cfquery>	

		<cfoutput>	
			<script language="JavaScript1.1">		
				ptoken.location("#SESSION.root#/procurement/Application/Invoice/Matching/InvoiceMatch.cfm?Id=#URL.ID#")
			</script>		
		</cfoutput>	
	
</cfif>

<cfif ParameterExists(Form.Purge) 
	or ParameterExists(Form.Cancel) 
	or ParameterExists(Form.Delete) 	
	or ParameterExists(Form.Reinstate)>
	
    <cftransaction>	
		
		<cfquery name="Invoice" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Invoice
			WHERE  InvoiceId = '#URL.ID#'
		</cfquery>
		
		<!--- get the class --->
		
		<cfquery name="Incoming" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * 
			FROM   InvoiceIncoming
			WHERE  Mission       = '#Invoice.Mission#'
			AND    OrgUnitOwner  = '#Invoice.OrgUnitOwner#'
			AND    OrgUnitVendor = '#Invoice.OrgUnitVendor#'
			AND    InvoiceNo     = '#Invoice.InvoiceNo#'			
		</cfquery>
		
		<cfif Incoming.InvoiceClass eq "Standard">
		
			<cfquery name="ResetReceipt" 
			    datasource="AppsPurchase" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    UPDATE PurchaseLineReceipt
				SET    ActionStatus = '1', 
				       InvoiceIdMatched = NULL
				WHERE  ReceiptId IN (SELECT L.ReferenceId 
				                      FROM  Accounting.dbo.TransactionLine L, 
									        Accounting.dbo.TransactionHeader H
									 WHERE  L.Journal = H.Journal
									   AND  L.JournalSerialNo = H.JournalSerialNo
									   AND  H.ReferenceId = '#URL.ID#')
				<!--- 6/2/2010 by Dev for OICT processing --->
				OR   InvoiceIdMatched = '#URL.ID#'					   
			</cfquery>`
		
		<cfelseif ParameterExists(Form.Purge)>
		
		    <!--- warehouse issuance tracking --->
		
			<cfquery name="ResetReceipt" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    UPDATE Materials.dbo.ItemTransactionShipping
				SET    InvoiceId = NULL
				WHERE  InvoiceId = '#URL.ID#'				   
		    </cfquery>							
		
		</cfif>
						
		<cfquery name="ResetReceipt" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    UPDATE PurchaseLineReceipt
			SET    ActionStatus = '1', 
			       InvoiceIdMatched = NULL
			WHERE  ReceiptId IN (SELECT L.ReferenceId 
			                      FROM  Accounting.dbo.TransactionLine L, 
								        Accounting.dbo.TransactionHeader H
								 WHERE  L.Journal = H.Journal
								   AND  L.JournalSerialNo = H.JournalSerialNo
								   AND  H.ReferenceId = '#URL.ID#')
			<!--- 6/2/2010 by Dev for OICT processing --->
			OR   InvoiceIdMatched = '#URL.ID#'					   
		</cfquery>
		
		<!--- reset the receipt of the warehouse --->
		
		<cfquery name="Invoice" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Invoice
			WHERE  InvoiceId = '#URL.ID#'
		</cfquery>
			
		<!--- verify if I need to delete the parent copy of the record --->
				
		<cfquery name="Invoices" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * FROM Invoice
			WHERE     Mission       = '#Invoice.Mission#'
			AND       OrgUnitVendor = '#Invoice.OrgUnitVendor#'
			AND       InvoiceNo     = '#Invoice.InvoiceNo#'						
		</cfquery>
		
		<cfquery name="Matched" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * FROM Invoice D
			WHERE     Mission       = '#Invoice.Mission#'
			AND       OrgUnitVendor = '#Invoice.OrgUnitVendor#'
			AND       InvoiceNo     = '#Invoice.InvoiceNo#'		
			AND       InvoiceId IN (SELECT InvoiceidMatched FROM PurchaseLineReceipt WHERE InvoiceidMatched = D.InvoiceId)				
		</cfquery>
						
		<!--- Note : Trigger will remove GL entry and a Workflow entry ---> 
		
		<cfif ParameterExists(Form.Purge)>		
		
			
		    <cfif Matched.recordcount gte "1">
			
				<cf_waitEnd> 
							
				<cf_message 
				  message = "Invoice was matched already. Operation not allowed."
				  return = "back">
				  <cfabort>
				
			<cfelseif Invoices.recordcount eq "1">
			
				 <!--- clear ledger --->
				
				<cfquery name="Ledger" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT * 
					FROM   Accounting.dbo.TransactionHeader 
					WHERE  ReferenceId = '#URL.ID#' 
					ORDER BY Created DESC
				</cfquery>			
				
				<cfloop query="Ledger">
			
					<cfquery name="Delete" 
					    datasource="AppsPurchase" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						DELETE FROM Accounting.dbo.TransactionHeader 
						WHERE  TransactionId = '#TransactionId#' 
					</cfquery>				
				
				</cfloop>									
				
				<cfquery name="Delete" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    DELETE FROM InvoiceIncoming
					WHERE     Mission       = '#Invoice.Mission#'
					AND       OrgUnitVendor = '#Invoice.OrgUnitVendor#'
					AND       InvoiceNo     = '#Invoice.InvoiceNo#'
				</cfquery>
				
				<!--- listing refresh --->
				
				<cftry>		
			
					<cfquery name="Delete" 
					    datasource="AppsPurchase" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					    DELETE FROM userquery.dbo.lsInvoice_#SESSION.acc#
						WHERE  InvoiceId = '#URL.ID#'
					</cfquery>
				
					<cfcatch></cfcatch>
				
				</cftry>
			
			<cfelse>
			
			    <!--- clear ledger --->
				
				<cfquery name="Ledger" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT   * 
					FROM     Accounting.dbo.TransactionHeader 
					WHERE    ReferenceId = '#URL.ID#'
					ORDER BY Created DESC
				</cfquery>			
				
				<cfloop query="Ledger">
			
					<cfquery name="Delete" 
					    datasource="AppsPurchase" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						DELETE FROM Accounting.dbo.TransactionHeader 
						WHERE  TransactionId = '#TransactionId#'
					</cfquery>				
				
				</cfloop>	
				
				<cfquery name="Update" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    DELETE FROM Invoice
					WHERE  InvoiceId = '#URL.ID#'
				</cfquery>	
				
				<!--- listing refresh --->
				
				<cftry>		
			
					<cfquery name="Delete" 
					    datasource="AppsPurchase" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					    DELETE FROM userquery.dbo.lsInvoice_#SESSION.acc#
						WHERE  InvoiceId = '#URL.ID#'
					</cfquery>
				
					<cfcatch></cfcatch>
				
				</cftry>
					
			</cfif>
			
			<cfoutput>
			
			<script language="JavaScript1.1">
		
				try {						    		
				    parent.opener.applyfilter('1','','#url.id#') 									
					} catch(e) { }						
					
					ptoken.location("Invoicematch.cfm?html=no&id=#url.id#")								
				
			</script>	
			
			</cfoutput>		
			
		<cfelseif ParameterExists(Form.Cancel)>
		
				<!--- clear ledger --->
				
				<cfquery name="Ledger" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT * FROM Accounting.dbo.TransactionHeader 
					WHERE  ReferenceId = '#URL.ID#'
					ORDER BY Created DESC
				</cfquery>			
				
				<cfloop query="Ledger">
			
					<cfquery name="Delete" 
					    datasource="AppsPurchase" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						DELETE FROM Accounting.dbo.TransactionHeader 
						WHERE  TransactionId = '#TransactionId#'
					</cfquery>				
				
				</cfloop>						
								
				<cfquery name="ResetWorkflow" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    UPDATE Organization.dbo.OrganizationObject
					SET    Operational = 0			
					WHERE  ObjectKeyValue4 = '#URL.ID#'
				</cfquery>						
				
				<!--- SET STATUS as 9 and undo reconciliation --->	
				
				<cfquery name="Incoming" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT IC.*
					FROM   InvoiceIncoming IC INNER JOIN
                      Invoice I ON IC.Mission = I.Mission 
					  AND IC.OrgUnitOwner = I.OrgUnitOwner 
					  AND IC.OrgUnitVendor = I.OrgUnitVendor 
					  AND IC.InvoiceNo = I.InvoiceNo
					WHERE  InvoiceId = '#URL.ID#'
				</cfquery>		
		
				<cfquery name="Status" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    UPDATE Invoice
					SET    ActionStatus       = '9',					       
					       ActionStatusDate   = getDate(),
						   ActionStatusUserId = '#SESSION.acc#',
					       ReconciliationNo   = NULL					
					WHERE  InvoiceId = '#URL.ID#'
				</cfquery>
				
				<script language="JavaScript1.1">		
					ptoken.location("Invoicematch.cfm?id=<cfoutput>#url.id#</cfoutput>")					
				</script>	
				
		<cfelseif ParameterExists(Form.Reinstate)>		
		
				<!--- SET STATUS as 9 and undo reconciliation --->	
		
				<cfquery name="Status" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    UPDATE Invoice
					SET    ActionStatus = '0',
					       ReconciliationNo = NULL					
					WHERE  InvoiceId = '#URL.ID#'
				</cfquery>
				
				<cfquery name="ResetWorkflow" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    UPDATE Organization.dbo.OrganizationObject
					SET    Operational = 0			
					WHERE  ObjectKeyValue4 = '#URL.ID#'
				</cfquery>	
				
				<script language="JavaScript1.1">		
					ptoken.location("Invoicematch.cfm?id=<cfoutput>#url.id#</cfoutput>")					
				</script>						
		
		</cfif>	
			
	</cftransaction>

</cfif>

<!--- ---------------------------------------------------------------------- --->
<!--- directly process an invoice for a PO which is not requiring a workflow --->
<!--- invoice only = 0 and receipt =1 -------------------------------------- --->

<cfif ParameterExists(Form.Save)>

    <!--- ----------------------------------------------------------------- --->
    <!--- -------- Undo closure if the purchase is already closed --------- --->
	<!--- ----------------------------------------------------------------- --->
	
	<cfquery name="Check" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      InvoicePurchase I
			WHERE     InvoiceId = '#URL.ID#'			
	</cfquery>
	
	<cfquery name="PO" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      Purchase I
			WHERE     PurchaseNo = '#Check.PurchaseNo#'		
	</cfquery>
	
	<cfif PO.ObligationStatus eq "0">
	
		<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Purchase 
				SET    ObligationStatus      = '1',
					   ObligationStatusDate  = getDate(),
					   ObligationStatusActor = 'SystemReset'
				WHERE  PurchaseNo            = '#PO.PurchaseNo#'
		</cfquery>
		
		<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE PurchaseLine 
				SET    OrderAmountBaseObligated = OrderAmountBase 				       
				WHERE  PurchaseNo = '#PO.PurchaseNo#'
		</cfquery>		
	
	</cfif>
		  
	<!--- the below code is perfomed as Invoice registration as well --->
	      
	<cf_verifyOperational module="Accounting" Warning="No">
	
	<cfif operational eq "1">
				
			<cfquery name="Invoice" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT    *
		    FROM      Invoice I, Organization.dbo.Organization O
			WHERE     InvoiceId = '#URL.ID#'
			AND       I.OrgUnitVendor = O.OrgUnit
			</cfquery>
					
			<cfquery name="Currency" 
		      datasource="AppsLedger" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT    TOP 1 *
		      FROM      CurrencyExchange
			  WHERE     Currency = '#Invoice.DocumentCurrency#'
			  ORDER BY  EffectiveDate DESC
			</cfquery>
			
			<cfif Currency.recordcount eq "0">
						
				<cf_waitEnd> 
							
				<cf_message 
				  message = "Exchange rate has not been recorded. Operation not allowed."
				  return = "back">
				  <cfabort>
			  
			</cfif>  					
			
	</cfif>	
			
	<!--- reset remove and reset prior entries --->
		
	<cf_verifyOperational module = "Accounting" Warning = "No">
					
	<cfif operational eq "0">
	
			<cfparam name="form.receipt" default="">
			
			<!--- CMP model --->
			<cfif form.receipt neq "">
			
			     <cfquery name="SetReceipt" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    UPDATE  PurchaseLineReceipt
					SET     ActionStatus     = '2',
					        InvoiceIdMatched = '#URL.ID#'
					WHERE   ReceiptId IN (#preservesinglequotes(form.linesselect)#)
				</cfquery>	
			
			</cfif>
			
			 <cfquery name="SetInvoice" 
			    datasource="AppsPurchase" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    UPDATE  Invoice
				SET     ActionStatus     = '1'
				WHERE   InvoiceId = '#URL.ID#'				
			</cfquery>			
		
	<cfelse>
		
			<cftransaction>
		
			    <!--- reset receipt from prior posting to status 1, does never hurt --->
					
				<cfquery name="ResetReceipt" 
				    datasource="AppsLedger" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    UPDATE  Purchase.dbo.PurchaseLineReceipt
					SET     ActionStatus     = '1',
					        InvoiceIdMatched = '#URL.ID#'
					WHERE   ReceiptId IN (SELECT L.ReferenceId 
					                    FROM TransactionLine L, TransactionHeader H
										WHERE L.Journal = H.Journal
										AND L.JournalSerialNo = H.JournalSerialNo
										AND H.ReferenceId = '#URL.ID#') 
				</cfquery>
				
				<!--- ---------- --->
				<!--- GL Posting --->
				<!--- ---------- --->
				
				<cfinclude template="../../../../Tools/Process/EntityAction/INV007_Submit.cfm">
							
			</cftransaction>
			
	</cfif>	
	
	<cfquery name="UpdateInvoice" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	     UPDATE Invoice
		 SET    ActionStatus       = '1' 
		 WHERE  InvoiceId = '#URL.ID#'
	</cfquery> 
	
	<!--- funding --->
	
	<cfquery name="DeleteRecord" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		 DELETE  FROM    InvoiceFunding
		 WHERE   InvoiceId = '#URL.ID#' 		
	</cfquery>
	
	<cfquery name="FundedRecord" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		   INSERT INTO InvoiceFunding
		            (InvoiceId,Fund,ProgramPeriod,ProgramCode,ActivityId,ObjectCode,Amount)		
					 
			SELECT  InvoiceId,
			        Fund,
					Period,
					ProgramCode,
					ActivityId,
					ObjectCode, 
					SUM(Amount) as Amount
			
			FROM   (						 
					 	 
					SELECT     I.InvoiceId, 
					           F.Fund, 
							   F.Period, 
							   F.ProgramCode, 
							   F.ActivityId, 
							   F.ObjectCode, ROUND(F.Amount /
		                          (SELECT    SUM(Amount) 
		                           FROM      PurchaseFunding
									<!---  20/4/2016 ---  WHERE      (PurchaseNo = IP.PurchaseNo)), 2) * I.DocumentAmount AS Amount --->
								   WHERE     (PurchaseNo = IP.PurchaseNo)) * IP.AmountMatched, 2) AS Amount
					FROM      Invoice AS I INNER JOIN
				              InvoicePurchase AS IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
		        		      PurchaseFunding AS F ON IP.PurchaseNo = F.PurchaseNo
					WHERE     I.InvoiceId = '#url.id#'
					
					GROUP BY  IP.PurchaseNo,
					          I.InvoiceId, 
							  F.Fund, 
							  F.Period, 
							  F.ProgramCode, 
							  F.ActivityId,
							  F.ObjectCode, 
							  F.Amount, 
							  IP.AmountMatched 
							  
					) as sub
					
			GROUP BY InvoiceId,Fund,Period,ProgramCode,ActivityId,ObjectCode
						  
	</cfquery>
	
	<!--- old code 
		
	<cfquery name="FundedRecord" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  INSERT INTO InvoiceFunding
		     (InvoiceId,Fund,ProgramPeriod,ProgramCode,ActivityId,ObjectCode,Amount)
		    SELECT    I.InvoiceId, 
			          F.Fund, 
					  F.Period,
					  F.ProgramCode, 
					  F.ActivityId,
					  F.ObjectCode, 					 
					  ROUND(F.Amount /
                        (SELECT   SUM(Amount)
                          FROM    PurchaseFunding
                         WHERE    PurchaseNo = IP.PurchaseNo)*I.DocumentAmount, 2) AS Amount
			FROM      Invoice I INNER JOIN
                      InvoicePurchase IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
                      PurchaseFunding F ON IP.PurchaseNo = F.PurchaseNo
			WHERE     I.InvoiceId = '#url.id#'	
			GROUP BY  IP.PurchaseNo,
			          I.InvoiceId, 
					  F.Fund, 
					  F.Period, 
					  F.ProgramCode, 
					  F.ActivityId,
					  F.ObjectCode, 
					  F.Amount, 
					  I.DocumentAmount 	  
	</cfquery>
	
	--->
	
	<script language="JavaScript1.1">
		
		try {
		window.close()
		opener.history.go() } 
		catch(e) {
			ptoken.location("Invoicematch.cfm?html=no&id=<cfoutput>#url.id#</cfoutput>")					
		}						
		
	</script>	
			
</cfif>		
	
