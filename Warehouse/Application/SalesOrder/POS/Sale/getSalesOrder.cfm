
<!--- we generate a new quote --->

 <cfquery name="reset"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  CustomerRequest						
	WHERE RequestNo IN (SELECT RequestNo 
	                    FROM   CustomerRequestLine 
						WHERE  BatchId = '#url.batchid#')
</cfquery>

<cfquery name="vWarehouseBatch"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM    WarehouseBatch						
	WHERE   BatchId = '#url.batchid#'
</cfquery>	
 
 <!--- also clear any transactions here --->

  
<cfset URL.customerId = vWarehouseBatch.customerId>
<cfset URL.addressid  = vWarehouseBatch.addressId>  

<!--- we make sure the system will generate a new quote --->
			
<cfquery name="setPrior" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    UPDATE CustomerRequest
		SET    ActionStatus = '1'
		WHERE  Warehouse  = '#url.warehouse#'
		AND    CustomerId = '#url.customerid#'		
		AND    AddressId  = '#url.addressid#'			
		AND    ActionStatus != '9'
</cfquery>		


<!--- this will generate a new quote --->
<cf_setCustomerRequest>
		
<!--- populate the lines --->		
<cfinvoke component = "Service.Process.Materials.POS"  
	   method           = "getTransaction" 
	   warehouse        = "#URL.warehouse#" 
	   batchId          = "#URL.batchId#"
	   RequestNo        = "#thisrequestNo#">	
	
<!--- refresh the screen --->	
<cfoutput>
	<script>			   	   	    	  
	  ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?requestNo=#thisrequestNo#&batchid=#url.batchid#&customerid=#url.customerid#&addressid=#url.addressid#&warehouse=#url.warehouse#&terminal='+document.getElementById('terminal').value,'customerbox')
	</script> 
</cfoutput> 





	   
	   