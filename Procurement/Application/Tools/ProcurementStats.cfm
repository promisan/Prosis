
<!--- this template performs a variety of housekeeping tasks.

1. It verifies and corrects the status of requisition lines

2. It verifies and corrects the status of the purchase order status 

3. It generate a purchase order status sktable which can be used for reporting

4. It verifies cost tagging consistency

--->


<!--- -------------------------------------------------------------------------------------- --->
<!--- ------------------------- 1. Requisition line verification --------------------------- --->
<!--- -------------------------------------------------------------------------------------- --->

<cf_assignid>
<cfparam name="schedulelogid" default="#rowguid#">

<!--- clean requisition lines --->

<cfquery name="Clear" 
	datasource="AppsPurchase">
	SELECT * 
	FROM   RequisitionLine
	WHERE  OrgUnit is NULL and ActionStatus = '0'
	AND    Created < getdate()
</cfquery>	

<cfloop query="Clear">	

	<cfquery name="UPDATE" 
		datasource="AppsPurchase">
		DELETE FROM RequisitionLine
		WHERE RequisitionNo = '#RequisitionNo#'
	</cfquery>	
		
</cfloop>

<!--- ------------------------------------------------------------------------------------ --->
<!--- ------------------ 2. Position funding through requisitions ------------------------ --->
<!--- ------------------------------------------------------------------------------------ --->

<!--- clean position for deleted reqs --->
	
	<cfquery name="DeletedReqs" 
			datasource="AppsEmployee">	
			DELETE FROM PositionParentFunding
			WHERE    RequisitionNo IS NOT NULL 
			AND      RequisitionNo NOT IN
	                          (SELECT RequisitionNo
	                           FROM   Purchase.dbo.RequisitionLine)
	</cfquery>		
	
	
	<!--- clean position for cencelled reqs --->
	
	<cfquery name="CancelledReqs" 
			datasource="AppsEmployee">	
			DELETE FROM PositionParentFunding
			WHERE    RequisitionNo IS NOT NULL 
			AND 
			(
					RequisitionNo IN (SELECT  RequisitionNo
	                                   FROM   Purchase.dbo.RequisitionLine
							           WHERE  ActionStatus = '9')
			OR      RequisitionNo IN (SELECT  RequisitionNo
			                           FROM   Purchase.dbo.RequisitionLine			   
									   WHERE  ItemMaster NOT IN (SELECT I.Code 
										                         FROM   Purchase.dbo.ItemMaster I, Purchase.dbo.Ref_EntryClass C
																 WHERE  I.EntryClass = C.Code
																 AND    CustomDialog = 'Contract'
																 )
									 )							 
			)													 
							   
	</cfquery>	
	
<!--- update PersonNo if this is not assignmed to a personNo --->

<cfquery name="getList" 
	datasource="AppsPurchase">	
	  SELECT     P.PositionParentId,
	             R.RequisitionNo, 
				 R.Mission, 				
				 R.PersonNo, 				 
				 P.PositionNo, 
				 PF.DateExpiration
	  FROM       Employee.dbo.Position AS P INNER JOIN
                 Employee.dbo.PositionParentFunding AS PF ON P.PositionParentId = PF.PositionParentId INNER JOIN
                 RequisitionLine AS R ON PF.RequisitionNo = R.RequisitionNo
	  WHERE      R.PersonNo NOT IN
                            (SELECT  PersonNo
                             FROM    Employee.dbo.Person
                             WHERE   PersonNo = R.PersonNo) 
	  AND        R.ActionStatus >= '1' 
	  ORDER By P.PositionParentid
</cfquery>     


<cfloop query="getList">

	<cfquery name="Inc" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 PA.*
		FROM    PersonAssignment PA 
		WHERE   PA.PositionNo = '#PositionNo#'			
		AND     PA.AssignmentStatus IN ('0', '1') 		
	    AND     PA.AssignmentType   = 'Actual'
		AND     PA.DateEffective <= '#dateExpiration#' 
		ORDER BY PA.DateExpiration DESC			
	</cfquery>	
	
	<cfif Inc.recordcount eq "1">
	
		<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   UPDATE  RequisitionLine
		   SET     PersonNo = '#Inc.PersonNo#'
		   WHERE   RequisitionNo = '#RequisitionNo#'	 
		</cfquery>
	
	</cfif>

</cfloop>
	
<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "Verification of the lines">									

<!--- check process status --->

<cfquery name="Reset" 
	datasource="AppsPurchase">
	UPDATE  RequisitionLine
	SET     ActionStatus = '3'
	WHERE   ActionStatus <= '2q'
	AND     RequisitionNo IN (SELECT RequisitionNo 
	                          FROM   PurchaseLine 
							  WHERE  ActionStatus != '9')
</cfquery>	


<!--- -------------------------------------------------------------------------------------- --->
<!--- ------------------------- 3. Purchase order sk Table  -------------------------------- --->
<!--- -------------------------------------------------------------------------------------- --->

<cfquery name="Update" 
	datasource="AppsPurchase">
	UPDATE Purchase
	SET    Currency = '#APPLICATION.BaseCurrency#'
	WHERE  Currency is NULL	
</cfquery>	

<CF_DropTable dbName="AppsQuery"    full="yes" tblName="PurchaseInvoice">
<CF_DropTable dbName="AppsQuery"    full="yes" tblName="PurchaseReceipt">
<!---
<CF_DropTable dbName="AppsPurchase" full="yes" tblName="skPurchase">
--->

<cftry>
	
	<cfquery name="Class" 
		datasource="AppsPurchase">
			CREATE TABLE [skPurchase] (
			[PurchaseNo]      [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
			[MatchingClass]   [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
			[Currency]        [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
			[OrderAmount]           [float] NOT NULL CONSTRAINT [DF_skPurchase_OrderAmount]      DEFAULT (0),
			[OrderAmountObligation] [float] NOT NULL CONSTRAINT [DF_skPurchase_OrderAmountOblig] DEFAULT (0),
			[ReceiptAmount]   [float] NOT NULL CONSTRAINT [DF_skPurchase_ReceiptAmount]          DEFAULT (0),
			[StockedAmount]   [float] NOT NULL CONSTRAINT [DF_skPurchase_StockAmount]            DEFAULT (0),
			[InvoiceAmount]   [float] NOT NULL CONSTRAINT [DF_skPurchase_InvoiceAmo0unt]         DEFAULT (0),
			[Created]         [datetime] NOT NULL CONSTRAINT [DF_skPurchase_Created]             DEFAULT getDate(),
			CONSTRAINT [PK_skPurchase] PRIMARY KEY  CLUSTERED ([PurchaseNo],[Currency])  ON [PRIMARY] )
	</cfquery>
	
	<cfcatch>
	
		<cfquery name="Purchase" 
		datasource="AppsPurchase">
	    	DELETE FROM skPurchase		
		    WHERE PurchaseNo IN (SELECT PurchaseNo 
			                     FROM   Purchase 
								 WHERE  ActionStatus < '4')
	    </cfquery>
		
	</cfcatch>

</cftry>

<!--- ------------------------------- --->
<!--- create a summary analysis table --->
<!--- ------------------------------- --->

<cfquery name="Class" 
	datasource="AppsPurchase">
	
		INSERT INTO skPurchase 

		(PurchaseNo,MatchingClass,Currency,OrderAmount,OrderAmountObligation)
	   
		SELECT   P.PurchaseNo, 
		         'Receipt' AS MatchingClass, 
				 L.Currency, 
				 ROUND(SUM(L.OrderAmount),2) as Amount,
				 ROUND(SUM(L.OrderAmountBaseObligated*L.ExchangeRate),2) as AmountObli
		FROM     Purchase P INNER JOIN
	             PurchaseLine L ON P.PurchaseNo = L.PurchaseNo INNER JOIN
	             Ref_OrderType R ON P.OrderType = R.Code
		WHERE    R.ReceiptEntry != '9'
		AND      P.ActionStatus < '4'
		GROUP BY P.PurchaseNo, L.Currency
		
		UNION
		
		SELECT   P.PurchaseNo, 
		         'Invoice' AS MatchingClass, 
				 L.Currency, 
				 ROUND(SUM(L.OrderAmount),2) as Amount,
				 ROUND(SUM(L.OrderAmountBaseObligated*L.ExchangeRate),2) as AmountObli
		FROM     Purchase P INNER JOIN
	             PurchaseLine L ON P.PurchaseNo = L.PurchaseNo INNER JOIN
	             Ref_OrderType R ON P.OrderType = R.Code
		WHERE    R.ReceiptEntry = '9'
		AND      P.ActionStatus < '4'
		GROUP BY P.PurchaseNo, L.Currency
		
</cfquery>

<cfquery name="Purchase" 
	datasource="AppsPurchase">
	SELECT  *
	FROM    skPurchase		
	WHERE   PurchaseNo IN (SELECT PurchaseNo 
			               FROM   Purchase 
						   WHERE  ActionStatus < '4')
</cfquery>

<!--- amount invoiced --->

<cf_verifyOperational 
         module    = "Accounting" 
		 Warning   = "No">
		 
<cfif Operational eq "1"> 

	<cfloop query="Purchase">

		<!--- take transaction currency which is the same as PO currency here --->
					
		<cfquery name="Posted" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		   SELECT     GLL.TransactionDate, 
			           GLL.currency, 
					<!--- adjusted 20/4/2016 as the invoice may be split over various purchase orders  so we apply the ratio --->
					<!--- adjusted as it was bringing division by zero error --->
					<!---   SUM((GLL.AmountCredit-GLL.AmountDebit)*(P.DocumentAmountMatched/I.DocumentAmount)) AS PaidAmount  --->
				SUM(
					(GLL.AmountCredit-GLL.AmountDebit)
					*
					(P.DocumentAmountMatched/
						CASE WHEN LTRIM(I.DocumentAmount) ='' THEN
							'1.0'
						WHEN LTRIM(I.DocumentAmount) <='0.0' THEN
							'1.0'
						ELSE
							I.DocumentAmount
						END
					)
				) AS PaidAmount 
					
			FROM       InvoicePurchase P INNER JOIN
                  	   Invoice I ON P.InvoiceId = I.InvoiceId INNER JOIN
                       Accounting.dbo.TransactionHeader GL ON I.InvoiceId = GL.ReferenceId INNER JOIN
      		           Accounting.dbo.TransactionLine GLL ON GL.JournalSerialNo = GLL.JournalSerialNo AND GL.Journal = GLL.Journal
			 WHERE     PurchaseNo              = '#PurchaseNo#'  
			 AND       I.ActionStatus         != '9'
			 AND       GLL.TransactionSerialNo = '0'
			 AND       GL.ActionStatus        != '9'
			 AND       GL.RecordStatus        != '9'
			 AND       (GLL.ParentJournal = '' or GLL.ParentJournal is NULL)
			 GROUP BY  GLL.TransactionDate,
			           GLL.Currency
			
		</cfquery>
					
		<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
		corrected for the base currency of the PO to give a balance figure ysing current
		exchange rates --->
		
		<cfset exp = 0>
		<cfset curr = Currency>
		
		<cfloop query="Posted">
		
			<cfif PaidAmount gt "0">
				<cfset amt = PaidAmount>
			<cfelse>
			    <cfset amt = 0>
			</cfif>	
			
			<cf_exchangeRate 
				        CurrencyFrom = "#Currency#" 
				        CurrencyTo   = "#Curr#"
						EffectiveDate = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#">
						
			<cfif Exc eq "0" or Exc eq "">
				<cfset exc = 1>
			</cfif>								
																						
			<cfset exp = exp+(amt/Exc)>
		
		</cfloop>
		
		<CFSET exp = numberformat(exp,"_.__")>

		<cfquery name="Update" 
			datasource="AppsPurchase">
			UPDATE skPurchase
			SET    InvoiceAmount = '#exp#'
			WHERE  PurchaseNo    = '#PurchaseNo#'			
		</cfquery>	
				 
		<!--- phase 2 receipt based --->

		<cfquery name="Matched" 
			datasource="AppsPurchase">
				SELECT     P.PurchaseNo, 
						   L.DeliveryDate,
				           L.Currency,
				           SUM(ReceiptAmount) AS Amount				
				FROM       PurchaseLine P INNER JOIN
			               PurchaseLineReceipt L ON P.RequisitionNo = L.RequisitionNo 
				WHERE      L.ActionStatus = '2'
				AND        P.PurchaseNo = '#PurchaseNo#'
				GROUP BY   P.PurchaseNo, L.DeliveryDate, L.Currency
		</cfquery>	
		
		<cfset exp = 0>
		
		<cfloop query="Matched">
		
			<cfif Amount gt "0">
				<cfset amt = Amount>
			<cfelse>
			    <cfset amt = 0>
			</cfif>	
			
			<cf_exchangeRate 
			        CurrencyFrom = "#Currency#" 
			        CurrencyTo   = "#Curr#"
					EffectiveDate = "#dateformat(DeliveryDate,CLIENT.DateFormatShow)#">
						
			<cfif Exc eq "0" or Exc eq "">
				<cfset exc = 1>
			</cfif>								
																						
			<cfset exp = exp+(amt/Exc)>
		
		</cfloop>
		
		<CFSET exp = numberformat(exp,"_.__")>

		<cfquery name="Update" 
			datasource="AppsPurchase">
			UPDATE skPurchase
			SET    ReceiptAmount = '#exp#'			
			WHERE  PurchaseNo = '#PurchaseNo#'			
		</cfquery>	

		<cfquery name="Stocked" 
			datasource="AppsPurchase">
				SELECT     P.PurchaseNo, 
						   TL.TransactionDate,
						   TL.Currency,	
				           SUM(TL.AmountDebit - TL.AmountCredit) AS Amount				
				FROM       PurchaseLine P INNER JOIN
			               PurchaseLineReceipt L ON P.RequisitionNo = L.RequisitionNo INNER JOIN
			               Accounting.dbo.TransactionLine TL ON L.ReceiptId = TL.ReferenceId
				WHERE      L.ActionStatus = '2'
				AND        P.PurchaseNo = '#PurchaseNo#'
				GROUP BY   P.PurchaseNo, TL.TransactionDate, TL.Currency
		</cfquery>	
		
		<cfset exp = 0>
		
		<cfloop query="Stocked">
		
			<cfif Amount gt "0">
				<cfset amt = Amount>
			<cfelse>
			    <cfset amt = 0>
			</cfif>	
			
			<cf_exchangeRate 
				        CurrencyFrom = "#Currency#" 
				        CurrencyTo   = "#Curr#"
						EffectiveDate = "#dateformat(TransactionDate,CLIENT.DateFormatShow)#">
						
			<cfif Exc eq "0" or Exc eq "">
				<cfset exc = 1>
			</cfif>								
																						
			<cfset exp = exp+(amt/Exc)>
		
		</cfloop>
		
		<CFSET exp = numberformat(exp,"_.__")>
		
		<cfquery name="Update" 
			datasource="AppsPurchase">
			UPDATE skPurchase
			SET    StockedAmount = '#exp#'			
			WHERE  PurchaseNo    = '#PurchaseNo#'			
		</cfquery>		

	</cfloop>		
	
<cfelse>

	<!--- no longer relevant, accounting is always enabled these days 

	<cfloop query="Purchase">

		<cfquery name="Pending" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    ROUND(SUM(DocumentAmount),2) AS Amount,DocumentCurrency
				FROM      InvoicePurchase Pur INNER JOIN Invoice I ON Pur.InvoiceId = I.InvoiceId 
				WHERE     PurchaseNo = '#PurchaseNo#' 									
				AND       I.ActionStatus != '9' 
				GROUP BY  DocumentCurrency
		</cfquery>
					
		<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
			  corrected for the base currency of the PO to give a balance figure ysing current
			  exchange rates --->
					
		<cfset curr = "#currency#">				
		<cfset pen = "0">
			
		<cfloop query="Pending">
			
			<cf_exchangeRate 
		        CurrencyFrom = "#DocumentCurrency#" 
		        CurrencyTo   = "#Curr#">
						
				<cfif Exc eq "0" or Exc eq "">
					<cfset exc = 1>
				</cfif>								
																						
				<cfset pen = pen+(Amount/Exc)>
														
		</cfloop>		
				
		<CFSET pen = numberformat(pen,"_.__")>

		<cfquery name="Update" 
			datasource="AppsPurchase">
			UPDATE  skPurchase
			SET     InvoiceAmount = '#pen#'
			WHERE   PurchaseNo = '#PurchaseNo#'			
		</cfquery>	
		
	</cfloop>		
	
	--->

</cfif>	

<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "Generated skPurchase table">		

<!--- ------------------------------------------------------------- --->
<!--- apply execution ratio to the field of obligation liquidation --->
<!--- ------------------------------------------------------------ --->

<!--- ------------------------------------------------------------------------------------- --->

<cfquery name="MissionList" 
	datasource="AppsPurchase">
		SELECT  *
		FROM    Ref_ParameterMission
		WHERE  	Mission IN (SELECT DISTINCT Mission FROM Purchase)		
</cfquery>	

<cfloop query="MissionList">

    <!--- matching on the PO level ---> 
	<cfif InvoiceRequisition eq "0">
		
	    <!--- liquidation is applied on bases of the PO and not correctly applied to each
		lines since the line is not used for invoice matching in this mode !! --->
	
		<cfquery name="Liquidation1" 
			datasource="AppsPurchase">
			UPDATE  PurchaseLine
			SET     OrderAmountBaseLiquidated = round((K.InvoiceAmount / K.OrderAmount) * OrderAmountBaseObligated,2)
			FROM    PurchaseLine L, skPurchase K
			WHERE   L.PurchaseNo = K.PurchaseNo
			AND     L.PurchaseNo IN (SELECT PurchaseNo FROM Purchase WHERE Mission = '#mission#')
			AND     K.OrderAmount > 0
		</cfquery>		
		
		<cfinvoke component = "Service.Process.Procurement.Purchase"  
	   		   method           = "setLiquidation" 
			   mission          = "#Mission#">			
		
		<!--- liquidate based on the set overwrite --->
	
	<cfelse>				
		
		<cfif Operational eq "1">
								
			<!--- October 2010 ------------------------------------------------------------------------ --->
			<!--- if the matching for the purchase order is on the requisition level the query is taken --->
			<!--- ------------------------------------------------------------------------------------- --->
			
			<!--- prepare liquidation table 
			
			clean InvoicePurchasePosting  
			add records 
			use the sum to update the purchase line liquidationBase 
			
			PENDING issue with invoice matched to PO only --->
					
			<cfinvoke component = "Service.Process.Procurement.Purchase"  
	   		   method           = "setLiquidation" 
			   mission          = "#Mission#">	
			
		   <!--- update the liquidation --->	
		   
		   <cfquery name="ResetLiquidated" 
				datasource="AppsPurchase">			
			    UPDATE  PurchaseLine
				SET     OrderAmountBaseLiquidated = 0				
				WHERE   PurchaseNo IN (SELECT PurchaseNo 
				                       FROM   Purchase 
									   WHERE  Mission = '#mission#')
			</cfquery>
			
			<!--- set the new value of the requisition line which is in the UN mode --->
		   
		   <cfquery name="UpdateLiquidated" 
				datasource="AppsPurchase">			
			    UPDATE PurchaseLine
				SET    OrderAmountBaseLiquidated = 
				
						(SELECT ISNULL(SUM(P.AmountPostedBase),0)
						 FROM   InvoicePurchasePosting P
						 
						 WHERE  P.RequisitionNo = L.RequisitionNo
						 
						 <!--- invoice is not cancelled --->
						 AND    InvoiceId IN (SELECT InvoiceId 
						                      FROM   Invoice 
											  WHERE  ActionStatus <> '9'))
				
				FROM   PurchaseLine L
				
				WHERE  PurchaseNo IN (SELECT PurchaseNo FROM Purchase WHERE Mission = '#mission#')		
										
				AND    RequisitionNo IN (SELECT RequisitionNo 
				                         FROM   InvoicePurchasePosting 
										 WHERE  RequisitionNo = L.RequisitionNo)
				
			</cfquery>					
							
		<cfelse>
				
			<!--- les relevant as accounting is always operational 
			
			<cfquery name="PurchaseLines" 
			datasource="AppsPurchase">
				SELECT   PurchaseNo,RequisitionNo,Currency 
				FROM     PurchaseLine P
				WHERE    PurchaseNo IN (SELECT PurchaseNo 
				                        FROM   Purchase 
									    WHERE  PurchaseNo = P.PurchaseNo
									    AND    Mission    = '#mission#')
				ORDER BY PurchaseNo
			</cfquery>			
			 
			<cfset cnt = "0">
			 
			<cfloop query="PurchaseLines">	
			
				<cfset cnt = cnt+1>
			
				<cfset exp = ""> 				
									
					<cfquery name="Pending" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    ROUND(SUM(DocumentAmount),2) AS Amount, 
							          DocumentCurrency
							FROM      InvoicePurchase Pur INNER JOIN Invoice I ON Pur.InvoiceId = I.InvoiceId 
							WHERE     PurchaseNo      = '#PurchaseNo#' 
							AND       Requisitionno   = '#Requisitionno#'									
							AND       I.ActionStatus != '9' 
							GROUP BY  DocumentCurrency
					</cfquery>
								
					<!--- ATTENTION if Invoice is not issued in same currency as PO, the docoument amount is
						 corrected for the base currency of the PO to give a balance figure ysing current
						 exchange rates --->
								
					<cfset curr = "#currency#">				
					<cfset pen = "0">
						
					<cfloop query="Pending">
						
						<cf_exchangeRate 
					        CurrencyFrom = "#DocumentCurrency#" 
					        CurrencyTo   = "#Curr#">
									
						<cfif Exc eq "0" or Exc eq "">
							<cfset exc = 1>
						</cfif>								
																									
						<cfset pen = pen+(Amount/Exc)>
																	
					</cfloop>		
							
					<CFSET exp = numberformat(pen,"_.__")>
												
				<cfif exp eq "">
				   <cfset exp = 0>
				</cfif>   
				
				<!--- update the value of the liquidation --->
						
				<cfquery name="Liquidation1" 
					datasource="AppsPurchase">
					UPDATE  PurchaseLine
					SET     OrderAmountBaseLiquidated = '#exp#'			
					WHERE   PurchaseNo           = '#Purchaseno#'
					AND     RequisitionNo        = '#RequisitionNo#'	
					AND     OrderAmountBaseLiquidated <> #exp#		
				</cfquery>					
				
				<cfif cnt eq "100">
					
					<cf_ScheduleLogInsert
				   	ScheduleRunId  = "#schedulelogid#"
					Description    = "#MissionList.Mission# Liquidation #currentrow#/#recordcount#">
							
					<cfset cnt = 0>
			
				</cfif>
				
			</cfloop>		
			
			--->
			
		</cfif>	
		
	</cfif>

</cfloop>

<!--- overrule the calculated value once the purchase order was closed --->

<cfquery name="Liquidation2" 
	datasource="AppsPurchase">
	UPDATE    PurchaseLine
	SET       OrderAmountBaseObligated = OrderAmountBase
	WHERE     OrderAmountBaseObligated > OrderAmountBase	
</cfquery>		

<!--- reset the obligation amount to the liquidation amount if it is closed --->

<cfquery name="Liquidation3" 
	datasource="AppsPurchase">
	UPDATE    PurchaseLine
	SET       OrderAmountBaseObligated = OrderAmountBaseLiquidated
	<!--- if the PO is closed --->
	WHERE     PurchaseNo IN (SELECT PurchaseNo 
	                         FROM   Purchase 
							 WHERE  ObligationStatus = '0')	
	AND       OrderAmountBaseObligated <> OrderAmountBaseLiquidated						 					 
</cfquery>		

<!--- if the obligation status is set to no longer obligated, I added on
october 1st 2011 the condistion that the liquidated has to be smaller 

<cfquery name="Liquidation3" 
	datasource="AppsPurchase">
	UPDATE    PurchaseLine
	SET       OrderAmountBaseLiquidated = OrderAmountBaseObligated
	<!--- if the PO is closed --->
	WHERE     PurchaseNo IN (SELECT PurchaseNo 
	                         FROM   Purchase 
							 WHERE  ObligationStatus = '0')	
	AND     OrderAmountBaseLiquidated < OrderAmountBaseObligated						 
</cfquery>		
--->

<!--- general correction to prevent over-liquidation --->
<!--- 1/10/2011 I removed this safeguard as we allow the invoice to exceed the lines this 
caused an issue for small differences 

<cfquery name="Liquidation4" 
	datasource="AppsPurchase">
	UPDATE    PurchaseLine
	SET       OrderAmountBaseLiquidated = OrderAmountBaseObligated
	WHERE     OrderAmountBaseObligated < OrderAmountBaseLiquidated	
</cfquery>	

--->

<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "Defined Obligation Liquidation">		

<!--- -------------------------------------------------------------------------------------- --->
<!--- ------------------------- 3. Purchase order Status ----------------------------------- --->
<!--- -------------------------------------------------------------------------------------- --->

<cfquery name="Reset" 
	datasource="AppsPurchase">
	UPDATE Purchase
	SET    ActionStatus = '3'
	WHERE  ActionStatus = '4' and ObligationStatus = '1' <!--- unless the PO was close manually which then has value 0--->
</cfquery>	

<cfquery name="ResetAmounts" 
	datasource="AppsPurchase">
	UPDATE  PurchaseLine
	SET     OrderAmountBaseObligated = OrderAmountBase
	WHERE   PurchaseNo IN (SELECT PurchaseNo 
	                       FROM   Purchase 
						   WHERE  ObligationStatus = 1)	
	AND     OrderAmountBaseObligated <> OrderAmountBase
</cfquery>	

<!--- CLOSES THE PURCHASE ORDER IF IT IS FULLY BILLED --->

<cfquery name="Update" 
	datasource="AppsPurchase">
	UPDATE  Purchase
	SET     ActionStatus = '4'
	FROM    skPurchase T INNER JOIN Purchase P ON T.PurchaseNo = P.PurchaseNo
	WHERE   T.OrderAmount - T.InvoiceAmount < 0.05 <!--- within 5 cents the order is set as invoiced --->
</cfquery>	

<!--- clear orphaned invoices --->

<cfquery name="getList" 
	datasource="AppsPurchase">
	SELECT  InvoiceId 
	FROM    Invoice I
	WHERE   InvoiceId NOT IN
	                  (SELECT   InvoiceId
	                   FROM     InvoicePurchase
	                   WHERE    InvoiceId = I.InvoiceId) 
	AND     ActionStatus IN ('0', '9')
</cfquery>

<cfloop query="getList">
	
	<cfquery name="Delete" 
		datasource="AppsPurchase">
		DELETE FROM Invoice
		WHERE InvoiceId = '#InvoiceId#'
	</cfquery>

</cfloop>

<!--- -------------------------------------------------------------------------------------- --->
<!--- ------------------------- 4. Purchase order Tagging check ---------------------------- --->
<!--- -------------------------------------------------------------------------------------- --->
 
 <cfquery name="DELETE" 
	datasource="AppsLedger">
	DELETE FROM FinancialObject
	WHERE   EntityCode = 'REQ'
	AND     ObjectKeyValue1 NOT IN (SELECT RequisitionNo FROM Purchase.dbo.RequisitionLine)									
</cfquery>	
 
<cfquery name="DELETE" 
	datasource="AppsLedger">
	DELETE FROM FinancialObject
	WHERE  EntityCode = 'INV'
	AND   ObjectKeyValue4 NOT IN (SELECT InvoiceId FROM Purchase.dbo.Invoice)									
</cfquery>	

<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "Purchase Order Status defined">		
			
		
		
<!--- -------------------------------------------------------------------------------------- --->
<!--- ------------------------- 5. Delivery status consistency ----------------------------- --->
<!--- -------------------------------------------------------------------------------------- --->

<cfquery name="enforcemanualoverwrite" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  UPDATE PurchaseLine 
  SET    DeliveryStatus = '3'
  WHERE  RequisitionNo NOT IN (SELECT RequisitionNo 
                               FROM   PurchaseLineReceipt 
							   WHERE  ActionStatus != '9')
  AND    RecordStatus = '3' <!--- if recordstatus = 3 it is overwritten and deliverystatus = '3'--->		   
</cfquery>

<cfquery name="Initialize" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  UPDATE PurchaseLine 
  SET    DeliveryStatus = 0
  WHERE  RequisitionNo NOT IN (SELECT RequisitionNo 
                               FROM   PurchaseLineReceipt 
							   WHERE  ActionStatus != '9') 	
  AND    RecordStatus = '1' <!--- if recordstatus = 1 it is resetted for definition --->		   
</cfquery>

<cfquery name="Lines" 
	datasource="AppsPurchase">
	
	SELECT   TOP 2000 PL.OrderQuantity, <!--- provision to limit the number of considerations --->
	         R.ReceiptEntry, 
			 PL.RequisitionNo, 
			 PL.OrderAmount, 
			 PL.OrderAmountBase, 
			 PL.Currency
			 
	FROM     Purchase P INNER JOIN
             PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
             Ref_OrderType R ON P.OrderType = R.Code
	WHERE    R.ReceiptEntry IN ('0','1')  <!--- exclude invoice only purchase orders in this respect --->
	AND      PL.DeliveryStatus <> '0' 
	AND      PL.Recordstatus = '1'
	ORDER BY DeliveryStatusDate
			 		
</cfquery>		

<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "Delivery Consistency started">	

<cfset cnt = "0">

<cfloop query="Lines">

	 <cfset cnt = cnt+1>
			
	 <cfif cnt eq "250">
							
		<cf_ScheduleLogInsert
			ScheduleRunId  = "#schedulelogid#"
			Description    = "Process #currentrow#/#recordcount#">
					
		<cfset cnt = 0>
		
	 </cfif>	
    
	  <cfinvoke component = "Service.Process.Procurement.PurchaseLine"  
		  method           = "getDeliveryStatus" 							   
		  RequisitionNo    = "#RequisitionNo#"
		  returnvariable   = "DeliveryStatus">			  

</cfloop>

<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
    	Description    = "Delivery Consistency checked">	
		
	
<!--- -------------------------------------------------------------------------------------- --->
<!--- ------------------------- 6. Cancelled receipts -------------------------------------- --->
<!--- -------------------------------------------------------------------------------------- --->		

<cfquery name="reset" 
	datasource="AppsPurchase">
	UPDATE Receipt
	SET    ActionStatus = '9'
	WHERE  ReceiptNo IN (
	SELECT DISTINCT ReceiptNo
	FROM   PurchaseLineReceipt AS P
	WHERE  ActionStatus = '9'
	GROUP BY ReceiptNo
	HAVING    (SELECT   COUNT(*) AS Expr1
	           FROM     PurchaseLineReceipt 
	           WHERE    ReceiptNo = P.ReceiptNo 
			   AND      ActionStatus = '9') =
	                          (SELECT    COUNT(*) AS Expr1
	                            FROM     PurchaseLineReceipt 
	                            WHERE    ReceiptNo = P.ReceiptNo))	
</cfquery>								

<!--- Provision to correct Purchase status from 3 to 4 when ObligationStatus is already 0 --->
<cfquery name="reset" datasource="AppsPurchase">
	UPDATE   Purchase
	SET      ActionStatus = '4'
	WHERE    ActionStatus = '3' AND ObligationStatus = '0'
</cfquery>			