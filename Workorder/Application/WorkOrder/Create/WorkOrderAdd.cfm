
<cfif client.googlemap eq "1">
    <cfajaximport tags="cfform,cfdiv">
	<!---
	<cfajaximport tags="cfmap,cfform,cfdiv" params="#{googlemapkey='#client.googlemapid#'}#">
	--->
<cfelse>
	<cfajaximport tags="cfform,cfdiv">
</cfif>	

<cfparam name="url.orgunit"  default="">
<cfparam name="url.date"     default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="url.context"  default="backoffice">
		
<cfinclude template="../ServiceDetails/Billing/DetailBillingFormScript.cfm">
<cf_menuScript>
<cf_mapscript>
<cf_comboscript>
<cf_calendarscript>
<cf_dialogorganization>
<cf_dialogworkorder>
<cf_textareaScript>
<cf_PresentationScript>

<cf_tl id="Order" var="headerlabel">

<cfif url.context eq "Portal">
   	<cf_screentop jquery="yes" html="no" height="100%" label="#ucase(url.mission)# #headerlabel#" scroll="no" layout="webapp" banner="gray" bannerforce="Yes">
<cfelseif url.context eq "workflow">    
   	<cf_screentop jquery="yes" html="no" height="100%" label="#ucase(url.mission)# #headerlabel#" scroll="no" layout="webapp" banner="gray" bannerforce="Yes">
<cfelseif url.context eq "ajax">
    <cf_screentop jquery="yes" html="no" height="100%" label="#ucase(url.mission)# #headerlabel#" close="parent.ColdFusion.Window.destroy('myorder',true)" layout="webapp" scroll="no" banner="gray"> 
<cfelseif url.context eq "embed">
    <cf_screentop jquery="yes" html="no" height="100%" label="#ucase(url.mission)# #headerlabel#" close="parent.ColdFusion.Window.destroy('myorder',true)" layout="webapp" scroll="no" banner="gray"> 	
<cfelse>
    <cf_screentop jquery="yes" html="no" height="100%" label="#ucase(url.mission)# #headerlabel#" layout="webapp" scroll="no" banner="gray">
</cfif>	

<cf_layoutscript>
			
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	  
		
<cf_layout attributeCollection="#attrib#">

<cfif url.context neq "embed">
	<cf_layoutarea position="header" size="50" name="controltop">		  
		<cf_ViewTopMenu label="#ucase(url.mission)# #headerlabel#" menuaccess="context" background="blue">			
	</cf_layoutarea>	
</cfif>		 

<cf_layoutarea  position="center" name="box">
			
		<cf_divscroll style="height:98%">
		
				<table width="100%" bgcolor="FFFFFF" style="padding:10px">
					
					<tr><td id="adddetail" height="0px"></td></tr>
					
					<tr><td valign="top">
					   <table width="100%" border="0" align="center">
					   
					   <cfparam name="url.customerid"    default="">
					   <cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
					   <cfparam name="url.workorderline" default="1">
					   
					   <cfif url.customerid eq "">
					
						    <cf_assignid>
						    <cfset url.customerid = rowguid>
							
					   </cfif>     
					      
					   	<cfquery name="Customer" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM  Customer
							WHERE Customerid = '#URL.Customerid#' 			
						</cfquery>
						<!--- Fixing Sync  issue with customerName as in some instances is blank
						11/23/2020 - by Armin
						---->
						<cfif Customer.CustomerName eq "" AND Customer.PersonNo neq "">
							<cfquery name="qApplicant"
									datasource="appsWorkOrder"
									username="#SESSION.login#"
									password="#SESSION.dbpw#">
									SELECT *
									FROM applicant.dbo.Applicant
									WHERE PersonNo='#Customer.PersonNo#'
							</cfquery>

							<cfif qApplicant.Recordcount neq 0>

								<cfset vFullName = "">
								<cfif qApplicant.FirstName neq "">
									<cfset vFullName = "#qApplicant.FirstName#">
								</cfif>

								<cfif qApplicant.MiddleName neq "">
									<cfset vFullName = "#vFullName# #qApplicant.MiddleName#">
								</cfif>

								<cfif qApplicant.LastName neq "">
									<cfset vFullName = "#vFullName# #qApplicant.LastName#">
								</cfif>

								<cfif qApplicant.LastName2 neq "">
									<cfset vFullName = "#vFullName# #qApplicant.LastName2#">
								</cfif>

								<cfquery name="qUpdate"
										datasource="appsWorkOrder"
										username="#SESSION.login#"
										password="#SESSION.dbpw#">
										UPDATE Customer
										SET CustomerName = '#vFullName#'
										WHERE CustomerId = '#URL.Customerid#'
								</cfquery>

								<cfquery name="Customer"
										datasource="appsWorkOrder"
										username="#SESSION.login#"
										password="#SESSION.dbpw#">
										SELECT *
										FROM  Customer
										WHERE Customerid = '#URL.Customerid#'
								</cfquery>
							</cfif>

						</cfif>



						<cfquery name="getPrior" 
						 datasource="AppsWorkOrder" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							SELECT TOP 1 *
							FROM  WorkOrder
							WHERE CustomerId = '#url.customerid#'
							AND   OrgUnitOwner > '0'
							ORDER BY Created DESC						  
						</cfquery>		
						
						<!--- pending to limit the access to only the services a person has indeed access for it --->
						
						<cfset filter = "">	
								
						<cfif url.orgunit neq "0" and url.orgunit neq "">
						
							<cfquery name="getFilterService" 
								datasource="appsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							    SELECT   ServiceItem
								FROM     ServiceItemMissionOrgunit
								WHERE    Mission            = '#url.mission#' 
								AND      OrgUnitImplementer = '#url.orgunit#' 			
							</cfquery>	
							
							<cfif getFilterService.recordcount gte "1">	
								<cfset filter = quotedValueList(getFilterService.ServiceItem)>						
							</cfif>
											
						</cfif>
							 			
						<cfquery name="ServiceItemList" 
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT   *
							    FROM     ServiceItem
								WHERE    Code IN (SELECT ServiceItem 
								                  FROM   ServiceItemMission 
											      WHERE  Mission = '#url.mission#' 
												  <cfif filter neq "">
												  AND    ServiceItem IN (#preservesingleQuotes(filter)#)
												  </cfif>
											      AND    Operational = 1)							 
								AND      Operational = 1			
								<cfif url.context eq "portal">
								AND      Selfservice = 1
								</cfif>						
								ORDER BY ListingOrder
						</cfquery>	
									
						<cfif ServiceItemList.recordcount lt "1">
						    <cfset cl = "hide">
						<cfelse>
							<cfset cl = "regular">
						</cfif>
							
						<cfset go = "0">	
													
						<tr class="<cfoutput>#cl#</cfoutput>">		   
						   <td colspan="2" class="labelmedium" style="padding-top:6px;padding-left:20px">
						   
						   <table class="formpadding" style="border:1px solid silver">
						   <tr><td style="background-color:f1f1f1">
						   
						   <select name="serviceitemselect" 
						           id="serviceitemselect" 
								   style="font-size:22px;height:38px;border:0px;background-color:f1f1f1" 
								   class="regularxxl">   
						   	  
							   <cfoutput query="ServiceitemList">

								   <cfif customer.orgunit eq "">
									   <cfset vUnit = url.orgunit>
								   <cfelse>
									   <cfset vUnit = customer.orgunit>
								   </cfif>

							  	  <cfinvoke component = "Service.Access"  
									   method           = "workorderprocessor" 
									   mission          = "#url.mission#" 	
									   orgunit          = "#vUnit#"
									   serviceitem      = "#code#"  
									   returnvariable   = "access">  
								   				   
								  <cfif access eq "ALL" or access eq "EDIT" or url.context eq "Portal">		   
								      <cfset go = "1">
								      <option value="#Code#" <cfif getPrior.serviceItem eq Code>selected</cfif>>#Description#</option>
								  </cfif>	  
								   
							   </cfoutput>
							   
						   </select>
						   
						   </td>
						   
						   <cfif customer.recordcount eq "1">	
						      <td style="background-color:f1f1f1;padding-left:20px;padding-right:20px;font-size:20px;height:45px">
							  <cfoutput>		
								| #Customer.CustomerName#		
						      </cfoutput>	
							  </td>
							  
							 </tr></table>
							
							 </td>
							
						</cfif>							 
					
						</tr>
									
						<cfif go eq "0">
							
							<tr>
								<td colspan="2" style="height:40" class="labelmedium" align="center">
								<cf_tl id="No access granted to add workorders">.
								</td>
							</tr>	
									
						<cfelse>
						
						    <cfparam name="url.requestid" default=""> 		
							<cfparam name="url.orgunit" default=""> 
							<cfparam name="url.personno" default=""> 
										
							<cfoutput>
										
							<tr><td colspan="2">
								
								<table width="100%" class="formpadding">
													
									<tr>
									   <td colspan="2" style="padding:20px">
									       <!--- embedded form for this order --->										   				  					   
										   					  
									       <cf_securediv bind="url:#SESSION.root#/workorder/application/workorder/create/workorderform.cfm?idmenu=#url.systemfunctionid#&context=#url.context#&scope=add&mode=edit&mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#&date=#url.date#&serviceitem={serviceitemselect}&customerid=#url.customerid#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&requestid=#url.requestid#"
										     id="content">		
											 			
									   </td>
									</tr>
																			
									<tr><td height="4"></td></tr>
									
									<tr><td class="line" style="padding-top:3px" width="100%" colspan="2" align="center">		
									
										<cfoutput>	
														
											<script>
											
												function validate() {
													document.orderform.onsubmit() 
													if( _CF_error_messages.length == 0 ) {  
													    Prosis.busy('yes');
														_cf_loadingtexthtml='';	         
														ptoken.navigate(document.getElementById('formsave').value+'&customerid=#url.customerid#&requestid=#url.requestid#&idmenu=#url.systemfunctionid#','adddetail','','','POST','orderform')
													 }   
												
												}								
											
											</script>
										
										</cfoutput>						
																
										<cfif url.context neq "workflow">  
										
											<cf_tl id="save" var="vSave">
											<cf_tl id="close" var="vCancel">
										
											<table align="center" cellspacing="0" cellpadding="0" class="formspacing">
											<tr>					
												
												<td>	
															
													<input type    = "button" 
														   name    = "Close" 
														   style   = "width:170;height:27;font-size:12px"
														   class   = "button10g"
								                           id      = "Close"
														   value   = "#vCancel#" 						   
														   onclick = "returnValue=1;window.close()">								   
												</td>		
												
												<td> 	
											
											    	<input type    = "button" 
													       style   = "width:170;height:27;font-size:12px"
														   class   = "button10g"
														   name    = "Save" 
								                           id      = "Save"
														   value   = "#vSave#" 						   
														   onclick = "validate()">	
														   
												</td>	
											</tr>
											</table>	
											
										<cfelse>
										
											<cf_tl id="Apply request for service" var="vSave">
																	
											<table width="100%" cellspacing="0" cellpadding="0">
												<tr>					
																													
													<td style="padding-left:20px"> 	
												
												    	<input type    = "button" 
														       style   = "width:335;height:31;font-size:13px"
															   class   = "button10g"
															   name    = "Save" 
									                           id      = "Save"
															   value   = "#vSave#" 						   
															   onclick = "validate()">	
															   										   
													</td>	
												</tr>
											</table>	
															
										</cfif>
									
									</td></tr>
									
								</table>
							
							</td></tr>
							</cfoutput>
					
						</cfif>
							
					   </table>
					</td>
					
					</tr>
				</table>
			
		</cf_divscroll>
		
	</cf_layoutarea>
	
	<!---					
	<cf_layoutarea 
	    position="right" 
		name="helpercontent" 
		id="helpercontent" 
		minsize="20%" 
		maxsize="30%" 
		size="520" 
		overflow="hidden" 
		initcollapsed="yes"
		collapsible="true" 
		splitter="true">
	
	</cf_layoutarea>	
	--->
						
</cf_layout>				
		
