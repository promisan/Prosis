 
<cfoutput>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_Period
		WHERE  Period = '#URL.Period#' 
</cfquery>

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
			href="ReceiptViewOpen.cfm?ID1=Pending&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"							
			target="right"
	        expand="No">					
	
	<cf_verifyOperational module="Warehouse" Warning="No">
	
	<cf_tl id="Pending Asset Recording" var="vPendingAsset">
	
	<cf_UItreeitem value="Asset"
	        display="<span style='font-size:14px' class='labelit'>#vPendingAsset#</span>"
			parent="Tasks"					
			href="ReceiptViewOpen.cfm?ID1=Equipment&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"							
			target="right"
	        expand="No">							
   
    <cf_tl id="Inquiry" var="vInquiry">
   
	<cf_UItreeitem value="Listing"
	        display="<span style='font-size:17px;padding-top:5px;;padding-bottom:5px;font-weight:bold' class='labelit'>#vInquiry#</span>"
			parent="Root"						
	        expand="Yes">	 
			
		<cfif Period.dateexpiration gte now()>	
						
			
			<cf_tl id="Today" var="vToday">
								
			<cf_UItreeitem value="Today"
		        display="<span style='font-size:14px' class='labelit'>#vToday#</span>"
				parent="Listing" target="right"
				href="ReceiptViewOpen.cfm?ID1=TODAY&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#">			  
						
			<cf_tl id="This Week" var="vThisWeek">
				
			<cf_UItreeitem value="Week"
		        display="<span style='font-size:14px' class='labelit'>#vThisWeek#</span>"
				parent="Listing" target="right"
				href="ReceiptViewOpen.cfm?ID1=WEEK&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#">			
				
		</cfif>	
    	  
		
		<cf_tl id="Period" var="vPeriod">
				
		<cf_UItreeitem value="Year"
	        display="<span style='font-size:14px' class='labelit'>#url.period#</span>"
			parent="Listing" target="right"
			href="ReceiptViewOpen.cfm?ID1=YEAR&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#">			

</cf_UItree>

</cfoutput>

