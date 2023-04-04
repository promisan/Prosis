
<!--- populates the cusomterinvoice information based on the passed customer and invoiceid 

	a. Check if record exists in temp table and take the value from there
	b. if not Check for last sale
	c. populate with the same value as for the customer

--->

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT  *
		FROM   Warehouse
		WHERE  Warehouse = '#url.warehouse#'
</cfquery>

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
	
	<cfif get.SaleMode eq "1" or get.SaleMode eq "3">
		
	<cfquery name="getCustomerInvoiceTax" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	        SELECT    *
	        FROM      CustomerTaxCode C 
	        WHERE     C.CustomerId = '#url.CustomerId#'  
			ORDER BY Source DESC                                                                                                                                           			  
	</cfquery>

	<cfif getCustomerInvoice.CustomerName neq "">
	<table>
	<tr><td class="fixlength" title="#getCustomerInvoice.CustomerName#" style="padding-top:3px">#getCustomerInvoice.CustomerName#</td></tr>
	<tr><td>
	
	<input type="hidden" id="taxcode" value="#getCustomerInvoiceTax.taxcode#">
	
	    <cfloop query="getCustomerInvoiceTax">
	    <input type="radio" name="TaxCode" value="#TaxCode#" <cfif currentrow eq "1">checked</cfif> onclick="document.getElementById('taxcode').value='#taxcode#'">#TaxCode#
		</cfloop>		
		<input type="radio" name="TaxCode"  value="CF" <cfif getCustomerInvoiceTax.recordcount eq "0">checked</cfif> onclick="document.getElementById('taxcode').value='CF'">CF
	</td></tr>
	</table>
	</cfif> 
	
	<cfelse>
	
	#getCustomerInvoice.CustomerName#
	
	</cfif>
	
				
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

