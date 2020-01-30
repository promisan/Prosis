<cfoutput>
	 	 
	 	 <cfif par eq "1">
					 				 
	   		<cfset val = evaluate("#subtotal.total#")>
		
		 <cfelse>	
	  	        
		   <cfset val = evaluate("#total#")>
	   
		 </cfif>  
	    	 
		 <cfif Parameter.BudgetAmountMode eq "0">
		 	  <cf_space spaces="24">
			  <cf_numbertoformat amount="#val#" present="1" format="number">
		 <cfelse>
		      <cf_space spaces="20">
			  <cf_numbertoformat amount="#val#" present="1000" format="number1">
		 </cfif>  						     
	     #val#
		 
</cfoutput> 