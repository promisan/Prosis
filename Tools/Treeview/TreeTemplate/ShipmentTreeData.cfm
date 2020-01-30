 
<cfoutput>

<cftree name="root"
   font="verdana"
   fontsize="11"		
   bold="No"   
   format="html"    
   required="No"> 
   
   	 <cftreeitem value="Tasks"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labellarge'><b>Other Tasks</span>"
			parent="Root"								
	        expand="Yes">	
			
		 <!--- get the functions and determine access --->
		 
		   <cfinvoke component = "Service.Access.Menu"  
		     method             = "MenuList"  			 
			 mission            = "#Attributes.mission#"			 
			 Module             = "'WorkOrder'" 
			 Selection          = "'Shipping'"
			 MenuClass          = "'Shipment'"
			 returnvariable     = "functionlist">	 		 
			 
		 <cfloop query="FunctionList">		 
		 		 
			  <cftreeitem value="#currentrow#"
			        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>#FunctionName#</span>"
					parent="Tasks"			
					href="#FunctionPath#?ID1=Pending&systemfunctionid=#systemfunctionid#&Mission=#Attributes.Mission#&#FunctionCondition#"							
					target="right"
			        expand="No">	
		 
		 </cfloop> 	 
		
   <cftreeitem value=""
			display="<span class='labelmedium'></span>"
	    	parent=""									  				  	 				 		  								
   			expand="yes">								
   
   <cf_tl id="Inquiry" var="pInquiry">	
   
	<cftreeitem value="Listing"
	        display="<span style='padding-top:15px;padding-bottom:3px;color: gray;' class='labellarge'><b>#pInquiry#</span>"
			parent="Root"						
	        expand="Yes">	 
			
	<cf_tl id="Open WorkOrders" var="pWorkOrder">		
		
	<!--- pending embedding in the menu framework --->
							
	<cftreeitem value="WorkOrder"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>#pWorkOrder#"
			parent="Listing"				
			target="right"
			href="WorkOrderView/WorkOrderListing.cfm?systemfunctionid=#attributes.systemfunctionid#&ID1=OPEN&ID=STA&Mission=#Attributes.Mission#">			  
	
	<cf_tl id="Shipped" var="pShipped">		
	<cf_tl id="after" var="pLast">		
	<!--- pending embedding in the menu framework --->
							
	<cftreeitem value="Today"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>#pShipped# on <u><font color='6688aa'>#dateformat(now(), CLIENT.DateFormatShow)#</u></span>"
			parent="Listing"				
			target="right"
			href="#attributes.destination#?systemfunctionid=#attributes.systemfunctionid#&ID1=TODAY&ID=STA&Mission=#Attributes.Mission#">			  
			
	<cftreeitem value="Week"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>#pShipped# #plast# <u><font color='6688aa'>#dateformat(now()-30, CLIENT.DateFormatShow)#</span>"
			parent="Listing"				
			target="right"
			href="#attributes.destination#?systemfunctionid=#attributes.systemfunctionid#&ID1=WEEK&ID=STA&Mission=#Attributes.Mission#">			
		
	<cf_tl id="Billed" var="pBilled">
	
	<cftreeitem value="Billed"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>#pBilled# #plast# <u><font color='6688aa'>#dateformat(now()-360, CLIENT.DateFormatShow)#</span>"
			parent="Listing"				
			target="right"
			href="BillingView/BillingListing.cfm?systemfunctionid=#attributes.systemfunctionid#&ID1=Billing&ID=STA&Mission=#Attributes.Mission#">		 
			

</cftree>

</cfoutput>

