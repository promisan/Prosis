
<cfparam name="url.warehouse"  default="">


<cfinvoke component = "Service.Process.Materials.POS"  
	   method           = "getTransaction" 
	   warehouse        = "#URL.warehouse#" 
	   batchId          = "#URL.batchId#"
	   returnVariable   = "vWarehouseBatch">	
	   		   
<cfset URL.customerId = vWarehouseBatch.customerId>
<cfset URL.addressid = vWarehouseBatch.addressId>

<cfquery name="customer" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  *
	FROM   Customer
	WHERE  CustomerId = '#url.customerid#'	   							   
</cfquery>

<cfoutput>
	<script>		   
	  document.getElementById('customerselect').value = '#customer.reference#'	  	    	  
	  ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?batchid=#url.batchid#&customerid=#url.customerid#&addressid=#url.addressid#&warehouse=#url.warehouse#&terminal='+document.getElementById('terminal').value,'customerbox')
	</script> 
</cfoutput> 



	   
	   