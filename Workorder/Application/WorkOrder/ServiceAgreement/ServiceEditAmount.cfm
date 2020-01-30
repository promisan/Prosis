
<!--- calculate amounts --->

<cfquery name="workorder" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrder
  WHERE  WorkOrderId = '#URL.workorderId#'
</cfquery>

<cfquery name="unitlist" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   ServiceItemUnit
	  WHERE  ServiceItem = '#workorder.serviceitem#'
	  AND    BaseLineMode = 1		  		 
</cfquery>	
	
<cfset total = 0>	
	
<cfoutput query="unitlist">
	
		<cfset subtotal = 0>
	
	    <cfparam name="form.#unit#_qty" default="undefined">
		<cfparam name="form.#unit#_rte" default="undefined">
			
		<cfset qty = evaluate("form.#unit#_qty")>
		<cfset rte = evaluate("form.#unit#_rte")>
		
		<cfif qty neq "undefined">
							
		  <cfset qty = replaceNoCase(qty,",","","ALL")> 		  
	      <cfset rte = replaceNoCase(rte,",","","ALL")> 		  
		  
		  <cftry>
			  
			  	<cfset subtotal = qty*rte> 		
				
				 <cfset total = total+subtotal>		
				 
			   	<script>
					  document.getElementById('#unit#_total').innerHTML =  "#numberformat(subtotal,'__,__.__')#"		
				</script>
								
				<cfcatch>
				 			  
				 	<script>
					  document.getElementById('#unit#_total').innerHTML =  "na"		
				    </script>					
				 
				</cfcatch>
				
		   </cftry>	
		   
		 		 		
		</cfif>
							
</cfoutput>

<cfoutput>

	<script>
	  document.getElementById('total').innerHTML =  "#numberformat(total,'__,__.__')#"			
	</script>	
	
</cfoutput>


	
	
		