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

<!---  Name: /Component/Process/Program.cfc
       Description: Program procedures      
---> 

<cfcomponent>    

    <cfproperty name="name" type="string">
    <cfset this.name = "ProgramRoutine for Support cost and contribution allocation">
		
	<cffunction name="RequirementSnapshot"
             access="public"
             returntype="any"			 
             displayname="Take a program snapshot">
			
			<cfargument name="ReviewId"     type="string"  required="false"   default=""> 	
			<cfargument name="ProgramCode"  type="string"  required="false"  default=""> 		
			<cfargument name="Period"       type="string"  required="false"  default=""> 				
			<cfargument name="Editionid"    type="string"  required="false"  default=""> 
			<cfargument name="Fund"         type="string"  required="false"  default="">
			
			<cfif reviewId neq "">
			
				<cfquery name="get" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					SELECT * FROM ProgramPeriodReview WHERE ReviewId = '#reviewid#'
				</cfquery>	
			
				<cfset ProgramCode = get.ProgramCode>
				<cfset Period      = get.Period>
			
			</cfif>
						
				<cfquery name="Snapshot" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				
					INSERT INTO ProgramAllotmentRequestSnapshot
					
							(ReviewId,
							 SnapshotDate,
							 RequirementId, 
							 ProgramCode, 
							 Period, 
							 EditionId, 
							 ObjectCode, 
							 Fund, 
							 BudgetCategory,
							 ActivityId,
							 ItemMaster, 
							 TopicValueCode, 
							 RequestType,
							 RequestDescription, 
							 RequestDue, 
							 RequestLocationCode,
				             ResourceUnit, 
							 ResourceQuantity, 
							 ResourceDays, 
							 RequestQuantity, 
							 RequestPrice, 
							 AmountBaseAllotment,
							 RequestRemarks, 
							 ActionStatus, 
							 Source, 
				             SourceId, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName, 
							 Created)
							 
					SELECT   '#reviewid#',
					         getDate(), 
					         RequirementId, 
							 ProgramCode, 
							 Period, 
							 EditionId, 
							 ObjectCode, 
							 Fund, 
							 BudgetCategory,
							 ActivityId,
							 ItemMaster, 
							 TopicValueCode, 
							 RequestType,
							 RequestDescription, 
							 RequestDue, 
							 RequestLocationCode,
				             ResourceUnit, 
							 ResourceQuantity, 
							 ResourceDays, 
							 RequestQuantity, 
							 RequestPrice, 		
							 AmountBaseAllotment,				
							 RequestRemarks, 
							 ActionStatus, 
							 Source, 
				             SourceId, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName, 
							 Created
							 
					FROM     ProgramAllotmentRequest
					
					WHERE    1=1
					<cfif ProgramCode neq "">
					AND      ProgramCode = '#ProgramCode#'
					AND      Period      = '#Period#'
					</cfif>
					<cfif EditionId neq "">
					AND      EditionId   = '#EditionId#'
					</cfif>
					<cfif Fund neq "">
					AND      Fund        = '#Fund#'
					</cfif>
					
				</cfquery>				
			 
	</cffunction>		
	
	<cffunction name="logRequirement"
             access="public"
             returntype="any"			 
             displayname="LogRequirement">
			 
			 <!--- makes a snapshot of the requirement after it has been saved/updated  --->
			
			<cfargument name="RequirementId"  type="string"  required="true"  default=""> 		
			<cfargument name="ReviewId"       type="string"  required="false"  default="">					
			
			<cfquery name="get" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * FROM ProgramAllotmentRequest				 
					WHERE  RequirementId = '#requirementid#'	
			</cfquery>
			
			<cfquery name="last" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT MAX(serialNo) as Last
					FROM   ProgramAllotmentRequestLog				 
					WHERE  RequirementId = '#requirementid#'	
			</cfquery>
			
			<cfif last.last eq "">
			    <cfset ser = 1>
			<cfelse>
				<cfset ser = Last.Last+1>
			</cfif>
			
			<cfquery name="log" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ProgramAllotmentRequestLog
					
					(RequirementId, 
					 SerialNo, 
					 ReviewId, 
					 ActionStatus, 
					 RequestAmountBase, 
					 AmountBaseAllotment, 
					 OfficerUserId, 
					 OfficerLastName,
					 OfficerFirstName)
					
					VALUES (
						 '#requirementid#',
						 '#ser#',
						 <cfif ReviewId neq "">
						 	'#ReviewId#',
						 <cfelse>
							 NULL,
						 </cfif>
						 '#get.actionstatus#',
						 '#get.RequestAmountBase#',
						 '#get.AmountBaseAllotment#',
						 '#session.acc#',
						 '#session.last#',
						 '#session.first#'
					 )		
			</cfquery>
		 
	</cffunction> 
	
	<cffunction name="RequirementAdjusted"
             access="public"
             returntype="any"			 
             displayname="Generate Requuirements per quarters">
			
			<cfargument name="Mission"      type="string"  required="true"  default=""> 	 
			<cfargument name="Period"       type="string"  required="true"  default=""> 		
			<cfargument name="Editionid"    type="string"  required="true"  default=""> 
			<cfargument name="Fund"         type="string"  required="true"  default=""> 
			<cfargument name="ProgramCode"  type="string"  required="true"  default=""> 
			<cfargument name="ActionStatus" type="string"  required="true"  default="'0','1'">
			<cfargument name="Support"      type="string"  required="true"  default="No"> <!--- include the support costs percentage to the amounts --->
			<cfargument name="Mode"         type="string"  required="true"  default="Table">
			<cfargument name="Table"        type="string"  required="false" default="#SESSION.acc#Requirement">
			
			<cfif mission eq "">
			
				<cfquery name="Program" 
					datasource="AppsProgram">
				    SELECT P.*, O.Mission as UnitMission
					FROM   Program P
							INNER JOIN ProgramPeriod PP
								ON P.ProgramCode = PP.ProgramCode
							INNER JOIN Organization.dbo.Organization O
								ON PP.OrgUnit = O.OrgUnit
					WHERE  PP.ProgramCode = '#ProgramCode#' 
					AND    PP.Period = '#Period#'
				</cfquery>	
												
				<cfset Mission = Program.UnitMission>
			
			</cfif>
									
			<cfquery name="getDate" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT * FROM ref_Period WHERE Period = '#period#'
			</cfquery>	
			
			<cfif mode eq "Table">
				<CF_DropTable dbName="AppsQuery" tblName="#table#">
			</cfif>	
			
			<cfoutput>
			
			<cfsavecontent variable="baseQuery">
			
						SELECT       PAR.RequirementId, 
				                     PAR.ProgramCode, 
									 PAR.ActivityId,
									 OO.Mission,
						             P.ProgramClass,
									 Pe.PeriodHierarchy as ProgramHierarchy,
									 PAR.Period, 
									 PAR.EditionId, 
									 O.Resource, 
									 PAR.ObjectCode, 
									 
									 (SELECT     TOP 1 ObjectCode
		                              FROM       ProgramAllotmentRequest
			                          WHERE      RequirementIdParent = PAR.RequirementIdParent AND RequestType = 'Standard') as ObjectCodeParent,
									 									 
									 PAR.Fund, 
									 PAR.ItemMaster, 
									 R.AuditDate AS RequestDue, 
				                     PARQ.RequestQuantity, 
									 
									 <!--- generate the adjusted value for that quantity/month --->
									 
									 PARQ.RequestQuantity /
				                                           (SELECT  SUM(RequestQuantity) 
				                                            FROM    ProgramAllotmentRequestQuantity
				                                            WHERE   RequirementId = PAR.RequirementId) * PAR.RequestAmountBase AS RequestAmountBase, 
														
									 PAR.RequirementIdParent,
									 CONVERT(varchar,RequestRemarks) as RequestRemarks,
									 ActionStatus,
									 RequestType,
									 RequestDescription,
									 O.SupportEnable,
									 PAR.OfficerUserId,	
									 PAR.OfficerFirstName,	
									 PAR.OfficerLastName,						
									 PAR.Created
									 
				           FROM      ProgramAllotmentRequestQuantity AS PARQ INNER JOIN
				                     Ref_Audit AS R ON PARQ.AuditId = R.AuditId INNER JOIN
				                     ProgramAllotmentRequest AS PAR ON PARQ.RequirementId = PAR.RequirementId INNER JOIN
				                     Ref_Object AS O ON PAR.ObjectCode = O.Code INNER JOIN 
									 Program P ON PAR.ProgramCode = P.ProgramCode INNER JOIN 
									 ProgramPeriod Pe ON PAR.ProgramCode = Pe.ProgramCode AND PAR.Period = Pe.Period INNER JOIN 
									 Organization.dbo.Organization OO ON Pe.OrgUnit = OO.OrgUnit
									 
				           WHERE     1=1
						   <cfif ProgramCode neq "">
						   AND       PAR.ProgramCode  = '#programcode#'
						   <cfelse>
						   AND       PAR.ProgramCode IN (
						   								 SELECT PPx.ProgramCode
						                                 FROM   ProgramPeriod PPx INNER JOIN Organization.dbo.Organization Ox ON PPx.OrgUnit = Ox.OrgUnit
														 WHERE  PPx.ProgramCode = PAR.ProgramCode 
														 AND	PPx.Period = '#period#'
														 AND    Ox.Mission = '#mission#'
						   								) 
						   </cfif>						  
						   AND       PAR.Period       = '#period#'			
						   <cfif EditionId neq "">  
						   AND       PAR.EditionId    = '#editionid#'		  
						   </cfif>
						   <cfif Fund neq "">  
						   AND       PAR.Fund         = '#Fund#'		  
						   </cfif>
						   AND       PARQ.RequestQuantity <> 0
						   AND       PAR.ActionStatus IN (#preservesingleQuotes(ActionStatus)#)
						   		   
				           UNION ALL		   
						   		   
				           SELECT    RequirementId, 
						             P.ProgramCode, 
									 PARQ.ActivityId,
									 OO.Mission,
						             P.ProgramClass,
									 Pe.PeriodHierarchy as ProgramHierarchy,
									 PARQ.Period, 
									 EditionId, 
									 O.Resource, 
									 ObjectCode, 
									 
									  (SELECT  TOP 1 ObjectCode
		                               FROM    ProgramAllotmentRequest
			                           WHERE   RequirementIdParent = PARQ.RequirementIdParent AND RequestType = 'Standard') as ObjectCodeParent,
									 
									 
									 Fund, 
									 ItemMaster, 
									 ISNULL(RequestDue,'#dateformat(getDate.DateEffective,'YYYY-MM-DD')#') as RequestDue, 
									 RequestQuantity, 
									 RequestAmountBase, 
				                     RequirementIdParent,
									 CONVERT(varchar,RequestRemarks) as RequestRemarks,
									 ActionStatus,
									 RequestType,
									 RequestDescription,
									 O.SupportEnable,
									 PARQ.OfficerUserId,	
									 PARQ.OfficerFirstName,	
									 PARQ.OfficerLastName,						 
									 PARQ.Created
									 
				           FROM      ProgramAllotmentRequest AS PARQ 
						             INNER JOIN Ref_Object AS O ON PARQ.ObjectCode = O.Code 
									 INNER JOIN Program P ON PARQ.ProgramCode = P.ProgramCode
									 INNER JOIN ProgramPeriod Pe ON PARQ.ProgramCode = Pe.ProgramCode AND PARQ.Period = Pe.Period 
									 INNER JOIN Organization.dbo.Organization OO ON Pe.OrgUnit = OO.OrgUnit
						   WHERE     1=1
				           AND       NOT EXISTS (SELECT 'X' FROM ProgramAllotmentRequestQuantity WHERE RequirementId = PARQ.RequirementId) 		   
						   
						   <cfif ProgramCode neq "">
						   AND       P.ProgramCode  = '#programcode#'						   
						   <cfelse>
						   AND       P.ProgramCode IN (
						   								SELECT PPx.ProgramCode
						                                FROM   ProgramPeriod PPx INNER JOIN Organization.dbo.Organization Ox ON PPx.OrgUnit = Ox.OrgUnit
														WHERE  PPx.ProgramCode = PARQ.ProgramCode 
														AND	   PPx.Period = '#period#'
														AND    Ox.Mission = '#mission#'
						   							  ) 
						   </cfif>
						   
						   AND       PARQ.Period       = '#period#'	
						   	
						   <cfif EditionId neq "">  	  
						   AND       EditionId    = '#editionid#'
						   </cfif>
						   
						   <cfif Fund neq "">
						   AND       Fund         = '#fund#'
						   </cfif>
						   
						   AND       PARQ.ActionStatus IN (#preservesingleQuotes(ActionStatus)#)
						
			</cfsavecontent>				
			
			<cfsavecontent variable="thisquery">
			
					SELECT   RequirementId, 
					         B.Mission,
			                 B.ProgramCode, 
							 B.ActivityId,
							 LEFT(B.ProgramHierarchy, CHARINDEX('.', B.ProgramHierarchy) - 1) as ProgramParent,						 
							 B.Period, 
							 B.EditionId, 
							 B.Resource, 
							 B.ObjectCode, 
							 B.ObjectCodeParent,
							 B.Fund, 
							 B.ItemMaster, 
							 RequestDue,
							 YEAR(RequestDue) AS RequestYear, 
							 DatePart(QUARTER,RequestDue) as RequestQuarter,
							 RequestQuantity, 
							 <cfif Support eq "Yes">	
							 (CASE WHEN B.SupportEnable = 1 THEN 					 
							 RequestAmountBase+(RequestAmountBase*ISNULL(SupportPercentage/100.0,0))
							 ELSE  RequestAmountBase END) as RequestAmountBase, 	
							  (CASE WHEN B.SupportEnable = 1 THEN 					 
							 (RequestAmountBase*ISNULL(SupportPercentage/100.0,0))
							 ELSE  0 END) as SupportAmountBase, 	
							 <cfelse>
							 RequestAmountBase,
							 (CASE WHEN B.SupportEnable = 1 THEN 					 
							 (RequestAmountBase*ISNULL(SupportPercentage/100.0,0))
							 ELSE  0 END) as SupportAmountBase, 	
							 </cfif>										
							 RequirementIdParent,
							 RequestRemarks,
							 ActionStatus,
							 RequestType,
							 RequestDescription,
							 B.SupportEnable,
							 B.OfficerUserId,	
							 B.OfficerFirstName,	
							 B.OfficerLastName,						
							 B.Created
							 
					<cfif Mode eq "Table">
					INTO     userquery.dbo.#table#
					</cfif>		 
							 
					FROM       ( #preserveSingleQuotes(basequery)# ) as B INNER JOIN 
					           ProgramAllotment PA ON B.ProgramCode = PA.ProgramCode and B.Period = PA.Period AND B.EditionId = PA.EditionId 
					WHERE      B.Mission       = '#mission#'		
					
					<cfif programcode eq "">			 	   
					AND        B.ProgramClass != 'Program'
					</cfif>
					 
				<cfif Support eq "Object">
					 
				  UNION
				  
				  SELECT       RequirementId, 
					           B.Mission,
			                   B.ProgramCode, 
							   B.ActivityId,
							   LEFT(B.ProgramHierarchy, CHARINDEX('.', B.ProgramHierarchy) - 1) as ProgramParent,						 
							   B.Period, 
							   B.EditionId, 
							   B.Resource, 
							   PA.SupportObjectCode, 
							   B.ObjectCodeParent,
							   B.Fund, 
							   B.ItemMaster, 
							   RequestDue,
							   YEAR(RequestDue) AS RequestYear, 
							   DatePart(QUARTER,RequestDue) as RequestQuarter,
							   RequestQuantity, 	
							   (CASE WHEN B.SupportEnable = 1 THEN 					 
								 RequestAmountBase+(RequestAmountBase*ISNULL(SupportPercentage/100.0,0))
								 ELSE  RequestAmountBase END) as RequestAmountBase, 	
							   (CASE WHEN B.SupportEnable = 1 THEN 					 
							    (RequestAmountBase*ISNULL(SupportPercentage/100.0,0))
							    ELSE  0 END) as SupportAmountBase, 		 										 							   															
							   RequirementIdParent,
							   RequestRemarks,
							   ActionStatus,
							   RequestType,
							   RequestDescription,
							   B.SupportEnable,
							   B.OfficerUserId,	
							   B.OfficerFirstName,	
							   B.OfficerLastName,						
							   B.Created
					 
					FROM       ( #preserveSingleQuotes(basequery)# ) as B INNER JOIN 
					           ProgramAllotment PA ON B.ProgramCode = PA.ProgramCode and B.Period = PA.Period AND B.EditionId = PA.EditionId 
					WHERE      B.Mission       = '#mission#'	
					<cfif programcode eq "">					 	   
					AND        B.ProgramClass != 'Program'
					</cfif>
					AND        PA.SupportPercentage > 0
					AND        EXISTS (SELECT 'X' FROM Ref_Object WHERE Code = PA.SupportObjectCode) 
					 
				</cfif>					 		
			   
			   </cfsavecontent>
			   			 
			   </cfoutput>				     
			   
			   <cfif mode eq "table">
			   
				   	<cftransaction isolation="READ_UNCOMMITTED">
			
						<cfquery name="getData" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							#preservesingleQuotes(thisquery)# 
						</cfquery>	  
					
					</cftransaction>
					
					<cfquery name="Index" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					CREATE  CLUSTERED INDEX [ProgramInd] 
					   ON dbo.#table#([ProgramCode],[Fund]) ON [PRIMARY]
					</cfquery>	
																		
				<cfelse>
				
					<cfreturn thisquery>						
							
				</cfif>						 
					 
	</cffunction>		
			
	<cffunction name="RequirementDue"
             access="public"
             returntype="any"			 
             displayname="setDueRequirement">			 
					
			<cfargument name="Period"      type="string"  required="true"  default=""> 		
			<cfargument name="Editionid"   type="string"  required="true"  default=""> 
			<cfargument name="Fund"        type="string"  required="true"  default=""> 
			<cfargument name="ProgramCode" type="string"  required="true"  default=""> 		
			
			<cftransaction>
					
					<cfquery name="initdefault1" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							UPDATE    ProgramAllotmentRequest
							SET       AmountBasePercentageDue = 0						
							WHERE     EditionId   = '#editionid#' 
							AND       Period      = '#period#' 
							<cfif ProgramCode neq "">
							AND       ProgramCode = '#ProgramCode#'
							<cfelse>
							AND       Fund        = '#fund#'	
							</cfif>							
					</cfquery>	
					
					<!--- if there is no mapping, then 100 is due
					 if the amount already alloted for the requirement 
					 is bigger than the percentage calculated we 
					 set this to actual percentage --->
					 
					<!--- Attention : we first apply the generic rule, THEN we correct based on the 
					setting for this project specifically which can be date or percentage ---> 					
					
					<cfloop index="itm" list="edition,program">
					
							<cfquery name="setFutureAs0" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
								
									UPDATE    ProgramAllotmentRequest
									SET       AmountBasePercentageDue = 1	
									
									<cfif itm eq "edition">
									
										FROM      ProgramAllotmentRequest P, 
										          Ref_AllotmentEditionFundObject R
												  
										WHERE     P.EditionId   = R.EditionId
										AND       P.Fund        = R.Fund
										AND       P.ObjectCode  = R.ObjectCode
										
										<!--- exclude OE which are defined on the level of the program --->
										
										AND      NOT EXISTS (SELECT 'X'
															 FROM   ProgramAllotmentObject O
										                     WHERE  O.ProgramCode = P.ProgramCode
															 AND    O.Period      = P.Period
															 AND    O.EditionId   = P.EditionId
															 AND    O.Fund        = P.Fund
															 AND    O.ObjectCode  = P.ObjectCode)																
									
									<cfelse>									
									
										FROM      ProgramAllotmentRequest P, 
										          ProgramAllotmentObject R
												  
										WHERE     P.ProgramCode = R.ProgramCode
										AND       P.Period      = R.Period
										AND       P.EditionId   = R.EditionId
										AND       P.Fund        = R.Fund
										AND       P.ObjectCode  = R.ObjectCode
										AND       R.RequirementMode = 'Date'
									
									</cfif>
									
									AND       R.Operational  = 1
									AND       P.EditionId   = '#editionid#' 
									AND       P.Period      = '#period#' 
									
										<cfif ProgramCode neq "">
										AND       P.ProgramCode = '#ProgramCode#'
										<cfelse>
										AND       P.Fund        = '#fund#'	
										</cfif>
									
									AND       P.RequestDue <= R.RequirementDate 
									
									AND       P.ActionStatus = '1' <!--- only valid requirement --->
									
									<!--- single requirements --->
									
									AND       NOT EXISTS
								                 (SELECT  'X' 
								                  FROM    ProgramAllotmentRequestQuantity 
								                  WHERE   RequirementId = P.RequirementId AND RequestQuantity > 0) 										  
											 		
							</cfquery>	
							
							<cfquery name="setFuturePartial" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
								
								UPDATE    ProgramAllotmentRequest	
													
								SET       AmountBasePercentageDue = Base.Percentage							
								
								FROM      ProgramAllotmentRequest S, 
											(
											SELECT     P.RequirementId, O.RequirementDate, 
											
											           ROUND(
													         (SELECT  ISNULL(SUM(Q.RequestQuantity), 0)
										                      FROM    ProgramAllotmentRequestQuantity AS Q INNER JOIN
										                              Ref_Audit AS R ON Q.AuditId = R.AuditId
										                       WHERE  Q.RequirementId = P.RequirementId 
															   AND    R.AuditDate <= O.RequirementDate) 
															   
															  /  <!--- divide --->
										
										                     (SELECT  SUM(Q.RequestQuantity)
										                      FROM    ProgramAllotmentRequestQuantity AS Q INNER JOIN
										                              Ref_Audit AS R ON Q.AuditId = R.AuditId
										                      WHERE   Q.RequirementId = P.RequirementId), 2) AS Percentage
											
											
											<cfif itm eq "edition">
											
												FROM        ProgramAllotmentRequest AS P INNER JOIN
											                Ref_AllotmentEditionFundObject AS O ON P.EditionId = O.EditionId AND P.Fund = O.Fund AND P.ObjectCode = O.ObjectCode
												AND         P.EditionId    = '#editionid#' 
												AND         P.Period       = '#period#' 
												<cfif ProgramCode neq "">
												AND         P.ProgramCode  = '#ProgramCode#'
												<cfelse>
												AND       	P.Fund         = '#fund#'	
												</cfif>			
											
											<cfelse>
											
												FROM      ProgramAllotmentRequest P, 
											    	      ProgramAllotmentObject O
													  
												WHERE     P.ProgramCode = O.ProgramCode
												AND       P.Period      = O.Period
												AND       P.EditionId   = O.EditionId
												AND       P.Fund        = O.Fund
												AND       P.ObjectCode  = O.ObjectCode
												AND       O.RequirementMode = 'Date'
																				
											</cfif>
																																																						
											AND           P.ActionStatus = '1'		
											AND           O.Operational  = 1	
											
											<!--- composit requirements --->
											
											AND           EXISTS
										                   (SELECT  'X' 
										                    FROM    ProgramAllotmentRequestQuantity 
										                    WHERE   RequirementId = P.RequirementId AND RequestQuantity > 0) 					  
											GROUP BY      P.RequirementId, O.RequirementDate		
											) as Base
								
								WHERE     S.RequirementId = Base.RequirementId
								
							</cfquery>	
							
							<cfif itm eq "program">
							
								<cfquery name="setFutureAs0" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">	
									
										UPDATE    ProgramAllotmentRequest
										SET       AmountBasePercentageDue = CONVERT(FLOAT, RequirementDate)/100	
																															
										FROM      ProgramAllotmentRequest P, 
										          ProgramAllotmentObject R
												  
										WHERE     P.ProgramCode = R.ProgramCode
										AND       P.Period      = R.Period
										AND       P.EditionId   = R.EditionId
										AND       P.Fund        = R.Fund
										AND       P.ObjectCode  = R.ObjectCode
										AND       R.RequirementMode = 'Percentage'
																			
										AND       R.Operational  = 1
										AND       P.EditionId   = '#editionid#' 
										AND       P.Period      = '#period#' 
										
										<cfif ProgramCode neq "">
										AND       P.ProgramCode = '#ProgramCode#'
										<cfelse>
										AND       P.Fund        = '#fund#'	
										</cfif>
																											
										AND       P.ActionStatus = '1' <!--- only valid requirement --->														  
												 		
								</cfquery>	
							
							</cfif>
					
					</cfloop>
										
					<!--- 
						if less than 1 and if the amount already alloted (1) for the requirement 
						is bigger than the percentage calculated we set this to actual percentage 						 	 
					--->					 
					 
					<cfquery name="setCorrectionBaseonAllotment" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
					 
							UPDATE   ProgramAllotmentRequest
							SET      AmountBasePercentageDue = Sub.AmountBasePercentageAlloted
							FROM     ProgramAllotmentRequest C,
			                 	     ( SELECT     RequirementId, AmountBaseAllotment, AmountBasePercentageDue,
			                                       (SELECT   SUM(S.Amount)
			                                        FROM     ProgramAllotmentDetailRequest AS S INNER JOIN
			                                                 ProgramAllotmentDetail AS D ON S.TransactionId = D .TransactionId
			                                        WHERE    D.Status = '1' 
												    AND      S.RequirementId = P.RequirementId) / AmountBaseAllotment AS AmountBasePercentageAlloted    
				                       FROM      ProgramAllotmentRequest AS P
			                           WHERE     Period       = '#Period#'
									   AND       EditionId    = '#editionid#' 
									   <cfif ProgramCode neq "">
									   AND       ProgramCode  = '#ProgramCode#'
									   <cfelse>
									   AND       Fund         = '#fund#'	
									   </cfif>									 
									   AND       ActionStatus = '1' 
									   AND       AmountBasePercentageDue < 1 
									   AND       AmountBaseAllotment > 0) as Sub
							WHERE     C.RequirementId = Sub.RequirementId
						    AND       Sub.AmountBasePercentageAlloted > C.AmountBasePercentageDue
							AND       C.ActionStatus = '1'
							
					</cfquery>	 
					  					
			</cftransaction>
						 
	</cffunction>	 	
	
	<cffunction name="RequirementStatus"
             access="public"
             returntype="any"			 
             displayname="getStatus">
			
			<cfargument name="ProgramCode" type="string"  required="true"  default=""> 	
			<cfargument name="Period"      type="string"  required="true"  default=""> 		
			<cfargument name="Editionid"   type="string"  required="true"  default=""> 
			
			<cfquery name="getEdition" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT  *
			 FROM    Ref_AllotmentEdition
			 WHERE   EditionId   = '#EditionId#'		 
		    </cfquery>				
			
			<cfset statuslock = "0">
			
			<cfif getEdition.Status eq "9">
			
				<!--- has been locked no matter what --->				
				<cfset statuslock = "1">
			
			<cfelseif getEdition.Status eq "3">
			
			 <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
				Method         = "budget"
				ProgramCode    = "#ProgramCode#"
				Period         = "#Period#"	
				EditionId      = "'#editionID#'"  
				Role           = "'BudgetManager'"
				ReturnVariable = "BudgetAccess">	
				
				<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">
				
				    <!--- we keep it open for these fooks --->
					
					<cfset statuslock = "0">
				
				<cfelse>
				
					<cfset statuslock = "1">
				
				</cfif>
			
				<!--- always disabled unless budget manager access --->
						
			<cfelseif getEdition.status eq "1">
			
				<!--- open unless locked particularly fior program officer --->
				
				<cfset statuslock = "0">
			
				<cfquery name="getlock" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT *
				 FROM   ProgramAllotment
				 WHERE   EditionId   = '#EditionId#'
				 AND     ProgramCode = '#ProgramCode#'
				 AND     Period      = '#Period#'		
			    </cfquery>					
								
				<!--- has been explicitly locked --->
				
				<cfif getLock.LockEntry eq "1">				
				
				 <cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
					Method         = "budget"
					ProgramCode    = "#ProgramCode#"
					Period         = "#Period#"	
					EditionId      = "'#editionID#'"  
					Role           = "'BudgetManager'"
					ReturnVariable = "BudgetAccess">	
					
					<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">
								
						<!--- we keep it open --->
						
						<cfset statuslock = "0">
														
					<cfelse>
				
						<cfset statuslock = "1">
				
					</cfif>		
								
				</cfif>								
			
			</cfif>
							
			<cfreturn StatusLock>			
		 
	</cffunction>		 	
				 
		
	<cffunction name="validateContributionBalance"
             access="public"
             returntype="any"			 
             displayname="Validate">
			 
			 <!--- validates if the amount allocated for a project is enough to clear
			 a transaction --->
			 
		<cfargument name="ProgramCode"         type="string" required="true"   default="">
		<!--- this is the execution period which moves back to the correct planperiod + edition to compare with --->
		<cfargument name="Period"              type="string"  required="true"  default="">
		<cfargument name="Fund"                type="string"  required="true"  default="">
		<cfargument name="ObjectCode"          type="string"  required="true"  default="">		
		<cfargument name="ContributionLineId"  type="string"  required="true"  default="">
		<cfargument name="Amount"              type="numeric" required="true"  default="0">
		<cfargument name="Mode"                type="string"  required="true"  default="Full">
			
		<!--- query on all criteria 
		    check if amount alloted gte amount mapped --->
			
			<cfquery name="getObjects" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
					 SELECT Code
					 FROM   Ref_Object
					 WHERE  Code = '#ObjectCode#' 
					 UNION
					 SELECT Code
					 FROM   Ref_Object
					 WHERE  ParentCode = '#ObjectCode#' 						
			</cfquery>	
							
			<cfset objects = quotedValueList(getObjects.Code)>	
			
			<cfquery name="getProgram" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT   *
				FROM     Program
				WHERE    ProgramCode  = '#ProgramCode#'							
			</cfquery>	
			
			<cfquery name="getPeriod" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT   *
				FROM     Organization.dbo.Ref_MissionPeriod
				WHERE    Mission = '#getProgram.Mission#'
				AND      Period  = '#Period#'				
			</cfquery>	
			
			<cfquery name="getSetting" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT   *
				FROM     ProgramAllotment
				WHERE    ProgramCode  = '#ProgramCode#'			
				AND      Period       = '#getPeriod.PlanningPeriod#' 
				AND      EditionId    = '#getPeriod.EditionId#'				
			</cfquery>	
			
			<cfquery name="getAllotment" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT   SUM(DC.Amount) AS Allotment
				FROM     ProgramAllotmentDetail AS D INNER JOIN
		                 ProgramAllotmentDetailContribution AS DC ON D.TransactionId = DC.TransactionId
				WHERE    D.ProgramCode         = '#ProgramCode#'				
				AND      D.Period              = '#getPeriod.PlanningPeriod#' 
				AND      D.EditionId           = '#getPeriod.EditionId#'
				AND      D.Fund                = '#Fund#' 
				<!--- only actually cleared amounts are counted --->
				AND      D.Status              = '1' 
				
				<cfif contributionlineid neq "">
				
					<cfif getSetting.ModeMappingTransaction eq "0">
					<!--- this means we are only getting amount for OE that are the same as the requested --->
					AND      D.ObjectCode IN (#preserveSingleQuotes(objects)#)	 					
					</cfif>
					AND      DC.ContributionLineId = '#ContributionLineId#'
										
				<cfelse>
				
				AND      D.ObjectCode IN (#preserveSingleQuotes(objects)#)	 	
					
				</cfif>
				
				<!--- we exclude the support objectcode here as it is controlled --->
				AND D.ObjectCode != '#getSetting.SupportObjectCode#'
												
			</cfquery>
			
			<cfif getAllotment.Allotment eq "">
			    <cfset all = "0">
			<cfelse>
			    <cfset all  = getAllotment.Allotment>  
			</cfif>
			
			<cfquery name="getUsed" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			
					SELECT   ISNULL(SUM(AmountBaseDebit - AmountBaseCredit), 0) as Used
		            FROM     Accounting.dbo.TransactionLine TL
					WHERE    Journal IN (SELECT Journal 
			                             FROM   Accounting.dbo.Journal 
								         WHERE  Mission = '#getProgram.Mission#')
					AND      TL.Fund               = '#Fund#' 					
					AND      TL.ProgramCode        = '#ProgramCode#' 
					AND      TL.ProgramPeriod      = '#Period#'
					
					<cfif contributionlineid neq "">
					
						<cfif getSetting.ModeMappingTransaction eq "0">
						AND     TL.ObjectCode IN (#preserveSingleQuotes(objects)#)					
						</cfif>						
						AND     TL.ContributionLineId = '#ContributionLineId#'								
										
					<cfelse>
				
						AND      TL.ObjectCode IN (#preserveSingleQuotes(objects)#)	
					
					</cfif>
					
					<!--- we exclude the support objectcode here as it is controlled --->
					AND TL.ObjectCode != '#getSetting.SupportObjectCode#'
			
			</cfquery>
			
			<cfif getUsed.Used eq "">
			    <cfset used = "0">
			<cfelse>
			    <cfset used  = getUsed.Used>  
			</cfif>
			
			<!--- retrieve balance --->
			
			<cfset balance = all - used>	
			
			<cfset contribution.allotment = all>
			<cfset contribution.disbursed = used>				
			<cfset contribution.balance   = balance>
			
			<!--- retrieve result --->
				
			<cfset diff = balance - amount>
			
			<cfif round(diff) gte "0">			
				<cfset contribution.accept = "Yes">			
			<cfelse>			
				<cfset contribution.accept = "No">						
			</cfif>
			
			<cfreturn Contribution>
						 
	</cffunction>	
	
	<!--- function to link a contribution to an transaction --->	
		
	<cffunction name="associateContribution"
             access="public"
             returntype="any"
             displayname="Associate Contribution to allotment">	
			 
			 <!--- -------------------------------------------------------------------------------------- --->
			 <!--- please note that support costs are prepared in the routine that rechecks the allotment --->
			 <!--- -------------------------------------------------------------------------------------- --->	
			 
			 <cfargument name="TransactionId"       type="string"  required="true"   default="">
			 <cfargument name="ContributionLineId"  type="string"  required="true"   default=""> 
			 <cfargument name="Amount"              type="numeric" required="true"   default="0"> 
			 
			 <cfquery name="check" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">					
				SELECT   *
				FROM      ProgramAllotmentDetailContribution
				WHERE     TransactionId      = '#TransactionId#'		
				AND       ContributionLineId = '#contributionlineid#'			
			 </cfquery>	
			 
			 <!--- here we could validate if the funds would justify such a transaction of that contribution 
			 using the validate contribution balance 
			 --->
									
			 <cfif check.recordcount eq "0">				
																						
				<cfquery name="insert" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				
					INSERT INTO  ProgramAllotmentDetailContribution
					
						(TransactionId,
						 ContributionLineId,
						 Amount,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
						 
					VALUES ( '#transactionid#', 
					         '#contributionlineid#',
							 '#round(amount*100)/100#', 
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#')					 
													
				</cfquery>								
						
			 <cfelse>
										
				<cfquery name="update" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
					UPDATE    ProgramAllotmentDetailContribution
					SET       Amount = amount + #round(amount*100)/100#
					WHERE     TransactionId      = '#transactionid#'		
					AND       ContributionLineId = '#contributionlineid#'			
				</cfquery>	
						
			</cfif>		
			
			<!--- create a period record for the execution --->
			
			<cfquery name="get" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">					
				SELECT    E.Period
				FROM      ProgramAllotmentDetail P, Ref_AllotmentEdition E
				WHERE     P.TransactionId      = '#TransactionId#'								
				AND       P.EditionId = E.EditionId
			</cfquery>		
			
			<cfquery name="check" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">					
				SELECT    *
				FROM      ContributionLinePeriod
				WHERE     ContributionLineId = '#contributionlineid#'								
				AND       Period  = '#get.Period#'
			</cfquery>		
			
			<cfif check.recordcount eq "0">	
			
				<cfquery name="AddCorrectionPeriod" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ContributionLinePeriod
					(ContributionLineId,Period,OfficerUserId,OfficerLastName,OfficerFirstName)
					VALUES (
					'#contributionlineid#',
					'#get.Period#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#' )
				</cfquery>	 
			
			</cfif>						
			 
	</cffunction>		 
	
	<cffunction name="generateSupportCost"
             access="public"
             returntype="any"
             displayname="Program">
		
		<!--- ------------- Generating action GL transactions for the support cost as defined ----------- --->		
		<cfargument name="ProgramCode"        type="string" required="true"   default="">
		<cfargument name="Period"             type="string" required="true"   default="">
		<cfargument name="EditionId"          type="string" required="false"  default="">		
		<cfargument name="OrgUnitOwner"       type="string" required="false"  default="0">
		<!--- limit the transactions to manual entries and loaded like reconcile, obligation transactions --->
		<cfargument name="TransactionSource"  type="string" required="false"  default="'AccountSeries','ReconcileSeries','Obligation'">	
										
		<cfquery name="getProgram" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT  * 
			FROM    ProgramPeriod Pe, ProgramAllotment PA
			WHERE   Pe.ProgramCode = PA.ProgramCode
			AND     Pe.Period      = PA.Period
			AND     Pe.ProgramCode = '#ProgramCode#'
			AND     Pe.Period      = '#Period#'
			<cfif EditionId neq "">
			AND     EditionId = '#EditionId#'
			</cfif>
		</cfquery>	
		
		<cfquery name="getMission" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT  * 
				FROM    Program
				WHERE   ProgramCode = '#ProgramCode#'			
		</cfquery>	
				
		<cfquery name="getJournal" 
	     datasource="AppsProgram" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Accounting.dbo.Journal
		     WHERE  Mission  = '#getMission.Mission#'
			 AND    SystemJournal = 'SupportCost'   
		</cfquery>			
				
		<cfif getJournal.recordcount eq "0" or getJournal.GLAccount eq "">
		
			<cf_alert message="Either the Journal for support cost charges was not defined or support GL contra-account was not set for the support cost journal. Please contact your administrator.">
			<cfabort>
		
		</cfif>
					
		<cfif getProgram.SupportObjectCode neq "" and getProgram.SupportPercentage gte "0" and getJournal.recordcount eq "1"> 		
											
			<cfquery name="getAccount" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT  * 
				FROM    Accounting.dbo.Ref_Account
				WHERE   ObjectCode = '#getProgram.SupportObjectCode#'			
			</cfquery>	
						
			<cfif getAccount.GLAccount eq "">
		
				<cf_alert message="GL account for selected Object code #getProgram.SupportObjectCode# could not be determined">
				<cfabort>
		
			</cfif>			
					
			<cfquery name="getAccountPeriod" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">					
				SELECT  AccountPeriod 
				FROM    Organization.dbo.Ref_MissionPeriod	
				WHERE   Mission = '#getMission.Mission#'
				AND     Period  = '#Period#'		
		   </cfquery>	
		   		
		<!--- only of we have a contract account, and account for the ObjectCode and if it is enabled for the program --->
		
			<cfif getAccount.recordcount eq "1" and getJournal.GLAccount neq "" and  getProgram.SupportPercentage neq ""> 
						
					<cfset ObjectCode = getProgram.SupportObjectCode>
					<cfset Percentage = getProgram.SupportPercentage>	
							
					<cfquery name="getFund" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					
					    SELECT   DISTINCT Fund
						FROM     Accounting.dbo.TransactionLine AS L INNER JOIN
	                    		 Accounting.dbo.TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
						WHERE    L.ProgramCode   = '#ProgramCode#'
						AND      L.ProgramPeriod = '#Period#'						
						AND      L.ObjectCode    <> '#ObjectCode#' 
						AND      H.Journal       <> '#getJournal.Journal#'
						AND      H.TransactionSource IN (#preservesingleQuotes(TransactionSource)#)						
					</cfquery>						
					
					<cfloop query="getFund">
					
						<cfset fd = fund>
										
						<cfquery name="getYear" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						
						    SELECT   DISTINCT YEAR(L.TransactionDate) as Year
							FROM     Accounting.dbo.TransactionLine AS L INNER JOIN
		                    		 Accounting.dbo.TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
							WHERE    L.ProgramCode   = '#ProgramCode#'
							AND      L.ProgramPeriod = '#Period#'						
							AND      L.ObjectCode    <> '#ObjectCode#' 
							AND      L.Fund          = '#Fund#'
							AND      H.Journal       <> '#getJournal.Journal#'
							AND      H.TransactionSource IN (#preservesingleQuotes(TransactionSource)#)						
							ORDER BY YEAR(L.TransactionDate) 
						</cfquery>		
												
						<cfloop query="getYear">
											
							<cfset yr = Year>		
							
							<CF_DateConvert Value="31/12/#yr#">
												
							<cfif now() gt datevalue>
							    <cfset seldte = datevalue>
							<cfelse>
							    <cfset seldte = now()> 
							</cfif>																			
						
							<!--- define the total project amount recorded for any journal
							except the OE of the support cost this includes for DPA
							disbursement, obligations (DPA) and corrections --->
							
							<cfquery name="getProgramCost" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
								SELECT   ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit), 2) AS Amount
								FROM     Accounting.dbo.TransactionLine AS L INNER JOIN
			                    		 Accounting.dbo.TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
										 
								WHERE    H.Mission               = '#getMission.Mission#'		 
								AND      L.ProgramCode           = '#ProgramCode#'
								AND      L.ProgramPeriod         = '#Period#'
								AND      L.Fund                  = '#Fd#'
								AND      YEAR(L.TransactionDate) = #Yr#
	
								<!--- exclude support costs itself --->
								AND      L.ObjectCode    <> '#ObjectCode#' 										
								
								AND      L.ObjectCode IN (SELECT Code 
								                          FROM   Ref_Object 
												    	  WHERE  Code = L.ObjectCode 
													      AND    SupportEnable = 1)
								AND      H.TransactionSource IN (#preservesingleQuotes(TransactionSource)#)	
							</cfquery>	
							
							<cfif getProgramCost.Amount neq "">
							
							<cfset SupportCostTotal = getProgramCost.Amount * (Percentage/100)>
												
							<!--- clear posted entries if they are NOT mapped, we could make this transactional
							later as well but for now we wipe it out, these could be imis transactions as well  --->
							
							<cfquery name="removeNotMappedProgramCost" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
							  DELETE Accounting.dbo.TransactionHeader
							  FROM   Accounting.dbo.TransactionHeader H
							  WHERE  H.Mission = '#getMission.Mission#'
							  AND    JournalSerialNo IN (SELECT JournalSerialNo	
							                            FROM   Accounting.dbo.TransactionLine L
														WHERE  Journal                 = H.Journal
														AND    JournalSerialNo         = H.JournalSerialNo
													    AND    L.ProgramCode           = '#ProgramCode#' 
													    AND    L.ProgramPeriod         = '#Period#' 
													    AND    L.Fund                  = '#fd#'
														AND    YEAR(L.TransactionDate) = #Yr#
													    AND    (
															       L.ContributionLineId IS NULL 
															       OR
															       L.ContributionLineId NOT IN (SELECT ContributionLineId 
																                                FROM   ContributionLine
																								WHERE  ContributionLineId = L.ContributionLineId)
															   )								
													    AND    L.ObjectCode            = '#ObjectCode#')
							</cfquery>												
							
							<cfquery name="getContributions" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
												
								SELECT   C.ContributionLineId, 
								
								         <!--- retrieve the amount posted per contributions --->
										 
										 ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit), 2) AS ContributionMapped,									 
																			  
										  <!--- retrieve the amount already posted until today for the contribution --->
										  
										 (SELECT   ROUND(SUM(DL.AmountBaseDebit - DL.AmountBaseCredit), 2) 
				                          FROM     Accounting.dbo.TransactionLine AS DL INNER JOIN
		                                           Accounting.dbo.TransactionHeader AS DH ON DL.Journal = DH.Journal AND DL.JournalSerialNo = DH.JournalSerialNo
		                                  WHERE    DL.ProgramCode           = '#ProgramCode#' 
										  AND      DL.ProgramPeriod         = '#Period#' 
										  AND      DL.Fund                  = '#fd#'
										  AND      YEAR(DL.TransactionDate) = #Yr#
										  AND      DL.ContributionLineId    = C.ContributionLineId
										  AND      DL.ObjectCode            = '#ObjectCode#') as AmountPosted
		                                
										 
								FROM     Program.dbo.ContributionLine AS C INNER JOIN
			                    		 Accounting.dbo.TransactionLine AS L INNER JOIN
					                     Accounting.dbo.TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo ON C.ContributionLineId = L.ContributionLineId
								WHERE    H.Mission = '#getMission.Mission#'		 
								AND      L.ProgramCode           =  '#ProgramCode#' 
								AND      L.ProgramPeriod         =  '#Period#' 
								AND      YEAR(L.TransactionDate) =  #Yr#
								AND      L.Fund                  =  '#fd#'
								AND      L.ObjectCode           <>  '#ObjectCode#' 
								AND      L.ObjectCode IN (SELECT Code 
								                          FROM   Ref_Object 
												    	  WHERE  Code = L.ObjectCode 
													      AND    SupportEnable = 1)
								AND      H.TransactionSource IN (#preservesingleQuotes(TransactionSource)#)	
								GROUP BY C.ContributionLineId	
																					
							</cfquery>										
							
							<!--- generate PSC transactions for each contribution --->
																			
							<cfloop query="getContributions">
							
									<cfset calc = ContributionMapped * (Percentage/100)>
									<cfset calc = round(calc*100)/100>
									
									<!--- Hanno : correction needed, that incase we exceed we do not used that contribution !--->
									
									<cfif amountPosted eq "">
										<cfset diff = calc>
									<cfelse>
										<cfset diff = calc - amountPosted>
									</cfif>	
									
									<cfif abs(diff) gte 2>													
									
									<cf_GledgerEntryHeader
									    Mission               = "#getMission.Mission#"
									    OrgUnitOwner          = "#OrgUnitOwner#"       
									    Journal               = "#getJournal.Journal#"  						
										Description           = "Support Cost calculation #getProgram.Reference#"
										TransactionSource     = "AccountSeries"
										TransactionDate       = "#DateFormat(seldte,CLIENT.dateformatshow)#"
										AccountPeriod         = "#getAccountPeriod.AccountPeriod#"
										TransactionCategory   = "Memorial"
										MatchingRequired      = "0"
										Reference             = "#getProgram.Reference#"       
										ReferenceName         = ""							
										Workflow              = "No"							
										DocumentCurrency      = "#Application.BaseCurrency#"							
										DocumentAmount        = "#diff#"
										OfficerUserId         = "#SESSION.acc#"
										OfficerLastName       = "#SESSION.Last#"
										OfficerFirstName      = "#SESSION.First#">
									
									<cf_GledgerEntryLine
										Lines                 = "2"
									    Journal               = "#getJournal.journal#"
										JournalNo             = "#JournalSerialNo#"							
										AccountPeriod         = "#getAccountPeriod.AccountPeriod#"
										Currency              = "#Application.BaseCurrency#"
										TransactionDate       = "#DateFormat(seldte,CLIENT.dateformatshow)#"
																		
										TransactionSerialNo1  = "1"				
										Class1                = "Debit"
										Reference1            = "Disbursement"       
										ReferenceName1        = "Support Cost"
										Description1          = "Automatic Support Cost calculation"
										GLAccount1            = "#getAccount.GLAccount#"  
										Fund1                 = "#fd#"
										ObjectCode1           = "#ObjectCode#"
										ContributionLineId1   = "#ContributionLineId#"
										Costcenter1           = ""
										ProgramCode1          = "#ProgramCode#"
										ProgramPeriod1        = "#Period#"
										ReferenceId1          = ""
										TransactionType1      = "Standard"
										Amount1               = "#diff#"
										
										TransactionSerialNo2  = "0"
										Class2                = "Credit"
										Reference2            = "Disbursement"       
										ReferenceName2        = "Support Cost"
										Description2          = "Automatic Support Cost calculation"
										GLAccount2            = "#getJournal.GLAccount#"
										TransactionType2      = "Standard"
										Amount2               = "#diff#">														
									
									</cfif>							
							
							</cfloop>
							
							<!--- now we determine the total amount mapped to a contribution, so we
							know how much to record for the PSC in general to have the full picture --->
							
							<cfquery name="getMappedCost" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
								SELECT   ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit), 2) AS Amount
								FROM     Accounting.dbo.TransactionLine AS L INNER JOIN
			                    		 Accounting.dbo.TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
								WHERE    H.Mission = '#getMission.Mission#'		 
								AND      L.ProgramCode   = '#ProgramCode#'
								AND      L.ProgramPeriod = '#Period#'
								AND      L.Fund          = '#Fd#'
								AND      YEAR(L.TransactionDate) = #Yr#
								
								<!--- associated to a valid contribution record --->
								
								AND      (
										 L.ContributionLineId IS NOT NULL 
								         AND
										 L.ContributionLineid IN (SELECT ContributionLineId 
								                                  FROM   ContributionLine 
														          WHERE  ContributionLineId = L.ContributionLineId)
										 )
										 										  
								AND      L.ObjectCode    <> '#ObjectCode#' 
								AND      L.ObjectCode IN (SELECT Code 
								                          FROM   Ref_Object 
												    	  WHERE  Code = L.ObjectCode 
													      AND    SupportEnable = 1)
								AND      H.TransactionSource IN (#preservesingleQuotes(TransactionSource)#)	
							</cfquery>										
							
							<cfif getMappedCost.Amount neq "">		
								<cfset SupportCostMapped = getMappedCost.Amount * (Percentage/100)>									
								<cfset diff = SupportCostTotal - SupportCostMapped>
							<cfelse>
								<cfset diff = SupportCostTotal>
							</cfif>
						
							<!---
							<cfoutput>#SupportCostTotal#][#SupportCostMapped#---</cfoutput>
							--->
							
							<!--- generate PSC transactions remaining as unmapped --->
							
							<cfif abs(diff) gte 1>
																			
								<cf_GledgerEntryHeader
								    Mission               = "#getMission.Mission#"
								    OrgUnitOwner          = "#OrgUnitOwner#"       
								    Journal               = "#getJournal.Journal#"  						
									Description           = "Support Cost calculation #getProgram.Reference#"
									TransactionSource     = "AccountSeries"
									TransactionDate       = "#DateFormat(seldte,CLIENT.dateformatshow)#"
									AccountPeriod         = "#getAccountPeriod.AccountPeriod#"
									TransactionCategory   = "Memorial"
									MatchingRequired      = "0"
									Reference             = "#getProgram.Reference#"       
									ReferenceName         = ""							
									Workflow              = "No"							
									DocumentCurrency      = "#Application.BaseCurrency#"							
									DocumentAmount        = "#diff#"
									OfficerUserId         = "#SESSION.acc#"
									OfficerLastName       = "#SESSION.Last#"
									OfficerFirstName      = "#SESSION.First#">
								
								<cf_GledgerEntryLine
									Lines                 = "2"
								    Journal               = "#getJournal.journal#"
									JournalNo             = "#JournalSerialNo#"							
									AccountPeriod         = "#getAccountPeriod.AccountPeriod#"
									Currency              = "#Application.BaseCurrency#"
									TransactionDate       = "#DateFormat(seldte,CLIENT.dateformatshow)#"
																	
									TransactionSerialNo1  = "1"				
									Class1                = "Debit"
									Reference1            = "Disbursement"       
									ReferenceName1        = "Support Cost"
									Description1          = "Automatic Support Cost calculation"
									GLAccount1            = "#getAccount.GLAccount#"  
									Fund1                 = "#fd#"
									ObjectCode1           = "#ObjectCode#"
									ContributionLineId1   = ""
									Costcenter1           = ""
									ProgramCode1          = "#ProgramCode#"
									ProgramPeriod1        = "#Period#"
									ReferenceId1          = ""
									TransactionType1      = "Standard"
									Amount1               = "#diff#"
									
									TransactionSerialNo2  = "0"
									Class2                = "Credit"
									Reference2            = "Disbursement"       
									ReferenceName2        = "Support Cost"
									Description2          = "Automatic Support Cost calculation"
									GLAccount2            = "#getJournal.GLAccount#"
									TransactionType2      = "Standard"
									Amount2               = "#diff#">														
									
							</cfif>		
							
						</cfif>	
																	
					</cfloop>
				
				</cfloop>
				
			</cfif>
		
		</cfif>
						
  </cffunction>
  		
</cfcomponent>	 