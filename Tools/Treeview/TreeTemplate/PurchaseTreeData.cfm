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

<cf_tl id="Purchase" var="vPurchase">


<cf_UItree
	id="root"
	title="<span style='font-size:19px;color:gray;padding-bottom:3px'>#vPurchase# #url.mission#</span>"	
	expand="Yes">
			
    <cf_tl id="Issued" var="vIssue">	
							
			<cf_UItreeitem value="Issued"
	        display="<span style='font-size:16px;padding-top:3px;padding-bottom:3px' class='labelit'>#vIssue# #dateformat(now()-7, CLIENT.DateFormatShow)#</span>"
			parent="root"	
			target="right"						
			href="PurchaseViewOpen.cfm?ID1=Today&ID=TOD&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"		
	        expand="Yes">				
						   									
			<cfquery name="StatusList" 
			    datasource="AppsPurchase" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT   *
			    FROM     #Client.LanPrefix#Status 
				WHERE    StatusClass IN ('Job','Purchase')
				ORDER BY StatusClass 
			</cfquery>
			
			 <cfquery name="Parameter" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT *
				 FROM  Ref_ParameterMission
				 WHERE Mission = '#Attributes.Mission#'
		     </cfquery>
			
			<cfoutput query="StatusList" group="StatusClass">
												
			    <cf_tl id="#StatusClass#" var="vStatusClass">	
				
				<cfif StatusClass eq "Job">
				   <cfset lbl = "Procurement Job">
				<cfelse>
				   <cfset lbl = "Obligations"> 
				</cfif>
											
				<cf_UItreeitem value="#StatusClass#"
			        display="<span style='font-size:16px;;padding-top:3px;padding-bottom:1px' class='labelit'>#lbl#</span>"
					parent="root"													
			        expand="Yes">										
			
				<cfoutput>
				
				   <cfif StatusClass eq "Job">
				   
				   	<cfquery name="Check" 
				    datasource="AppsPurchase" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
						SELECT TOP 1 *
					    FROM   Job 
						WHERE  ActionStatus = '#Status#' 
						AND    Mission = '#mission#' 
						AND    Period = '#period#'								
					</cfquery>
					
					 <cfif check.recordcount eq "1">
			   		       					   											   
				   	   <cf_UItreeitem value="#StatusClass#_#Status#"
					        display="<span style='font-size:15px;' class='labelit'>#Description#</span>"
							parent="#StatusClass#"	
							target="right"	
							href="../JobView/JobViewOpen.cfm?ID1=#status#&ID=STA&Mission=#Attributes.Mission#"												
					        expand="Yes">		
						
					  </cfif>				
					
				   <cfelse>
							   
					   <cfif Parameter.EnforceProgramBudget eq "1" and Status eq "1f">
					   	    <!--- hide status --->
					   <cfelseif Parameter.FundingClearPurchase eq "0" 
					        and (Status eq "1f" or Status eq "1")>			   			   
					        <!--- hide status --->
					   <cfelse>
					   
					      <cfquery name="Check" 
							     datasource="AppsPurchase" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
							     SELECT DISTINCT P.ActionStatus as Status, P.OrderClass, C.Description
								 FROM   Purchase P, Ref_OrderClass C
								 WHERE  P.Mission    = '#Attributes.Mission#'
								 AND    P.Period     = '#Attributes.Period#'
								 AND    P.OrderClass = C.Code
								 AND    ActionStatus = '#Status#' 
								 <cfif getAdministrator(Attributes.Mission) eq "0">							
								 <!--- has been given access through roles --->
								 AND    P.OrderClass IN (SELECT ClassParameter 
								                         FROM   Organization.dbo.OrganizationAuthorization
														 WHERE  UserAccount = '#SESSION.acc#'
														 AND    Mission     = '#Attributes.Mission#'   
														 AND    ClassParameter = P.OrderClass
														 AND    Role = 'ProcApprover')
								 </cfif>						 
						   </cfquery>
						  						   
						   <cfset par = "#StatusClass#_#Status#">
					   
						   <cfif Status eq "7" or Status eq "9">						   	   
						   								   
							   <cfif Check.recordcount gte "1">
	
								   <cf_UItreeitem value="#par#"
								        display="<span style='font-size:15px;' class='labelit'>#Description#</span>"
										parent="#StatusClass#"	
										target="right"	
										href="PurchaseViewOpen.cfm?ID1=#status#&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"														
								        expand="No">	
									
									<cfloop query="Check">
									
										 <cf_UItreeitem value="#par#_#orderclass#"
								        display="<span style='font-size:13px;' class='labelit'>#Description#</span>"
										parent="#par#"	
										target="right"	
										href="PurchaseViewOpen.cfm?ID1=#status#&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#&orderclass=#orderclass#"														
								        expand="no">	
																		
									</cfloop>					
																
								</cfif>
							
							<cfelse>					   
							
								   <cf_UItreeitem value="#par#"
								        display="<span style='font-size:14px;' class='labelit'>#Description#</span>"
										parent="#StatusClass#"	
										target="right"	
										href="PurchaseViewOpen.cfm?ID1=#status#&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"													
								        expand="No">	
																		
									<cfloop query="Check">
									
										 <cf_UItreeitem value="#par#_#orderclass#"
								        display="<span style='font-size:13px;' class='labelit'>#Description#</span>"
										parent="#par#"	
										target="right"	
										href="PurchaseViewOpen.cfm?ID1=#status#&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#&orderclass=#orderclass#"														
								        expand="No">	
																		
									</cfloop>			
							
							</cfif>
							
							<cfif Status eq "3">
							
							      <cfset par = "#StatusClass#_#Status#_receipt">
									
								   <cf_UItreeitem value="#par#"
							        display="<span style='font-size:14px;' class='labelit'>Pending Receipt</span>"
									parent="#StatusClass#"	
									target="right"	
									href="PurchaseViewOpen.cfm?ID1=PendingReceipt&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"													
							        expand="No">									
																		
									<cfloop query="Check">
									
										 <cf_UItreeitem value="#par#_#orderclass#"
								        display="<span style='font-size:13px;' class='labelit'>#Description#</span>"
										parent="#par#"	
										target="right"	
										href="PurchaseViewOpen.cfm?ID1=#status#&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#&orderclass=#orderclass#"														
								        expand="No">	
																		
									</cfloop>	
									
								   <cfset par = "#StatusClass#_#Status#_invoice">
									
								   <cf_UItreeitem value="#par#"
							        display="<span style='font-size:14px;' class='labelit'>Partial Invoice</span>"
									parent="#StatusClass#"	
									target="right"	
									href="PurchaseViewOpen.cfm?ID1=PendingInvoice&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"													
							        expand="No">									
																		
									<cfloop query="Check">
									
										 <cf_UItreeitem value="#par#_#orderclass#"
								        display="<span style='font-size:13px;' class='labelit'>#Description#</span>"
										parent="#par#"	
										target="right"	
										href="PurchaseViewOpen.cfm?ID1=#status#&ID=STA&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#&orderclass=#orderclass#"														
								        expand="No">	
																		
									</cfloop>	
							
							</cfif>												
					
					    </cfif>	
						   
					</cfif>	   	
				   
				</cfoutput> 	
			
		</cfoutput>	
					
</cf_UItree>			
   
	   
