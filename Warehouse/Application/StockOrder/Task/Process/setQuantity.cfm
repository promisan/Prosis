
<!--- get the variance and set the total --->

<cfparam name="url.form" default="standard">

<cfoutput>
			
	<cfset total    = "0">
	<cfset totaluom = "0">
	
	<cfloop index="itm" from="1" to="#url.rows#">
	
		<cfparam name="Form.f#itm#_storageid" default="00000000-0000-0000-0000-000000000000">
			
		<cfif evaluate("Form.f#itm#_storageid") eq "00000000-0000-0000-0000-000000000000"> 
		
			  <script>
				   document.getElementById('f#itm#_quantityaccepted').value = ''
			  </script>
		
		<cfelse>
			
			<cfparam name="Form.f#itm#_meterreadinginitial" default="-1">
			
			<cfif evaluate("Form.f#itm#_meterreadinginitial") neq "-1"> 
				      	
				  <cfset ini = evaluate("Form.f#itm#_meterreadinginitial")>
				  <cfset fnl = evaluate("Form.f#itm#_meterreadingfinal")>
				  <cfset uom = evaluate("Form.f#itm#_meterreadinguom")>
				  							  
				  <cf_getUoMMultiplier ItemNo="#form.ItemNo#" UoMTo="#form.ItemUoM#" UoMFrom="#uom#">
								  			  			  
				  <cfset ini  = replace("#ini#",",","")>
				  <cfset fnl  = replace("#fnl#",",","")>
				  
				  <cfif LSIsNumeric(ini) and LSIsNumeric(fnl)>
				  
					  <cfset diff = fnl - ini>
					  
					  <script>
					   document.getElementById('f#itm#_quantityaccepted').value = '#diff#'
					  </script>
					  					  
					  <cfset total    = total + (diff*UoMMultiplier)>					  	
					  
				  </cfif>	  	 
				  			  		  
			 <cfelse>
			 
			 	   <cfset uom = evaluate("Form.f#itm#_meterreadinguom")>
				  							  
				   <cf_getUoMMultiplier ItemNo="#form.ItemNo#" UoMTo="#form.ItemUoM#" UoMFrom="#uom#">			
				 
				   <cfset qty = evaluate("Form.f#itm#_quantityaccepted")>
				
				   <cfif LSIsNumeric(qty)>
				      <cfset total = total + (diff*UoMMultiplier)>							 	
				   </cfif>
				 
			 </cfif> 
		 
		 </cfif>
				  
	</cfloop>

	<!--- set the total --->
	<script language="JavaScript">
	  document.getElementById('transactionquantity').value = '#numberformat(total,"____._")#'	 
	</script>

</cfoutput>
