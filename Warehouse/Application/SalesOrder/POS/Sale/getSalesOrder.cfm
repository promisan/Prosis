<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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





	   
	   