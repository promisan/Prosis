
<cfset Criteria = ''>

<cfquery name="Mandate" 
	datasource="AppsOrganization" 	
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     Ref_Mandate
		WHERE    Mission = '#url.Mission#'
		ORDER BY MandateDefault DESC		
</cfquery> 

<cfset URL.role = "TimeKeeper">

<cfinvoke component = "Service.Access"  
   method           = "RoleAccess" 
   mission          = "#url.mission#" 
   role             = "'HROfficer','HRAssistant','Timekeeper'"  <!---   role             = "'Timekeeper','HROfficer'"  --->
   accesslevel      = "2"
   returnvariable   = "accessextended">	   
   
<cf_divscroll>
    	
    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				  
		  <tr><td style="font-size:19px;height:40px" class="labelit"><cf_tl id="Office attendance"></td></tr>	
	 	

		  <tr>
	        <td valign="top"> 
											
			    <cf_tl id="#url.mission#" var="1">	
									
				<cf_UItree name="idtree" fontsize="12" bold="No" format="html" required="No">
				
	 		     <cf_UItreeitem
				  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#mandate.mandateno#','OrganizationListing.cfm','ATT','#lt_text#')">
									  
			    </cf_UItree>
				
				</td>
				
			</tr>
			
						
			<tr><td valign="top" style="padding-left:10px">
			
			<cf_UItree
			id="root"
			root="no"
			title="<span style='font-size:24px;color:gray;padding-bottom:3px'>Attendance</span>"	
			expand="Yes">
			
			<cfif accessextended eq "GRANTED">
			
			    <cf_verifyOperational module="ePas" Warning="No">
				
				<cfif operational eq "1">
				
	   			  <cf_tl id="Performance Appraisal" var="PAS">
				
				  <cf_UItreeitem value="pas"
			        display="<span style='font-size:18px;padding-top:8px;font-weight:bold;padding-bottom:5px' class='labelit'>#PAS#</span>"														
					parent="root"							
			        expand="Yes">									
					
						 <cfquery name="Period" 
							datasource="AppsEPas" 	
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT   *
								FROM     Ref_ContractPeriod
								WHERE    Mission = '#url.mission#'
								AND      Operational = 1						
						</cfquery>	
					
						<cfif Period.recordcount gte 1>
																										
								<cfoutput query="Period">								
								  
							  	 <cf_UItreeitem value="pas_#currentrow#"
								        display="<span style='font-size:16px;padding-top:3px;padding-bottom:3px' class='labelit'>#Code#</span>"
										parent="pas"	
										href="../Appraisal/PASListing.cfm?mission=#url.mission#&period=#code#&filter=active&systemfunctionid=#url.systemfunctionid#"											
										target="right"
								        expand="Yes">											
																												
								</cfoutput>								
													
						</cfif>
										
					</cfif>
				
            </cfif>
			   
			<cfif accessextended eq "GRANTED">
			
				 <cf_tl id="Home Address Zones" var="home">
				
				  <cf_UItreeitem value="home"
			        display="<span style='font-size:18px;padding-top:8px;font-weight:bold;padding-bottom:5px' class='labelit'>#home#</span>"														
					parent="root"							
			        expand="Yes">								
			  				  																								
					 <cfquery name="Zone" 
						datasource="AppsEmployee" 	
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
							FROM     Ref_AddressZone
							WHERE    Mission = '#url.mission#'
							ORDER BY ListingOrder
					 </cfquery>	
					
					 <cfif Zone.recordcount gte 1>
																					
							<cfoutput query="Zone">
							
								 <cfquery name="AddressType" 
									datasource="AppsEmployee" 	
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT   *
									    FROM     Ref_AddressType	
										WHERE AddressType IN (SELECT DISTINCT AddressType
										                      FROM   PersonAddress
													          WHERE  AddressZone = '#code#')					        
								 </cfquery>	
								 
								  <cf_UItreeitem value="home_#code#"
								        display="<span style='font-size:16px;padding-top:3px;padding-bottom:3px' class='labelit'>#Description#</span>"
										parent="home"											
								        expand="No">
																
									<cfloop query="AddressType">	
									
										<cf_UItreeitem value="home_#zone.code#_#addresstype#"
									        display="<span style='font-size:15px;padding-top:2px;padding-bottom:2px' class='labelit'>#Description#</span>"
											parent="home_#zone.code#"	
											href="../Address/AddressListing.cfm?mission=#url.mission#&zone=#zone.code#&addresstype=#addresstype#&filter=active&systemfunctionid=#url.systemfunctionid#"										
											target="right"
									        expand="No">	
											
											<cf_UItreeitem value="home_#zone.code#_#addresstype#_map"
										        display="<span style='font-size:14px;padding-top:2px;padding-bottom:2px' class='labelit'>MAP"
												parent="home_#zone.code#_#addresstype#"	
												href="../Address/AddressListingMAP.cfm?mission=#url.mission#&zone=#zone.code#&addresstype=#addresstype#&filter=active"										
												target="right"
										        expand="No">									
																
											<cf_UItreeitem value="home.#zone.code#_#addresstype#_lis"
										        display="<span style='font-size:14px;padding-top:2px;padding-bottom:2px' class='labelit'>Listing"
												parent="home_#zone.code#_#addresstype#"	
												href="../Address/AddressListing.cfm?mission=#url.mission#&zone=#zone.code#&addresstype=#addresstype#&filter=active"										
												target="right"
										        expand="No">																												
									
									</cfloop>
							
							</cfoutput>	
											
					</cfif>
									
			</cfif>	
			
			 <cf_tl id="Leave records" var="leave">
				
			  <cf_UItreeitem value="leave"
			        display="<span style='font-size:18px;padding-top:8px;font-weight:bold;padding-bottom:5px' class='labelit'>#leave#</span>"														
					parent="root"							
			        expand="Yes">						
						
				<cfquery name="LeaveType" 
					datasource="AppsEmployee" 	
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
				        FROM     Ref_LeaveType
						WHERE    LeaveType IN (SELECT LeaveType 
						                  FROM   PersonLeave 
										  WHERE  OrgUnit IN (SELECT OrgUnit 
										                     FROM   Organization.dbo.Organization 
															 WHERE Mission = '#url.mission#')						     
										  )		
						ORDER BY ListingOrder				  			    
				</cfquery>	
							
				<cfif LeaveType.recordcount neq "0">			
				    
					 		<cf_UItreeitem value="all_leave"
							   display="<span style='font-size:16px;padding-top:3px;padding-bottom:3px' class='labelit'>All records</span>"
							   parent="leave"											
							   expand="Yes">					  
					  							  
					  		<cfquery name="StatusList" 
								datasource="AppsEmployee" 	
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT    Status as StatusCode, Description 
									FROM      Ref_Status
									WHERE     Class = 'Leave'
									-- AND       Status != '8'
								</cfquery>	
								
								<cfset tpe = LeaveType>								
								
								<cfloop query="StatusList">
								
									<cfif StatusCode gte '8'>
										<cfset cl = "red">
									<cfelse>
										<cfset cl = "6688aa">
									</cfif>
									
									<cf_UItreeitem value="all_leave_#statuscode#"
									        display="<span style='font-size:15px;padding-top:2px;padding-bottom:2px;color: #cl#;' class='labelit'>#Description#</span>"
											parent="all_leave"	
											href="../LeaveRequest/LeaveListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&leavetype=&filter=#statuscode#&systemfunctionid=#url.systemfunctionid#"										
											target="right"
									        expand="No">																	
																	
								</cfloop>	
								
							<cf_UItreeitem value="ltpe"
							   display="<span style='font-size:16px;padding-top:3px;padding-bottom:3px' class='labelit'>Type of leave</span>"
							   parent="leave"											
							   expand="No">													
																	
							<cfoutput query="LeaveType">
							
								<cf_UItreeitem value="ltpe_#LeaveType#"
							        display="<span style='font-size:15px;padding-top:2px;padding-bottom:2px' class='labelit'>#Description#</span>"
									parent="ltpe"	
									href="../LeaveRequest/LeaveListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&leavetype=#leavetype#&filter=active&systemfunctionid=#url.systemfunctionid#"										
									target="right"
							        expand="No">									
																	
									<cfquery name="StatusList" 
									datasource="AppsEmployee" 	
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    Status as StatusCode, Description 
										FROM      Ref_Status
										WHERE     Class = 'Leave'
										-- AND       Status != '8'
									</cfquery>	
									
									<cfset tpe = LeaveType>								
									
									<cfloop query="StatusList">
									
										<cfif StatusCode gte '8'>
											<cfset cl = "red">
										<cfelse>
											<cfset cl = "6688aa">
										</cfif>
										
										<cf_UItreeitem value="ltpe_#tpe#_#statuscode#"
										        display="<span style='font-size:14px;padding-top:2px;padding-bottom:2px;color:#cl#' class='labelit'>#description#</span>"
												parent="ltpe_#tpe#"	
												href="../LeaveRequest/LeaveListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&leavetype=#tpe#&filter=#statuscode#&systemfunctionid=#url.systemfunctionid#"										
												target="right"
										        expand="No">			
																			
									</cfloop>
																									
							</cfoutput>													
									
				</cfif>
												
				<cf_verifyOperational module="Payroll" Warning="No">
				
				<cfif operational eq "1">
				
					<cf_tl id="Overtime records" var="ovt">
				
					  <cf_UItreeitem value="ovt"
				        display="<span style='font-size:18px;padding-top:8px;font-weight:bold;padding-bottom:5px' class='labelit'>#ovt#</span>"														
						parent="root"							
				        expand="Yes">				
																		
							<cfquery name="Trigger" 
								datasource="AppsPayroll" 	
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT    *
									FROM      Ref_PayrollTrigger
									WHERE     TriggerGroup = 'Overtime'							       		    
							</cfquery>	
																	
							<cfoutput query="Trigger">
							
							   <cf_UItreeitem value="#SalaryTrigger#"
							   display="<span style='font-size:16px;padding-top:3px;padding-bottom:3px' class='labelit'>#Description#</span>"
							   target="right"
							   href="../../Inquiry/Overtime/OvertimeListing.cfm?mission=#url.mission#&salaryTrigger=#SalaryTrigger#&systemfunctionid=#url.systemfunctionid#"				
							   parent="ovt"											
							   expand="No">		
																						
							</cfoutput>
				
				</cfif>									   
						
		</cf_UItree>	
		
		</td></tr>
		
</table>		

</cf_divscroll>
