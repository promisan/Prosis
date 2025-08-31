<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.form" default="standard">

<cfoutput>

<cfif url.form eq "standard">
	
	<cfset total = "0">
	
	<cfloop index="itm" from="1" to="#url.rows#">
		      
		  <cfset shp = evaluate("Form.f#itm#_quantityshipped")>
		  <cfset acc = evaluate("Form.f#itm#_quantityaccepted")>
		  
		  <cfset shp  = replace("#shp#",",","")>
		  <cfset acc  = replace("#acc#",",","")>
		  
		  <cfif LSIsNumeric(shp) and LSIsNumeric(acc)>
		  
			  <cfset diff = acc - shp>
			  
			  <script>
			   document.getElementById('f#itm#_quantityvariance').value = '#diff#'
			  </script>
		  
		  </cfif>
		  
		  <cfif LSIsNumeric(acc)>
		    
		  	<cfset total = total + acc>
		  
		  </cfif>
	  
	</cfloop>

<cfelseif url.form eq "fuel">
		
	<cfset total = "0">
	
	<cfloop index="itm" from="1" to="#url.rows#">
	
		<cfparam name="Form.f#itm#_meterreadinginitial" default="-1">
	
		<cfif evaluate("Form.f#itm#_meterreadinginitial") neq "-1"> 
			      	
			  <cfset ini = evaluate("Form.f#itm#_meterreadinginitial")>
			  <cfset fnl = evaluate("Form.f#itm#_meterreadingfinal")>
			  
			  <cfset ini  = replace("#ini#",",","")>
			  <cfset fnl  = replace("#fnl#",",","")>
			  
			  <cfif LSIsNumeric(ini) and LSIsNumeric(fnl)>
			  
				  <cfset diff = fnl - ini>
				  
				  <script>
				   document.getElementById('f#itm#_quantityaccepted').value = '#diff#'
				  </script>
				  
				  <cfset total = total + diff>			 
			  
				  <cfset shp = evaluate("Form.f#itm#_quantityshipped")>
			  	  <cfset shp  = replace("#shp#",",","")>
			  				  
				  <cfif LSIsNumeric(shp)>
			  
					  <cfset var = diff - shp>
					  
					  <script>
					   document.getElementById('f#itm#_quantityvariance').value = '#var#'
					  </script>
			  
			      </cfif>
				  
			  </cfif>  			    
			  		  
		 <cfelse>
			 
			 	<cfset qty = evaluate("Form.f#itm#_quantityaccepted")>
				<cfif LSIsNumeric(qty)>
			 		 <cfset total = total + qty>
			 	</cfif>
			 
		 </cfif> 
				  
	</cfloop>


</cfif>

<!--- set the total --->
<script>
  document.getElementById('receiptquantity').value = '#total#'
  calc('#total#',document.getElementById('receiptprice').value,document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,document.getElementById('taxincl').value,document.getElementById('exchangerate').value,document.getElementById('taxexemption').value)
</script>

</cfoutput>
