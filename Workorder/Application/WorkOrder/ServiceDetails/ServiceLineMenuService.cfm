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

	<cfset itm = 1>					
	<cf_tl id="Provisioning" var="vProvisioning">
	
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/Features.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#"
				targetitem = "1" 
				padding    = "3"
				class      = "highlight"
				name       = "#vProvisioning#"
				source     = "Billing/DetailBilling.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#">			
				
	<cfif children.recordcount gte "1" or transferstatus eq "disable">			
	
		<cfset accessmode = "view">
				
	<cfelse>
	
		<cfset accessmode = "edit">	
					  
	</cfif>    
				
	<cfset itm = itm+1>		
	<cf_tl id="About this service" var="vEditLines">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/General.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "1"
				padding    = "3"
				name       = "#vEditLines#"
				source     = "ServiceLineForm.cfm?accessmode=#accessmode#&tabno=1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
				
	
	<!--- move to the line info	
	
	<cfif accessProcess neq "NONE">			
				
		<cfset itm = itm+1>	
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Workorder/Notes.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "3"
					targetitem = "2"
					name       = "Notes"
					source     = "../Memo/WorkorderLineMemo.cfm?tabno=contentbox2&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
					
	</cfif>
	
	--->
	
	
	<cfif ManualEntry.recordcount gte "1">
	
		<cfset itm = itm+1>	
		<cf_tl id="Usage" var="vUsage">
		<cf_menutab item   = "#itm#" 
	            iconsrc    = "Logos/Workorder/DataEntry.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				targetitem = "1"
				padding    = "3"
				name       = "#vUsage#"
				source     = "Transaction/TransactionListing.cfm?tabno=#itm#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">			
	
	</cfif>			
	
	<cfif accessProcess neq "NONE">	
	
		<cfset itm = itm+1>		
		<cf_tl id="Actions" var="vActions">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Workorder/Task.png" 
					iconwidth  = "#wd#" 
					targetitem = "1"
					padding    = "3"
					iconheight = "#ht#" 
					name       = "#vActions#"
					source     = "Action/WorkAction.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=1">	
							
	</cfif>		
	
	<cfif accessRequest eq "ALL">	
												
		<cfset itm = itm+1>	
		<cf_tl id="Amendments" var="vAmendments">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Workorder/Request.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "3"
					targetitem = "2"
					name       = "#vAmendments#"
					source     = "../../Request/Listing/RequestListingView.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#">	
				
	</cfif>				
	
	<cfquery name="CheckAsset" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    ServiceItemMaterials
		 WHERE   ServiceItem   = '#Item.code#'	
		 AND     MaterialsClass = 'Asset'
	</cfquery>			
	
	<cfif CheckAsset.recordcount gte "1">					
							
		<cfset itm = itm+1>	
		<cf_tl id="Devices" var="vDevices">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Workorder/Device.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "3"
					targetitem = "1"
					name       = "#vDevices#"
					source     = "../Assets/AssetDialog.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
					
	</cfif>				
				
	<cfset itm = itm+1>		
	<cf_tl id="Charges" var="vCharges">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Financials.png" 
				iconwidth  = "#wd#" 
				padding    = "3"
				targetitem = "1"
				iconheight = "#ht#" 
				name       = "#vCharges#"
				source     = "Charges/ChargesWorkorderLine.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
				
	<cfif accessFunding neq "NONE">	
												
		<cfset itm = itm+1>		
		<cf_tl id="Approvals" var="vApprovals">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Approval.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					padding    = "3"
					targetitem = "1"
					name       = "#vApprovals#"
					source     = "Action/ClosingListing.cfm?tabno=1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">	
				
	</cfif>		
				