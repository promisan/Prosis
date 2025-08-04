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