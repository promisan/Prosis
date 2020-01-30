<cfparam name="ApprovalAccess" default="NONE">

<!--- we first check if this PO is for a workorder --->

<cfquery name="getRequestType" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
 	 SELECT * 
	 FROM   RequisitionLine 
	 WHERE  RequisitionNo IN (SELECT RequisitionNo 
	                          FROM   PurchaseLine 
							  WHERE  PurchaseNo = '#URL.purchaseno#') 
	 AND    WorkOrderId is not NULL
</cfquery>	 

<cfquery name="Lines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Q.*, 
	          R.RequestDescription AS RequestDescription, 
			  R.WorkOrderId,
			  
			    (SELECT count(*)
				  FROM   RequisitionLineTopic T, Ref_Topic S
				  WHERE  T.Topic = S.Code
				  AND    S.Operational   = 1
				  AND    T.RequisitionNo = R.RequisitionNo) as Topics,	
			  
			  (
			    SELECT   count(*)
			    FROM     PurchaseLineReceipt 
		   	    WHERE    RequisitionNo = R.RequisitionNo 
		   	    AND      ActionStatus != '9'	
			  ) as Receipts,		
			  
			  ( 
			     SELECT  SUM(AmountMatched)    
				 FROM    InvoicePurchase IP, Invoice I
				 WHERE   I.InvoiceId = IP.InvoiceId
				 AND     I.ActionStatus != '9'
				 AND    (
				  		   NOT EXISTS
							(SELECT 'X'
								FROM   Organization.dbo.OrganizationObject
								WHERE  EntityCode    = 'ProcInvoice'
								AND    ObjectKeyValue4 = I.InvoiceId 
								) 
									 
							AND HistoricInvoice = 0
						)
				  AND     IP.RequisitionNo = R.RequisitionNo  	
			   ) onHold,
			   
			     (
			  	SELECT  sum(AmountMatched)    
				FROM    InvoicePurchase IP, Invoice I
			    WHERE   I.InvoiceId = IP.InvoiceId
			    AND     I.ActionStatus = '0'
			    AND    ( EXISTS
						(SELECT 'X'
							FROM   Organization.dbo.OrganizationObject
							WHERE  EntityCode    = 'ProcInvoice'
							AND ObjectKeyValue4 = I.InvoiceId 
							) 
						 OR 
						 HistoricInvoice = 1)
								 
			    AND     IP.RequisitionNo = R.RequisitionNo   	
			  ) as InProcess,			
			  
			   (
			  	SELECT  sum(AmountMatched)    
				FROM    InvoicePurchase IP, Invoice I
			    WHERE   I.InvoiceId = IP.InvoiceId
			    AND     I.ActionStatus IN ('1','2')
			    AND    ( EXISTS
						(SELECT 'X'
							FROM   Organization.dbo.OrganizationObject
							WHERE  EntityCode    = 'ProcInvoice'
							AND ObjectKeyValue4 = I.InvoiceId 
							) 
						 OR 
						 HistoricInvoice = 1)
								 
			    AND     IP.RequisitionNo = R.RequisitionNo   	
			  ) as Invoiced,				  			  
			  
			  Job.JobNo, 		  
			  Job.CaseNo AS CaseNo,
			  R.Period
			  
	INTO	  Userquery.dbo.#SESSION.acc#_POLines
	
	FROM      PurchaseLine Q INNER JOIN
              RequisitionLine R ON Q.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
              Job ON R.JobNo = Job.JobNo
	WHERE     Q.PurchaseNo = '#URL.purchaseno#' 
	<cfif getRequestType.recordcount gte "1">
	ORDER BY R.WorkOrderId, Q.ListingOrder, R.Created
	<cfelse>  
	ORDER BY R.Period, Q.ListingOrder, R.Created
	</cfif>
</cfquery>