
<cfparam name="url.caller"               default="0">
<cfparam name="URL.Source"               default="MANUAL">
<cfparam name="URL.RecordId"             default="0">
<cfparam name="URL.ApplicantNo"          default="">
<cfparam name="Form.ParentOffice"        default="">
<cfparam name="Form.ParentLocation"      default="">

<cfparam name="PersonVerify.RecordCount" default="0">
<cfparam name="PostVerify.RecordCount"   default="0">
<cfparam name="URL.ID" default="#Form.PositionNo#">

<cfquery name= "Parameter" 
 datasource  = "AppsEmployee" 
 maxrows     = 1 
 username    = "#SESSION.login#" 
 password    = "#SESSION.dbpw#">
	 SELECT * 
	 FROM Parameter
</cfquery>

<cfset status = "Go">

<!--- check if not yet approved records are conflicting --->

<!--- 27/07 define the scope of units to be checked --->

<!--- define the scope --->

<cfquery name="Mission" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT MissionOwner 
	FROM    Organization.dbo.Ref_Mission
	WHERE  Mission = '#Form.Mission#'
</cfquery>	

<!--- define the scope of the conflict validation to the same owner only --->

<cfquery name="OrgScope" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT OrgUnit
	INTO   userQuery.dbo.#SESSION.acc#OrgScope
	FROM   Organization.dbo.Organization
	WHERE  Mission IN (SELECT Mission 
	                   FROM   Organization.dbo.Ref_Mission 
					   WHERE  MissionOwner = '#Mission.MissionOwner#')
</cfquery>	

<cfquery name="Parameter1" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM  Ref_ParameterMission
		WHERE Mission   = '#Form.Mission#'
</cfquery>

 <cfquery name="assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT     B.AssignmentClass
        FROM       Ref_AssignmentClass AS A INNER JOIN
                   Ref_AssignmentClass AS B ON A.ClassParent = A.ClassParent
        WHERE      A.AssignmentClass = '#Form.AssignmentClass#' 
		AND        B.Incumbency > 0 
		AND        A.Operational = 1
</cfquery>
		
<cfset assclass = quotedValueList(assignment.assignmentclass)>
			
<cfif Parameter1.AssignmentClear eq "1">
  			
	<!--- closed mandate --->
	  		
	<cfif Mandate.MandateStatus eq "1">
		
	    <!--- verify if there is a NOT approved assignment record for this PERSON --->
	
		<cfquery name="PersonVerify0" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT PA.AssignmentNo, PO.Mission, PO.MandateNo
		FROM   PersonAssignment PA, Position Po
		WHERE  PA.PositionNo = PO.PositionNo
		  AND  PA.PersonNo = '#Form.PersonNo#' 
		  AND  PA.DateExpiration  >= #STR#
		  AND  PA.DateEffective   <= #END#
		  AND  PA.AssignmentClass IN (#preservesingleQuotes(assclass)#)
		  AND  PA.Incumbency      != 0 
		  AND  PA.AssignmentNo    != #Form.AssignmentNo# 
		  AND  PA.AssignmentStatus = '0'
		  AND  PO.OrgUnitOperational IN (SELECT OrgUnit 
		                                 FROM userQuery.dbo.#SESSION.acc#OrgScope
                     					 WHERE OrgUnit = PO.OrgUnitOperational)
							 
		</cfquery>
		
		<!--- verify if there is a NOT approved assignment record for this POSITION --->
		
		<cfquery name="PostVerify0" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT PA.AssignmentNo, PO.Mission, PO.MandateNo
		FROM  PersonAssignment PA, Position Po
		WHERE PA.PositionNo = PO.PositionNo
		  AND PA.PositionNo       = '#Form.PositionNo#' 
		  AND PA.DateExpiration  >= #STR#
		  AND PA.DateEffective   <= #END#
		  AND PA.AssignmentClass  IN (#preservesingleQuotes(assclass)#))
		  AND PA.Incumbency      != 0
		  AND PA.AssignmentNo    != #Form.AssignmentNo#
		  AND PA.AssignmentStatus = '0'
		  AND PA.PersonNo        != '#Form.PersonNo#'  
		  AND PO.OrgUnitOperational IN (SELECT OrgUnit 
		                                FROM   userQuery.dbo.#SESSION.acc#OrgScope
							            WHERE  OrgUnit = PO.OrgUnitOperational)
		</cfquery>  
		
		   <cfif PersonVerify0.recordcount gte "1" or PostVerify0.recordcount gte "1">
			    <cfset status = "NotApproved">
		   </cfif>
		   
	</cfif>
	
</cfif>	




<!--- verify if a record exists for employee with the same assignment class --->

<cfif Status eq "Go">
	
	<!--- check if person itself has a conflict with the new assignment in any mission --->
	
	<cfquery name="PersonVerify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PA.PositionNo, 
		       PA.PersonNo, 
			   PA.AssignmentNo, 
			   PA.DateEffective,
		       PO.Mission, 
			   PO.MandateNo
		FROM   PersonAssignment PA, Position Po
		WHERE  PA.PositionNo = PO.PositionNo
		  AND  PA.PersonNo        = '#Form.PersonNo#' 
		  AND  PA.DateExpiration >= #STR#
		  
		  <!--- was disabled to prevent handling future assignment :however
		   for a certain carry over scenario it was still needed we could make changes --->	  
		  
		  AND  PA.DateEffective  <= #END# 
		  		  
		  AND  PA.AssignmentClass IN (#preservesingleQuotes(assclass)#)
		  AND  PA.Incumbency       = '#Form.Incumbency#'
		  AND  PA.AssignmentNo     <> #Form.AssignmentNo#
		  AND  PA.AssignmentStatus < '#Parameter.AssignmentShow#'
		  <!--- all units of the same owner --->
		  AND  PO.OrgUnitOperational IN (SELECT OrgUnit 
			                             FROM   userQuery.dbo.#SESSION.acc#OrgScope
										 WHERE  OrgUnit = PO.OrgUnitOperational)
										 
								  
	</cfquery>
	
	
	<!--- check if post in this mission/mandate has a conflict with this assignment  --->
	
	<cfquery name="PostVerify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PositionNo, PersonNo, AssignmentNo, DateEffective
		FROM   PersonAssignment PO
		WHERE  PositionNo       = '#Form.PositionNo#' 
		  AND  DateExpiration  >= #STR#
		  AND  DateEffective   <= #END#
		  AND  AssignmentClass  IN (#preservesingleQuotes(assclass)#)
		  AND  Incumbency      = '#Form.Incumbency#'
		  AND  AssignmentNo     <> #Form.AssignmentNo#
		  AND  AssignmentStatus < '#Parameter.AssignmentShow#' 
		  AND  PersonNo         <> '#Form.PersonNo#' 
		  <!--- all units of the same owner --->
		  AND  OrgUnit IN (SELECT OrgUnit 
			               FROM   userQuery.dbo.#SESSION.acc#OrgScope
						   WHERE  OrgUnit = PO.OrgUnit)
	</cfquery>  
	
	<cfif Status eq "NotApproved"> 
	     <cfset handle = "0">
	<cfelseif PersonVerify.recordCount eq "0" and PostVerify.recordCount eq "0">
	     <!--- no conflicts --->
		 <cfset handle = "0">
	<cfelseif PersonVerify.recordCount eq "0" and PostVerify.recordCount gte "1">
	      <cfif Form.Condition eq "2">
		     <cfset handle = "1">
		 <cfelse>
		     <cfset handle = "0">	 
		 </cfif> 
	<cfelseif PersonVerify.recordCount gte "1" and PostVerify.recordCount eq "0">
	     <cfif Form.Condition eq "1" or Form.Condition eq "2">
		     <cfset handle = "1">
		 <cfelse>
		     <cfset handle = "0">	 
		 </cfif>
	<cfelseif PersonVerify.recordCount gte "1" and PostVerify.recordCount gte "1">	 
	     <cfif Form.Condition eq "2">
		     <cfset handle = "1">
		 <cfelse>
		     <cfset handle = "0">	 
		 </cfif>
	</cfif>	 	
	
	<cfif handle eq "1">
		
	   <cftransaction>
	
	   <!--- a pointer to first make correction based on the selected option of HANDLING of conflicst
	    terminate existing assigment of the SAME person --->
	   
	   <cfloop query = "PersonVerify"> 	 
	      			
		   <cfquery name="MandateVerify" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   Organization.dbo.Ref_Mandate
				WHERE  Mission   = '#Mission#'
				AND    MandateNo = '#MandateNo#'
		   </cfquery>		
			      
		   <cfif MandateVerify.MandateStatus eq "1">
		   
			     <!--- set current record to status = 9 --->
				 
				 <cfquery name="UpdateAssignment" 
			         datasource="AppsEmployee" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			    	 UPDATE PersonAssignment
			    	 SET    AssignmentStatus = '9',
					        ActionReference  = #NoAct# 
			    	 WHERE  AssignmentNo     = '#AssignmentNo#' 
			    </cfquery>	
									
				<cfset maction = "Disable current record">					

				<!--- was throwing an error because of value = 0 --->
				
				<cfquery name="setdata" 
				   datasource="AppsEmployee" 
			       username="#SESSION.login#" 
			       password="#SESSION.dbpw#">
				   INSERT INTO PersonAssignmentAction	
				          (PersonNo, 
						   PositionNo, 
						   AssignmentNo, 
						   ActionCode, 
						   ActionMemo, 
						   OfficerUserId, OfficerLastName, OfficerFirstName)
						   
				   VALUES ('#PersonNo#',
				           '#PositionNo#',
						   '#AssignmentNo#',
						   'Verify',
						   '#maction#',
       					   '#session.acc#','#session.last#','#session.first#')	       
				</cfquery> 	
					
				<cfif STR lte DateEffective>
				
				    <!--- do nothing here as the transaction is obsolete, this is the charles scenario of future transaction  --->
				
				<cfelse>
				
				    <!--- create a new record for the existing record before the new assignment --->
				 						
					<cfquery name="InsertAssignment0" 
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
							 '#clr#', 
							 #NoAct#, 
							 AssignmentClass, 
							 AssignmentType, 
							 Incumbency, 
							 Remarks, 
							 'CHECK',
							 '#SESSION.acc#',
					         '#SESSION.last#', 
							 '#SESSION.first#'
					  FROM   PersonAssignment
				      WHERE  AssignmentNo = '#AssignmentNo#'
					  
				    </cfquery>
					
					<cfquery name="getAssignment" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					   	 SELECT   * 
						 FROM     PersonAssignment
						 WHERE    AssignmentNo = '#AssignmentNo#'									 			   	 
				    </cfquery>
											
					<cfquery name="Class" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					   	 SELECT   * 
						 FROM     Ref_AssignmentClass
						 WHERE    AssignmentClass = '#getAssignment.AssignmentClass#'					   	 
						 
				    </cfquery>				
	
					<cfif class.PositionOwner eq "1">
					
						<!--- New : check if the person has a 0 assignment around the start date already
						 assignmentadd in case of owner assignment a 0 percent record as well --->
						
						<cfquery name="checkAssignment" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						   	 SELECT   * 
							 FROM     PersonAssignment
							 WHERE    PersonNo   = '#getAssignment.PersonNo#'					   	 
							 -- AND      PositionNo = '#getAssignment.PositionNo#'
							 AND      Incumbency      = '0'
							 AND      AssignmentStatus IN ('0','1')
							 AND      DateEffective  <= #STR#
							 AND      DateExpiration >= #STR#
							 
					    </cfquery>
						
						<cfif checkassignment.recordcount eq "0">
									
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
										 SourceId,
										 OfficerUserId,
										 OfficerLastName,
										 OfficerFirstName)
								  SELECT PersonNo, 
								         PositionNo, 
										 #STR#,
									     DateExpiration,
									     OrgUnit, 
										 LocationCode, 
										 FunctionNo,
									     FunctionDescription, 
										 '#clr#', 
										 #NoAct#, 
										 AssignmentClass, 
										 AssignmentType, 
										 '0', 
										 'Check Lien assignment', 
										 '#Form.AssignmentNo#',
									     '#SESSION.acc#', 
										 '#SESSION.last#', 
										 '#SESSION.first#'
								  FROM  PersonAssignment
							      WHERE AssignmentNo = '#AssignmentNo#'
						    </cfquery>
							
						</cfif>	
													
					</cfif>						
				
				</cfif>
		      
		   <cfelse>	
		   
			   <!--- open mandate --->
			        
			   <cfif STR lte DateEffective>
			   
			      <cfquery name="Delete" 
			      datasource="AppsEmployee" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      	  DELETE FROM PersonAssignment
					  WHERE  AssignmentNo = '#AssignmentNo#'
			      </cfquery>
			      
			   <cfelse>
			
			     <cfquery name="Update" 
			      datasource="AppsEmployee" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      	  UPDATE PersonAssignment
				   	  SET    DateExpiration = #STR#-1
				      WHERE  AssignmentNo = '#AssignmentNo#'
			     </cfquery>
			   
			   </cfif>
		     
		   </cfif>
	   
	   </cfloop>
	  	
	   
	   <!--- position conflict --->
	  
	 
	   <cfloop query = "PostVerify"> 
	 
			   <cfif Mandate.MandateStatus eq "1">
			   
				     <!--- set current record to status = 9 --->
					 
					 <cfquery name="UpdateAssignment" 
				         datasource="AppsEmployee" 
				         username="#SESSION.login#" 
				         password="#SESSION.dbpw#">
					     UPDATE PersonAssignment
					     SET    AssignmentStatus = '9',
						        ActionReference  = '#NoAct#' 
					     WHERE  AssignmentNo     = '#AssignmentNo#' 
				    </cfquery>	
					
					<cfif STR lte DateEffective>
					
					    <!--- do nothing here as the transaction is effectively overruled --->
					
					<cfelse>
					
						<!--- create a new record for the remaining period --->
								
						<cfquery name="InsertAssignment0" 
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
								 '#clr#', 
								 #NoAct#, 
								 AssignmentClass, 
								 AssignmentType, 
								 Incumbency, 
								 Remarks, 
								 'CHECK2',
								 '#SESSION.acc#',
						         '#SESSION.last#', 
								 '#SESSION.first#'
						  FROM  PersonAssignment
					      WHERE AssignmentNo = '#AssignmentNo#'
					    </cfquery>
						
						<cfquery name="getAssignment" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						   	 SELECT   * 
							 FROM     PersonAssignment
							 WHERE    AssignmentNo = '#AssignmentNo#'					   	 
					    </cfquery>		
												
						<cfquery name="Class" 
					    datasource="AppsEmployee" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						   	 SELECT   * 
							 FROM     Ref_AssignmentClass
							 WHERE    AssignmentClass = '#getAssignment.AssignmentClass#'					   	 
					    </cfquery>
					
						<cfif class.PositionOwner eq "1">
						
							<!--- New : add in case of owner assignment a 0 percent record as well if this does not exist
							yet --->
							
							<cfquery name="checkAssignment" 
						    datasource="AppsEmployee" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							   	 SELECT   * 
								 FROM     PersonAssignment
								 WHERE    PersonNo   = '#getAssignment.PersonNo#'					   	 
								 -- AND      PositionNo = '#getAssignment.PositionNo#'
								 AND      Incumbency      = '0'
								 AND      AssignmentStatus IN ('0','1')
								 AND      DateEffective  <= #STR#
								 AND      DateExpiration >= #STR#
						    </cfquery>
							
							<cfif checkassignment.recordcount eq "0">
																	
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
											 SourceId,
											 OfficerUserId,
											 OfficerLastName,
											 OfficerFirstName)
									  SELECT PersonNo, 
									         PositionNo, 
											 #STR#,
										     DateExpiration,
										     OrgUnit, 
											 LocationCode, 
											 FunctionNo,
										     FunctionDescription, 
											 '#clr#', 
											 #NoAct#, 
											 AssignmentClass, 
											 AssignmentType, 
											 '0', 
											 'AUTO LIEN', 
											 '#Form.AssignmentNo#',
										     '#SESSION.acc#', 
											 '#SESSION.last#', 
											 '#SESSION.first#'
									  FROM  PersonAssignment
								      WHERE AssignmentNo = '#AssignmentNo#'
			  					    </cfquery>
									
								</cfif>
								
						</cfif>	
										
						<!--- wildcard : delete same day assignments --->
						
						<cfquery name="Clean" 
					     datasource="AppsEmployee" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
							 DELETE FROM PersonAssignment
							 WHERE DateEffective = DateExpiration
							 AND   PersonNo = '#PersonNo#'				 
						</cfquery> 			
				
					</cfif>
				
				<cfelse> <!--- open mandate --->
			 
			        <!--- terminate existing assignment for this position --->
			  
				   <cfif STR lte DateEffective>
				   
				    <cfquery name="Delete" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    DELETE FROM PersonAssignment
						WHERE  AssignmentNo = '#AssignmentNo#' 
				    </cfquery>
					
				   <cfelse>	
				     
				    <cfquery name="Update" 
				    datasource="AppsEmployee" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					    UPDATE PersonAssignment
						SET    DateExpiration = #STR#-1
					    WHERE  AssignmentNo = '#AssignmentNo#' 
				    </cfquery>
			   
				   </cfif>
			   	
			   </cfif>
		
		</cfloop>
			
		</cftransaction>
	        
	</cfif> 

</cfif>  

   
	
<!--- store the proposed transaction --->

<cfquery name="CreateTable"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	CREATE TABLE UserQuery.dbo.#SESSION.acc#AssignmentConflict (
		[PersonNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[LastName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[FirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[IndexNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[ParentOffice] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[ParentLocation] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[PositionNo] [int] NOT NULL ,
		[AssignmentNo] [int] NOT NULL ,
		[DateEffective] [datetime] NOT NULL ,
		[DateExpiration] [datetime] NULL ,
		[DateArrival] [datetime] NULL ,
		[DateDeparture] [datetime] NULL ,	
		[Mission] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[OrgUnit] [int] NOT NULL ,
		[OrgUnitCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[MandateNo] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[OrgUnitName] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[OrgUnitClass] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[LocationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[FunctionNo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[FunctionDescription] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
		[AssignmentStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[AssignmentClass] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[AssignmentType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[Incumbency] [int] NULL DEFAULT (100),
		[Source] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SourceNo] [int] NULL ,	
		[Remarks] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 	
	) ON [PRIMARY]
</cfquery>

		

<cfquery name="Person" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Person 
		WHERE      PersonNo = '#Form.PersonNo#'
</cfquery>

<cfparam name="ARR" default="NULL">
<cfparam name="DEP" default="NULL">
	
<cfquery name="InsertAssignment" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO UserQuery.dbo.#SESSION.acc#AssignmentConflict
	         (PersonNo,
			 LastName,
			 FirstName,
			 IndexNo,
			 ParentOffice,
			 ParentLocation,
			 PositionNo,
			 AssignmentNo,
			 DateEffective,
			 DateExpiration,
			 DateArrival,
			 DateDeparture,
			 Mission,
			 OrgUnit,
			 OrgUnitName,
			 OrgUnitClass,
			 OrgUnitCode,
			 MandateNo,
			 FunctionNo,
			 FunctionDescription,
			 AssignmentStatus,
			 AssignmentClass,
			 AssignmentType,
			 Incumbency,
			 Remarks)
      VALUES ('#Form.PersonNo#',
	    	  '#Person.LastName#',
			  '#Person.FirstName#',
			  '#Person.IndexNo#',
			  '#Person.Parentoffice#',
			  '#Person.ParentOfficeLocation#',
	     	  '#Form.PositionNo#',
			  '#Form.AssignmentNo#',
			  #STR#,
			  #END#,
			  #ARR#,
			  #DEP#, 
			  '#Form.Mission#',
			  '#Form.OrgUnit#',
			  '#Form.OrgUnitName#',
			  '#Form.OrgUnitClass#',
			  '#Form.OrgUnitCode#',
			  '#Form.MandateNo#',
			  '#Form.FunctionNo#',
			  '#Form.FunctionDescription#',
			  '#clr#',
			  '#Form.AssignmentClass#',
			  '#Form.AssignmentType#',
			  '#Form.Incumbency#',
			  left('#Form.Remarks#' ,100))
			  			  
 </cfquery>
	
<cfif ((PostVerify.recordCount gte "1" or PersonVerify.recordCount gte "1") 
         and handle eq "0") or status eq "NotApproved">		   
   		
	  <cfoutput>
	 	
		<script language="JavaScript">						
		 parent.AssignmentConflict('#Call#','#URL.Caller#','#Status#','#URL.Source#','#URL.RecordId#','#URL.ApplicantNo#','#url.id#','#url.box#')
		</script>
		
	
		
  	 </cfoutput>	
		
	<cfset conflict = "1">	
	
<cfelse>

	<cfset conflict = "0">	
	
</cfif>	


