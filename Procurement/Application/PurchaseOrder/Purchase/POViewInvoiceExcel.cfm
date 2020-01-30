
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Invoice">
		
   <cfquery name="Invoice" 
    datasource="AppsPurchase" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	SELECT     Mission, Period, InvoiceNo, Description, DocumentCurrency, DocumentAmount, DocumentDate, OrderType, ActionStatus, OfficerUserId, 
                      OfficerLastName, OfficerFirstName
	INTO     userquery.dbo.#SESSION.acc#Invoice   
	FROM     Invoice
	WHERE     (InvoiceId IN
                      (SELECT     Invoiceid
                       FROM          InvoicePurchase
                       WHERE      PurchaseNo = '#url.purchaseno#'))	   
	
   </cfquery> 
      
<cfset client.table1   = "#SESSION.acc#Invoice">	


