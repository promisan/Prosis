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

<!--- delete request quantity --->

<!--- recalculate requirement --->

<cfquery name="Header" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					UPDATE    ProgramAllotmentRequest
					SET       ResourceQuantity =
			                          (SELECT     SUM(ResourceQuantity)
			                            FROM      ProgramAllotmentRequestQuantity
			                            WHERE     RequirementId = '#requirementId#'),
							  ResourceDays =
			                          (SELECT     SUM(ResourceDays)
			                            FROM      ProgramAllotmentRequestQuantity
			                            WHERE     RequirementId = '#requirementId#'),
							  RequestQuantity =
			                          (SELECT     ISNULL(SUM(RequestQuantity),0)
			                            FROM      ProgramAllotmentRequestQuantity
			                            WHERE     RequirementId = '#requirementId#'),		
							  RequestDue = 	
								  	 (SELECT      MIN(AuditDate)
									    FROM      ProgramAllotmentRequestQuantity Q, Ref_Audit R
										WHERE     Q.AuditId = R.AuditId
			                            AND       RequirementId = '#requirementId#')							  		
														
					WHERE     RequirementId = '#requirementId#'
			</cfquery>		
			
			<!--- correcion 30/10/2014 if resource quantity = NULL, we a pply a ceiling / 12 --->
					
			<cfquery name="Header" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					UPDATE    ProgramAllotmentRequest
					SET       ResourceQuantity = CEILING(RequestQuantity/12)													
					WHERE     RequirementId = '#requirementId#'
					AND       ResourceQuantity is NULL
			</cfquery>											
			
			<!--- now we check oif we change the amount to be released for allotment should change --->
					
			<cfquery name="get" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
					FROM   ProgramAllotmentRequest
					WHERE  RequirementId = '#RequirementId#'	
			</cfquery>													
						   
			<cfif get.AmountBaseAllotment neq get.RequestAmountBase>				
					
				<cfquery name="set" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE ProgramAllotmentRequest
					SET    AmountBaseAllotment = '#get.RequestAmountBase#'
					WHERE  RequirementId = '#RequirementId#'	
				</cfquery>
					
			</cfif>					
			
			<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
					   method           = "LogRequirement" 
					   RequirementId    = "#url.RequirementId#">			