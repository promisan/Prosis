
<!---  Name: /Component/Process/Procurement/PurchaseLine.cfc
       Description: Purchase Line procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "PurchaseRoutines">
	
	<cffunction name="setLiquidation"
             access="public"
             returntype="string"
             displayname="setLiquidation">
		
		<cfargument name="PurchaseNo"    type="string" required="false"  default="">	
		<cfargument name="Mission"       type="string" required="false"  default="">	
		<cfargument name="Datasource"    type="string" required="false"  default="appsLedger">
		
		<cfquery name="Clean" 
				datasource="#datasource#"  
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				DELETE  FROM Purchase.dbo.InvoicePurchasePosting
				<cfif Purchaseno eq "">
				WHERE   PurchaseNo IN (SELECT PurchaseNo 
				                       FROM   Purchase.dbo.Purchase 
									   WHERE  Mission = '#mission#')			
				<cfelse>
				WHERE   PurchaseNo = '#PurchaseNo#'				
				</cfif>					   
			</cfquery>		
			
			<!--- this table creates a routing table as to how the invoices is split over the funding block.
			per invoice sumof the product of RatioInPurchase * RatioInFund = 1)
							
				SELECT     InvoiceId, ROUND(SUM(RatioInPurchase * RatioInFunding), 2) AS result
				FROM         InvoicePurchasePosting
				GROUP BY InvoiceId
			
			--->	
									
			<cfquery name="Update" 
				datasource="#datasource#"				 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">		
				
							
				INSERT INTO Purchase.dbo.InvoicePurchasePosting
	                      (InvoiceId, 
						   PurchaseNo,
						   RequisitionNo,
						   Fund,
						   ProgramCode,
						   ActivityId,
						   ProgramPeriod,
						   ObjectCode,
						   RatioInPurchase,
						   RatioInFunding,
						   AmountPostedBase)
				
				SELECT    
				           H.ReferenceId, 
						   P.PurchaseNo,
						   ISNULL(P.RequisitionNo,''),				         
					       L.Fund,        
				           L.ProgramCode, 
						   ISNULL(L.ActivityId,0),
				           L.ProgramPeriod,                    
				           L.ObjectCode, 			
				
					    (			
					   P.AmountMatched /			                        
						(
							SELECT SUM(AmountMatched) 
							FROM   Purchase.dbo.InvoicePurchase WHERE InvoiceId = H.ReferenceId
						)
				
					   ) AS Ratio_Purchase,					            
				
					   ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit),2) /
				
				           (SELECT     ROUND(SUM(SL.AmountBaseCredit - SL.AmountBaseDebit), 2) 
				            FROM       Accounting.dbo.TransactionHeader AS SH INNER JOIN
				                       Accounting.dbo.TransactionLine AS SL ON SH.Journal = SL.Journal AND SH.JournalSerialNo = SL.JournalSerialNo
				            WHERE      SL.TransactionSerialNo = '0' 
							AND        SH.ActionStatus != '9'
							AND        SH.RecordStatus != '9'
							AND        SH.ReferenceId = H.ReferenceId
				           ) AS Ratio_Posting,						
						   
				      (		
					  	
				           (SELECT     ROUND(SUM(SL.AmountBaseCredit - SL.AmountBaseDebit), 2) AS Expr1
				            FROM       Accounting.dbo.TransactionHeader AS SH INNER JOIN
				                       Accounting.dbo.TransactionLine AS SL ON SH.Journal = SL.Journal AND SH.JournalSerialNo = SL.JournalSerialNo
				            WHERE      (SL.TransactionSerialNo = '0') AND (SH.ReferenceId = H.ReferenceId)) * 		
				
					   (
				
					   P.AmountMatched /
				                        
						(
							SELECT SUM(AmountMatched) 
							FROM   Purchase.dbo.InvoicePurchase WHERE InvoiceId = H.ReferenceId
						)
				
					   ) *			            
				
					   ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit),2) /
				
				           (SELECT     ROUND(SUM(SL.AmountBaseCredit - SL.AmountBaseDebit), 2) 
				            FROM       Accounting.dbo.TransactionHeader AS SH INNER JOIN
				                       Accounting.dbo.TransactionLine AS SL ON SH.Journal = SL.Journal AND SH.JournalSerialNo = SL.JournalSerialNo
				            WHERE      SL.TransactionSerialNo = '0' 
							AND        SH.ReferenceId = H.ReferenceId
							AND        SH.ActionStatus != '9'
							AND        SH.RecordStatus != '9'
				           ) 
				
						) as AmountPostedBase 			
				
				FROM    Accounting.dbo.TransactionHeader AS H INNER JOIN 
				        Accounting.dbo.TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN 
				        Purchase.dbo.InvoicePurchase P ON P.InvoiceId = H.ReferenceId
				
				WHERE   H.TransactionSource = 'PurchaseSeries' 
				
				AND     H.ReferenceId IN
				                      (SELECT  InvoiceId
				                       FROM    Purchase.dbo.Invoice
				                       WHERE   InvoiceId = H.ReferenceId
									   AND     ActionStatus IN ('1','2')  )  
									   <!--- this ActionStus condition is likely a bit overdone as it should have status = 1 if posted --->
											
				AND     L.TransactionSerialNo != '0'		
				AND     H.ActionStatus != '9'
				AND     H.RecordStatus != '9'			
				
				<cfif Purchaseno eq "">
			    AND     H.Mission = '#Mission#'					
				<cfelse>				
				AND     P.PurchaseNo = '#PurchaseNo#'						
				</cfif>			
				
				GROUP BY  P.PurchaseNo, 
				          H.ReferenceId, 
						  P.RequisitionNo, 
						  P.AmountMatched, 
						  L.ProgramCode, 
						  L.ActivityId,
						  L.Fund, 
						  L.ProgramPeriod, 
						  L.ObjectCode
				
						HAVING      ((SELECT   SUM(AmountMatched) 
				                      FROM     Purchase.dbo.InvoicePurchase AS InvoicePurchase_1
				                      WHERE    InvoiceId = H.ReferenceId) <> 0)			
								
		    </cfquery>			 				
		 
   </cffunction>		
	
</cfcomponent>	 