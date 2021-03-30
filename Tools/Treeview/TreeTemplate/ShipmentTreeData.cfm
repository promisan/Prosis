 
<cfoutput>

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#attributes.mission#</span>"	
	expand="Yes">
	
   <cf_tl id="Shipment" var="vShip">
   	   
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
		 
		 	 <cf_UItreeitem value="Return#currentrow#"
		        display="<span style='font-size:14px' class='labelit'>#FunctionName#</span>"
				parent="Tasks"			
				href="#FunctionPath#?ID1=Pending&systemfunctionid=#systemfunctionid#&Mission=#Attributes.Mission#&#FunctionCondition#"							
				target="right"
		        expand="No">		 
		 			 
		 </cfloop> 	
			

   <cf_tl id="Return" var="vReturn">
   	   
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
				href="#FunctionPath#?ID1=Pending&systemfunctionid=#systemfunctionid#&Mission=#Attributes.Mission#&#FunctionCondition#"							
				target="right"
		        expand="No">		 
		 			 
		 </cfloop>  
	 		
   
   <cf_tl id="Inquiry" var="pInquiry">	
   
   <cf_UItreeitem value="Listing"
		        display="<span style='font-size:17px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labelit'>#pInquiry#</span>"
				parent="root"								
		        expand="Yes">	  
			
	<cf_tl id="Open WorkOrders" var="pWorkOrder">		
		
	<!--- pending embedding in the menu framework --->
	
	 	 <cf_UItreeitem value="WorkOrder"
		        display="<span style='font-size:14px' class='labelit'>#pWorkOrder#</span>"
				parent="Listing"			
				href="WorkOrderView/WorkOrderListing.cfm?systemfunctionid=#attributes.systemfunctionid#&ID1=OPEN&ID=STA&Mission=#Attributes.Mission#"							
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
		
		 <cf_tl id="Billed" var="pBilled">
	
		 <cf_UItreeitem value="Billed"
			        display="<span style='font-size:14px' class='labelit'>#pBilled# #pLast# #dateformat(now()-36, CLIENT.DateFormatShow)#</span>"
					parent="Listing"			
					href="BillingView/BillingListing.cfm?systemfunctionid=#attributes.systemfunctionid#&ID1=Billing&ID=STA&Mission=#Attributes.Mission#"							
					target="right"
			        expand="No">		
	
	</cf_UItree>

</cfoutput>

