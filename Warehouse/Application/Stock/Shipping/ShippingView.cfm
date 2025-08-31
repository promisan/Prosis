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
<!--- Attention 

9/7/2015 this function allows an external contractor (outsource) that operates within the organization of the entity to bill (AP) the entity 
items that were provided by them --->

<cfinvoke component = "Service.Access"  
     method             = "function"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 warehouse          = "#url.warehouse#"
	 SystemFunctionId   = "#url.SystemFunctionId#" 
	 returnvariable     = "access">	 	

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr><td align="center" height="40">
		    <font face="Verdana" color="FF0000">
			<cf_tl id="Detected a Problem with your access"  class="Message">
			</font>
			</td></tr>
	</table>	
	<cfabort>	
		
</cfif>		

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

	<cfoutput>
		
	<tr><td height="30">
	
			<table width="100%" border="0" class="formpadding" align="center" cellspacing="0" cellpadding="0">		  		
							
				<cfset ht = "48">
				<cfset wd = "48">
						
				<tr>				
										
						<cf_menutab item       = "1" 
					        iconsrc    = "Logos/Warehouse/Summary.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 									
							class      = "highlight1"
							name       = "Billing Summary"
							source     = "../Shipping/Summary/SummaryView.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">			
																			
						<cf_menutab item       = "2" 
					        iconsrc    = "Logos/Warehouse/Process.png" 
						    iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"
							name       = "Submit for Billing"
							source     = "../Shipping/PendingTransaction/Pending.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">
							
						<cf_menutab item       = "3" 
					        iconsrc    = "Logos/Warehouse/Distribute.png" 
						    iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"
							name       = "Ready for Submission"
							source     = "../Shipping/Payables/Create/PrepareInvoice.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">
						
							
						<cf_menutab item       = "4" 
					        iconsrc    = "Logos/Warehouse/Inquiry.png" 
						    iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							targetitem = "1"
							name       = "Recorded Payables"
							source     = "../Shipping/Payables/Payables.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">	
						
						<!--- alternate for issues that are outgoing in the regular mode
							
						<cf_menutab item       = "3" 
					        iconsrc    = "Logos/Procurement/Invoice.png" 
						    iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							name       = "Payables"
							source     = "../Shipping/ShippingReceiables.cfm?mission=#URL.Mission#&warehouse=#url.warehouse#">		
							
							--->
							
							<td width="10%"></td>
																		 		
					</tr>
			</table>
	
		</td>
	 </tr>
	 
	 </cfoutput>	
		 
	 <tr><td height="100%" style="padding:8px">
	 
		 <table width="100%" 
		      border="0"
			  height="100%"		  
			  align="center">
			  	 					
				<cf_menucontainer item="1" class="regular">		
					<cfinclude template="Summary/SummaryView.cfm">	
				<cf_menucontainer>
			
						
		 </table>	
						  	 
	 </td></tr>
	  
 </table>
 
 <!---
 </cf_tableround>
 --->
