 
<cfoutput>

<cf_tl id="Receipts" var="vReceipt">

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#vReceipt# #attributes.mission#</span>"	
	expand="Yes">
   
   <cf_tl id="Tasks" var="vTasks">
   	   
   <cf_UItreeitem value="Tasks"
		        display="<span style='font-size:17px;padding-to:5px;padding-bottom:5px;font-weight:bold' class='labelit'>#vTasks#</span>"
				parent="root"								
		        expand="Yes">	
	
	 <cf_tl id="Shipment Clearance" var="vPendingClearance">
	
	 <cf_UItreeitem value="Pending"
	        display="<span style='font-size:14px' class='labelit'>#vPendingClearance#</span>"
			parent="Tasks"			
			href="ReceiptViewOpen.cfm?ID1=Pending&ID=STA&Mission=#Attributes.Mission#"							
			target="right"
	        expand="No">					
	
	<cf_verifyOperational module="Warehouse" Warning="No">
	
	<cf_tl id="Pending Asset Recording" var="vPendingAsset">
	
	<cf_UItreeitem value="Asset"
	        display="<span style='font-size:14px' class='labelit'>#vPendingAsset#</span>"
			parent="Tasks"					
			href="ReceiptViewOpen.cfm?ID1=Equipment&ID=STA&Mission=#Attributes.Mission#"							
			target="right"
	        expand="No">	
						
   
    <cf_tl id="Inquiry" var="vInquiry">
   
	<cf_UItreeitem value="Listing"
	        display="<span style='font-size:17px;padding-top:5px;;padding-bottom:5px;font-weight:bold' class='labelit'>#vInquiry#</span>"
			parent="Root"						
	        expand="Yes">	 
						
		<cf_tl id="Received" var="vReceivedOn">
		<cf_tl id="Today" var="vToday">
							
		<cf_UItreeitem value="Today"
	        display="<span style='font-size:14px' class='labelit'>#vReceivedOn# #vToday#</span>"
			parent="Listing"				
			target="right"
			href="ReceiptViewOpen.cfm?ID1=TODAY&ID=STA&Mission=#Attributes.Mission#">			  
			
		<cf_tl id="Received" var="vReceived">
		<cf_tl id="This Week" var="vThisWeek">
			
		<cf_UItreeitem value="Week"
	        display="<span style='font-size:14px' class='labelit'>#vReceived# #vThisWeek#</span>"
			parent="Listing"				
			target="right"
			href="ReceiptViewOpen.cfm?ID1=WEEK&ID=STA&Mission=#Attributes.Mission#">			
    		  
		<cf_tl id="Received" var="vReceived">
		<cf_tl id="This Month" var="vThisMonth">
			
		<cf_UItreeitem value="Month"
	        display="<span style='font-size:14px' class='labelit'>#vReceived# #vThisMonth#</span>"
			parent="Listing"				
			target="right"
			href="ReceiptViewOpen.cfm?ID1=MONTH&ID=STA&Mission=#Attributes.Mission#">			

</cf_UItree>

</cfoutput>

