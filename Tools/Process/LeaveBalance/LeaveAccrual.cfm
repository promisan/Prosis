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
<cfparam name="Attributes.Credit" default="2.5"> 
<cfparam name="Attributes.DS"     default=""> 
<cfparam name="Attributes.DE"     default=""> 
<cfparam name="Attributes.Mode"   default="Standard"> 

<cfset DS     = Attributes.DS>
<cfset DE     = Attributes.DE>
<cfset END    = Attributes.END>
<cfset Credit = attributes.Credit>

<cfif Credit eq "2.5">

	 <!--- arrival during the month --->
	 
	 <cfif attributes.Mode eq "Standard">
					 
		 <cfif DS eq 1 and DE eq daysInMonth(END)>
		   
		    <!--- most common --->
		   	<cfset crd = credit>		
		   
		 <cfelseif DS gte 2 and DS lte 16 and DE eq daysInMonth(END)>  
			 	 	 
		 		<!--- arrival during the month --->
		 		<cfset crd = credit - 0.5>
				
		 <cfelseif DS gte 17 and DE eq daysInMonth(END)>  
		
		 		<!--- arrival during the month --->	
		 		<cfset crd = credit - 1.5>		
				
		 <cfelseif DS eq 1 and DE lte 15>
		
		  		<!--- departure during the month --->	
		 		<cfset crd = credit - 1.5>		
							
		 <cfelseif DS eq 1 and DE gte 16 and DE lte (daysInMonth(END)-1)>
		
		  		<!--- departure during the month but before the LAST day of work--->	
		 		<cfset crd = credit - 0.5>		
		 		
		 <cfelse>
		 
		 		<cfset crd = 0>
		 				 
		 </cfif>
		 
		 <cfset caller.crd = crd>
		 
	 <cfelse>
	 
		<!--- SLWOP correction so the dates effectively work in the reverse --->
	 
	 	<cfif DS eq 1 and DE eq daysInMonth(END)>
		   
			 <!--- most common --->
			 <cfset ded = credit>				     
		 <cfelseif DS gte 2 and DS lte 16 and DE eq daysInMonth(END)>  
		 	 	<!--- SLWOP correction in reverse 01/06 applied ---> 		 						
		 		<cfset ded = credit - 1.0>		
					
		 <cfelseif DS gte 17 and DE eq daysInMonth(END)>  	
		        <!--- SLWOP correction in reverse 01/06 applied --->	 		 		
		 		<cfset ded = credit - 2.0>								
		 <cfelseif DS eq 1 and DE lte 15>
		 		<!--- SLWOP correction in reverse 01/06 applied --->  						
		 		<cfset ded = credit - 2.0>										
		 <cfelseif DS eq 1 and DE gte 16 and DE lte (daysInMonth(END)-1)>	  		
		 		<cfset ded = credit - 1.5>				 						
		 <cfelse>		 
		 		<cfset ded = 0>		 				 
		 </cfif>
		 
		 <cfset caller.crd = ded>
	 
	 </cfif>	 
	
		 
<cfelseif Credit eq "3.5">	

	<!--- arrival during the month not applicable --->
					 
	 <cfif DS eq 1 and DE eq daysInMonth(END)>
	   
	    <!--- most common --->
	   	<cfset crd = credit>		
	   
	 <cfelseif DS gte 2 and DS lte 16 and DE eq daysInMonth(END)>  
	 	 	 
	 		<!--- arrival during the month --->
	 		<cfset crd = credit - 0.7>
			
	 <cfelseif DS gte 17 and DE eq daysInMonth(END)>  
	 
	 		<!--- arrival during the month --->	
	 		<cfset crd = credit - 2.1>		
			
	 <cfelseif DS eq 1 and DE lte 15>
	 
	  		<!--- departure during the month --->	
	 		<cfset crd = credit - 2.1>		
			
	 <cfelseif DS eq 1 and DE gte 16>
	 
	  		<!--- departure during the month --->	
	 		<cfset crd = credit - 0.7>		
	 		
	 <cfelse>
	 
	 		<cfset crd = 0>
	 				 
	 </cfif>
	 
	 <!--- correction to make it half days --->
	 <cfset crd = crd * 2>
	 <cfset crd = int(crd)/2>
	 	 
	 <cfset caller.crd = crd>

</cfif> 