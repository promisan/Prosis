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
<!---  Name: /Component/Process/CarryOver.cfc
       Description: Program procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "ProgramRoutine for CarryOver">
	
	<cffunction name="ProgramEditionCarryOver"
             access="public"
             returntype="any"			 
             displayname="Validate">
			 
		<!--- validates if the amount allocated for a project is enough to clear a transaction --->
			 
		<cfargument name="ProgramCode"         type="string" required="true"   default="">
		
		<!--- this is the execution period which moves back to the correct planperiod + edition to compare with --->
		<cfargument name="FromPeriod"          type="string"  required="true"  default="">
		<cfargument name="FromEdition"         type="string"  required="true"  default="">
		<cfargument name="ToPeriod"            type="string"  required="true"  default="">
		<cfargument name="ToEdition"           type="string"  required="true"  default="">
		<cfargument name="BudgetEntryMode"	   type="string"  required="false" default="1">
		<cfargument name="Funding"	   		   type="string"  required="false" default="">
			

		<!--- ToPeriod is URL.PeriodCurrent--->

					<cfif FromEdition neq "" and ToEdition neq "">

					  <cfquery name="Budget" 
						 datasource="AppsProgram" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#"> 
							  INSERT INTO ProgramAllotment
									   (ProgramCode,
										Period,				 
										EditionId,
										Description,
										Fund,
										FundEnforce,
      									SupportPercentage,
								        SupportObjectCode,
      									ModeMappingTransaction,
      								    LockEntry,
      									AmountRounding, 
      									TransactionSerialNo,
										Status,					 
										OfficerUserId,
										OfficerLastName,
										OfficerFirstName)
							  SELECT  ProgramCode,
							          '#ToPeriod#',
									  '#ToEdition#',
									   Description,
									   Fund,
									   FundEnforce,
									   SupportPercentage,
								       SupportObjectCode,
      								   ModeMappingTransaction,
      								   LockEntry,
      								   AmountRounding, 
      								   TransactionSerialNo,									   
									   '0',						 
									   '#SESSION.acc#',
									   '#SESSION.last#',
									   '#SESSION.first#'
							  FROM    ProgramAllotment
							  WHERE   Period      = '#FromPeriod#'	
							  AND     EditionId   = #FromEdition#				
							  AND     ProgramCode = '#ProgramCode#'				
					 </cfquery>					 

					<cfquery name="InsertHeaderCeiling" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    INSERT INTO ProgramAllotmentCeiling
						(ProgramCode,
						 Period,
						 EditionId,
						 Resource,
						 Currency,
						 Amount,					
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
					SELECT     ProgramCode,
					           '#ToPeriod#',
					           '#ToEdition#',
					           Resource,
							   Currency,
							   Amount,						 
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName
					FROM       ProgramAllotmentCeiling
					WHERE      EditionId   = '#FromEdition#' 
					AND        Period      = '#FromPeriod#'
					AND        ProgramCode = '#ProgramCode#'
				    </cfquery>				 
					 
					 <cfquery name="Budget2" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 
					 	INSERT INTO ProgramAllotmentDetail
							     (ProgramCode, 
								  Period, 
								  EditionId, 
								  TransactionDate, 
								  Currency, 
								  Amount, 
								  ExchangeRate, 
							      AmountBase, 
								  ObjectCode, 
								  OrgUnit,
								  Remarks,
								  Fund, 
								  TransactionIdSource,
								  Status,
           						  TransactionType,
								  OfficerUserId, 
								  OfficerLastName, 
								  OfficerFirstName)
						SELECT    ProgramCode, 
						          '#ToPeriod#', 
								  '#ToEdition#', 
								  getDate(), 
								  Currency, 
								  Amount, 
								  ExchangeRate, 
			            		  AmountBase, 
								  ObjectCode,
								  OrgUnit,
								  Remarks,
								  Fund, 
								  TransactionId,
								  '0', 
           						  TransactionType,
								  '#SESSION.acc#',
								  '#SESSION.last#', 
								  '#SESSION.first#'
						FROM      ProgramAllotmentDetail D
						WHERE     ProgramCode = '#ProgramCode#'
						AND       Period      = '#FromPeriod#' <!--- prior planning period --->		
						AND       EditionId   = #FromEdition#		       
						AND       (
						          ActionId IN (SELECT ActionId 
						                       FROM   ProgramAllotmentAction 
											   WHERE  ActionClass = 'Transaction'
											   AND    ActionId = D.ActionId)
								  OR ActionId IS NULL
								  )
								  
								 <cfif Funding neq "">
								 	 AND Fund IN (#preservesinglequotes(funding)#)
									
								 </cfif>	 
								  AND Fund IN (SELECT Fund FROM Ref_AllotmentEditionFund WHERE EditionId = '#ToEdition#') 	

					 </cfquery>		
						 
				<cfif  BudgetEntryMode neq 0>
					 <!--- carry over the requirement definition if they exist of course for the period --->
					 
					 <!--- --------------------------------------- --->				
					 <!--- ----------transfer requirements-------- --->
					 <!--- --------------------------------------- --->							
							<cfquery name="InsertLine" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    INSERT INTO ProgramAllotmentRequest
									( ProgramCode, 
									  Period,
									  EditionId, 						  						 					 
									  ObjectCode, 
									  Fund,
									  ActivityId,
									  RequestType,
									  ItemMaster,
									  TopicValueCode,
									  RequestDescription,
									  RequestRemarks,
									  RequestDue,
									  ResourceUnit,
									  ResourceQuantity,
									  ResourceDays,
									  RequestQuantity,
									  RequestPrice,
									  Source,
									  SourceId,
									  ActionStatus,
								      BudgetCategory,
								      RequestLumpsum,
								      AmountBaseAllotment,
								      ActionStatusDate,
								      ActionStatusOfficer,
								      RequirementIdParent,
								      RequirementSerialNo,									  
									  OfficerUserId, 
									  OfficerLastName, 
				                      OfficerFirstName)
							SELECT     ProgramCode,
							           '#ToPeriod#',
							           '#ToEdition#',					          
								       ObjectCode, 
								       Fund, 
									   ActivityId,
									   RequestType,
									   ItemMaster,
									   TopicValueCode,
								       RequestDescription,
									   RequestRemarks,
								       RequestDue,
								       ResourceUnit,
								       ResourceQuantity,
								       ResourceDays,
								       RequestQuantity,
								       RequestPrice,
								       'Prior',
								       RequirementId,
									   ActionStatus,
								       BudgetCategory,
								       RequestLumpsum,
								       AmountBaseAllotment,
								       ActionStatusDate,
								       ActionStatusOfficer,
								       RequirementIdParent,
								       RequirementSerialNo,									  
									   OfficerUserId,
									   OfficerLastName,
									   OfficerFirstName
							FROM       ProgramAllotmentRequest
							WHERE      ProgramCode   = '#ProgramCode#'	
							AND        Period        = '#FromPeriod#' <!--- prior planning period --->			 
						    AND        EditionId     = #FromEdition#
						    AND        ActionStatus != '9'		
							<cfif Funding neq "">
								 AND  Fund IN (#preservesinglequotes(funding)#)
								 
							</cfif>	  	
							 AND Fund IN (SELECT Fund FROM Ref_AllotmentEditionFund WHERE EditionId = '#ToEdition#')
										   	 				
						    </cfquery> 
							
							<!--- --------------------------------------- --->
							<!--- transfer the requirement/detail mapping --->
							<!--- --------------------------------------- --->
																
							<cfquery name="InsertMapping" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    INSERT INTO ProgramAllotmentDetailRequest
										 (TransactionId,
										  RequirementId,
										  Amount)
								SELECT    C.TransactionId, <!--- new lines --->
								          B.RequirementId,
								          A.Amount						         
								FROM      ProgramAllotmentDetailRequest A, <!--- old source lines --->
								          ProgramAllotmentRequest B, <!--- new request --->
										  ProgramAllotmentDetail C <!--- new lines --->
								WHERE     A.RequirementId = B.SourceId
								AND       A.TransactionId = C.TransactionIdSource
								AND       B.Period        = '#ToPeriod#' 
							    AND       B.ProgramCode   = '#ProgramCode#'	
								AND       B.EditionId     = #ToEdition#				   										
						    </cfquery> 	
							
							<!--- --------------------------------------- --->														
							<!--- -------transfer quantity details------- --->
							<!--- --------------------------------------- --->
							
							<cfquery name="InsertQuantity" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    INSERT INTO ProgramAllotmentRequestQuantity
										 (RequirementId, 
										  AuditId,
										  ResourceQuantity,
										  ResourceDays, 						  						 					 
										  RequestQuantity, 
										  Remarks)
								SELECT    B.RequirementId,
								          A.AuditId,
								          A.ResourceQuantity,
									 	  A.ResourceDays, 						  						 					 
									      A.RequestQuantity, 
									      A.Remarks
								FROM      ProgramAllotmentRequestQuantity A,
								          ProgramAllotmentRequest B
								WHERE     A.RequirementId = B.SourceId
								AND       B.Period        = '#ToPeriod#' 
							    AND       B.ProgramCode   = '#ProgramCode#'	
								AND       B.EditionId     = #ToEdition#											
						    </cfquery> 
							

							<cfquery name="InsertQuantityPrice" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
									INSERT INTO ProgramAllotmentRequestPrice
									           (RequirementId
									           ,CostElement
									           ,CostOrder
									           ,Calculation
									           ,CalculationQuantity
									           ,CalculationBase
									           ,CostElementAmount
									           ,CostMemo
									           ,OfficerUserId
									           ,OfficerLastName
									           ,OfficerFirstName)
										SELECT    B.RequirementId,
										          A.CostElement,
										          A.CostOrder,
											 	  A.Calculation, 						  						 					 
											      A.CalculationQuantity, 
									              A.CalculationBase,
									              A.CostElementAmount,
									           	  A.CostMemo,
									              A.OfficerUserId,
									              A.OfficerLastName,
									              A.OfficerFirstName
										FROM      ProgramAllotmentRequestPrice A,
										          ProgramAllotmentRequest B
										WHERE     A.RequirementId = B.SourceId
										AND       B.Period        = '#ToPeriod#' 
									    AND       B.ProgramCode   = '#ProgramCode#'	
										AND       B.EditionId     = #ToEdition#								           
						    </cfquery> 


							<!--- --------------------------------------- --->
							<!--- attention we have an issue possible here as 
							the period auditid does not match --->
							<!--- --------------------------------------- --->
						

							
							
							<!--- -------added-20/1/2013----------------- --->														
							<!--- -------transfer rate details----------- --->
							<!--- --------------------------------------- --->
							
							
							
							
							<!--- --------------------------------------- --->					
							<!--- -------------transfer topic------------ --->
							<!--- --------------------------------------- --->

							<cfquery name="InsertTopic" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    INSERT INTO ProgramAllotmentRequestTopic
										 (RequirementId, 
										  Topic,
										  ListCode, 						  						 					 
										  TopicValue,
										  OfficerUserId,
									      OfficerLastName,
									      OfficerFirstName)
								SELECT    B.RequirementId,
								          A.Topic,
										  A.ListCode, 						  						 					 
										  A.TopicValue,
										  A.OfficerUserId,
									      A.OfficerLastName,
									      A.OfficerFirstName
								FROM      ProgramAllotmentRequestTopic A,
								          ProgramAllotmentRequest B
								WHERE     A.RequirementId = B.SourceId
								AND       B.Period = '#ToPeriod#' 
							    AND       B.ProgramCode = '#ProgramCode#'	
								AND       B.EditionId = #ToEdition#													
						    </cfquery> 
							
						</cfif>	

					</cfif>

								 
	</cffunction>	
	  		
</cfcomponent>	 