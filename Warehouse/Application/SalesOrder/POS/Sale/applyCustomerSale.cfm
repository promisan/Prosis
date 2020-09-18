<cfparam name="url.batchid"  default="">

<cfset billingid = url.customerid>

<!--- not sure what this was about, to be reviewed : Hanno 11/8 --->

<cfquery name="getLines"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 W.MissionOrgUnitId, 
		         T.Mission, 
				 T.CustomerIdInvoice
		FROM     vwCustomerRequest T INNER JOIN Materials.dbo.Warehouse W ON W.Warehouse = T.Warehouse
		WHERE    T.RequestNo  = '#url.RequestNo#'					
</cfquery>

<cfset vTransactionDate = "">

<cfif url.batchid neq "">

	<cfquery name="Batch" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT  *
		FROM   WarehouseBatch
		WHERE  BatchId = '#url.BatchId#'	   							   
	</cfquery>		
	
	<cfset vTransactionDate = dateformat(Batch.TransactionDate,CLIENT.DateFormatShow)>
	
	<cfif batch.CustomerIdInvoice neq "">
	   <cfset billingid = batch.CustomerIdInvoice>
	</cfif>
		
<cfelse>

	<cfset vTransactionDate = dateformat(now(),CLIENT.DateFormatShow)>
	
	<cfif getLines.CustomerIdInvoice neq "">
	   <cfset billingid = getLines.CustomerIdInvoice>
	</cfif>
	
</cfif>	

<cfoutput>
	
	<script>
		  
	  _cf_loadingtexthtml='';			
	
	  // set the screen form values
	  $('##customeridselect').val('#URL.CustomerId#');	
	  $('##customerselect').val('#customer.reference#');
	  
	  <cfif vTransactionDate neq "">
	  	$('##transaction_date').val('#vTransactionDate#');
	  	$('##itoday').val('#vTransactionDate#');
	  	$('##dtoday').html('#vTransactionDate#');
	  </cfif>	
	  
	  <cfif url.batchid neq "">
	  	 $('##Print').hide();
	  <cfelse>
	     $('##Print').show();
	  </cfif>
	  
	  // refresh the customer billing
	  
	  		
	  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/getCustomerBilling.cfm?requestno=#url.requestno#&customerid=#billingid#&warehouse=#url.warehouse#','customerinvoicebox')		 	  	  
	   // show valid transactions
	  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/getCustomerRequest.cfm?requestno=#url.requestno#&customerid=#billingid#&warehouse=#url.warehouse#','trarequestno')		 	  
	  // refresh the customer schedule	  
	  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/getSchedule.cfm?requestno=#url.requestno#&customerid=#url.customerid#&warehouse=#url.warehouse#','schedulebox')		  	  		 
	   // refresh the customer discount  
	  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/getDiscount.cfm?requestno=#url.requestno#&customerid=#url.customerid#&warehouse=#url.warehouse#','discountbox')		  	  		 	
	   // refresh lines for this sales person
	  ptoken.navigate('#SESSION.root#/Warehouse/Application/salesOrder/POS/Sale/getSalesPerson.cfm?requestno=#url.requestno#&customerid=#url.customerid#&warehouse=#url.warehouse#&field=salesperson&mission=#getLines.Mission#&MissionOrgUnitId=#getLines.MissionOrgUnitId#&saleid=salespersonno','personbox')		
	   // refresh lines for this customer
	  ptoken.navigate('#SESSION.root#/Warehouse/Application/salesOrder/POS/Sale/SaleViewLines.cfm?requestno=#url.requestno#&customerid=#url.customerid#&warehouse=#url.warehouse#&addressid=#URL.addressid#','salelines')		
	  // refresh additional box
	  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/getCustomerInfo.cfm?requestno=#url.requestno#&customerid=#url.customerid#&warehouse=#url.warehouse#','customeradditional')					
	  // refresh void button	  
	  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/SaleVoid.cfm?requestno=#url.requestno#&customerid=#url.customerid#&warehouse=#url.warehouse#','divVoidDocument')				
		  
  	</script>
	
	<!--- refresh the totals in the screen --->
	<cfinclude template="setTotal.cfm">

</cfoutput>