
<!--- 
   Name : /Component/Employee/PositionAction.cfc
   Description : Execution procedures
   
   1.1.  Extend a position and related assignments    
      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Position Action">
	
	<cffunction name="PositionVacant" access="public" returntype="any" displayname="Get the date vacant of a position">
			 
			 <cfargument name="PositionParentId"   type="string" required="true"  default="0">
			 <cfargument name="DataSource"         type="string" required="true"  default="appsEmployee">		
			 
			 	<cfquery name="getPosition" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   Position
					 WHERE  PositionParentid = '#PositionParentId#' 
					 ORDER BY DateEffective DESC
				</cfquery>		
								 
			  <cfquery name="Post" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   PersonAssignment
					 WHERE  PositionNo      IN  (SELECT PositionNo FROM Position WHERE PositionParentid = '#PositionParentId#') 
					 AND    AssignmentStatus IN ('0','1')
					 AND    AssignmentType   = 'Actual'					 
					 AND    Incumbency       = 100
					 AND    DateEffective  <= CAST(GETDATE() AS Date) 
					 and    DateExpiration >= CAST(GETDATE() AS Date)				
					 AND    DateEffective  < '#DateFormat(getPosition.DateExpiration,client.dateSQL)#'
				</cfquery>		
				
				<cfif Post.recordcount eq "0">
				
					<cfset Vacant.Status = "Vacant">
					
					<cfquery name="Assignment" 
						 datasource="#datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 
							SELECT     PA.*
							FROM       Employee.dbo.PositionParent AS PP INNER JOIN
							           Employee.dbo.Position AS P ON PP.PositionParentId = P.PositionParentId INNER JOIN
							           Employee.dbo.PersonAssignment AS PA ON P.PositionNo = PA.PositionNo
							WHERE      PP.SourcePostNumber IN (SELECT SourcePostNumber 
							                                   FROM   PositionParent 
															   WHERE  PositionParentid = '#PositionParentId#') 
							AND        PA.AssignmentStatus IN ('0', '1') 
							AND        PA.AssignmentType = 'Actual' 
							AND        PA.AssignmentClass = 'Regular'
							ORDER BY   PA.DateExpiration DESC
						 
					 </cfquery>	
						 
					 <cfif Assignment.Incumbency eq "0">
				 
						  <cfset Vacant.Original = Assignment.DateEffective>
						 
					 <cfelseif Assignment.recordcount gte "1">
						 
					 	<cfset Vacant.Original = dateadd("d","1",Assignment.DateExpiration)>	
						
					 <cfelse>	
					 
					 <cfset Vacant.Original = "">
						 
					 </cfif>		
				
				<cfelseif Post.recordcount gte "1">
								
					<cfquery name="PostStatus" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						 SELECT *
						 FROM   PersonAssignment
						 WHERE  PositionNo      = '#getPosition.PositionNo#'
						 AND    AssignmentStatus IN ('0','1')
						 AND    AssignmentType   = 'Actual'
						 AND    AssignmentClass  = 'Regular'
						 AND    Incumbency       = 100
						 AND    DateEffective  <= CAST(GETDATE() AS Date) 
						 and    DateExpiration >= CAST(GETDATE() AS Date)				
						 AND    DateEffective  < '#DateFormat(getPosition.DateExpiration,client.dateSQL)#'
					</cfquery>	
					 
					 <cfquery name="PostLien" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
						 SELECT *
						 FROM   PersonAssignment
						 WHERE  PositionNo      = '#getPosition.PositionNo#'
						 AND    AssignmentStatus IN ('0','1')
						 AND    AssignmentType   = 'Actual'
						 AND    AssignmentClass  = 'Regular' <!--- added --->
						 AND    Incumbency = 0
						 AND    DateEffective  <= CAST(GETDATE() AS Date) 
						 and    DateExpiration >= CAST(GETDATE()-60 AS Date)		<!--- 60 days threshold --->		
						 AND    DateEffective  < '#DateFormat(getPosition.DateExpiration,client.dateSQL)#'
					</cfquery>						
						
					<cfif PostStatus.recordcount gte "1" and PostLien.recordcount eq "0">		
					
					    <cfset Vacant.Status   = "Encumbered by holder">		
						<cfset Vacant.Original = "">
									
					<cfelse>	
					
						<cfset Vacant.Status = "Encumbered">		
						
												
						 <cfquery name="Assignment" 
						 datasource="#datasource#"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 
							SELECT     PA.*
							FROM       Employee.dbo.PositionParent AS PP INNER JOIN
							           Employee.dbo.Position AS P ON PP.PositionParentId = P.PositionParentId INNER JOIN
							           Employee.dbo.PersonAssignment AS PA ON P.PositionNo = PA.PositionNo
							WHERE      PP.SourcePostNumber IN (SELECT SourcePostNumber 
							                                   FROM   PositionParent 
															   WHERE  PositionParentid = '#PositionParentId#') 
							AND        PA.AssignmentStatus IN ('0', '1') 
							AND        PA.AssignmentType = 'Actual' 
							AND        PA.AssignmentClass = 'Regular' <!--- condition for real incumbecny --->
							ORDER BY   PA.DateExpiration DESC 
						 
						 </cfquery>	
						 
						  <cfif Assignment.Incumbency eq "0">
				 
							  <cfset Vacant.Original = Assignment.DateEffective>
						 
						 <cfelseif Assignment.recordcount gte "1">
							 
						 	<cfset Vacant.Original = dateadd("d","1",Assignment.DateExpiration)>	
							
						 <cfelse>	
						 
						    <cfset Vacant.Original = "">
							 
						 </cfif>		
										
					</cfif>  			   
			 
			    </cfif>
				
				<cfreturn Vacant>
						 
    </cffunction>				 
	
	<cffunction name="PositionFunding"
             access="public"
             returntype="any"
             displayname="Record Position Extension based on the funding">
		
		<cfargument name="RequisitionNo"      type="string" required="true"  default="">
		<cfargument name="PositionParentId"   type="string" required="true"  default="0">
		<cfargument name="AssignmentAmend"    type="string" required="true"  default="Yes">		
		<cfargument name="DataSource"         type="string" required="true"  default="appsProcurement">		
		
		<!--- check if the position funding expiration is later than the position parent,
		    and update if mandate expiration is later --->
			
			<cfquery name="Funding" 
			 datasource="#datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT  max(DateExpiration) as Expiration
				 FROM    Employee.dbo.PositionParentFunding
				 WHERE   PositionParentId = '#PositionParentId#'					
				 AND     RequisitionNo IN (SELECT RequisitionNo 
				                           FROM   Purchase.dbo.RequisitionLine 
										   WHERE  ActionStatus IN ('2k','2q','3')
										  ) 
			</cfquery>	
			
			<cfquery name="PositionParent" 
			 datasource="#datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    Employee.dbo.PositionParent
				 WHERE   PositionParentId = '#PositionParentId#'					
			</cfquery>
			
			<cfquery name="Mandate" 
			 datasource="#datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    Organization.dbo.Ref_Mandate
				 WHERE   Mission = '#Mission#'					
				 AND     MandateNo = '#MandateNo#'
			</cfquery>
			
			<!--- check if funding expirate exceeds the parent --->
			
			<cfif Funding.Expiration lte Mandate.DateExpiration>
					<cfset exp = Funding.Expiration>
			<cfelse>
					<cfset exp = Mandate.DateExpiration>						
			</cfif>		
			
			<cfif Funding.Expiration gt PositionParent.DateExpiration>				

				<cfquery name="PositionParentUpdate" 
				 datasource="#datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 UPDATE  Employee.dbo.PositionParent
					 SET     DateExpiration = '#exp#'
					 WHERE   PositionParentId = '#PositionParentId#'					
				</cfquery>	
						
			</cfif>
			
			<!--- extend the position --->
			
			<cfquery name="Position" 
			 datasource="#datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     Employee.dbo.Position
				 WHERE    PositionParentId = '#PositionParentId#'					
				 ORDER BY DateEffective DESC
			</cfquery>
			
			<cfif Position.recordcount eq "1">
			
				<cfif Funding.Expiration lte Mandate.DateExpiration>
						<cfset exp = Funding.Expiration>
				<cfelse>
						<cfset exp = Mandate.DateExpiration>						
				</cfif>		
			
				<cfif Funding.Expiration gt Position.DateExpiration>					
					
					<cfquery name="PositionUpdate" 
					 datasource="#datasource#"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 UPDATE  Employee.dbo.Position
						 SET     DateExpiration = '#exp#'
						 WHERE   PositionNo = '#Position.PositionNo#'					
					</cfquery>		
				
				</cfif>
			
			</cfif>
			
			<cfif assignmentAmend eq "Yes">
						
			<!--- extend the assignment on the above position --->
			
			<cfquery name="Assignment" 
			 datasource="#datasource#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     Employee.dbo.PersonAssignment
				 WHERE    PositionNo = '#Position.PositionNo#'		
				 AND      AssignmentStatus IN ('0','1') AND AssignmentType = 'Actual'		
				 <!--- ----------------------------------------------------------- --->
				 <!--- only if the person is recently on board it will be extended --->
				 <!--- ----------------------------------------------------------- --->
				 <cfif exp gte now()>
				 AND      DateExpiration >= getdate()-30	
				 <cfelse>
				 <!--- catch up of an already position in the past --->
				 AND      DateExpiration >= #exp-90#	
				 </cfif>
				 ORDER BY DateEffective DESC
			</cfquery>
			
			<cfif Assignment.recordcount eq "1">
			
				<!--- set the value of the requisition --->
					
				<cfquery name="Update" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   UPDATE  RequisitionLine
				   SET     PersonNo = '#Assignment.PersonNo#'
				   WHERE   RequisitionNo = '#RequisitionNo#'	 
				</cfquery>
						
			    <!--- check if the funding would extend the assignment --->
				
				<cfif Funding.Expiration gt Assignment.DateExpiration>
				
					<cfif Funding.Expiration lte Mandate.DateExpiration>
							<cfset exp = Funding.Expiration>
					<cfelse>
							<cfset exp = Mandate.DateExpiration>						
					</cfif>		
					
					<cfquery name="GetLastNumber" 
					    datasource="#datasource#" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							 SELECT * 
							 FROM   Employee.dbo.Parameter
					</cfquery>
					 
					<cfset NoAct = GetLastNumber.ActionNo + 1>
					 
					<cfquery name="GetLastNumber" 
					    datasource="#datasource#" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							 UPDATE Employee.dbo.Parameter
							 SET    ActionNo = #NoAct#
					</cfquery>
					
					<!--- reassignment --->
					<cfset Action = "0004">	
										
					<!--- since this is an automated transaction we do this always in a review mode --->
					<!---
					<cfif Mandate.MandateStatus eq "1">
					--->
					
						<cfquery name="ArchiveAssignmentRecord" 
					         datasource="#datasource#" 
					         username="#SESSION.login#" 
					         password="#SESSION.dbpw#">
					    	 UPDATE Employee.dbo.PersonAssignment
					    	 SET    AssignmentStatus = '9',
							        ActionReference  = #NoAct# 
					    	 WHERE  AssignmentNo     = '#Assignment.AssignmentNo#' 
					    </cfquery>
						
						<!--- ---------------------- --->
						<!--- 0. new assignment record  --->
						<!--- ---------------------- ---> 		
						  
					    <cfquery name="InsertAssignment" 
					     datasource="#datasource#" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO Employee.dbo.PersonAssignment
						         (PersonNo,
								 PositionNo,
								 DateEffective,
								 DateExpiration,								
								 OrgUnit,
								 LocationCode,
								 FunctionNo,
								 FunctionDescription,
								 AssignmentStatus,								
								 AssignmentClass,
								 AssignmentType,
								 Incumbency,
								 Remarks,
								 Source,
								 SourceId,								 
								 ActionReference, 
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						  SELECT PersonNo,
								 PositionNo,
								 DateEffective,
								 '#exp#',								
								 OrgUnit,
								 LocationCode,
								 FunctionNo,
								 FunctionDescription,
								 '0',								 
								 AssignmentClass,
								 AssignmentType,
								 Incumbency,
								 Remarks,
								 Source,
								 SourceId,
								 '#NoAct#',
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName
						  FROM   Employee.dbo.PersonAssignment
						  WHERE  AssignmentNo = '#Assignment.AssignmentNo#'		 						
					    </cfquery>
						
						<!--- 2. record the PA action--- --->		
					
						<cfif Action neq "">		
						
							<!--- retrieve the create assignment ---->
					
							<cfquery name="Get" 
							     datasource="#datasource#" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
								     SELECT   TOP 1 AssignmentNo
									 FROM     Employee.dbo.PersonAssignment
									 WHERE    PersonNo   = '#Assignment.PersonNo#'
									 AND      PositionNo = '#Assignment.PositionNo#'
									 ORDER BY AssignmentNo DESC
							</cfquery>
								
							<cfset ass = Get.AssignmentNo>
							   
							<cfquery name="LogPAAction" 
							     datasource="#datasource#" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
								     INSERT INTO Employee.dbo.EmployeeAction
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
										 OfficerFirstName)
								      VALUES 
									    (#NoAct#,
										 '#Action#',
										 '#Assignment.PersonNo#',
										 'Assignment',
										 '#ass#',  <!--- main record which has the wf --->
										 'Ripple: Extension through Position Funding',
										 '#PositionParent.Mission#',
										 '#PositionParent.MandateNo#',
										 '#PositionParent.PostType#',
										 '0',
										 '#SESSION.acc#',
								    	 '#SESSION.last#',		  
									  	 '#SESSION.first#')
								 </cfquery>
						 
								<!--- -------------------------------------------- --->					
								<!--- --link affected records to personnel action- --->
								<!--- -------------------------------------------- --->				
							
								<cfset link = "Staffing/Application/Assignment/AssignmentActionView.cfm?ActionReference=#NoAct#">
														
								<cfquery name="InsertPALines" 
							     datasource="#datasource#" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
							     INSERT INTO Employee.dbo.EmployeeActionSource
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
								  FROM    Employee.dbo.PersonAssignment
							      WHERE   ActionReference = '#NoAct#'	
							    </cfquery>
						
						</cfif>
					
					<!---
									
					<cfelse>
					
						<!--- mandate is open --->					
					
					</cfif>
					
					--->
					
					</cfif>
								
				</cfif>
			
			</cfif>
					
	</cffunction>	
	
	<cffunction name="PositionWorkschedule"
             access="public"
             returntype="any"
             displayname="Inherit the workschedule to a newly created position from its parent"
             output="yes">
		
		<cfargument name="PositionNo"    type="string" required="true"  default="">
		<cfargument name="DataSource"    type="string" required="true"  default="appsEmployee">		
		
		<cfquery name="get" 
	     datasource="#datasource#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
			 SELECT     Old.Positionno as PositionNoPrior, 
			            New.*
			 FROM       Employee.dbo.Position New INNER JOIN
	                    Employee.dbo.Position Old ON New.SourcePositionNo = Old.PositionNo
			 WHERE      New.PositionNo = '#positionno#'
		
		</cfquery>
		
		<!--- 
		
		1.  check if the parent position has a workschedule defined 
		2.  check if workschedule is enabled for the new unit 
		3a. apply the 
		3b  remove.
		
		--->
		
		<cfif get.recordcount gte "1">
		
			<cfquery name="getSchedules" 
		     datasource="#datasource#" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT    DISTINCT WorkSchedule
			 FROM      Employee.dbo.WorkSchedulePosition
			 WHERE     PositionNo = '#get.PositionNoPrior#'
			 AND       CalendarDate >= '#dateformat(get.DateEffective,client.dateSQL)#'			
			</cfquery>
									
			<cfloop query="getSchedules">
			
				<cfquery name="getScheduleValid" 
			     datasource="#datasource#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">		
					SELECT     WSP.WorkSchedule
					FROM       Employee.dbo.Position New 
							   INNER JOIN Employee.dbo.Position Old ON New.SourcePositionNo = Old.PositionNo 
							   INNER JOIN Employee.dbo.WorkSchedulePosition WSP ON Old.PositionNo = WSP.PositionNo 
							   INNER JOIN Employee.dbo.WorkScheduleOrganization WSO ON New.OrgUnitOperational = WSO.OrgUnit AND 
				               WSP.WorkSchedule = WSO.WorkSchedule
					WHERE      New.PositionNo   = '#positionno#'
					AND        WSP.WorkSchedule = '#workschedule#'
				</cfquery>	
			
				<cfif getScheduleValid.recordcount eq "0">
				
					<!--- remove entries --->
					
					<cfquery name="clearDate" 
				     datasource="#datasource#" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 
						 DELETE FROM Employee.dbo.WorkSchedulePosition
						 WHERE  PositionNo    = '#get.PositionNoPrior#'
						 AND    WorkSchedule  = '#workschedule#'
						 AND    CalendarDate >= '#dateformat(get.DateEffective,client.dateSQL)#'							 		
					
					</cfquery>
											
				<cfelse>
				
					<!--- reassign entries entries --->
				
					<cfquery name="resetSchedule" 
				     datasource="#datasource#" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 
						 UPDATE Employee.dbo.WorkSchedulePosition
						 SET    PositionNo    = '#positionno#'
						 WHERE  PositionNo    = '#get.PositionNoPrior#'
						 AND    WorkSchedule  = '#workschedule#'	
						 AND    CalendarDate >= '#dateformat(get.DateEffective,client.dateSQL)#'								
					
					</cfquery>		
									
				</cfif>
				
			</cfloop>		
									
			</cfif>
		
	</cffunction>			
	
</cfcomponent>	

