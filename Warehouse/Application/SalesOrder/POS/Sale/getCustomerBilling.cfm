
<!--- populates the cusomterinvoice information based on the passed customer and invoiceid 

	a. Check if record exists in temp table and take the value from there
	b. if not Check for last sale
	c. populate with the same value as for the customer

--->

<cfparam name="url.customerid" default="00000000-0000-0000-0000-000000000000">

<cfif url.customerid eq "" or url.customerid eq "insert">
	<cfset url.customerid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfoutput>
			
	 <!--- take the same --->		
			 
	 <cfquery name="getCustomerInvoice" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	        SELECT    *
	        FROM      Customer C 
	        WHERE     C.CustomerId = '#url.CustomerId#'                                                                                                                                             			  
	</cfquery>

	#getCustomerInvoice.CustomerName#	
				
	<script language="JavaScript">	  
	   try {  	    
		    document.getElementById('customerinvoiceselect').value     = '#getCustomerInvoice.Reference#'		
			document.getElementById('customerinvoiceidselect').value   = '#getCustomerInvoice.customerid#'					
			if ('#url.customerid#' == document.getElementById('customeridselect').value) {
				 document.getElementById('customerinvoicedata_toggle').className = 'hide'	
				 document.getElementById('customerinvoicedata_box').className    = 'hide'	 		
			} else {
		   		 document.getElementById('customerinvoicedata_toggle').className = 'regular'			
			}
			} catch(e) {}
	</script>	
	
		
</cfoutput>

