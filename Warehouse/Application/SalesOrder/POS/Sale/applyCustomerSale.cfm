<cfparam name="url.batchid"  default="">

<!--- ---------------------------------------------------------------- --->
<!--- Ajax template to trigger updates in the screen upon customer set --->
<!--- ---------------------------------------------------------------- --->

<!---

This template is called from many spots and thus below query is deleting too much. Examples: 
	-User A loading a sale from history causes all other users to lose draft sales they are working on.
	-User A clicking on 'new sale' makes all other users to lose their draft sales

<cfquery name="remove" 
	 datasource="AppsTransaction" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    DELETE
		FROM 	Sale#URL.Warehouse#
		WHERE  	BatchId IS NOT NULL
		AND		CustomerId != '#url.customerid#'
</cfquery>
--->

<!---
	The below cleaning takes care of the following scenario:
	1. User A opens a historical sale for customer John Doe (i.e. batch no. 4587)
	2. Prosis stores details of sale 4587 in temporary table Sale#URL.Warehouse#
	3. User B types John Doe to record a sale for John Doe and because point (2), system keeps on loading sale 4587, instead of giving a blank fresh POS screen to record the new sale
--->
<cfif url.batchid eq ""> <!--- if so, it means that user is typing/loading customer from scratch, not loading a historical sale --->

	<cfquery name="remove" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		    DELETE
			FROM 	CustomerRequestLine
			WHERE  	BatchId IS NOT NULL
			AND		RequestNo = '#url.requestNo#'
	</cfquery>
	
	 <cfquery name="remove"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE Settle#Warehouse#_#SESSION.acc#
			WHERE  CustomerId = '#url.customerid#'
	 </cfquery>

</cfif>

<cfset billingid = url.customerid>

<cfquery name="getLines"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 W.MissionOrgUnitId, T.Mission, T.CustomerIdInvoice
		FROM     Sale#URL.Warehouse# T, Materials.dbo.Warehouse W
		WHERE    T.CustomerId      = '#url.customerid#'		
		AND      W.Warehouse       = T.Warehouse
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
	   // refresh the customer schedule	  
	  ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/getSchedule.cfm?requestno=#url.requestno#&customerid=#url.customerid#&warehouse=#url.warehouse#','schedulebox')		  	  		 
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