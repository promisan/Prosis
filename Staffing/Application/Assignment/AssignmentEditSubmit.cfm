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
<cf_screentop html="No" jquery="Yes">

<cfparam name="Form.ExpirationCode" default="">
<cfparam name="Form.ExpirationListCode" default="">
<cfparam name="Form.PositionGroup" default="">
<cfparam name="Form.Remarks" default="">

<cf_systemscript>

<cfquery name="Position" 
         datasource="AppsEmployee" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
    	 SELECT * 
		 FROM   PersonAssignment
	   	 WHERE  AssignmentNo = '#Form.AssignmentNo#' 
</cfquery>

<cfif ParameterExists(Form.Delete)> 

    <!--- deletion will perform several action
	
   	a. Delete will detect the PA action related to the transaction (mandate batches to be excluded !) , 
	b. if it exists it will revert like the cancel and then remove the assignment with status = 8, 
	c. the employee action completely and 
	d. to make sure also this assignment specifically in case it was not linked to a PA action to begin with	
	--->
	
	<cfquery name="LastAction" 
	         datasource="AppsEmployee" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	    	 SELECT TOP 1 * 
			 FROM   EmployeeActionSource E
			 WHERE  ActionSourceNo = '#Form.AssignmentNo#' 
			 AND    ActionSource   = 'Assignment'
			 <!--- exclude batch actions --->
			 AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
			                             FROM   EmployeeAction 
										 WHERE  ActionDocumentNo = E.ActionDocumentNo
										 AND    MandateNo is NULL)
			 AND    ActionStatus IN ('0','1')
			 ORDER BY ActionDocumentNo DESC
			 
	</cfquery>
	
	<!---
	
	<cfoutput>
	
	#lastaction.recordcount#
	....
	SELECT TOP 1 * 
			 FROM   EmployeeActionSource E
			 WHERE  ActionSourceNo = '#Form.AssignmentNo#' 
			 AND    ActionSource   = 'Assignment'
			 <!--- exclude batch actions --->
			 AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
			                             FROM   EmployeeAction 
										 WHERE  ActionDocumentNo = E.ActionDocumentNo
										 AND    MandateNo is NULL)
			 AND    ActionStatus IN ('0','1')
			 ORDER BY ActionDocumentNo DESC
	</cfoutput>		
	
	---> 
				
	<cfif LastAction.recordcount gte "1">	
			
		<cf_PAAssignmentAction 
		      Action="Revert" 
			  Clean="No" 
			  ActionDocumentNo="#LastAction.ActionDocumentNo#">
	
	<cfelse>		
				
		<cfquery name="DeleteAssignment" 
		         datasource="AppsEmployee" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		    	 DELETE PersonAssignment
			   	 WHERE  AssignmentNo = '#Form.AssignmentNo#' 
		</cfquery>
	
	</cfif>	
			
</cfif>	


<cfif ParameterExists(Form.Submit)> 

	    <!--- verify if transaction can be made for the requested period --->
				
		<cfif Len(Form.Remarks) gt 400>
		 <cf_alert message = "You entered remarks which exceeded the allowed size of 400 characters."
		  return = "back">
		  <cfabort>
		</cfif>
		
		<cfquery name="Check" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT  A.*, 
			         P.PostType, 
					 P.Mission, 
					 P.MissionOperational,
					 P.MandateNo
			 FROM    PersonAssignment A, 
			         Position P
			 WHERE   A.AssignmentNo = '#Form.AssignmentNo#'
			 AND     A.PositionNo   = P.PositionNo
		</cfquery>	
		
		<cfif check.recordcount eq "0">
			 <cf_alert message = "Could not find the assignment. Operation halted. Contact your administrator if this persists." return = "back">
			  <cfabort>
		</cfif>
		
		<cfquery name="Mandate" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT  *
			 FROM    Ref_Mandate
			 WHERE   Mission   = '#Form.Mission#'
			 AND     MandateNo = '#Form.MandateNo#'
		</cfquery>	

        <cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)#">
		<cfset MSTR = dateValue>
					
		<cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#">
		<cfset MEND = dateValue>
								
		<cfparam name="Form.LocationCode" default=""> 
					
		<cfquery name="Post" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   Position
			WHERE  PositionNo = '#Form.PositionNo#'
		</cfquery>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DateEffective#">
		<cfset STR = dateValue>
		
				
		<cfif STR lt Post.DateEffective>
		    <CF_DateConvert Value="#DateFormat(Post.DateEffective,CLIENT.DateFormatShow)#">
		    <cfset STR = dateValue>
		</cfif> 
		
		<CF_DateConvert Value="#DateFormat(Post.DateExpiration,CLIENT.DateFormatShow)#">
		<cfset PEXP = dateValue>
		
		<cfif STR gt PEXP>
				  						
			<cf_alert message = "Requested effective date #Form.DateEffective# exceeds position effective period [#DateFormat(PEXP,CLIENT.DateFormatShow)#].  Operation not allowed!"
   		        return = "back">
		    <cfabort>
			 
		</cfif>   
				
		<cfset dateValue = "">
		<cfif Form.DateExpiration neq ''>
		    <CF_DateConvert Value="#Form.DateExpiration#">
		    <cfset END = dateValue>
		<cfelse>
		    <cfset END = 'NULL'>
		</cfif>	
								
		<cfif END gt PEXP>
				  			
			 <cf_alert message = "Requested Expiration date #Form.DateExpiration# exceeds position effective period [#DateFormat(PEXP,CLIENT.DateFormatShow)#].  Operation not allowed!"
   		      return = "back">
		     <cfabort>
			
		</cfif>   
		
		<cfif END lt STR and END neq 'NULL'>
		   <cfset END = STR>
		</cfif>
				
		<cfset ass = Form.AssignmentNo>
						
		<cfset checkstatus = 0>
		
		<cfset call = "Edit">
		
		<cfinclude template="ActionNo.cfm">
		
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#Check.MissionOperational#'  <!--- was the owning mission changed 1/11/2013 --->
		</cfquery>
		
		<!--- identify mandate --->
				
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OrgScope"> 
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#AssignmentConflict"> 
		
		<cfif Parameter.AssignmentClear gte "1">
			<!--- requires clearance, so set to 0 --->
			<cfset clr = "0">
		<cfelse>	
		    <!--- does not requires clearance, so set to 1 immediately ---> 
		    <cfset clr = "1">
		</cfif>	
							
		<cfif form.incumbency eq "0">
		
			<!--- no checkup for incumbency = 0  --->
		
		<cfelse>
						
			<cfinclude template="AssignmentConflictCheck.cfm"> 
	
			<!--- result of conflict check --->
																	
			<cfif conflict eq "1">
			     <cfabort>
			</cfif>
		
		</cfif>
				
		<cftransaction action="BEGIN">		
		
		<cfset wf = "0"> 
		
		<cfif check.AssignmentStatus eq "0">
		
				<!--- we allow for a plain edit of this draft record --->
		
				<cfquery name="UpdateAssignment" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 UPDATE PersonAssignment
			    	 SET    DateEffective   = #STR#,
						    DateExpiration  = #END#,
							LocationCode    = '#Form.LocationCode#',
							Incumbency      = '#Form.Incumbency#',
							AssignmentClass = '#Form.AssignmentClass#',
					        AssignmentType  = '#Form.AssignmentType#',							
							<cfif Form.ExpirationListCode neq "">
								ExpirationCode     = '#Form.ExpirationCode#',
								ExpirationListCode = '#Form.ExpirationListCode#',
						   </cfif>
						    Remarks         = '#Form.Remarks#'
			    	 WHERE  AssignmentNo    = '#Form.AssignmentNo#'
			    </cfquery>	 
											
		<cfelseif Mandate.MandateStatus eq "1"> <!--- approved --->
							   				
				<!--- ----------------------------------------------------------- --->					
				<!--- determine the type of personnel action if mandate is closed --->
				<!--- ----------------------------------------------------------- --->
				 
				<cfset wf       = "0"> 
				<cfset Action   = "">
				<cfset dbAction = "update">
				
				<cfif Form.DateExpiration lt DateFormat(Check.DateExpiration,CLIENT.DateFormatShow)>
				      <!--- expiration --->
					  <cfset Action = "0001">
				</cfif>	 
					
				<cfif Form.DateExpiration gt DateFormat(Check.DateExpiration,CLIENT.DateFormatShow)>
				      <!--- reassigned/extension --->
					  <cfset Action = "0004">
				</cfif>	 
				
				<cfif Form.DateEffective neq DateFormat(Check.DateEffective,CLIENT.DateFormatShow)>
				      <!--- change effectibe date : treat carefully --->
					  <cfset Action = "0005">
				</cfif>	   
				
				<!--- Did the PersonAssignmentGroup changed?--->
				<cfquery name="CheckGroup" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT  *
					 FROM    PersonAssignmentGroup
					 WHERE   AssignmentNo = '#Check.AssignmentNo#'
					 AND     PositionNo   = '#Check.PositionNo#'
					 AND     PersonNo     = '#Check.PersonNo#'
				</cfquery>					
				
				<cfif Form.positiongroup eq "" and CheckGroup.recordcount eq 0>
					<cfset groupChange = 0>
				<cfelse>
					<cfset groupChange = 1>
				</cfif>				
				
				<cfif Check.FunctionNo neq Form.FunctionNo 
				                  OR
			          Check.OrgUnit neq Form.OrgUnit
					   			  OR
			          Check.LocationCode neq Form.LocationCode
								  OR
			          Check.AssignmentClass neq Form.AssignmentClass
					   			  OR					   			  
			          Check.Incumbency neq Form.Incumbency
					  			  OR
					  groupChange eq 1>
					  
					  <!--- change of assignment, unit and function is not possible anymore, just incumbency
					  PENDING : disable the change of the assignment class here --->
					  
					     <cfset Action   = "0002">
					     <cfset dbAction = "create">
						 
				</cfif>	
				
				<cfparam name="Form.EditExpiration" default="0">
												
				<cfif action eq "" and Form.EditExpiration eq "0">
					
					<cfoutput>
				
					<script>
						alert("It appears you have not applied any changes to this record.\nNo amendment has been recorded.")		
						ptoken.location("AssignmentEdit.cfm?id=#check.PersonNo#&id1=#Form.AssignmentNo#&Template=Assignment")																		
					</script>
					
					</cfoutput>
				
					<cfabort>				
				
				</cfif>
							
				<cfset ass = Form.AssignmentNo>
				
				<!--- TRANSFER to other position generates a PA action --->
								
				<cfif url.source eq "TFR">
				  					 
					<cfset Action   = "0006">	
					
					<cfquery name="thisAction" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Ref_Action
						 WHERE    ActionCode = '#action#'  						
					</cfquery>					
					
					<cfset actionlabel = "#thisaction.description#">					
					
  				    <cfset dbAction = "create">
					 						
					<!--- try to genetate a workflow and if this is enabled set the status = 0
					 as it will need to be cleared --->
					 
					  <cfquery name="CheckPostType" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Ref_PostType 
						 WHERE    PostType       = '#check.PostType#'  						
					</cfquery>
					 
					 <cfquery name="CheckMission" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Organization.dbo.Ref_EntityMission 
						 WHERE    EntityCode     = 'Assignment'  
						 AND      Mission        = '#Form.Mission#' 
					</cfquery>
					
					 <cfif CheckMission.WorkflowEnabled eq "0" 
						      	or  CheckMission.recordcount eq "0" 
								or  CheckPostType.enableworkflow eq "0">
								
						<cfset wf = 0>
						<cfset st = clr>
								 
					 <cfelse>
					 
					    <cfset wf = 1>
						<cfset st = 0>  
						
					 </cfif>	
					 
				<!--- CHANGE of post/title always generates a PA action --->	 
					 
				<cfelseif url.source eq "Change">
				  					 
					<cfset Action   = "0007">	
										
					<cfquery name="thisAction" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Ref_Action
						 WHERE    ActionCode = '#action#'  						
					</cfquery>					
					
					<cfset actionlabel = "#thisaction.description#">		
					
  				    <cfset dbAction = "create">
					 						
					<!--- try to genetate a workflow and if this is enabled set the status = 0
					 as it will need to be cleared --->
					 
					 <cfquery name="CheckPostType" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Ref_PostType 
						 WHERE    PostType       = '#check.PostType#'  						
					 </cfquery>
					
					 <cfquery name="CheckMission" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Organization.dbo.Ref_EntityMission 
						 WHERE    EntityCode     = 'Assignment'  
						 AND      Mission        = '#Form.Mission#' 
					</cfquery>
					
					 <cfif CheckMission.WorkflowEnabled eq "0"  <!--- disabled --->
						      	or  CheckMission.recordcount eq "0" <!--- not defined --->
								or  CheckPostType.enableworkflow eq "0">
								
						<!--- no workflow --->		
								
						<cfset wf = 0>
						<cfset st = clr>
								 
					 <cfelse>
					 
					    <cfset wf = 1>
						<cfset st = 0>  
						
					 </cfif>	
					 		 
				<cfelse>
									
					<cfquery name="Parameter" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM  Ref_ParameterMission
						WHERE Mission   = '#check.MissionOperational#'
					</cfquery>
					
					<!--- new mode to enable the workflow ---> 
				
					<cfif Parameter.AssignmentClear eq "2">	
										   											
						<cfquery name="thisAction" 
						 datasource="AppsEmployee"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT   *
							 FROM     Ref_Action
							 WHERE    ActionCode = '#action#'  						
						</cfquery>					
						
						<cfset actionlabel = "#thisaction.description#">					
						
	  				    <cfset dbAction = "create">
						 						
						<!--- try to genetate a workflow and if this is enabled set the status = 0
						 as it will need to be cleared --->
						 
						<cfquery name="CheckPostType" 
						 datasource="AppsEmployee"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT   *
							 FROM     Ref_PostType 
							 WHERE    PostType = '#check.PostType#'  						
						</cfquery>
												
						<cfif CheckPostType.enableworkflow eq "0">
						 				
							<!--- Direct mode or simple clearance --->
												 									
							<cfset wf = 0>
							<cfset st = clr>
									 
						<cfelse>
						 
						    <cfset wf = 1>
							<cfset st = 0>  
							
						</cfif>	 					
					
					<cfelse>
				
						<!--- Direct mode or simple clearance --->
																
						<cfif action eq "">
						
							 <!--- always set to cleared, exceptional situation --->
							 <cfset st = "1">
							 <cfset wf = 0>
						
						<cfelse>
							
							<!--- see above --->					
							<cfset wf = 0>
					 	 	<cfset st = clr>
										
						 </cfif>
						 
					</cfif>	 
					
				</cfif>	
												
				<!--- ------- --->
				<!--- perform --->
				<!--- ------- --->
				
								  
				<cfswitch expression="#dbAction#">
				
				<cfcase value="update">
					
				    <cfquery name="ResetPriorAssignmentRecord" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
				    	 UPDATE PersonAssignment
				    	 SET    AssignmentStatus = '9',
						        ActionReference  = #NoAct#,
								ContractId       = NULL <!--- we prevent this onwards to be controlled by the contract workflow as this is an explicit action on the incumbecny --->
				    	 WHERE  AssignmentNo     = '#Form.AssignmentNo#' 
				    </cfquery>
					
					<!--- ---------------------- --->
					<!--- 0. new assignment record  --->
					<!--- ---------------------- ---> 		
					
					 <cfquery name="getPrior" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   PersonAssignment
					 WHERE  AssignmentNo = '#Form.AssignmentNo#'					
					 </cfquery>
					 
					 <!-- the start date is the same we take the same source as it was --->
					 
					 <cfif getPrior.dateEffective lte str and getPrior.dateExpiration gte str>
					 
						 <cfset source = getPrior.source>
						 <cfset srceid = getPrior.sourceId>
						 <cfset srcper = getPrior.sourcePersonNo>
					
					 <cfelse>	 
					 
						 <cfset source = "Manual">
						 <cfset srceid = "#Form.AssignmentNo#">
						 <cfset srcper = "">
					 
					 </cfif>
					  
				    <cfquery name="InsertAssignment" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO PersonAssignment
					         (PersonNo,
							 PositionNo,
							 DateEffective,
							 DateExpiration,
							 <cfif Form.ExpirationListCode neq "">
								 ExpirationCode,
								 ExpirationListCode,
							 </cfif>
							 OrgUnit,
							 LocationCode,
							 FunctionNo,
							 FunctionDescription,
							 AssignmentStatus,
							 ActionReference, 
							 AssignmentClass,
							 AssignmentType,
							 Incumbency,
							 Remarks,
							 Source,
							 SourceId,
							 SourcePersonNo,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				      VALUES ('#Form.PersonNo#', 
					       	  '#Form.PositionNo#',
						      #STR#,
							  #END#,
							  <cfif Form.ExpirationListCode neq "">
								  '#Form.ExpirationCode#',
								  '#Form.ExpirationListCode#',
							  </cfif>
							  '#Form.OrgUnit#',
							  '#Form.LocationCode#',
							  '#Form.FunctionNo#',
							  '#Form.FunctionDescription#',
							  '#st#',
							  #NoAct#, 
							  '#Form.AssignmentClass#',
							  '#Form.AssignmentType#',
							  '#Form.Incumbency#',
							  '#Form.Remarks#',
							  '#source#',
							  '#srceid#',
							  '#srcper#',							  							  
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				    </cfquery>
					
					
					
					<!--- retrieve assignment no ---->
					
					<cfquery name="Get" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT   top 1 AssignmentNo
						 FROM     PersonAssignment
						 WHERE    PersonNo   = '#Form.PersonNo#'
						 AND      PositionNo = '#Form.PositionNo#'
						 ORDER BY AssignmentNo DESC
					</cfquery>
					
					<cfset ass = Get.AssignmentNo>
					
					<!--- 1. workflow -------------- --->
					<!--- delayed until line 829 to omit the cftransaction --- --->											
					
					<!--- 2. personnel action--- --->		
					
					<cfif Action neq "">		
						   
					    <cfquery name="LogAction" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     INSERT INTO EmployeeAction
						        (ActionDocumentNo,
								 ActionCode,
								 ActionDate,
								 ActionPersonNo,
								 ActionSource,
								 ActionSourceNo,
								 ActionDescription,
								 Mission,
								 MandateNo,
								 Posttype,
								 ActionStatus,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						      VALUES (#NoAct#,
									 '#Action#',
									 '#DateFormat(STR,CLIENT.DateSQL)#',
									 '#Form.PersonNo#',
									 'Assignment',
									 '#ass#',  <!--- main record which has the wf --->
									 '',
									 '#Form.Mission#',
									 '#Form.MandateNo#',
									 '#Check.PostType#',
									 '#clr#',
									 '#SESSION.acc#',
							    	 '#SESSION.last#',		  
								  	 '#SESSION.first#')
						 </cfquery>
				 
						<!--- -------------------------------------------- --->					
						<!--- --link affected records to personnel action- --->
						<!--- -------------------------------------------- --->				
					
						<cfset link = "Staffing/Application/Assignment/AssignmentActionView.cfm?ActionReference=#NoAct#">
												
						<cfquery name="InsertPALines" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO EmployeeActionSource
							        (ActionDocumentNo, 
									 PersonNo,
									 ActionSource,
									 ActionSourceNo,
									 ActionStatus,
									 ActionLink)
					      SELECT  ActionReference, 
						          PersonNo, 
								  'Assignment', 
								  AssignmentNo, 
								  AssignmentStatus,
								  '#link#'
						  FROM    PersonAssignment
					      WHERE   ActionReference = '#NoAct#'	
					    </cfquery>
					
					</cfif>
			   
				</cfcase> 
				
				<cfcase value="create">
									
					<!--- current assignment to deleted --->	
				
				    <cfquery name="UpdateCurrentAssignment" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
				    	 UPDATE PersonAssignment
				    	 SET    AssignmentStatus = '9',
						        ActionReference = #NoAct#, 
								ContractId      = NULL <!--- we prevent this onwards to be controlled by the contract workflow as this is an explicit action on the incumbecny --->
				    	 WHERE  AssignmentNo = '#Form.AssignmentNo#' 
				    </cfquery>	
					
					 <cfquery name="getPrior" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						 SELECT *
						 FROM   PersonAssignment
						 WHERE  AssignmentNo = '#Form.AssignmentNo#'
					 </cfquery>				
					
					<!--- create record for period until current date --->
					
					 <cfif getPrior.dateEffective lte str and getPrior.dateExpiration gte str>
					 
						 <cfset source = getPrior.source>
						 <cfset srceid = getPrior.sourceId>
						 <cfset srcper = getPrior.sourcePersonNo>
					
					 <cfelse>	 
					 
						 <cfset source = "Manual">
						 <cfset srceid = "#Form.AssignmentNo#">
						 <cfset srcper = "">
					 
					 </cfif>
					 
					 <cfquery name="Checkme" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					      SELECT * 
						  FROM   PersonAssignment
					      WHERE  AssignmentNo = '#Form.AssignmentNo#'	
						  AND    DateEffective < #STR#-1
					</cfquery>	  
					
					<!---
					<cfoutput>
					<script>alert('#checkme.recordcount#-#Form.AssignmentNo#-#dateformat(str,client.dateformatshow)#')</script>
					</cfoutput>
					<cfabort>
					--->
					
					<cfif checkme.recordcount gte "1">
					 							
						<cfquery name="InsertAssignment1" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 
						     INSERT INTO PersonAssignment
						         (PersonNo,
								 PositionNo,
								 DateEffective,
								 DateExpiration,
								 OrgUnit,
								 LocationCode,
								 FunctionNo,
								 FunctionDescription, 
								 AssignmentStatus,
								 ActionReference,
								 AssignmentClass,
								 AssignmentType,
								 Incumbency,
								 Remarks,
								 Source,
								 SourceId,
								 SourcePersonNo,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
								 
							  SELECT PersonNo, 
							         PositionNo, 
									 DateEffective, 
									 #STR#-1, 
								     OrgUnit, 
									 LocationCode, 
									 FunctionNo,
								     FunctionDescription, 
									 '#st#', 
									 #NoAct#, 
									 AssignmentClass, 
									 AssignmentType, 
									 Incumbency, 
									 Remarks, 
									 '#source#',
								     '#srceid#',
								     '#srcper#',		
								     '#SESSION.acc#', 
									 '#SESSION.last#', 
									 '#SESSION.first#'
							  FROM   PersonAssignment
						      WHERE  AssignmentNo = '#Form.AssignmentNo#'	
							  AND    DateEffective < #STR#-1 <!--- prevent creating records with 0 dates --->
					    </cfquery>
					
						<cfquery name="Class" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						   	 SELECT   * 
							 FROM     Ref_AssignmentClass
							 WHERE    AssignmentClass = '#Position.AssignmentClass#'				   	 
						</cfquery>
					
						<cfif class.PositionOwner eq "1">
						
							<!--- New : add in case of owner assignment a 0 percent record as well --->
										
							<cfquery name="InsertAssignmentLien" 
						     datasource="AppsEmployee" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
							     INSERT INTO PersonAssignment
							         (PersonNo,
									 PositionNo,
									 DateEffective,
									 DateExpiration,
									 OrgUnit,
									 LocationCode,
									 FunctionNo,
									 FunctionDescription, 
									 AssignmentStatus,
									 ActionReference,
									 AssignmentClass,
									 AssignmentType,
									 Incumbency,
									 Remarks,
									 Source,
								     SourceId,
								     SourcePersonNo,
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName)
								  SELECT PersonNo, 
								         PositionNo, 
										 #STR#,
									     #END#,
									     OrgUnit, 
										 LocationCode, 
										 FunctionNo,
									     FunctionDescription, 
										 '#st#', 
										 #NoAct#, 
										 AssignmentClass, 
										 AssignmentType, 
										 '0', 
										 'Lien assignment', 
										 '#source#',
								         '#srceid#',
								          '#srcper#',		
									     '#SESSION.acc#', 
										 '#SESSION.last#', 
										 '#SESSION.first#'
								  FROM  PersonAssignment
							      WHERE AssignmentNo = '#Form.AssignmentNo#'						
						    </cfquery>
							
						</cfif>	
						
					</cfif>	
					
					<!--- create record for period for new date --->
				   
				    <cfquery name="InsertAssignment2" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO PersonAssignment
					         (PersonNo,
							 PositionNo,
							 DateEffective,
							 DateExpiration,
							 <cfif Form.ExpirationListCode neq "">
									 ExpirationCode,
									 ExpirationListCode,
							 </cfif>
							 OrgUnit,
							 LocationCode,
							 FunctionNo,
							 FunctionDescription,
							 AssignmentStatus,
							 ActionReference, 
							 AssignmentClass,
							 AssignmentType,
							 Incumbency,
							 Remarks,
							 Source,
							 SourceId,
							 SourcePersonNo,							
						     OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					      VALUES ('#Form.PersonNo#',
					     	  '#Form.PositionNo#',
							  #STR#,
							  #END#,
							  <cfif Form.ExpirationListCode neq "">
									 '#Form.ExpirationCode#',
									 '#Form.ExpirationListCode#',
							   </cfif>
							  '#Form.OrgUnit#',
							  '#Form.LocationCode#',
							  '#Form.FunctionNo#',
							  '#Form.FunctionDescription#',
							  '#st#',
							  #NoAct#, 
							  '#Form.AssignmentClass#',
							  '#Form.AssignmentType#',
							  '#Form.Incumbency#',
							  '#Form.Remarks#',
							  '#source#',
							  '#srceid#',
							  '#srcper#',	
							  
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				    </cfquery>
													
					<!--- retrieve assignment no ---->
					
					<cfquery name="Get" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT   TOP 1 AssignmentNo
						 FROM     PersonAssignment
						 WHERE    PersonNo   = '#Form.PersonNo#'
						 AND      PositionNo = '#Form.PositionNo#'
						 ORDER BY AssignmentNo DESC
					</cfquery>
					
					<cfset ass = Get.AssignmentNo>
					
					<!--- 1. workflow-------- --->
					<!--- delayed until below --->	
					<!--- ------------------- --->
														
					<cfset link = "Staffing/Application/Authorization/Staffing/TransactionViewDetail.cfm?ActionReference=#NoAct#">
					
					<!--- 2. personnel action --->				
						   
				    <cfquery name="LogAction" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO EmployeeAction
						        (ActionDocumentNo,
								 ActionCode,
								 ActionPersonNo,
								 ActionSource,
								 ActionSourceNo,
								 ActionDescription,
								 Mission,
								 MandateNo,
								 Posttype,
								 ActionStatus,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName,
								 ActionDate)
					      VALUES 
							    (#NoAct#,
								 '#Action#',
								 '#Form.PersonNo#',
								 'Assignment',
								 '#ass#',  <!--- main record which has the wf --->
								 '',
								 '#Form.Mission#',
								 '#Form.MandateNo#', 
								 '#Check.PostType#',
								 '#clr#',
								 '#SESSION.acc#',
						    	 '#SESSION.last#',		  
							  	 '#SESSION.first#',
								 '#DateFormat(STR,CLIENT.DateSQL)#')
					 </cfquery>
										
					<cfquery name="InsertDetails" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO EmployeeActionSource
						        (ActionDocumentNo, 
								 PersonNo,
								 ActionSource,
								 ActionSourceNo,
								 ActionStatus,
								 ActionLink)
					       SELECT ActionReference, 
						          PersonNo, 
								  'Assignment', 
								  AssignmentNo, 
								  AssignmentStatus,
								  '#link#'
						  FROM  PersonAssignment
					      WHERE ActionReference = #NoAct#	
				    </cfquery>
			 	
				</cfcase>
				
				</cfswitch>				
			
		<cfelse> <!--- Mandate is in DRAFT MODE no special action --->
		
			<cfif Check.FunctionNo neq Form.FunctionNo OR
			      Check.OrgUnit neq Form.OrgUnit>
					 
			      <!--- in case operational unit or function has changed 
				  THEN create a different entry to capture the history properly --->
					
			    <cfquery name="UpdateAssignment" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 UPDATE PersonAssignment
			    	 SET    DateExpiration = #STR#-1
			    	 WHERE  AssignmentNo   = '#Form.AssignmentNo#'
			    </cfquery>	
				
				<cfquery name="DeleteAssignment" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 DELETE PersonAssignment
			    	 WHERE  DateExpiration <= DateEffective
			    	 AND    AssignmentNo    = '#Form.AssignmentNo#'
			    </cfquery>	
			   
			    <cfquery name="InsertAssignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PersonAssignment
			         (PersonNo,
					 PositionNo,
					 DateEffective,
					 DateExpiration,
					 <cfif Form.ExpirationListCode neq "">
						ExpirationCode,
						ExpirationListCode,
					 </cfif>
					 OrgUnit,
					 LocationCode,
					 FunctionNo,
					 FunctionDescription,
					 AssignmentStatus,
					 AssignmentClass,
					 AssignmentType,
					 Incumbency,
					 Remarks,
					 SourceId,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#Form.PersonNo#',
			       	  '#Form.PositionNo#',
				      #STR#,
					  #END#,
					  <cfif Form.ExpirationListCode neq "">
						 '#Form.ExpirationCode#',
						 '#Form.ExpirationListCode#',
				      </cfif>
					  '#Form.OrgUnit#',
					  '#Form.LocationCode#',
					  '#Form.FunctionNo#',
					  '#Form.FunctionDescription#',
					  '0',
					  '#Form.AssignmentClass#',
					  '#Form.AssignmentType#',
					  '#Form.Incumbency#',
					  '#Form.Remarks#',
					  '#Form.AssignmentNo#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			    </cfquery>
				
				<!--- ass ---->
				
				<cfquery name="Get" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT TOP 1 AssignmentNo
				 FROM     PersonAssignment
				 WHERE    PersonNo = '#Form.PersonNo#'
				 AND      PositionNo = '#Form.PositionNo#'
				 ORDER BY AssignmentNo DESC
				</cfquery>
				
				<cfset ass = Get.AssignmentNo>
			 
			 <cfelse>
			 
			     <cfquery name="UpdateAssignment" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 UPDATE PersonAssignment
			    	 SET    DateEffective   = #STR#,
						    DateExpiration  = #END#,
							LocationCode    = '#Form.LocationCode#',
							Incumbency      = '#Form.Incumbency#',
							AssignmentClass = '#Form.AssignmentClass#',
					        AssignmentType  = '#Form.AssignmentType#',							
							<cfif Form.ExpirationListCode neq "">
								ExpirationCode     = '#Form.ExpirationCode#',
								ExpirationListCode = '#Form.ExpirationListCode#',
						   </cfif>
						    Remarks         = '#Form.Remarks#'
			    	 WHERE  AssignmentNo    = '#Form.AssignmentNo#'
			    </cfquery>	 
			
			 </cfif>	
			
		</cfif>		
		
		<!--- update topics --->
		
		<cfinclude template="AssignmentEditTopicSubmit.cfm">
		
		<!--- update group --->
		
		<cfquery name="ResetGroup" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE PersonAssignmentGroup
			SET    Status = '9'
			WHERE  AssignmentNo = '#ass#'
		</cfquery>
		
		<cfparam name="Form.PositionGroup" type="any" default="">
		
		<cfloop index="Item" 
		        list="#Form.PositionGroup#" 
		        delimiters="' ,">
		
			<cfquery name="VerifyGroup" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  AssignmentGroup
				FROM    PersonAssignmentGroup
				WHERE   AssignmentNo    = '#ass#' 
				AND     AssignmentGroup = '#Item#'
			</cfquery>
			
			<cfif VerifyGroup.recordCount is 1 > 
			
				<cfquery name="UpdateGroup" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE PersonAssignmentGroup
					 SET   Status = '1',
					       OfficerUserId    = '#SESSION.acc#',
						   OfficerLastName  = '#SESSION.last#',
						   OfficerFirstName = '#SESSION.first#'
					WHERE  AssignmentNo     = '#ass#' 
					AND    AssignmentGroup  = '#Item#'
				</cfquery>
			
			<cfelse>
			
				<cfquery name="InsertGroup" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO PersonAssignmentGroup 
					         (PersonNo, PositionNo, AssignmentNo,
							 AssignmentGroup,
							 Status,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#Form.PersonNo#','#Form.PositionNo#', '#Ass#',
					      	  '#Item#',
						      '1',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
			    </cfquery>
						  
			</cfif>
		
		</cfloop>					
		
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   Ref_ParameterMission
			WHERE  Mission   = '#Form.Mission#'
		</cfquery>
		
		<cfif Parameter.EnableMissionPeriod eq "1">
			<!--- <cfinclude template="AssignmentMissionEntry.cfm">		--->
			<cf_AssignmentMissionEntry PersonNo = "#Form.PersonNo#" Mission="#Form.Mission#">
		</cfif>
		
		<cfinclude template="AssignmentMissionExtension.cfm">
		
		</cftransaction>
				
		<!--- ----------------------------------------------------------- --->
		<!--- workflow generation, if this is enaqbled ------------------ --->
		<!--- ----------------------------------------------------------- --->
				
		<cfif wf eq "1">
								 								 
			 <cfquery name="Person" 
			 	datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
					SELECT *
					FROM   Person
					WHERE  PersonNo = '#Form.PersonNo#' 
		 	  </cfquery>
			  
			  <cfquery name="wfclass" 
			 	datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
					SELECT *
					FROM   Ref_Action
					WHERE  ActionCode = '#action#' 
		 	  </cfquery>
											
			  <!--- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --->
			  <!--- define a link for my clearances --->
			   				  					
			  <cfset link = "Staffing/Application/Employee/PersonView.cfm?ID=#Form.PersonNo#&template=position">
			
			  <cf_ActionListing 
				    EntityCode       = "Assignment"
					EntityClass      = "#wfclass.EntityClass#"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#Form.mission#"
					PersonNo         = "#Form.PersonNo#"											
					ObjectReference  = "#actionlabel#"
					ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
					ObjectFilter     = "#action#"
				    ObjectKey1       = "#ass#"							
					ObjectURL        = "#link#"
					Show             = "No"> 
															
		</cfif>		
				
		<!--- pending perform a final consistency check for this person, 
		      record problem in exception table --->
			
</cfif>

<!--- ------------------ --->
<!--- record a new track --->
<!--- ------------------ --->

<cfparam name="Form.EntityClass" default="">

<cfif Form.EntityClass neq "">
    <cfinclude template="AssignmentEditSubmitTrack.cfm">	
</cfif>

<!--- refresh the screen --->

<cfoutput>

	<script LANGUAGE = "JavaScript">
	
				 
	 try { 	   
	 
	   parent.opener.parent.details('e#form.OrgUnit#','#form.OrgUnit#','show')		
	   } catch(e) {}
	  		
	 try {    
	 								 
		 se = parent.opener.document.getElementById("refresh_#URL.box#")				 
		 if (se) {				     	    		 
			 se.click();						 			
		     } else {						
			 parent.opener.history.go();			 
			 }
			 
		 } catch(e) {
		   
		    try { parent.opener.history.go(); } catch(e) {}
	  }	 
	  // close this window	   
	  parent.window.close();	  
		  
	</script>
	
</cfoutput>	

