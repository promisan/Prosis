
<cfquery name="Customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Customer
		WHERE  CustomerId = '#url.customerid#'	
</cfquery>
	
<cfif url.customerid neq "">
		
	<cfoutput>
		<script>	 	  
		  document.getElementById('customerto').value      = '#url.customerid#'	
		  document.getElementById('tocustomer').innerHTML    = '#Customer.CustomerName#'			
		</script>
	</cfoutput>

</cfif>
