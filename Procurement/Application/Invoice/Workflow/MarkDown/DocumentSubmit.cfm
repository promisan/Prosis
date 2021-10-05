
<cfparam name="URL.Mode" default="Workflow">
<cfparam name="URL.dialog" default="0">
<cfparam name="FORM.TaxExemption"   default="0">

<cfset dateValue = "">
<cfif Form.DocumentDate neq ''>
    <CF_DateConvert Value="#Form.DocumentDate#">
    <cfset DTEDOC = dateValue>
<cfelse>
    <cfset DTEDOC = 'NULL'>
</cfif>	

<cfset dateValue = "">
<cfif Form.ActionBefore neq ''>
    <CF_DateConvert Value="#Form.ActionBefore#">
    <cfset DTEDUE = dateValue>
<cfelse>
    <cfset DTEDUE = 'NULL'>
</cfif>	

<cfparam name="form.remainder" default="1">

<cfif Len(Form.Description) gt 400>
      <cfif url.dialog eq "0">	
	 	  <cf_message message = "You entered a memo that exceeded the allowed size of 400 characters."  return = "back">
	  <cfelse>
	      <cf_alert message = "You entered a memo that exceeded the allowed size of 400 characters.">
	   </cfif>	 
	  <cfabort>
</cfif> 

<cfquery name="Inv" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Invoice
	WHERE InvoiceId = '#Form.Key4#'
</cfquery>

<cftransaction>

<cfquery name="Update" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Invoice
	SET    Description = '#Form.Description#',
			TaxExemption = '#FORM.TaxExemption#'
	WHERE  InvoiceId = '#Form.Key4#' 
</cfquery>

<cfparam name="Form.InvoiceLineId" default="">

<cfquery name="Delete" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE InvoiceLine
	WHERE  InvoiceId = '#Form.Key4#' 	
</cfquery>

<cfloop index="line" list="#Form.InvoiceLineId#">
	
	<cfquery name="Insert" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO InvoiceLine
		(InvoiceId,InvoiceLineId)
	VALUES
		('#Form.Key4#','#line#')	
	</cfquery>

</cfloop>

<cfquery name="DetailLines" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT sum(LineAmount) as Total
	FROM   InvoiceIncomingLine
	WHERE  InvoiceLineId  IN (SELECT InvoiceLineId FROM InvoiceLine WHERE InvoiceId ='#Form.Key4#') 	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Inv.Mission#' 
</cfquery>

<cfquery name="Parent" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM InvoiceIncoming
	WHERE  InvoiceNo        = '#inv.InvoiceNo#'
	AND    Mission          = '#inv.Mission#'
	AND    OrgUnitOwner     = '#inv.OrgUnitOwner#'
	AND    OrgUnitVendor    = '#inv.OrgUnitVendor#'
</cfquery>

<!--- ----------------------------------------------------------------- --->
<!--- -------- Undo closure if the purchase is already closed --------- --->
<!--- ----------------------------------------------------------------- --->

<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      InvoicePurchase I
		WHERE     InvoiceId = '#Form.Key4#'			
</cfquery>

<cfquery name="PO" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Purchase
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
	
	<cfquery name="PO" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE PurchaseLine 
			SET    OrderAmountBaseObligated = OrderAmountBase 				       
			WHERE  PurchaseNo = '#PO.PurchaseNo#'
	</cfquery>		

</cfif>

<cfset inc = Parent.InvoiceIncomingId>

<!--- ----------------- --->
<!--- Update Invoice No --->
<!--- ----------------- --->

<cftry>	
			
	<cfquery name="Update" 
		datasource="appsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE InvoiceIncoming
			SET    InvoiceSeries      = '#Form.InvoiceSeries#',
			       InvoiceNo          = '#Form.InvoiceNo#',
				   InvoiceIssued      = '#Form.InvoiceIssued#',
				   InvoiceReference   = '#Form.InvoiceReference#'
			WHERE  InvoiceIncomingId  = '#inc#'
	</cfquery>	
					
	<cfcatch>
	
		  <cfif url.dialog eq "0">	
		 	<cf_message message = "Your entered an invoice No that already existed for this vendor. Operation aborted.">
		  <cfelse>
		     <cf_alert message = "Your entered an invoice No that already existed for this vendor. Operation aborted.">
		  </cfif>	 
		  <cfabort>
	
	</cfcatch>

</cftry>

<cfif ParameterExists(Form.PurchaseNo)> 

		<cfset val = 0>
		
		<!--- purchase lines --->

		<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   PL.*, R.Mission, J.CaseNo
			FROM     PurchaseLine PL INNER JOIN
	                 RequisitionLine R ON PL.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
	                 Job J ON R.JobNo = J.JobNo
			WHERE    PL.PurchaseNo = '#Form.PurchaseNo#'
			AND      PL.OrderAmount <> 0
			ORDER BY PL.ListingOrder,R.RequisitionNo					
		</cfquery>
	
				
		<!--- capture the prior distribution of this invoice into a query --->
		
		<cfquery name="PriorDistribution" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   PurchaseNo,
			         RequisitionNo,
				     AmountMatched 
			FROM     InvoicePurchase
			WHERE    InvoiceId  = '#Form.Key4#'
		</cfquery>
		
		<!--- remove the mapping of the invoice to the request --->
		
		<cfif lines.recordcount gte "1">
		
			<cfquery name="Clear" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE 
				FROM    InvoicePurchaseClass
				WHERE   InvoiceId = '#Form.Key4#'
			</cfquery>
		
			<cfquery name="UpdateInvoice" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE 
				 FROM   InvoicePurchase
				 WHERE  InvoiceId  = '#Form.Key4#'
			</cfquery>
					
		</cfif>
		
		<!--- insert the new mapping for this invoice --->
		
		<cfset map = 0>
		
		 <!--- check the currency --->
			   
		 <cfquery name="getPO" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Purchase
			WHERE    PurchaseNo = '#Form.PurchaseNo#'					
		 </cfquery>
		  
		 <cfquery name="getInv" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Invoice
			WHERE    InvoiceId = '#Form.Key4#'					
		 </cfquery>

		<cfoutput query="Lines">
								
			<cfparam name="Form.req#currentrow#" default="">
		
			<cfset v = evaluate("Form.req#currentrow#")>
			<cfset v = replace(v,',','',"ALL")>			
														
			<cfif v neq "" and (v gt "0" or v lt "0")>
						
				  <cfif NOT LSisNumeric(v)>
				  
					 <cfif url.dialog eq "0">	
					 	 <cf_message message = "You have entered a non-numeric number. Operation not allowed."
					  	             return  = "back">
					  <cfelse>
					     <cf_alert message = "You have entered a non-numeric number. Operation not allowed.">
					  </cfif>	 
					  <cfabort>
											
				  </cfif>
				  
				  <!--- auto assign --->			  
			  
				  <cfif getPO.Currency eq getInv.DocumentCurrency>
				  
				  	 <cfset doc   =   Round(v*100)/100>
				     <cfset mat   =   Round(v*100)/100>					
				  			  
				  <cfelse>
				  
				  	<cfset doc   =   Round(v*100)/100>
					
				  	<cf_ExchangeRate DataSource="AppsPurchase" 
					                 CurrencyFrom="#getInv.DocumentCurrency#"
									 CurrencyTo="#getPO.Currency#">
				  
				  	 <cfset mat   =  Round((doc/exc)*100)/100>
					 
				  
				  </cfif>
				  
				  <cfset map = 1>
				  
				   <cfquery name="InsertMapping" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO InvoicePurchase
							 (InvoiceId,
							  PurchaseNo,
							  RequisitionNo,
							  DocumentAmountMatched,
							  AmountMatched,							  
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName) 
					  VALUES ('#Form.Key4#', 
							  '#Form.PurchaseNo#',
							  '#RequisitionNo#',
							  '#doc#',
							  '#mat#',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				   </cfquery>
				   
				   <!--- verify overposting --->
			
				   <cfquery name="CheckSum" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     SELECT SUM(AmountMatched) as Amount
							 FROM   InvoicePurchase IP
							 WHERE  IP.RequisitionNo  = '#RequisitionNo#' 									
							  <!--- only counted for invoices that are in process at this point --->
							 AND    IP.InvoiceId IN (SELECT InvoiceId 
				                 				     FROM   Invoice
						        				     WHERE  InvoiceId = IP.InvoiceId
												     AND    ActionStatus != '9')			
				   </cfquery>
				   
				   <!--- provision to apply a percentage for allowable difference --->
				   
				   <cfset allowed = OrderAmount + (OrderAmount * (parameter.InvoiceMatchDifference/100))>
				   
				   <cfset charged = checkSum.amount>
				   					 
				   <cfif (allowed - charged) lte -0.5>				  							 
				   						   
				   		  <cfif url.dialog eq "0">	
						  
						    <cfset msg = "It is not permitted to overspend (amount : #currency# #numberformat(charged,'__,__.__')#) the line: #RequisitionNo# with an obligation amount of #currency# #numberformat(allowed,'__,__.__')#. <br> <i><u>#OrderItem#</u></i> <br> Please contact your administrator if this problem persists.">						 
						 	<cf_message message = "#msg#" return = "no">
							
						  <cfelse>
						  
						     <cfset msg = "It is not permitted to overspend (amount : #currency# #numberformat(charged,'__,__.__')#) the line: #RequisitionNo# with an obligation amount of #currency# #numberformat(allowed,'__,__.__')#. \n\n #OrderItem# \n\n Please contact your administrator if this problem persists.">						
						     <cf_alert message = "#msg#">
							 
						  </cfif>	 
						  
						  <cfabort>
					 					 
				   </cfif>
				   
				   <cfset val = val+v>
				   
				   <cfif Parameter.EnablePurchaseClass eq "1"> 
								
						<cfset guid = Form.Key4>
						<cfinclude template="../../InvoiceEntry/InvoiceEntryMatchRequisitionClassSubmit.cfm">	
								   
				   </cfif>
				      											 		
			</cfif>
				
		</cfoutput>
		
		<cfif map eq "0">
		
		    <cfif url.dialog eq "0">	
			 	<cf_message message = "It appears that you have not entered an amount. Operation aborted."
			  	return = "back">
			<cfelse>
			     <cf_alert message = "It appears that you have not entered an amount. Operation aborted.">
			</cfif>	 
			<cfabort>			
		 		
		</cfif>
								
<cfelse>

	   <!--- 29/4/2016 
         apply the changes to invoicepurchase and update related information accordingly --->
		 
		<!--- clean invoice purchase --->
		
		<cfquery name="deleteInvoice" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			     DELETE FROM InvoicePurchase
				 WHERE InvoiceId = '#Form.Key4#'
		</cfquery>		 	 
		 	 
		<cfloop index="po" list="#Form.selectedpurchase#" delimiters=",">
										
			 <cfquery name="getPO" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Purchase P
				WHERE    PurchaseSerialNo = '#po#'			
			</cfquery>
						
			<cfparam name="Form.Purchase_#po#" default="">	
			<cfset val = evaluate("Form.Purchase_#po#")>
				
			<cfif IsNumeric(val)>	
				
					<cfif getPO.Currency eq Inv.DocumentCurrency>
					  
					  	 <cfset doc   =   Round(val*100)/100>
					     <cfset pod   =   Round(val*100)/100>
											  			  
					  <cfelse>
					  
					  	<cfset doc   =   Round(val*100)/100>
						
					  	<cf_ExchangeRate DataSource="AppsPurchase" 
						                 CurrencyFrom="#Inv.DocumentCurrency#"
										 CurrencyTo="#getPO.Currency#">
					  
					  	 <cfset pod   =  Round((doc/exc)*100)/100>						 
					  
			</cfif>
					
			<!--- purchase correction --->
			
			<cfquery name="InsertInvoice" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO InvoicePurchase
					 (InvoiceId,
					  PurchaseNo,
					  DocumentAmountMatched,	
					  AmountMatched, <!--- PO matched --->						  				  
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
				  VALUES
					  ('#Form.Key4#', 
					   '#getPO.PurchaseNo#',
					   '#doc#',
					   '#pod#',	
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#') 
			</cfquery>
							
			 <!--- --------------------------------------------- ---> 		
			 <!--- --verify overposting of the obligated amount- --->
			 <!--- --------------------------------------------- --->
							  
			 <cfquery name="PO" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Purchase P, Ref_OrderType T
				WHERE    P.OrderType = T.Code 
				AND      P.PurchaseNo = '#getPO.PurchaseNo#'
			</cfquery>
			
			<!--- this will have just one record as the lines should have the same purchase currency of the purchase order --->
			
			<cfquery name="Amount" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   Currency, SUM(ROUND(OrderAmount,2)) as OrderAmount
				FROM     PurchaseLine
				WHERE    PurchaseNo = '#getPO.PurchaseNo#'
				GROUP BY Currency
			</cfquery>
				  
			<cfif PO.ReceiptEntry neq "9">
					
					<!--- take transaction currency which is the same as PO currency here --->
					
					<cfquery name="Posted" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT     GLL.TransactionDate, 
						           GLL.currency, 
								   <!--- adjusted 20/4/2016 as the invoice may be split over various purchase orders  so we apply the ratio --->
								   SUM((GLL.AmountCredit-GLL.AmountDebit)*(P.DocumentAmountMatched/I.DocumentAmount)) AS PaidAmount
						FROM       InvoicePurchase P INNER JOIN
		                   		   Invoice I ON P.InvoiceId = I.InvoiceId INNER JOIN
			                       Accounting.dbo.TransactionHeader GL ON I.InvoiceId = GL.ReferenceId INNER JOIN
		       		               Accounting.dbo.TransactionLine GLL ON GL.JournalSerialNo = GLL.JournalSerialNo AND GL.Journal = GLL.Journal
						 WHERE     PurchaseNo = '#getPO.PurchaseNo#'  
						 AND       I.ActionStatus != '9'
						 AND       GLL.TransactionSerialNo = '0'
						 AND       GL.ActionStatus != '9'
						 AND       GL.RecordStatus != '9'
						 AND       (GLL.ParentJournal = '' or GLL.ParentJournal is NULL)
						 GROUP BY  GLL.TransactionDate,
						           GLL.Currency
								   
					</cfquery>
					
					<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
					corrected for the base currency of the PO to give a balance figure ysing current
					exchange rates --->
					
					<cfset exp = 0>
					
					<!--- purchase currency --->
					<cfset curr = Amount.currency>
					
					<cfloop query="Posted">
					
						<cfif PaidAmount gt "0">
							<cfset amt = PaidAmount>
						<cfelse>
						    <cfset amt = 0>
						</cfif>	
						
						<cf_exchangeRate 
									DataSource   = "AppsPurchase"
							        CurrencyFrom = "#currency#" 
							        CurrencyTo   = "#Curr#"
									EffectiveDate = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#">
									
						<cfif Exc eq "0" or Exc eq "">
							<cfset exc = 1>
						</cfif>								
																									
						<cfset exp = exp+(amt/Exc)>
					
					</cfloop>	
					
				<!--- not posted yet --->									
			
				<cfquery name="Pending" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   SUM(P.DocumentAmountMatched) AS Amount, 
					         I.DocumentCurrency
					FROM     InvoicePurchase P INNER JOIN
	                   		 Invoice I ON P.InvoiceId = I.InvoiceId 
					WHERE    I.InvoiceId NOT IN (SELECT ReferenceId FROM Accounting.dbo.TransactionHeader WHERE ReferenceId is not NULL)
					AND      P.PurchaseNo = '#getPO.PurchaseNo#' 
					AND      I.ActionStatus != '9' 
					GROUP BY DocumentCurrency
				</cfquery>
				
				<cfset curr = Amount.currency>
						
				<cfset pen = "0">
						
				<cfloop query="Pending">
						
					<cf_exchangeRate 
					        DataSource="AppsPurchase"
					        CurrencyFrom = "#DocumentCurrency#" 
					        CurrencyTo   = "#Curr#">
									
						<cfif Exc eq "0" or Exc eq "">
							<cfset exc = 1>
						</cfif>		
																				
						<cfset pen = pen+(Amount/Exc)>
																	
				</cfloop>				
				
				<cfset tot = exp+pen>
				<cfset amt = Amount.OrderAmount*(100+parameter.InvoiceMatchDifference)/100>
				 					  
				<cfif amt lt tot>
							
				 <cf_alert message = "You are about to exceed the obligated #getPO.PurchaseNo# Amount (#numberformat(amt,"__,__.__")#) with a total amount of #numberformat(tot,",.__")#. The difference exceeds the threshold of #parameter.InvoiceMatchDifference#%."
					return = "back">					
									 			 	
				 	<cfabort>
				
				</cfif> 						  
				  
			</cfif>
			
			</cfif>
			
		</cfloop>		 
		
		<!--- 
		   invoice funding :OK 
		   invoice purchase execution  : OK
		   invoice purchase class is not relevant here 
		   invoice purchase posting -> compoennt 
		 --->
		
	<!--- now we can update the invoice itself --->	
		
	<cfset val = Form.DocumentAmountPayable>		
		
</cfif>		

<cfset val = replaceNoCase(val," ","","ALL")> 
<cfset val = replaceNoCase(val,",","","ALL")> 

<cfquery name="Header" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   InvoiceIncoming
	WHERE  InvoiceIncomingId  = '#inc#'	
</cfquery>

<cfif Header.ExemptionPercentage neq "0">

	<cfset incamt = Header.DocumentAmount - Header.ExemptionAmount>
			
<cfelse>

	<cfset incamt = Header.DocumentAmount>

</cfif>

<cfif (val - incamt) gt 0.005>
  
    <cfif url.dialog eq "0">	
	 	<cf_message message = "You are not allowed to exceed the amount of the received invoice #Header.DocumentCurrency# #numberformat(incamt,",.__")#."
	  	return = "no">
	<cfelse>
	     <cf_alert message = "You are not allowed to exceed the amount of the received invoice in the amount of #Header.DocumentCurrency# #numberformat(incamt,',.__')#.">
	</cfif>	 
	<cfabort>			
 

</cfif>

<cfquery name="Update" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Invoice
	SET    DocumentAmount     = '#val#',
		   DocumentDate       =  #dtedoc#,
		   Journal            = '#Form.PostingJournal#',
		   ActionBefore       =  #dteDue#,
		   ActionTerms        = '#Form.ActionTerms#',
		   ActionDiscountDays = '#Form.ActionDiscountDays#',
		   ActionDiscount     = '#Form.ActionDiscount#',
		   ActionDiscountDate = #dteDoc#<cfif Form.ActionDiscountDays gte "1">+#Form.ActionDiscountDays#</cfif>
	WHERE  InvoiceId = '#Form.Key4#'
</cfquery>

<cfif abs(val-Inv.DocumentAmount) gte 0.01>
	
	<!--- -------------------------------- --->
	<!--- adjust the linkaage for receipts --->
	<!--- -------------------------------- --->
	
	<cfquery name="Update" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE PurchaseLineReceipt
		SET    InvoiceIdMatched = NULL, 
		       ActionStatus = '1'	
		WHERE  InvoiceIdMatched = '#Form.Key4#' 
	</cfquery>
	
</cfif>

<cfparam name="Form.ExecutionId" default="">
		
<!--- ----------------------------------- --->	
<!--- record purchase execution execution --->
<!--- ----------------------------------- --->

<cfparam name="Form.ExecutionId" default="">
		
	<!--- ------------------------------- --->	
	<!--- -----record execution table---- --->
	<!--- ------------------------------- --->
	
	<cfquery name="cleanExecution" 
	     datasource="AppsPurchase" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 DELETE FROM InvoicePurchaseExecution			
		 WHERE    InvoiceId = '#Form.Key4#'			
	</cfquery>		
	
	<cfif Form.ExecutionId neq "">
		
	  <cf_exchangeRate 
		CurrencyFrom  = "#Inv.Currency#" 
		CurrencyTo    = "#PO.Currency#"
		Datasource    = "AppsPurchase"
		EffectiveDate = "#dateformat(Form.DocumentDate,CLIENT.DateFormatShow)#">
									
	  <cfif Exc eq "0" or Exc eq "">
		   <cfset exc = 1>
	  </cfif>			
		
	  <cfquery name="InsertExecution" 
	     datasource="AppsPurchase" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 INSERT INTO InvoicePurchaseExecution
				       (InvoiceId,
					     PurchaseNo,
					     ExecutionId,
					     AmountInvoiced,
					     ExchangeRate,
					     Amount,
					     OfficerUserId,
					     OfficerLastName,
					     OfficerFirstName)				  
			 SELECT    InvoiceId, 
			           PurchaseNo,
					   '#Form.ExecutionId#',
					   SUM(AmountMatched),
					   '#exc#',
					   SUM(DocumentAmountMatched),
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')	
			  FROM     InvoicePurchase
			  WHERE    InvoiceId = '#Form.Key4#'	
			  GROUP BY InvoiceId, 
			           PurchaseNo   				  
		</cfquery>	
	
	</cfif>
	
	<!---REMOVED 29-4/2016
	
	<cfif Form.ExecutionId neq "">
		
		<cfset amountexe   = replace("#form.executionamount#",",","","ALL")>
		
		<cfquery name="CleanPrior" 
	     datasource="AppsPurchase" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 DELETE FROM InvoicePurchaseExecution
		 WHERE InvoiceId = '#Form.Key4#'
		 AND   PurchaseNo = '#Form.PurchaseNo#'
		</cfquery> 
		
		<cfquery name="PO" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     PurchaseLine 
			WHERE    PurchaseNo = '#Form.PurchaseNo#'	
			ORDER BY RequisitionNo
		</cfquery>
	
	    <!--- exchange rate correction --->
		
		<cf_exchangeRate 
		        CurrencyFrom = "#Inv.DocumentCurrency#" 
		        CurrencyTo   = "#PO.Currency#"
				Datasource = "AppsPurchase"
				EffectiveDate = "#dateformat(dtedoc,CLIENT.DateFormatShow)#">
									
		<cfif Exc eq "0" or Exc eq "">
			<cfset exc = 1>
		</cfif>			
		
		<cfset amt = amountexe/exc>
			
		<cfquery name="InsertExecution" 
	     datasource="AppsPurchase" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 INSERT INTO InvoicePurchaseExecution
		     (InvoiceId,
			  PurchaseNo,
			  ExecutionId,
			  AmountInvoiced,
			  ExchangeRate,
			  Amount,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
		 VALUES
		    ('#Form.Key4#',
			 '#Form.PurchaseNo#',
			 '#Form.ExecutionId#',
			 '#amountexe#',
			  '#exc#',
			 '#amt#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')		 
	    </cfquery>
				
	</cfif>
	
	--->
	
	<!--- ---------------------------------------------------------------------- --->
	<!--- ------- update funding summary table which is used for inquiry ------- --->
	<!--- ---------------------------------------------------------------------- --->
	<!--- -------------- adjusted to incorporate change multi purchase --------- --->
	
	<cfquery name="cleanExecution" 
	     datasource="AppsPurchase" 
    	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 DELETE FROM InvoiceFunding		
		 WHERE    InvoiceId = '#Form.Key4#'			
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
							   F.ObjectCode, 
							   ROUND(F.Amount /
		                          (SELECT    SUM(Amount) 
		                           FROM      PurchaseFunding
									<!---  20/4/2016 ---  WHERE      (PurchaseNo = IP.PurchaseNo)), 2) * I.DocumentAmount AS Amount --->
								   WHERE     (PurchaseNo = IP.PurchaseNo)) * IP.AmountMatched, 2) AS Amount
					FROM      Invoice AS I INNER JOIN
				              InvoicePurchase AS IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
		        		      PurchaseFunding AS F ON IP.PurchaseNo = F.PurchaseNo
					WHERE     I.InvoiceId = '#Form.Key4#'
					
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

<!--- ----------- --->
<!--- final check --->
<!--- ----------- --->

<cfif ParameterExists(Form.PurchaseNo)> 
	
		<cfquery name="CheckTotal" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT sum(DocumentAmountMatched) as Amount, 
		        count(*) as Records
		 FROM   InvoicePurchase
		 WHERE  InvoiceId  = '#INV.invoiceId#' 					
		 AND    InvoiceId NOT IN (SELECT InvoiceId FROM Invoice WHERE ActionStatus = '9')
	 	</cfquery>
	
		<cfif checkTotal.amount eq "">
		   <cfset amt = 0>
		<cfelse>
		   <cfset amt = checkTotal.amount>   
		</cfif>
		
		<cfif abs(val - amt) gte 0.001>
		
			<cfif url.dialog eq "0">	
			 	<cf_message message = "You must distribute your invoice amount exactly over the available purchase lines. Currently #numberformat(amt,'__,__.__')# is distributed over #checktotal.records# lines"
			  	            return  = "back">
			<cfelse>
			     <cf_alert message = "You must distribute your invoice amount exactly over the available purchase lines. Currently #numberformat(amt,'__,__.__')# is distributed over #checktotal.records# lines">
			</cfif>	 
			<cfabort>		
				
		</cfif>
		
		<!--- compare the associated lines with the amount tagged: incorrect if the amount is lowered  
		
		<cfif DetailLines.Total neq "">
		
			<cfif abs(DetailLines.Total - amt) gte 0.001>
			
				<cfif url.dialog eq "0">	
				 	<cf_message message = "You must distribute your payable amount #numberformat(detaillines.total,'__,__.__')# exactly over the available purchase lines."
			  				return = "back">
				<cfelse>
				     <cf_alert message = "You must distribute your payable amount #numberformat(detaillines.total,'__,__.__')# exactly over the available purchase lines.">
				</cfif>	 
			<cfabort>		
			
			</cfif>		
		
		</cfif>
		
		--->

</cfif>

<!--- ---------------------------------------------------------------------------------- --->
<!--- check if new invoice for remainder needs to be created in invoice is under process --->
<!--- ---------------------------------------------------------------------------------- --->

<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ObjectKeyValue4 
        FROM   Organization.dbo.OrganizationObject
       	WHERE  EntityCode    = 'ProcInvoice'
		AND    ObjectKeyValue4 = '#Inv.InvoiceId#' 
</cfquery>	   
     

<cfif parameter.invoiceLineCreate eq "1" and form.remainder eq "1" and check.recordcount gte "1">
	
	<cfparam name="form.remainderamount" default="0">
		
	<cfquery name="Inv" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Invoice
		WHERE InvoiceId = '#Form.Key4#'
	</cfquery>
	
	<cfquery name="Lines" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SUM(DocumentAmount) as Amount, 
		       MAX(InvoiceSerialNo) as ser
		FROM   Invoice
		WHERE  InvoiceNo     = '#Inv.InvoiceNo#'
		AND    Mission       = '#Inv.Mission#'
		AND    OrgUnitOwner  = '#Inv.OrgUnitOwner#'
		AND    OrgUnitVendor = '#Inv.OrgUnitVendor#'	
	</cfquery>
	
	<cfif Header.DocumentAmount gt Lines.amount and form.remainderamount neq "0">
								
		<!--- assign a unique identifier --->
		<cf_AssignId>
		<cfset invid = rowguid>	
		
		<!--- #Header.DocumentAmount-Lines.amount# --->

		<cfset diff = form.remainderamount>
				
		<cfquery name="InsertInvoice" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Invoice
				 (OrgUnitVendor, 
				  Period, 
				  Mission,
				  OrgUnitOwner,
				  InvoiceNo,
				  InvoiceId,
				  InvoiceSerialNo,
				  Description,
				  DocumentCurrency,
				  DocumentAmount,
				  DocumentDate,		 
				  OrderType,				 
				  ActionBefore,
				  ActionTerms,
				  ActionDiscountDays,
				  ActionDiscount,
				  ActionDiscountDate,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
			  SELECT 
			        OrgUnitVendor, 
				    Period,
				    Mission,
				    OrgUnitOwner,
				    InvoiceNo,
				    '#invid#',
				    '#lines.ser+1#',
				    Description,
			        DocumentCurrency,
			        '#diff#',
			        DocumentDate,
				    OrderType,
			        ActionBefore,
				    ActionTerms,
				    ActionDiscountDays,
				    ActionDiscount,
				    ActionDiscountDate, 
			        '#SESSION.acc#',
				    '#SESSION.last#', 
				    '#SESSION.first#'
			  FROM  Invoice
			  WHERE InvoiceId = '#Form.Key4#' 
		</cfquery>			
				
		<cfquery name="AssociateLines" 
		datasource="appsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO InvoiceLine
			(InvoiceId,InvoiceLineId,OfficerUserId,OfficerLastName,OfficerFirstName)
			SELECT '#invid#', 
			       InvoiceLineId,
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#'
			FROM   InvoiceIncomingLine
			WHERE  InvoiceNo     = '#Inv.InvoiceNo#'
			AND    Mission       = '#INV.Mission#'
			AND    OrgUnitOwner  = '#INV.OrgUnitOwner#'
			AND    OrgUnitVendor = '#INV.OrgUnitVendor#'	
			AND    InvoiceLineId NOT IN (SELECT InvoiceLineId FROM InvoiceLine)				
		</cfquery>
				
		<cfparam name="form.InvoiceMemo" default="">
		
		<cfif Form.InvoiceMemo neq "">
		
			<cf_assignId>
			<cfset memoid = rowguid>	
			
			<cfquery name="InsertInvoice" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO InvoiceMemo
					 (InvoiceId,
					  MemoId,
					  InvoiceMemo,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName) 
				 VALUES (
				 	'#invid#',
					'#memoid#',
				 	'#form.InvoiceMemo#',
				  	'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#' )
			</cfquery>	
		
		</cfif>
				
		<cfif ParameterExists(Form.PurchaseNo)> 
		
		    <!--- ------------------------------------------------------------------------------------ --->
			<!--- map invoice to the requisition line of the same as the current invoices is linked to --->
			<!--- ------------------------------------------------------------------------------------ --->
				
			<cfset distribute = 1>
			
			<!--- determine if the new distribution introduce new requisition lines	that were not linked before --->
			
			<cfquery name="CurrentDistribution" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">		     
				  SELECT   *  
				  FROM     InvoicePurchase
				  WHERE    InvoiceId     = '#Form.Key4#'					 	  
			</cfquery>
				
			<cfloop query="CurrentDistribution">
						
				<cfquery name="Prior"
        	        dbtype="query">
				  	  SELECT   *	  
					  FROM     PriorDistribution
					  WHERE    PurchaseNo    = '#PurchaseNo#'
					  AND      RequisitionNo = '#RequisitionNo#'
				  </cfquery>
				
				<cfif prior.recordcount eq "0">
				    <!--- A new distribution to a line was introduced with the mark doen
					that did not exist before as a result we do not support the auto distribution of the existing
					line --->
				    <cfset distribute = 0>				 
				</cfif>
				
			</cfloop>				
						
			<cfif distribute eq "0">	
										
				<cfquery name="InsertInvoice" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">				
			     INSERT INTO InvoicePurchase
						  (InvoiceId,
						   PurchaseNo,
						   RequisitionNo,
						   AmountMatched,
						   DocumentAmountMatched,
						   OfficerUserId, 
						   OfficerLastName, 
						   OfficerFirstName) 
				  SELECT   TOP 1 '#invid#',
				           PurchaseNo, 
						   RequisitionNo, 
						   '#diff#', 
						   <!--- 16/12/2012 pending provision to apply the correct currency --->
						   '#diff#',
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#'	  
				  FROM     InvoicePurchase
				  WHERE    InvoiceId = '#Form.Key4#'	
				  ORDER BY AmountMatched DESC
				</cfquery>
										
			<cfelse>
			
				<cfloop query="PriorDistribution">
						
					<cfquery name="Current" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">		     
					  SELECT   AmountMatched as MatchedNew	  
					  FROM     InvoicePurchase
					  WHERE    InvoiceId     = '#Form.Key4#'	
					  AND      PurchaseNo    = '#PurchaseNo#'
					  AND      RequisitionNo = '#RequisitionNo#'			  
					</cfquery>
					
					<cfif amountMatched neq current.MatchedNew>
					
						<cfif current.MatchedNew eq "">
						    <cfset diff = amountMatched>
						<cfelse>
							<cfset diff = amountMatched - current.MatchedNew>
						</cfif>
					
						<cfquery name="InsertMapping" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     INSERT INTO InvoicePurchase
									 (InvoiceId,
									  PurchaseNo,
									  RequisitionNo,
									  AmountMatched,
									  DocumentAmountMatched,
									  OfficerUserId, 
									  OfficerLastName, 
									  OfficerFirstName)
							  VALUES ('#invid#',
							          '#PurchaseNo#',
									  '#RequisitionNo#',
									  '#diff#',
									  <!--- 16/12/2012 pending provision to apply the correct currency --->
									  '#diff#',
									  '#SESSION.acc#',
									  '#SESSION.last#',
									  '#SESSION.first#'	) 						  
						  </cfquery>
					
					</cfif>
			
				</cfloop>
				
			</cfif>	
				
		<cfelse>
		
			 <cfif PO.Currency eq Inv.DocumentCurrency>
			 
				 	<cfset poamt = Inv.DocumentAmount>
			
			 <cfelse>
			 			
			  	 <cf_ExchangeRate DataSource="AppsPurchase" 
				                 CurrencyFrom="#Inv.DocumentCurrency#"
								 CurrencyTo="#PO.Currency#">
			  
			  	 <cfset poamt   =  Round((poamt/exc)*100)/100>
									  
   		    </cfif>
		
							
			<cfquery name="InsertInvoice" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO InvoicePurchase
					 (InvoiceId,
					  PurchaseNo,
					  AmountMatched,
					  DocumentAmountMatched,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			  SELECT  '#invid#',
			          PurchaseNo,
					  '#poamt#',
					  '#Inv.DocumentAmount#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#'	  
			  FROM    InvoicePurchase
			  WHERE   InvoiceId = '#Form.Key4#'	
			  
			</cfquery>
		
		</cfif>
	
	</cfif>

</cfif> 

<cfquery name="InsertInvoice" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM InvoicePurchase				
			 WHERE  InvoiceId = '#Form.Key4#'	
			 AND    abs(DocumentAmountMatched) < 0.01			  
</cfquery>

</cftransaction>

<cfif url.mode neq "workflow">
	
	<script>
    	parent.parent.document.getElementById('refreshamount').click()
		parent.parent.ProsisUI.closeWindow('mydialog')	
	</script>	
    
</cfif>
