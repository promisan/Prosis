
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
   
  <tr><td valign="top" style="padding-left:20px">
  
    <cfform>
	
	    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="left">
				  
		  <tr><td style="font-size:19px;height:40px;font-weight:200" class="labelmedium"><cf_tl id="Office attendance"></td></tr>	
	 	
		  <tr>
	        <td valign="top"> 
											
			    <cf_tl id="#url.mission#" var="1">	
									
				<cftree name="idtree" fontsize="12" bold="No" format="html" required="No">
				
	 		     <cftreeitem 
				  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#mandate.mandateno#','OrganizationListing.cfm','ATT','#lt_text#')">  		 
									  
			    </cftree>	
				
				</td>
				
			</tr>
			
			<cfif accessextended eq "GRANTED">
			
			    <cf_verifyOperational module="ePas" Warning="No">
				
				<cfif operational eq "1">
					
				 <tr><td height="8"></td></tr>
				  <tr><td style="font-size:19px;height:40px;font-weight:200" class="labelmedium"><cf_tl id="Performance Appraisal"></td></tr>	
				  		 <tr><td>	  				
					
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
									
							<cftree name="idPAS" fontsize="12" bold="No" format="html" required="No">
																			
								<cfoutput query="Period">
										
									<cftreeitem value="#currentrow#"
								        display="<span style='padding-top:3px;padding-bottom:3px;color: 6688aa;' class='labelmedium'>#Code#</span>"	
										href="../Appraisal/PASListing.cfm?mission=#url.mission#&period=#code#&filter=active"		
										target="right"		
										parent="idPAS"																											
								        expand="No">	
																			
								</cfoutput>	
							
							</cftree>	
						
						</cfif>
					
					
					</td>
					</tr>
					
					</cfif>
				
               </cfif>
			   
			   <cfif accessextended eq "GRANTED">
							
			     <tr><td height="8"></td></tr>
			     <tr><td style="font-size:19px;height:40px;font-weight:200" class="labelmedium">Home Address Zones</td></tr>	
			  			  			  
				     <tr><td>
				  																								
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
					
						<cftree name="idwarden" fontsize="12" bold="No" format="html" required="No">
																
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
							
								<cftreeitem value="#Code#"
							        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>#Description#</span>"
									parent="idwarden"														
							        expand="No">	
									
									<cfloop query="AddressType">								
															
										<cftreeitem value="#zone.code#_#addresstype#"
									        display="<span style='padding-top:3px;padding-bottom:3px;color: 6688aa;' class='labelit'>#Description#</span>"
											parent="#zone.code#"	
											target="right"
											href="../Address/AddressListing.cfm?mission=#url.mission#&zone=#zone.code#&addresstype=#addresstype#&filter=active"													
									        expand="No">									
																			
											<cftreeitem value="#zone.code#_#addresstype#_map"
										        display="&nbsp;Map"
												parent="#zone.code#_#addresstype#"	
												target="right"
												img="#SESSION.root#/images/map.png"
												href="../Address/AddressListingMAP.cfm?mission=#url.mission#&zone=#zone.code#&addresstype=#addresstype#&filter=active"													
										        expand="No">	
												
											<cftreeitem value="#zone.code#_#addresstype#_lis"
										        display="List"
												parent="#zone.code#_#addresstype#"	
												target="right"												
												href="../Address/AddressListing.cfm?mission=#url.mission#&zone=#zone.code#&addresstype=#addresstype#&filter=active"													
										        expand="No">				
									
									</cfloop>
							
							</cfoutput>	
															
						</cftree>	
					
					</cfif>
					
					</td></tr>		
					
				</cfif>	
				
				<tr><td height="8"></td></tr>
			    <tr><td style="font-size:19px;height:40px;font-weight:200" class="labelmedium"><cf_tl id="Leave records"></td></tr>	 
				
				<tr><td>
				
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
				
				      <cftree name="idleave" fontsize="12" bold="No" format="html" required="No">	
					  
					  		<cftreeitem value="all"
							        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>All records</span>"											
									target="right"																				
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
																
									<cftreeitem value="all_#statuscode#"		
									parent="all"								
							        display="<span style='padding-top:3px;padding-bottom:3px;color:#cl#' class='labelmedium'>#description#</span>"	
									href="../LeaveRequest/LeaveListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&leavetype=&filter=#statuscode#"		
									target="right"																				
							        expand="No">	
								
								</cfloop>	
								
							<cftreeitem value="ltpe"
							        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>Type of leave</span>"											
									target="right"																				
							        expand="No">							
																	
							<cfoutput query="LeaveType">
							
								
								<cftreeitem value="#LeaveType#"
							        display="<span style='padding-top:3px;padding-bottom:3px;color: 002350' class='labelmedium'>#Description#</span>"	
									href="../LeaveRequest/LeaveListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&leavetype=#leavetype#&filter=active"		
									target="right"	
									parent="ltpe"																				
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
																	
										<cftreeitem value="#tpe#_#statuscode#"
										parent="#tpe#"	
								        display="<span style='padding-top:3px;padding-bottom:3px;color: #cl#;' class='labelmedium'>#description#</span>"	
										href="../LeaveRequest/LeaveListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&leavetype=#tpe#&filter=#statuscode#"		
										target="right"																				
								        expand="No">	
									
									</cfloop>
																									
							</cfoutput>	
													
					</cftree>	
				
				</cfif>
				
				</td>
				</tr>
				
				<cf_verifyOperational module="Payroll" Warning="No">
				
				<cfif operational eq "1">
				
					<tr><td height="8"></td></tr>
				    <tr><td style="font-size:19px;height:40px;font-weight:200" class="labelmedium"><cf_tl id="Overtime records"></td></tr>	 
									
					<tr><td>
										
						<cftree name="idovertime" fontsize="12" bold="No" format="html" required="No">
														
									<cfquery name="Trigger" 
										datasource="AppsPayroll" 	
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT    *
											FROM      Ref_PayrollTrigger
											WHERE     TriggerGroup = 'Overtime'							       		    
									</cfquery>	
																			
									<cfoutput query="Trigger">
									
										<cftreeitem value="#SalaryTrigger#"
									        display="<span style='padding-top:3px;padding-bottom:3px;color: 6688aa;' class='labelmedium'>#Description#</span>"
											target="right"
											href="../../Inquiry/Overtime/OvertimeListing.cfm?mission=#url.mission#&salaryTrigger=#SalaryTrigger#"																							
									        expand="No">										
																			
									</cfoutput>	
															
						</cftree>	
						
						</td>
					</tr>
				
				</cfif>
									   
							   
	    </table></td>
	
	</cfform>
	
  </tr>
  
</table>

</cf_divscroll>
