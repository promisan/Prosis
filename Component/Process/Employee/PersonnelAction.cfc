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

<!--- 
   Name : /Component/Process/Program.cfc
   Description : Execution procedures
   
   1.1.  Record an action without details 
   1.2.  Record an action with field specification
   1.3.  Record an action with record reference      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Personnel Action">

	<cffunction name="getEOD"
             access="public"
             returntype="any"
             displayname="Return EOD date of staffmember">

			<cfargument name="Mode"       type="string" required="true"   default="View">			
			<cfargument name="PersonNo"   type="string" required="true"   default="">
			<cfargument name="Mission"    type="string" required="true"   default="">
			<cfargument name="Type"       type="string" required="true"   default="Last">
			<cfargument name="SelDate"    type="string" required="true"   default=""> <!--- euro format --->
			
			<cfif seldate neq "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#seldate#">
				<cfset dte = dateValue>
			</cfif>
							
			<cfquery name="EOD" 
				 datasource="AppsEmployee" 					 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
									
					 SELECT  <cfif Type eq "Last">MAX(DateEffective)<cfelse>MIN(DateEffective)</cfif> as EODDate	
					 FROM    PersonContract					 
					 WHERE   PersonNo 	= '#Personno#'
					 AND     Mission 	= '#Mission#' 
					 <cfif seldate neq "">
					 AND     DateExpiration <= #dte#
					 </cfif>
					 AND     ActionCode IN
					               (SELECT   ActionCode
					                FROM     Ref_Action
			    		            WHERE    ActionSource = 'Contract' 
					 			    AND      ActionInitial = '1') 
					 AND     ActionStatus != '9'				
					    
				</cfquery>		
						
													
				<cfif EOD.EODDate neq "">			
				
						<cfreturn EOD.EODDate>
						
				<cfelse>

					<cfquery name="EOD2" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 
					 SELECT  <cfif Type eq "Last">MAX(DateEffective)<cfelse>MIN(DateEffective)</cfif> as EODDate				
					 FROM    PersonContract
					 WHERE   PersonNo 	= '#Personno#'
					 AND     Mission 	= '#Mission#' 
					 <cfif seldate neq "">
					 AND     DateExpiration <= #dte#
					 </cfif>
					 AND     ActionCode IN
					               (SELECT   ActionCode
					                FROM     Ref_Action
					                WHERE    ActionSource  = 'Contract' 
					 			    AND      ActionInitial = '1') 
					 AND     ContractId IN (SELECT ActionSourceId 
					                        FROM   EmployeeAction 
					                        WHERE  ActionStatus != '9')  		
																
					</cfquery>
					
					<cfif EOD2.EODDate neq "">
					
						<cfreturn EOD2.EODDate>
						
					<cfelse>
					
						<cfquery name="qPerson" 
						 datasource="AppsEmployee" 								
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	 SELECT  *
							 FROM Person
							 WHERE PersonNo 	= '#PersonNo#'
						</cfquery>					
						
						<cfif qPerson.OrganizationStart neq "">
						
							<cfreturn qPerson.OrganizationStart>
							
						<cfelse>
						
							<cfquery name="qAssignment" 
							 datasource="AppsEmployee" 									 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">							 
							   SELECT   MIN(PA.DateEffective) as DateEffective
					           FROM     PersonAssignment PA, Position P
					           WHERE    PA.PersonNo     = '#PersonNo#'
							   AND      PA.PositionNo   = P.PositionNo
							   AND      P.Mission       = '#Mission#'							   
							   AND      PA.AssignmentStatus IN ('0','1')				  
							</cfquery>					
							
							<cfif qAssignment.recordcount gte 1>		
														
								<cfreturn qAssignment.DateEffective>
								
							<cfelse>
							
								<cfreturn qPerson.Created>	
								
							</cfif>	
							
						</cfif>	
						
					</cfif>
								
			   </cfif>
				

	</cffunction>
	
	<cffunction name="getGrade"
             access="public"
             returntype="any"
             displayname="Return EOD date of staffmember">

			<cfargument name="Mode"       type="string" required="true"   default="View">			
			<cfargument name="PersonNo"   type="string" required="true"   default="">
			<cfargument name="Mission"    type="string" required="true"   default="">
			<cfargument name="Type"       type="string" required="true"   default="Last">
			<cfargument name="SelDate"    type="string" required="true"   default=""> <!--- euro format --->
			
			<cfif seldate neq "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#seldate#">
				<cfset dte = dateValue>
			</cfif>
						
						
			<cfquery name="GradeSPA" 
				 datasource="AppsEmployee" 					 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
									
					 SELECT  TOP 1 *	
					 FROM    PersonContractAdjustment					 
					 WHERE   PersonNo 	= '#Personno#'
					 AND     ContractId IN (SELECT ContractId 
					                        FROM   PersonContract 
											WHERE  PersonNo = '#PersonNo#' 
											AND    Mission = '#Mission#') 
					 <cfif seldate neq "">
					 AND     DateEffective <= #dte# and DateExpiration >= #dte#
					 </cfif>					 
					 AND     ActionStatus != '9'	
					 ORDER BY DateEffective							    
			</cfquery>		
			
			<cfif gradeSPA.recordcount gte "1">
			
				<cfreturn SPA.PostAdjustmentLevel>	
			
			<cfelse>
			
				<cfquery name="Grade" 
					 datasource="AppsEmployee" 					 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">				 
										
						 SELECT  TOP 1 *	
						 FROM    PersonContract					 
						 WHERE   PersonNo 	= '#Personno#'
						 AND     Mission 	= '#Mission#' 
						 <cfif seldate neq "">
						 AND     DateEffective <= #dte#
						 </cfif>					 
						 AND     ActionStatus != '9'	
						 ORDER BY DateEffective			
						    
				</cfquery>	
				
				<cfreturn Grade.ContractLevel>	 
				
			</cfif>					

	</cffunction>
	
	<cffunction name="ActionRecord"
             access="public"
             returntype="any"
             displayname="Record Personnel Action for field changes">
		
		<cfargument name="PersonNo"           type="string" required="true"  default="">
		<cfargument name="ActionStatus"       type="string" required="true"  default="0">		
		
		<cfargument name="Mission"            type="string" required="true"  default="">
				
		<!--- field changes --->		
		<cfargument name="ActionCode1"        type="string" required="false" default="">
		<cfargument name="Field1"             type="string" required="false" default="">		
		<cfargument name="Field1New"          type="string" required="false" default="">
		<cfargument name="Field1Old"          type="string" required="false" default="">		
		<cfargument name="Field1Effective"    type="string" required="true"  default="">
		<cfargument name="Field1Description"  type="string" required="true"  default="">
		
		<cfargument name="ActionCode2"        type="string" required="false" default="">
		<cfargument name="Field2"             type="string" required="false" default="">
		<cfargument name="Field2New"          type="string" required="false" default="">
		<cfargument name="Field2Old"          type="string" required="false" default="">		
		<cfargument name="Field2Effective"    type="string" required="true"  default="">
		<cfargument name="Field2Description"  type="string" required="true"  default="">
		
		<cfargument name="ActionCode3"        type="string" required="false" default="">
		<cfargument name="Field3"             type="string" required="false" default="">
		<cfargument name="Field3New"          type="string" required="false" default="">
		<cfargument name="Field3Old"          type="string" required="false" default="">		
		<cfargument name="Field3Effective"    type="string" required="true"  default="">
		<cfargument name="Field3Description"  type="string" required="true"  default="">
		
		<cfargument name="ActionCode4"        type="string" required="false" default="">
		<cfargument name="Field4"             type="string" required="false" default="">
		<cfargument name="Field4New"          type="string" required="false" default="">
		<cfargument name="Field4Old"          type="string" required="false" default="">		
		<cfargument name="Field4Effective"    type="string" required="true"  default="">
		<cfargument name="Field4Description"  type="string" required="true"  default="">
		
		<cfargument name="ActionCode5"        type="string" required="false" default="">
		<cfargument name="Field5"             type="string" required="false" default="">
		<cfargument name="Field5New"          type="string" required="false" default="">
		<cfargument name="Field5Old"          type="string" required="false" default="">		
		<cfargument name="Field5Effective"    type="string" required="true"  default="">
		<cfargument name="Field5Description"  type="string" required="true"  default="">
		
		<cfargument name="ActionCode6"        type="string" required="false" default="">
		<cfargument name="Field6"             type="string" required="false" default="">
		<cfargument name="Field6New"          type="string" required="false" default="">
		<cfargument name="Field6Old"          type="string" required="false" default="">		
		<cfargument name="Field6Effective"    type="string" required="true"  default="">
		<cfargument name="Field6Description"  type="string" required="true"  default="">
		
		<!--- --------------------------------------------- --->
		<!--- check if the personnel action mode is enabled --->
		<!--- --------------------------------------------- --->
		
		<cfquery name="Parameter" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Parameter					
		</cfquery>
		
		<cfif Parameter.actionMode eq "1">
						
			<cfif mission eq "">
			
				<!--- if entity is not found track the entity bases on the on-boarding --->
				 
				 <cfquery name="OnBoard" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   TOP 1 P.*
					 FROM     PersonAssignment PA, Position P
					 WHERE    PersonNo             = '#PersonNo#'
					 AND      PA.PositionNo        = P.PositionNo					 
					 AND      PA.AssignmentStatus IN ('0','1')
					 AND      PA.AssignmentClass   = 'Regular'
					 AND      PA.AssignmentType    = 'Actual'
					 AND      PA.Incumbency        = '100'  
					 ORDER BY PA.DateEffective DESC
				</cfquery>
				
				<cfset mission = Onboard.Mission>
		
			</cfif>		
			
			<cfif mission eq "">
			
				<!--- if entity is not found track the entity bases on the contract --->
				 
				 <cfquery name="OnContract" 
				 datasource="AppsEmployee"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   TOP 1 *
					 FROM     PersonContract
					 WHERE    PersonNo     = '#PersonNo#'					
					 AND      Mission is not NULL
					 AND      ActionStatus != '9'		
					 ORDER BY DateEffective DESC		
				</cfquery>
				
				<cfset mission = OnContract.Mission>
		
			</cfif>		
						
			<!--- track field changes --->
			
			<cfset prioract = ""> 
						 			 
			<cfloop index="itm" from="1" to="6">
			
				<cfset act = evaluate("ActionCode#itm#")>				
				<cfset fld = evaluate("Field#itm#")>
				<cfset new = evaluate("Field#itm#new")>
				<cfset old = evaluate("Field#itm#old")>
				<cfset eff = evaluate("Field#itm#Effective")>
				<cfset des = evaluate("Field#itm#Description")>
				
				<cfquery name="get" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     Ref_Action
						 WHERE    ActionCode = '#act#'			
				</cfquery>
				
				<cfif get.Operational eq "1">
					
					<cfif eff eq "">
			
						<cfset dateValue = "">
						<CF_DateConvert Value="#dateformat(now(),CLIENT.DateFormatShow)#">
			
					<cfelse>
	
						<cfset dateValue = "">
						<CF_DateConvert Value="#eff#">
				
					</cfif>
					
					<cfset eff = dateValue>
									
					<cfif find("{d",new)>
						  <cfset tpe = "date">
					<cfelse>
						  <cfset tpe = "text">  
					</cfif>								
									
					<cfif act neq "" and (old neq new or fld eq "record") and act neq prioract> 
					
						<cfquery name="ActionCode" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
								 SELECT *  
								 FROM   Ref_Action
								 WHERE  ActionCode = '#act#'
						</cfquery>
						
						<cfquery name="GetLastNumber" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
								 SELECT * FROM Parameter
						</cfquery>
						 
						<cfset NoAct = GetLastNumber.ActionNo + 1>
				 
						<cfquery name="GetLastNumber" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
								 UPDATE Parameter
								 SET    ActionNo = #NoAct#
						</cfquery>								
									
						<cf_assignId>	
						
						<cfif len(des) gt "300">
							 <cfset des = left(des,300)>
						</cfif>	
											
						<cfquery name="InsertAction" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     INSERT INTO EmployeeAction 
							         (ActionDocumentNo,
									 Mission,
									 ActionPersonNo,
									 ActionDate,
									 ActionCode,
									 ActionSource,
									 ActionSourceId,
									 ActionStatus,
									 ActionDescription,
									 NodeIP,							
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName)
						      VALUES (
							      '#NoAct#',
								  '#Mission#',
						          '#PersonNo#',
								  #eff#,
								  '#act#',
								  '#ActionCode.ActionSource#',	
								  '#rowguid#',			  
								  '#ActionStatus#',
								  '#des#',
								  '#CGI.Remote_Addr#',							  
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#') 
					     </cfquery>
						 
						 <cfset prioract = act>
						 
					</cfif>
									
					<cfif act neq "" and (old neq new or fld eq "record")> 
						 							 		 
						<cfif fld neq "" and fld neq "record">
								 
							  <cfif new neq "" or old neq "">
								 
								 	<cfquery name="InsertSource" 
								     datasource="AppsEmployee" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">
									     INSERT INTO EmployeeActionSource 
									         (ActionDocumentNo,
											 PersonNo,						
											 ActionSource,
											 ActionStatus,
											 ActionField,
											 ActionFieldEffective,
											 ActionFieldValue)
									      VALUES (
										      '#NoAct#',
									          '#PersonNo#',
											  '#ActionCode.ActionSource#',				  
											  '1',  
											  '#fld#',
											  #eff#,
											  <cfif tpe eq "date">#new#<cfelse>'#new#'</cfif>  )
											
								     </cfquery>
									 
									 <cfif old neq "">					 
									 
										 <cfquery name="InsertSource" 
									     datasource="AppsEmployee" 
									     username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
										     INSERT INTO EmployeeActionSource 
										         (ActionDocumentNo,
												 PersonNo,						
												 ActionSource,
												 ActionStatus,
												 ActionField,
										   	     ActionFieldValue)
										      VALUES (
											      '#NoAct#',
										          '#PersonNo#',
												  '#ActionCode.ActionSource#',				  
												  '9',
												  '#fld#',
											      '#old#')
									     </cfquery>								 		 
									 
									 </cfif>
									 
							</cfif> 
							
						</cfif>	
								
					 </cfif>		
					 
				</cfif> 			 
		 
			 </cfloop> 
			 
		 </cfif> 									
		
	</cffunction>	
		
	<cffunction name="ActionDocument"
             access="public"
             returntype="any"
             displayname="Record Personnel Action for records">
		
		<cfargument name="DataSource"          type="string" required="true"  default="appsEmployee">		
		<cfargument name="ActionDocumentNo"    type="string" required="true"  default="">
		<cfargument name="PersonNo"            type="string" required="true"  default="">
		<cfargument name="ActionStatus"        type="string" required="true"  default="1">
		<cfargument name="DetailStatus"        type="string" required="false" default="1">	
		<cfargument name="ActionDate"          type="string" required="true"  default="#dateformat(now(),CLIENT.DateFormatShow)#">
		<cfargument name="ActionCode"          type="string" required="true"  default="">
		<cfargument name="ActionDescription"   type="string" required="true"  default="">	
		<cfargument name="Mission"             type="string" required="true"  default="">	
		<cfargument name="ActionLink"          type="string" required="true"  default="">	
		<cfargument name="ActionSourceId"      type="string" required="true"  default="">			
		<cfargument name="ripple1"             type="string" required="true"  default="">	
		<cfargument name="ripple9"             type="string" required="true"  default="">	
		
		<cfif actiondate neq "">
		
			<cfset dateValue = "">
			<CF_DateConvert Value="#actiondate#">

		<cfelse>

			<cfset dateValue = "">
			<CF_DateConvert Value="#dateformat(now(),CLIENT.DateFormatShow)#">
	
		</cfif>
		
		<cfset DTE = dateValue>
						
		<cfquery name="Parameter" 
			 datasource="#datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Employee.dbo.Parameter					
			</cfquery>
			
		<cfif Parameter.actionMode eq "1">
			
			<cfif mission eq "">
			
				<!--- if entity is not found track the entity bases on the on-boarding --->
				 
				 <cfquery name="OnBoard" 
				 datasource="#Datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   TOP 1 P.*
					 FROM     Employee.dbo.PersonAssignment PA, Employee.dbo.Position P
					 WHERE    PersonNo = '#PersonNo#'
					 AND      PA.PositionNo = P.PositionNo					 
					 AND      PA.AssignmentStatus IN ('0','1')
					 AND      PA.AssignmentClass = 'Regular'
					 AND      PA.AssignmentType = 'Actual'
					 AND      PA.Incumbency = '100' 
					 ORDER BY PA.DateEffective DESC
				</cfquery>
				
				<cfset mission = Onboard.Mission>
		
			</cfif>		
			
			<cfif mission eq "">
			
				<!--- if entity is not found track the entity bases on the contract --->
				 
				 <cfquery name="OnContract" 
				 datasource="#DataSource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   *
					 FROM     Employee.dbo.PersonContract
					 WHERE    PersonNo = '#PersonNo#'
					 AND      DateEffective < getdate()
					 AND      DateExpiration > getDate()
					 AND      Mission is not NULL
					 AND      ActionStatus != '9'				
				</cfquery>
				
				<cfset mission = OnContract.Mission>
		
			</cfif>						
						
			<cfquery name="ActionList" 
			    datasource="#DataSource#" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					 SELECT * 
					 FROM   Employee.dbo.Ref_Action
					 WHERE  ActionCode = '#actioncode#' 
			</cfquery>
						
			<cfif actionDocumentNo neq "">
			
			    <cfset NoAct = ActionDocumentNo>
				
				<!--- update the passed effective actiondate --->
				
				<cfquery name="update" 
				    datasource="#DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					 UPDATE Employee.dbo.EmployeeAction
					 SET    ActionDate = #dte#
					 WHERE  ActionDocumentNo = '#actionDocumentNo#'					
				</cfquery>
			
			<cfelse>
			
				<cfquery name="GetLastNumber" 
				    datasource="#DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					 SELECT *  
					 FROM   Employee.dbo.Parameter
				</cfquery>
				 
				<cfset NoAct = GetLastNumber.ActionNo + 1>
		 
				<cfquery name="GetLastNumber" 
				    datasource="#DataSource#" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					 UPDATE Employee.dbo.Parameter
					 SET    ActionNo = #NoAct#
				</cfquery>
						
				<cfquery name="InsertAction" 
			     datasource="#datasource#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     INSERT INTO Employee.dbo.EmployeeAction 
				         (ActionDocumentNo,
						 Mission,
						 ActionPersonNo,
						 ActionDate,
						 ActionCode,
						 ActionSource,
						 ActionStatus,
						 ActionDescription,
						 NodeIP,				
						 ActionSourceId,				
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				      VALUES (
					      '#NoAct#',
						  '#Mission#',
				          '#PersonNo#',
						  #dte#,
						  '#Actioncode#',
						  '#ActionList.ActionSource#',				  
						  '#ActionStatus#',
						  '#ActionDescription#',
						  '#CGI.Remote_Addr#',
						  <!--- contains a link to the master record --->				 
						  '#ActionSourceId#',				 
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
			     </cfquery>
							 
			</cfif>
							 
		 	<cfquery name="InsertSource" 
		     datasource="#datasource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO Employee.dbo.EmployeeActionSource 
				       (ActionDocumentNo,
						PersonNo,						
						ActionSource, 
						ActionStatus,
						ActionSourceId,
						ActionLink)
			      VALUES ('#NoAct#',
			           '#PersonNo#',
					   '#ActionList.ActionSource#',				  
					   '#DetailStatus#',
					   '#ActionSourceId#',
					   '#ActionLink##ActionSourceId#')
		     </cfquery>
			 
			 <cfloop index="id" list="#ripple1#">
			 
					<cfquery name="InsertSource" 
				     datasource="#datasource#" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Employee.dbo.EmployeeActionSource 
				         (ActionDocumentNo,
						 PersonNo,						
						 ActionSource,
						 ActionStatus,
						 ActionSourceId,
						 ActionLink)
				      VALUES ('#NoAct#',
					          '#PersonNo#',
							  '#ActionList.ActionSource#',				  
							  '1',
							  '#id#',
							  '#ActionLink##id#')
				     </cfquery>
			 		 
			 </cfloop>
			 
			 <cfloop index="id" list="#ripple9#">
			 
			        <!--- check if the line exists then we set it as 9 otherwise we add --->
					
					<cfquery name="CheckSource" 
				     datasource="#datasource#" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 	SELECT *
						FROM Employee.dbo.EmployeeActionSource 
						WHERE ActionDocumentNo = '#NoAct#'
						AND   ActionSourceId = '#Id#'					  
				     </cfquery>
					 
					 <cfif checksource.recordcount gte "1">
					 
						 <cfquery name="CheckSource" 
					     datasource="#datasource#" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						 	UPDATE Employee.dbo.EmployeeActionSource 
							SET    ActionStatus = '9'
							WHERE  ActionDocumentNo = '#NoAct#'
							AND    ActionSourceId = '#Id#'					  
					     </cfquery>
					 
					 <cfelse>
			 
						<cfquery name="InsertSource" 
					     datasource="#datasource#" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     INSERT INTO Employee.dbo.EmployeeActionSource 
						         (ActionDocumentNo,
								 PersonNo,						
								 ActionSource,
								 ActionStatus,
								 ActionSourceId,
								 ActionLink)
						      VALUES (
							      '#NoAct#',
						          '#PersonNo#',
								  '#ActionList.ActionSource#',				  
								  '9',
								  '#id#',
								  '#ActionLink##id#')
					     </cfquery>
						 
					  </cfif>	 
			 		 
			 </cfloop>
			 
		<cfelse>
		
			<cfset NoAct = "">	 
			 		 
		</cfif>
		 
		<CFSET Caller.SourceActionNo = NoAct>
				
	</cffunction>	
	
	<cffunction name="ActionWorkflow"
             access="public"
             returntype="any"
             displayname="Record Workflow for Personnel Actions">
			 
			<cfargument name="PersonNo"    type="string" required="true" default="">
			<cfargument name="ActionCode"  type="string" required="true" default="">
			 			 
		   <cfquery name="Parameter" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Parameter					
			</cfquery>
		
			<cfif Parameter.actionMode eq "1">
					 
				 <cfquery name="Objects" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     SELECT A.*,R.Description, R.EntityClass
						 FROM   EmployeeAction A INNER JOIN Ref_Action R ON A.ActionCode = R.ActionCode
						 WHERE  A.ActionPersonNo   = '#PersonNo#'
						 AND    A.ActionSource     = 'Person'
						 AND    A.ActionDocumentNo NOT IN (SELECT ObjectKeyValue1 
						                                   FROM   Organization.dbo.OrganizationObject 
														   WHERE  EntityCode = 'PersonAction')							
						 AND    (Mission IS NOT NULL AND Mission != '')	  
						 
				  </cfquery>
				  
				  <cfquery name="Person" 
					 	datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
								SELECT *
								FROM Person
								WHERE PersonNo = '#PersonNo#' 
				  </cfquery>
				  
				  <cfloop query="Objects">
				  		 			 
					 <!--- --------------------------------------- --->
					 <!--- create a workflow object for the action --->
					 <!--- --------------------------------------- --->
					  
					  <cfset link = "#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionDialog.cfm?drillid=#ActionDocumentNo#">
			
					  <cf_ActionListing 
						    EntityCode       = "PersonAction"
							EntityClass      = "#EntityClass#"
							EntityGroup      = ""
							EntityStatus     = ""
							Mission          = "#mission#"
							PersonNo         = "#PersonNo#"
							ObjectReference  = "#Description#"
							ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
							ObjectFilter     = "PersonAction"
						    ObjectKey1       = "#ActionDocumentNo#"							
							ObjectKey4       = "#ActionSourceId#"	
							ObjectURL        = "#link#"
							Show             = "No"						
							CompleteFirst    = "No">			 						 
									 
				  </cfloop>					  
			  
			  </cfif>
			
	</cffunction>	
	
</cfcomponent>	

