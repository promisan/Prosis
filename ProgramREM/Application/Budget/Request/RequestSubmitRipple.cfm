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

	<cfset row = row + 1>
	
	<cfquery name="getRequest" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     *
			FROM       ProgramAllotmentRequest
			WHERE      RequirementId = '#requirementId#'				
	</cfquery>	
	
			
	<cfif getRequest.recordcount eq "1">
				
			<!---
				1. get valid ripples for this itemmaster, mission, toopicvaluecode  and having existing OE for this edition (usage) 
				2. Add records to the table and tag them as RequestType = 'ripple' and the parent is the same
				3. present the generated records as an expand and show them not as editing under the correct OE 						
			--->		
			
		
			<cfif row eq "1">	
																	
																									
					<cfquery name="RemoveRipplesNotAllotted" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE ProgramAllotmentDetailRequest
                        FROM   ProgramAllotmentDetailRequest DR
						WHERE  RequirementId IN (SELECT RequirementId 
						                         FROM   ProgramAllotmentRequest 
												 WHERE  RequirementIdParent = '#getRequest.RequirementIdParent#'
												 AND    EditionId           = '#getRequest.EditionId#'
												 AND    Period              = '#getRequest.Period#'
												 AND    RequestType         = 'Ripple')
						AND    TransactionId IN (SELECT TransactionId 
												 FROM   ProgramAllotmentDetail
												 WHERE  TransactionId = DR.Transactionid
												 AND    Status IN ('P','0')) 	
												 
												 				  															  	
					</cfquery>					
					
					<!--- if this line has been cleared for recreation --->
															
					<cfquery name="RemoveRippleMasterLines" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE ProgramAllotmentRequest
						FROM   ProgramAllotmentRequest R	
						WHERE  RequirementIdParent = '#getRequest.RequirementIdParent#'
						AND    EditionId    = '#getRequest.EditionId#'
					    AND    Period       = '#getRequest.Period#'	
						AND    RequestType  = 'Ripple'		
						AND    RequirementId NOT IN (SELECT RequirementId 
						                             FROM   ProgramAllotmentDetailRequest 
													 WHERE  RequirementId = R.RequirementId)				  
					</cfquery>		
					
					<cfquery name="RemoveRippleMasterLines" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE ProgramAllotmentRequest
						FROM   ProgramAllotmentRequest R	
						WHERE  RequirementIdParent NOT IN (SELECT RequirementIdParent FROM ProgramAllotmentRequest WHERE RequestType='Standard')
						AND    EditionId    = '#getRequest.EditionId#'
					    AND    Period       = '#getRequest.Period#'	
						AND    RequestType  = 'Ripple'											  
					</cfquery>		
					
			</cfif>		
			
			<!--- apply the defined ripples for this item master / mission / topic --->
			
			<cfoutput>
			<cfsavecontent variable="GetRipples">
			
				SELECT       R.Code, 
				             R.TopicValueCode, 
							 R.Mission, 
							 R.RippleItemMaster, 
							 R.RippleObjectCode, 							 
							 R.BudgetMode, 
							 R.BudgetAmount, 
							 R.BudgetMemo, 
							 R.Operational
				FROM         Purchase.dbo.ItemMasterRipple AS R INNER JOIN
	                             (SELECT       Code, TopicValueCode, Mission, RippleItemMaster, RippleObjectCode, MAX(DateEffective) AS Date
	                               FROM        Purchase.dbo.ItemMasterRipple
	                               WHERE       DateEffective < '#getRequest.RequestDue#' 
								   AND         Mission = '#Program.Mission#'
	                               GROUP BY Code, TopicValueCode, Mission, RippleItemMaster, RippleObjectCode) 
								   AS D  ON R.Code             = D.Code 
								        AND R.TopicValueCode   = D.TopicValueCode 
										AND R.Mission          = D.Mission 
										AND R.RippleItemMaster = D.RippleItemMaster 
										AND R.RippleObjectCode = D.RippleObjectCode 
										AND R.DateEffective    = D.Date
				WHERE        R.Operational = 1
			
			</cfsavecontent>
			</cfoutput>
				
			<cfquery name="getRipple" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     R.*
				FROM       (#preservesingleQuotes(getRipples)#) as R INNER JOIN Purchase.dbo.ItemMaster S ON R.RippleItemMaster = S.Code
				WHERE      R.Code = '#getRequest.ItemMaster#'
				<cfif getRequest.topicvalueCode neq "">
				AND        (TopicValueCode = '#getRequest.TopicValueCode#' or TopicValueCode = '')
				<cfelse>
				AND        TopicValueCode = ''
				</cfif> 
				AND        R.Mission       = '#Program.Mission#' 
				
				AND        R.RippleObjectCode IN
			                          (SELECT  Code
		          			           FROM    Program.dbo.Ref_Object
		                      		   WHERE   ObjectUsage = '#Object.ObjectUsage#')
											
				AND        R.Operational = 1	
				AND        S.Operational = 1								
			</cfquery>	
			
															
			<cfloop query="getRipple">	
								
					<cf_assignid>
					
					<!--- we check if we already have a ripple amount for this record which 
					was allotted --->
					
					<cfquery name="getRipple" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT ISNULL(SUM(RequestQuantity),0) as wasRippled, ISNULL(SUM(AmountBaseAllotment),0) as wasRippledAmount
						FROM   ProgramAllotmentRequest	
						WHERE  ProgramCode    = '#getRequest.ProgramCode#' 						
					    AND    Period         = '#getRequest.Period#'	
						AND    EditionId      = '#getRequest.EditionId#'
						AND    Fund           = '#getRequest.Fund#'
						AND    TopicValueCode = '#getRequest.TopicValueCode#'	
						AND    ActionStatus   = '1'
						AND    RequestType    = 'Ripple'		
						AND    ObjectCode     = '#RippleObjectCode#'
						AND    ItemMaster     = '#RippleItemMaster#'		
												  
						AND    RequirementIdParent = '#getRequest.RequirementIdParent#'
					</cfquery>		
															
					<cfif budgetMode eq "1">
					
					       <cfset quantity = "1">							   
						 		   
						   <cfset price = BudgetAmount - getRipple.wasRippledAmount>
						   <cfset diff  = BudgetAmount - getRipple.wasRippledAmount>
														   
						   <!--- we remove any possible quantities here in the underlying records --->	
						   						   
						   <cfquery name="cleanperiod" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								DELETE FROM ProgramAllotmentRequestQuantity
								WHERE  RequirementId IN (SELECT RequirementId
														FROM   ProgramAllotmentRequest	
														WHERE  ProgramCode         = '#getRequest.ProgramCode#' 						
													    AND    Period              = '#getRequest.Period#'	
														AND    EditionId           = '#getRequest.EditionId#'
														AND    Fund                = '#getRequest.Fund#'
														AND    RequirementIdParent = '#getRequest.RequirementIdParent#'
														AND    TopicValueCode      = '#getRequest.TopicValueCode#'	
														AND    ActionStatus        = '1'
														AND    RequestType         = 'Ripple'		
														AND    ObjectCode          = '#RippleObjectCode#'
														AND    ItemMaster          = '#RippleItemMaster#')													  
							</cfquery>	 					   					   
						   						   
					<cfelseif budgetMode eq "2" and getRequest.ResourceQuantity neq "">					       
					       <cfset quantity = getRequest.ResourceQuantity>		
						   <cfset price    = BudgetAmount>
						   <cfset diff     = quantity - getRipple.wasRippled>		
																		   				    
					<cfelse>  <!--- requirement quantity --->
					 	   <cfset quantity = getRequest.RequestQuantity>
						   <cfset price    = BudgetAmount>
						   <cfset diff     = quantity - getRipple.wasRippled>	
					</cfif>	   						
										
					<cfif diff neq "0">
										
						<cfquery name="Insert" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						INSERT INTO ProgramAllotmentRequest
						         (ProgramCode,			 
								 Period,
								 EditionId,
								 RequirementId,
								 ObjectCode,
								 Fund,
								 ActivityId,
								 ItemMaster,	
								 RequestType,
								 <cfif getRequest.BudgetCategory neq "">
								 BudgetCategory,				 		
								 </cfif>					 
								 ResourceUnit,					 								 						
								 RequestLocationCode,																 
								 TopicValueCode,	
								 <cfif getRequest.RequestDue neq "">													 
								 	RequestDue,
								 </cfif>
								 ResourceQuantity,									 
								 RequestQuantity,					 										 
								 RequestPrice,
								 RequestDescription,
								 RequirementIdParent,
								 ActionStatus,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						  VALUES ('#getRequest.ProgramCode#',	  
						  	      '#getRequest.Period#',    
								  '#getRequest.EditionId#',
								  '#rowguid#',
								  '#RippleObjectCode#',
								  '#getRequest.Fund#',
								  '#getRequest.ActivityId#',
								  '#RippleItemMaster#',	
								  'Ripple',
								  <cfif getRequest.BudgetCategory neq "">
								  '#getRequest.BudgetCategory#',
								  </cfif>
								  '#getRequest.ResourceUnit#',		
								  '#getRequest.RequestLocationCode#',						  				  
							      '#getRequest.TopicValueCode#',	
								  <cfif getRequest.RequestDue neq "">						  				 		  
								  	'#getRequest.RequestDue#',
								  </cfif>
								  '#quantity#', 
								  '#quantity#',							  				 
								  '#round(Price)#',	<!--- this is the price attention the ripples are default to one currency --->				  
								  '#BudgetMemo#',   
								  '#getRequest.requirementIdParent#',
								  '#st#',				
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#')
						</cfquery>
	
					   <cfif budgetMode eq "2" or budgetMode eq "3">
					   
							<!---- now we populate ProgramAllotmentRequestQuantity Armin -- 5/28/2014 ---->
							
							 <cfquery name="InsertQuantities" 
								  datasource="AppsProgram" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  INSERT INTO ProgramAllotmentRequestQuantity
								 		 (RequirementId,
										  AuditId, 
										  RequestQuantity,
										  ResourceQuantity,
										  ResourceDays,
										  Remarks,
										  OfficerUserId,
										  OfficerLastName,
										  OfficerFirstName)
								  SELECT  '#rowguid#', 
								          AuditId, 
										  RequestQuantity,
										  ResourceQuantity,
										  ResourceDays,
										  Remarks,
										  '#session.acc#',
										  '#session.last#',
										  '#session.first#'
								  FROM    ProgramAllotmentRequestQuantity
								  WHERE   RequirementId = '#requirementId#'
							 </cfquery>	 	
							 
							 <cfquery name="UpdateRequest" 
								  datasource="AppsProgram" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  UPDATE ProgramAllotmentRequest
								  SET RequestDue = (
									  SELECT TOP 1 A.AuditDate 
									  	FROM  ProgramAllotmentRequestQuantity RQ INNER JOIN Ref_Audit A ON A.AuditId = RQ.AuditId
										WHERE RQ.RequirementId = R.RequirementId
										ORDER BY A.AuditDate ASC
									)
								  FROM  ProgramAllotmentRequest R
								  WHERE R.RequirementId = '#rowguid#'
							 </cfquery>		
							 
						</cfif>	 	
						
						<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
						   method           = "LogRequirement" 
						   RequirementId    = "#rowguid#">													 
							 					
				   </cfif>						
											
					<!--- now we check if we change the amount to be released for allotment should change --->
					
					<cfquery name="get" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM   ProgramAllotmentRequest
						WHERE  RequirementId = '#RequirementId#'	
					</cfquery>
					
					<cfif get.AmountBaseAllotment neq get.RequestAmountBase>
					
						<cfquery name="get" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  UPDATE ProgramAllotmentRequest
						  SET    AmountBaseAllotment = '#get.RequestAmountBase#'
						  WHERE  RequirementId = '#RequirementId#'	
						</cfquery>						
										
					</cfif>		
					
					<cfparam name="Form.ObjectCode" default="">									
					
					<cfif form.ObjectCode neq "">
					
						<cfoutput>									   
						
							<script language="JavaScript">	
							   try {		
								parent.ptoken.navigate('ObjectSelect.cfm?objectcode=#RippleObjectCode#&prior=#Form.ObjectCode#','selected')
								} catch(e) {}
							</script>
							
						</cfoutput>
					
					</cfif>
							
			</cfloop>	
			
	</cfif>	
