	
<cfquery name="setPrice" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
      UPDATE  ItemTransactionShipping
	  SET     SalesCurrency = '#url.currency#' 	        
	  WHERE   SalesId = '#url.salesid#'
</cfquery>	  
	
<cf_compression>	

	  