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
<cf_dialogorganization>

<cfparam name="url.mode"          default="view">
<cfparam name="url.portal"        default="0">
<cfparam name="url.customerid"    default="">
<cfparam name="url.serviceclass"  default="">
<cfparam name="url.id2"           default="">
<cfparam name="url.mission"       default="#url.id2#">
<cfparam name="url.dsn"           default="AppsMaterials">

<cfif url.customerid eq "" and url.portal eq "1">
	
	<table cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr>
	<td height="80" class="labelmedium"><font color="gray"><cf_tl id="No service information found" class="message">.</font></td>
	</tr>
	</table>

<cfelse>			
	
		<cfquery name="Get" 
			datasource="#url.dsn#"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Customer
				<cfif url.customerid neq "">
				WHERE CustomerId  = '#URL.CustomerId#' 
				<cfelse>
				WHERE 1=0
				</cfif>
		</cfquery>
		
		<cfif url.customerid neq "">
		
			<cfif get.recordcount eq "0">
			
			    <script>
					Prosis.busy('no')
				</script>
				<table cellspacing="0" cellpadding="0" align="center" class="formpadding">
					<tr>
						<td height="80" class="labelmedium"><font color="red"><cf_tl id="Record has been removed from database" class="message"></td>
					</tr>
				</table>
			
				<cfabort>
			
			</cfif>
		
			<cfquery name="Mission" 
				datasource="#url.dsn#"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM  Ref_ParameterMission		
					WHERE Mission = '#get.mission#'	
			</cfquery>
		
		<cfelse>
		
			<cfquery name="Mission" 
				datasource="#url.dsn#"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_ParameterMission		
					WHERE  Mission = '#url.mission#'	
			</cfquery>
		
		</cfif>
		
	<cfoutput>		
		
	<table width="100%" height="100%" class="formpadding">											
									
		<tr><td height="100%" valign="top">		
							
			<table width="98%" height="100%" align="center">		
							   
				   <tr><td colspan="2" id="customerbox">				  
					   <cfinclude template="CustomerData.cfm">
				   </td></tr>			
				   				   
				   <cfif url.portal eq "0">			
					
				<tr><td height="10" colspan="2">											
												
					<table width="100%" align="center">
													 						 
							 	<tr>
								<td>
								
									<table width="99%" align="center" class="formspacing formpadding">
																							
									<tr>
																																			
									<cfset ht = "64">
									<cfset wd = "64">															
									
									<cf_tl id="Status of Orders" var="vStatus">
																		
									<cf_menutab item   = "1" 
									        base       = "sub"
											target     = "subbox"
											targetitem = "1"											
											padding    = "3"
											class      = "highlight"
									        iconsrc    = "Status-02.png" 
											iconwidth  = "#wd#" 									
											iconheight = "#ht#" 
											name       = "#vStatus#"
											source     = "#SESSION.root#/Workorder/Application/WorkOrder/Create/WorkorderListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#get.mission#&customerid=#url.customerid#&portal=0">										
											
									<cf_tl id="Actions" var="vAction">
									
									<cf_menutab item   = "2" 
									        base       = "sub"
											target     = "subbox"
											targetitem = "1"											
											padding    = "3"											
									        iconsrc    = "Action.png" 
											iconwidth  = "#wd#" 									
											iconheight = "#ht#" 
											name       = "#vAction#"
											source     = "#SESSION.root#/System/Organization/Customer/Action/CustomerActionListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#get.mission#&customerid=#url.customerid#&portal=0">										
								
											
									<cf_tl id="Invoices Issued" var="vInvoice">
									
									<cf_menutab item   = "3" 
									        base       = "sub"
											target     = "subbox"
											targetitem = "1"									
											padding    = "3"																		
									        iconsrc    = "Invoice.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#vInvoice#"
											source     = "../../../Workorder/Application/WorkOrder/ServiceDetails/Charges/InvoiceListingContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#get.mission#&customerid=#url.customerid#">							
									
									<cf_tl id="Contact and Address" var="vContact">
									
									<cf_menutab item   = "4" 
									        base       = "sub"
											target     = "subbox"
											targetitem = "2"									
											padding    = "3"																			
									        iconsrc    = "Contact.png" 
											iconwidth  = "#wd#" 
											iconheight = "#ht#" 
											name       = "#vContact#">						
											
									<cfif url.portal eq "0">		
										
										<cf_tl id="Charge Summary" var="vBilling">
										
										<cf_menutab item   = "5" 
										        base       = "sub"
												target     = "subbox"
												targetitem = "2"												
												padding    = "3"										
										        iconsrc    = "Billing.png" 
												iconwidth  = "#wd#" 
												iconheight = "#ht#" 
												name       = "#vBilling#"
												source     = "../../../Workorder/Application/WorkOrder/ServiceDetails/Charges/ChargesCustomer.cfm?systemfunctionid=#url.systemfunctionid#&mission=#get.mission#&customerid=#url.customerid#">				
												
									  </cfif>	
									  
									  <td style="width:10%"></td>	
									 								 								
									</tr>
									</table>	
								</td>							 									
								</tr>
																									
					</table>	
								 				
				    </td>
					
					</tr>
			
			</cfif>	      					   
					 					   			    
					   <cfif url.dsn eq "AppsMaterials">				     
	
							  <cfinclude template="../../../Warehouse/Application/SalesOrder/EmbedCustomer.cfm">					  
							  
					   <cfelseif url.dsn eq "AppsWorkOrder">		  							   
									   
					   <!--- --------------------------------- --->
					   <!--- ----link to Material application- --->
					   <!--- --------------------------------- --->
					   						     			  
						   <cfif get.Recordcount eq "0">
						  
						   <!--- entry mode --->			   	
							
						   <cfelse>
						  											
						  							
							<cfoutput>	
							
							<tr>
							   <td colspan="2" valign="top" height="100%">	
							   
							   <table width="99%" height="100%" align="center">	   					
															
									<cfif url.serviceclass eq "">
																															
										<cf_menucontainer name="subbox" item="1" class="regular">										
										      <cfset url.mission = get.mission>
											  <cfinclude template="../../../Workorder/Application/WorkOrder/Create/WorkOrderListing.cfm">											 
										</cf_menucontainer>
										
										<cf_menucontainer name="subbox" item="2" class="hide">	
										 <cfset url.id = get.orgunit>
											  <cfinclude template="../Application/Address/UnitAddressView.cfm">											  
										</cf_menucontainer>	  										
										<cf_menucontainer name="subbox" item="3" class="hide">																		  
										</cf_menucontainer>		
																		
									<cfelse>
									
										<cf_menucontainer name="subbox" item="1" class="hide">
											  <cfset url.id = get.orgunit>
											  <cfinclude template="../Application/Address/UnitAddressView.cfm">
										</cf_menucontainer>
																	
										<cf_menucontainer name="subbox" item="2" class="regular">											
										      <cfset mission = get.mission>
											  <cfinclude template="../../../Workorder/Application/WorkOrder/Create/WorkOrderListing.cfm">										
										</cf_menucontainer>
										
										<cf_menucontainer name="subbox" item="3" class="xxxxxhide">		
										</cf_menucontainer>																  																
									
									</cfif>								
								
							   </table>
							  							
							   </td>
							
							</tr>	
							
							</cfoutput>		
																						 
					</cfif>	
					
					</cfif>
									   
									   			
			</table> 
					
		</td></tr>
	
	</table>	
			
	</cfoutput>		

</cfif>

<!--- initially load --->

<cfif url.serviceclass neq "">

	<script>
	   try { document.getElementById('sub1').click() } catch(e) {}
	</script>

</cfif>

<script>
	Prosis.busy('no')
</script>

	