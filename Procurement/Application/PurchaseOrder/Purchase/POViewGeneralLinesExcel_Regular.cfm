<cfquery name="Lines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT    Q.*, 
	          R.RequestDescription AS RequestDescription, 
			  		  	  
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
			  
			  Job.JobNo, 
			  Job.CaseNo AS CaseNo
			  
	INTO	  Userquery.dbo.#SESSION.acc#_POLines
	
	FROM      PurchaseLine Q INNER JOIN
              RequisitionLine R ON Q.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
              Job ON R.JobNo = Job.JobNo
	WHERE     Q.PurchaseNo = '#URL.purchaseno#' 
	ORDER BY Q.ListingOrder, R.Created
</cfquery>