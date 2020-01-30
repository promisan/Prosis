<cfset url.scope 	= "standalone">
<cfparam name="url.currency"          default="QTZ">
<cfparam name="url.mode"              default="1">
		
<cfquery name="qHeader" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	SELECT *
	FROM Accounting.dbo.TransactionHeader TH 
	WHERE Journal		='#URL.Journal#'
	AND JournalSerialNo ='#URL.JournalSerialNo#'
	AND TransactionSource='SalesSeries'
</cfquery>
	
<cfif qHeader.recordcount eq 1>
		<cfquery name="qBatch" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">	
		SELECT *
		FROM Materials.dbo.WarehouseBatch B 
	 	WHERE B.BatchId = '#qHeader.TransactionSourceId#'
		</cfquery>
		

		<cfset url.batchId    = qBatch.BatchId>
		<cfset url.addressId  = qBatch.AddressId>
		<cfset url.warehouse  = qBatch.Warehouse>
		<cfset url.customerId = qBatch.CustomerId>
		<cfset url.customeridinvoice = qBatch.CustomerIdInvoice>
		<cfset url.terminal   = "">
			
		<cfquery name="qCheck" 
	  	datasource="AppsMaterials" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">				
			SELECT * 
			FROM Accounting.dbo.TransactionHeaderAction
			WHERE Journal	    ='#URL.Journal#'
			AND JournalSerialNo ='#URL.JournalSerialNo#'
			AND ActionCode      = 'Invoice'			
		</cfquery>
		
		<cfif qCheck.recordcount eq 0>
			<cfinvoke  component = "Service.Process.Materials.POS"  
			   method             = "initiateInvoice" 
			   batchid            = "#url.batchId#"
			   warehouse          = "#url.warehouse#" 
			   terminal           = "#url.terminal#"
			   customerid         = "#url.customerid#"
			   customeridinvoice  = "#url.customeridinvoice#"
			   currency           = "#url.Currency#"	
			   Mode               = "#url.mode#"	   
			   returnvariable     = "vInvoice">

			
			<cfset vActionId = vInvoice.ActionId>
		<cfelse>
			<cfset vActionId = qCheck.ActionId>		
		</cfif>	
		
		<cfoutput>	
		<script>
			ptoken.navigate("#SESSION.root#/Warehouse/Application/Salesorder/POS/Settlement/SaleInvoice.cfm?actionid=#vActionId#&batchid=#URL.BatchId#&warehouse=#url.warehouse#&currency=#url.currency#&terminal=#url.terminal#"+"&ts="+new Date().getTime(), 'wsettle');
			try { window.opener.location.reload(); } catch(e) {}			
		</script>
		</cfoutput>
			   

</cfif>			


