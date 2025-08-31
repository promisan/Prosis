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
<cfoutput>

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#attributes.mission#</span>"	
	expand="Yes">
	
   <cf_tl id="Preparation" var="vPrepare">
   	   
         <cf_UItreeitem value="Prepare"
		        display="<span style='font-size:17px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labelit'>#vPrepare#</span>"
				parent="root"								
		        expand="Yes">	
				
			 <cfinvoke component = "Service.Access.Menu"  
		     method             = "MenuList"  			 
			 mission            = "#Attributes.mission#"			 
			 Module             = "'WorkOrder'" 
			 Selection          = "'Prepare'"
			 MenuClass          = "'Shipment'"
			 returnvariable     = "functionlist">	 		 
			 
		 <cfloop query="FunctionList">		
		 
		 	 <cf_UItreeitem value="Prepare#currentrow#"
		        display="<span style='font-size:14px' class='labelit'>#FunctionName#</span>"
				parent="Prepare"			
				href="#FunctionPath#?ID1=Pending&systemfunctionid=#systemfunctionid#&Mission=#Attributes.Mission#&#FunctionCondition#"							
				target="right"
		        expand="No">		 
		 			 
		 </cfloop> 	
	
   <cf_tl id="Shipping" var="vShip">
   	   
         <cf_UItreeitem value="Tasks"
		        display="<span style='font-size:17px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labelit'>#vShip#</span>"
				parent="root"								
		        expand="Yes">	
				
			 <cfinvoke component = "Service.Access.Menu"  
		     method             = "MenuList"  			 
			 mission            = "#Attributes.mission#"			 
			 Module             = "'WorkOrder'" 
			 Selection          = "'Shipping'"
			 MenuClass          = "'Shipment'"
			 returnvariable     = "functionlist">	 		 
			 
			 <cfloop query="FunctionList">		
			 
			 	 <cf_UItreeitem value="Task#currentrow#"
			        display="<span style='font-size:14px' class='labelit'>#FunctionName#</span>"
					parent="Tasks"			
					href="#FunctionPath#?ID1=Pending&systemfunctionid=#systemfunctionid#&Mission=#Attributes.Mission#&#FunctionCondition#"							
					target="right"
			        expand="No">		 
			 			 
			 </cfloop> 	
			

   <cf_tl id="Return handling" var="vReturn">
   	   
          <cf_UItreeitem value="Return"
		        display="<span style='font-size:17px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labelit'>#vReturn#</span>"
				parent="root"								
		        expand="Yes">	   
   			
		 <!--- get the functions and determine access --->
		 
		   <cfinvoke component = "Service.Access.Menu"  
		     method             = "MenuList"  			 
			 mission            = "#Attributes.mission#"			 
			 Module             = "'WorkOrder'" 
			 Selection          = "'Return'"
			 MenuClass          = "'Shipment'"
			 returnvariable     = "functionlist">	 		 
			 
		 <cfloop query="FunctionList">		
		 
		 	 <cf_UItreeitem value="Return#currentrow#"
		        display="<span style='font-size:14px' class='labelit'>#FunctionName#</span>"
				parent="Return"			
				href="#FunctionPath#?ID1=Pending&systemfunctionid=#systemfunctionid#&Mission=#Attributes.Mission#&#FunctionCondition#"							
				target="right"
		        expand="No">		 
		 			 
		 </cfloop> 
		 
   <cf_tl id="Billing" var="vBilling">	 	
   
   	      <cf_UItreeitem value="Billing"
		        display="<span style='font-size:17px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labelit'>#vBilling#</span>"
				parent="root"								
		        expand="Yes">	   
   			
		 <!--- get the functions and determine access --->
		 
		   <cfinvoke component = "Service.Access.Menu"  
		     method             = "MenuList"  			 
			 mission            = "#Attributes.mission#"			 
			 Module             = "'WorkOrder'" 
			 Selection          = "'Billing'"
			 MenuClass          = "'Shipment'"
			 returnvariable     = "functionlist">	 		 
			 
		 <cfloop query="FunctionList">		
		 
		 	 <cf_UItreeitem value="Billing#currentrow#"
		        display="<span style='font-size:14px' class='labelit'>#FunctionName#</span>"
				parent="Billing"			
				href="#FunctionPath#?systemfunctionid=#systemfunctionid#&Mission=#Attributes.Mission#&#FunctionCondition#"							
				target="right"
		        expand="No">		 
		 			 
		 </cfloop>  
	 		
   
   <cf_tl id="Inquiry" var="pInquiry">	
   
   <cf_UItreeitem value="Listing"
		        display="<span style='font-size:17px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labelit'>#pInquiry#</span>"
				parent="root"								
		        expand="Yes">	  
			
	<cf_tl id="WorkOrders" var="pWorkOrder">		
		
	<!--- pending embedding in the menu framework --->
	
	 	 <cf_UItreeitem value="WorkOrder"
		        display="<span style='font-size:14px' class='labelit'>#pWorkOrder#</span>"
				parent="Listing"			
				href="WorkOrderView/WorkOrderListing.cfm?systemfunctionid=#attributes.systemfunctionid#&ID=STA&Mission=#Attributes.Mission#"							
				target="right"
		        expand="No">		 
					
			<cf_tl id="Shipped" var="pShipped">		
			<cf_tl id="after" var="pLast">		
			<!--- pending embedding in the menu framework --->
			
		 <cf_UItreeitem value="Today"
		        display="<span style='font-size:14px' class='labelit'>#pShipped# #plast# #dateformat(now(), CLIENT.DateFormatShow)#</span>"
				parent="Listing"			
				href="#attributes.destination#?systemfunctionid=#attributes.systemfunctionid#&ID1=TODAY&ID=STA&Mission=#Attributes.Mission#"							
				target="right"
		        expand="No">		
				
		 <cf_UItreeitem value="Week"
		        display="<span style='font-size:14px' class='labelit'>#pShipped# #pLast# #dateformat(now()-30, CLIENT.DateFormatShow)#</span>"
				parent="Listing"			
				href="#attributes.destination#?systemfunctionid=#attributes.systemfunctionid#&ID1=WEEK&ID=STA&Mission=#Attributes.Mission#"							
				target="right"
		        expand="No">	
				
		 <cf_UItreeitem value="Month6"
		        display="<span style='font-size:14px' class='labelit'>#pShipped# in #dateformat(now(), 'YYYY')#</span>"
				parent="Listing"			
				href="#attributes.destination#?systemfunctionid=#attributes.systemfunctionid#&ID1=YEAR&ID=STA&Mission=#Attributes.Mission#"							
				target="right"
		        expand="No">	
				
		<cfset last = year(now())-1>
				
		 <cf_UItreeitem value="Month12"
		        display="<span style='font-size:14px' class='labelit'>#pShipped# in #last# </span>"
				parent="Listing"			
				href="#attributes.destination#?systemfunctionid=#attributes.systemfunctionid#&ID1=LASTYEAR&ID=STA&Mission=#Attributes.Mission#"							
				target="right"
		        expand="No">	
				
		<cfset last = last-1>
				
		 <cf_UItreeitem value="Month24"
		        display="<span style='font-size:14px' class='labelit'>#pShipped# in #last# </span>"
				parent="Listing"			
				href="#attributes.destination#?systemfunctionid=#attributes.systemfunctionid#&ID1=YEAR2&ID=STA&Mission=#Attributes.Mission#"							
				target="right"
		        expand="No">														
		
		 <cf_tl id="Billed" var="pBilled">
	
		 <cf_UItreeitem value="Billed"
			        display="<span style='font-size:14px' class='labelit'>#pBilled# in #dateformat(now(), 'YYYY')#</span>"
					parent="Listing"			
					href="BillingView/BillingListing.cfm?systemfunctionid=#attributes.systemfunctionid#&ID2=YEAR&ID1=Billing&ID=STA&Mission=#Attributes.Mission#"							
					target="right"
			        expand="No">	
					
		 <cfset last = year(now())-1>				
				
		 <cf_UItreeitem value="Billed"
			        display="<span style='font-size:14px' class='labelit'>#pBilled# in #last#</span>"
					parent="Listing"			
					href="BillingView/BillingListing.cfm?systemfunctionid=#attributes.systemfunctionid#&ID2=LASTYEAR&ID1=Billing&ID=STA&Mission=#Attributes.Mission#"							
					target="right"
			        expand="No">					
	
	</cf_UItree>

</cfoutput>

