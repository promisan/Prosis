
<cf_screentop html="No" jquery="Yes">

<cf_systemscript>

<cf_DialogPosition>

<cfparam name="Form.AssignmentNo"   default="0">
<cfparam name="Form.Mission"        default="">
<cfparam name="Form.LocationCode"   default="">
<cfparam name="Form.MandateNo"      default="">
<cfparam name="URL.DocumentNo"      default="">

<cfif Form.assignmentNo eq "" or Form.Mission eq "">

    <cf_alert message="A problem occured saving your assignment as required data was not available.">
    <cfabort>
	
</cfif>

<cfset ass = Form.AssignmentNo>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Mandate
	WHERE  Mission   = '#Form.Mission#'
	AND    MandateNo = '#Form.MandateNo#'
</cfquery>

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Position
	WHERE  PositionNo = '#Form.PositionNo#'
</cfquery>

<cfif Form.ParentOffice neq "">

   <cfquery name="UpdateParent" 
	  datasource="appsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  UPDATE Person
	   SET   ParentOffice           = '#Form.ParentOffice#',
	         ParentOfficeLocation   = '#Form.ParentLocation#'
	  WHERE  PersonNo               = '#Form.PersonNo#'
   </cfquery>

</cfif>

<cfset dateValue = "">

<cftry>

	<cfparam name="Form.DateDeparture"  default="">
	<cfparam name="Form.DateEffective"  default="#Form.DateArrival#">
	<cfparam name="Form.DateExpiration" default="#Form.DateDeparture#">
		
	<cfcatch></cfcatch>
	
</cftry>

<cfif isDefined("Form.DateArrival") AND Form.DateArrival neq "">
    <CF_DateConvert Value="#Form.DateArrival#">
	<cfset ARR = dateValue>
<cfelse>
    <cfset ARR = 'NULL'>
</cfif>

<cfif Form.DateDeparture neq ''>
    <CF_DateConvert Value="#Form.DateDeparture#">
	<cfset DEP = dateValue>
<cfelse>
    <cfset DEP = 'NULL'>
</cfif>	

<cfquery name="CheckPosition" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Position
	WHERE  PositionNo = '#Form.PositionNo#'
	AND    (DateEffective > #DEP# OR DateExpiration < #ARR#) 
</cfquery>

<cfoutput>
	
	<cfif checkPosition.recordcount gte "1">
	
		<script>
		alert("You recorded an incumbency period that is not covered by the selected position. It is valid for : #DateFormat(check.dateeffective,client.dateformatshow)# - #DateFormat(check.dateexpiration,client.dateformatshow)#.\n\n\Operation aborted.")
		</script>
		<cfabort>
	
	</cfif>

</cfoutput>



<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>
<cfif STR lt Check.DateEffective>
    <CF_DateConvert Value="#DateFormat(Check.DateEffective,CLIENT.DateFormatShow)#">
    <cfset STR = dateValue>
</cfif> 

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif END gt Check.DateExpiration>
    <CF_DateConvert Value="#DateFormat(Check.DateExpiration,CLIENT.DateFormatShow)#">
    <cfset END = dateValue>
</cfif>   

<cfif END lt STR and END neq 'NULL'>
   <cfset END = STR>
</cfif>

<!--- below is a saeguard only, the system already adjusts to within the position period --->

<cfif (STR lt Check.DateEffective) OR (END gt Check.DateExpiration)>

	 <cf_alert message = "You defined a period (#Form.DateEffective# - #Form.DateExpiration#) which falls outside the current position effective period. Operation not allowed."
	 return = "back">
	 <cfabort>

</cfif>

<!--- --------------------------------------------------------------------------------------------------- --->
<!--- check if the person has an entered contract and if so check if the period falls within the contract --->
<!--- --------------------------------------------------------------------------------------------------- --->
	   
<cf_AssignmentContractCheck 
   mission   = "#check.missionoperational#"    
   personno  = "#form.personNo#">   
  
<cfif validcontract eq "1" and 
    ValidContractExpiration lt END and ValidContractExpiration gte STR>
	
	 <cf_alert message = "You submitted a #check.mission# Position Incumbency period [#dateformat(End,CLIENT.DateFormatShow)#] which starts before and ends AFTER to the determined Contract Expiration before [#dateformat(ValidContractExpiration,CLIENT.DateFormatShow)#]. \n\nThis operation is not allowed. Please contact your administrator."
		 return = "back">
	 <cfabort>
	 
</cfif>

<cfif Len(Form.Remarks) gt 200>
	 <cf_alert message = "You recorded remarks that exceeded the allowed length of 200 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfif Mandate.MandateStatus eq "1">
    <cfinclude template="ActionNo.cfm">
<cfelse>	
    <cfset NoAct = 'NULL'>
</cfif>

<cfset checkstatus = 0>

<cfset call = "Entry">

<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM  Ref_ParameterMission
		WHERE Mission   = '#check.MissionOperational#'
</cfquery>

<cfif Parameter.AssignmentClear eq "1">
	<!--- requires clearance, so set to 0 --->
	<cfset clr = "0">
<cfelse>	
	<!-- does not requires clearance, so set to 1 immediately ---> 
	<cfset clr = "1">
</cfif>	

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OrgScope"> 
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#AssignmentConflict"> 

<cfparam name="conflict" default="0">

<cftransaction action="BEGIN">
	
	<!--- perform the conflict check or handling --->
	
	<cftry>
			
		<cfinclude template="AssignmentConflictCheck.cfm"> 		
	
	
		<cfcatch>
		
		    <cfoutput>
				<cf_alert message="Assignment action could not be completed. Please try again later.<br>#CFCatch.Message# - #CFCATCH.Detail#">
			</cfoutput>
			<cfabort>
			
		</cfcatch>
	
	</cftry>
	
	
	<!--- no conflict is found --->
	
	<cfif conflict eq "0">
		  
		<cfif Mandate.MandateStatus eq "1"> 
		
			 <!--- approved so make a transaction--->
			 <cfset Action = "0003">
			 			 
			 <cfquery name="InsertAssignment" 
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
						 AssignmentClass,
						 AssignmentType,
						 Incumbency,
						 ActionReference, 
						 Source,
						 SourceId,
						 SourcePersonNo,
						 Remarks,
						 DateArrival,
						 DateDeparture,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
		      VALUES ('#Form.PersonNo#',
			     	  '#Form.PositionNo#',
					  #STR#,
					  #END#,
					  '#Form.OrgUnit#',
					  '#Form.LocationCode#',
					  '#Form.FunctionNo#',
					  '#Form.FunctionDescription#',
					  '#clr#',
					  '#Form.AssignmentClass#',
					  '#Form.AssignmentType#',
					  '#Form.Incumbency#',
					  #NoAct#,
			  		  '#URL.Source#',
					  <cfif url.documentno neq "">
					     '#URL.DocumentNo#',
					  <cfelse>
					     '#URL.RecordId#',
					  </cfif>
					  '#URL.ApplicantNo#',
					  '#Form.Remarks#',
					  #ARR#,
					  #DEP#,
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
				</cfquery>
				
				<cfquery name="getRecord" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">				     
				      SELECT  TOP 1 AssignmentNo,ActionReference, Remarks
					  FROM    PersonAssignment
				      WHERE   ActionReference = #NoAct#	
				      ORDER BY Created Desc
			    </cfquery>
				
				 <cfquery name="InsertAction" 
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
						 PostType,
						 ActionStatus,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName,
						 ActionDate)
			      VALUES (#NoAct#,
						  '#Action#',
						  '#Form.PersonNo#',
						  'Assignment',
						  '#getRecord.AssignmentNo#',
						  '#getRecord.Remarks#',
						  '#Form.Mission#',
						  '#Form.MandateNo#',
						  '#Check.PostType#',
						  '#clr#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#',
						  '#DateFormat(STR,CLIENT.DateSQL)#')
				 </cfquery>
				  
				<cfset link = "Staffing/Application/Authorization/Staffing/TransactionViewDetail.cfm?ActionReference=#NoAct#">
			     	  
				<cfquery name="InsertActionSource" 
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
				      WHERE   ActionReference = #NoAct#	
			    </cfquery>
		  
		 <cfelse>
			
			 <cfquery name="InsertAssignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PersonAssignment
				         (PersonNo,
						 PositionNo,
						 DateEffective,
						 DateExpiration,
						 OrgUnit,
						 FunctionNo,
						 FunctionDescription,
						 AssignmentStatus,
						 AssignmentClass,
						 AssignmentType,
						 Incumbency,
						 Source,
						 SourceId,
						 SourcePersonNo,
						 Remarks,
						 DateArrival,
						 DateDeparture,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			      VALUES ('#Form.PersonNo#',
				     	  '#Form.PositionNo#',
					      #STR#,
						  #END#,
					   	  '#Form.OrgUnit#',
						  '#Form.FunctionNo#',
						  '#Form.FunctionDescription#',
						  '#clr#',
						  '#Form.AssignmentClass#',
						  '#Form.AssignmentType#',
						  '#Form.Incumbency#',
						  '#URL.Source#',
						  '#URL.RecordId#',
						  '#URL.ApplicantNo#',
						  '#Form.Remarks#',
						  #ARR#,
						  #DEP#,
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
			  </cfquery>
			
		</cfif>	 
		
		<!--- ass ---->
			
		<cfquery name="Get" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		     SELECT    TOP 1 AssignmentNo
			 FROM      PersonAssignment
			 WHERE     PersonNo   = '#Form.PersonNo#'
			 AND       PositionNo = '#Form.PositionNo#'
			 ORDER BY  AssignmentNo DESC
		</cfquery>
		
		<cfset ass = Get.AssignmentNo>	
			
		<cfquery name="Parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   Ref_ParameterMission
			WHERE  Mission   = '#check.MissionOperational#'
		</cfquery>	  
		
		<cfif Parameter.EnableMissionPeriod eq "1"> 	
		
			<!--- <cfinclude template="AssignmentMissionEntry.cfm"> --->
			<cf_AssignmentMissionEntry PersonNo = "#Form.PersonNo#" Mission="#Form.Mission#">
			
		</cfif>
		
		<cfset dateValue = "">
		
		<cfif Form.DateDeparture neq ''>
				<CF_DateConvert Value="#Form.DateDeparture#">
				<cfset DEP = dateValue>
		<cfelse>
			    <cfset DEP = END>
		</cfif>		
		
		<cfif mandate.DateExpiration lte DEP>
		
				<cfquery name="CheckExtension" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE FROM PersonExtension 
					WHERE PersonNo     = '#Form.PersonNo#'
					AND   Mission      = '#Form.Mission#' 
					AND   MandateNo    = '#Form.MandateNo#'
				</cfquery>		
											
				<cfquery name="InsertExtension" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO PersonExtension 
							    (PersonNo, Mission, MandateNo, ActionStatus, DateExtension,OfficerUserId, OfficerLastName, OfficerFirstName)
						VALUES  ('#Form.PersonNo#', 
						         '#Form.Mission#', 
								 '#Form.MandateNo#',
								 '1', 
								 #DEP#, 
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#')
				</cfquery>
										
		</cfif>	
		
	</cfif>	
	  
</cftransaction>
	
	<cfif conflict eq "1">
	
	<script>
		alert("Conflict exists.")
	</script>
	
	<!--- --------------------------------------- --->
	<!--- it is import to halt the procssing here --->
	<cfabort>
	<!--- --------------------------------------- --->

</cfif>

<!--- ------------------------------------------- --->
<!--- special code for onboarding through a track --->
<!--- ------------------------------------------- --->

<cfif URL.Source eq "vac">

		<cfquery name="Object" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			  SELECT  * 
			  FROM    OrganizationObject
	          WHERE   ObjectKeyValue1 = '#URL.RecordId#'
			  AND     ObjectKeyValue2 = '#URL.ApplicantNo#'
			  AND     EntityCode = 'VacCandidate'
			  AND     Operational  = 1			
		 </cfquery> 
		 
		 <!--- check for step method and perform method ---> 

 		<cfquery name="LastStep" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT   TOP 1 * 
			FROM     OrganizationObjectAction
			WHERE    ObjectId = '#Object.ObjectId#'
			AND      ActionStatus='0'
			ORDER BY ActionFlowOrder
		 </cfquery> 

 		<cfquery name="MethodSubmission" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Ref_EntityActionPublishScript
			WHERE    ActionPublishNo = '#Object.ActionPublishNo#' 
			AND      ActionCode      = '#LastStep.ActionCode#' 
			AND      Method          = 'Submission'		 
		</cfquery>		 
		 
		<cfif MethodSubmission.DocumentId neq "">	
					 		 
			<!--- Perform method which will usually close the document and the step --->
			
	 		<cfquery name="GetScript" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_EntityDocument
				WHERE  DocumentId    = '#MethodSubmission.DocumentId#'
				AND    DocumentType  = 'script'
				AND    Operational   = '1'
			</cfquery>			
			
			<cfif GetScript.recordcount eq "1">
			
				<!--- this script will usually perform a closing of the steps, candidate doc and document --->			
				<cfinclude template="../../../#GetScript.DocumentTemplate#">
				
			</cfif>
			
		<cfelse>
		
			    <!--- Closing only that step ----->
				
				<cfquery name="UpdateVacancyAction" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 UPDATE OrganizationObjectAction
					  SET   ActionStatus      = '2',
					        OfficerUserId     = '#SESSION.acc#',
						    OfficerLastName   = '#SESSION.last#',
						    OfficerFirstName  = '#SESSION.first#',
						    OfficerDate       = getDate(),
						    TriggerActionType = 'Arrival'	 
					  WHERE ObjectId IN (SELECT ObjectId 
					                     FROM   OrganizationObject
			                      		 WHERE  ObjectKeyValue1 = '#Object.ObjectKeyValue1#'
										  AND   ObjectKeyValue2 = '#Object.ObjectKeyValue2#'
										  AND   EntityCode = 'VacCandidate'
										  AND   Operational  = 1)
					  AND   ActionStatus = '0'
					  AND   ActionCode='#LastStep.ActionCode#'
				</cfquery> 
		
		</cfif>				 
		 
		 <cfif Form.ParentOffice eq "">
		 
			 <cfquery name="Parent" 
			   datasource="appsVacancy" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT TOP 1 *
			   FROM   stReleaseRequest
			   WHERE  DocumentNo      = '#URL.RecordId#'	
			     AND  PersonNo        = '#URL.ApplicantNo#' 
			 </cfquery>
			 
			 <cfif Parent.ParentOffice neq "" and Parent.recordcount eq "1">
			 
				 <cfquery name="UpdateParent" 
				   datasource="appsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				   UPDATE Person
				   SET    ParentOffice           = '#Parent.ParentOffice#',
				          ParentOfficeLocation   = '#Parent.ParentLocation#'
				   WHERE  PersonNo        = '#Form.PersonNo#'
				 </cfquery>
			 
			 </cfif>
		 
		 </cfif>		
		 	 
</cfif>

<!--- update topics --->

<cfparam name="Post.Mission" default="#Form.Mission#">

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
		SELECT AssignmentGroup
		FROM   PersonAssignmentGroup
		WHERE  AssignmentNo = '#ass#' AND AssignmentGroup = '#Item#'
	</cfquery>
	
	<CFIF VerifyGroup.recordCount is 1 > 
		
		<cfquery name="UpdateGroup" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE PersonAssignmentGroup
			 SET   Status = '1',
			       OfficerUserId    = '#SESSION.acc#',
				   OfficerLastName  = '#SESSION.last#',
				   OfficerFirstName = '#SESSION.first#'
			WHERE  AssignmentNo = '#ass#' 
			AND    AssignmentGroup = '#Item#'
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
			  '#SESSION.first#')</cfquery>
	</cfif>

</cfloop>	

<!--- perform a through check of the assignment --->

<cfinclude template="AssignmentVerify.cfm">
		
<cfif url.caller eq "PostDialog">

     <script LANGUAGE = "JavaScript">
		 parent.window.close();	 
   	     parent.opener.history.go();	     
     </script>	
		
	 
<cfelseif url.source eq "VAC">	 

     <!--- also tag the record in DocumentCandidate --->
	 
	 <cfquery name="InsertBoardingLink" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  Vacancy.dbo.DocumentCandidate
			SET     PositionNo = '#Form.PositionNo#'
			WHERE   DocumentNo = '#URL.RecordId#'						
			AND     PersonNo   = '#URL.ApplicantNo#'
	 </cfquery>
	
	 <script LANGUAGE = "JavaScript">
		 parent.parent.ProsisUI.closeWindow('myarrival')
		 parent.parent.arrivalrefresh()     	 
	 </script>
	<!--- refresh the workflow --->
	 
<cfelse>
   
	<cfoutput>
	<script>
	     try { parent.opener.document.getElementById("reloadpos").value = "#Form.PositionNo#" } catch(e) {}
		 se = parent.opener.document.getElementById("refresh_#URL.box#")
		 if (se) {				     
			 se.click();
			 parent.window.close();
			 } else {
			 parent.window.close();
			 try {
			 parent.opener.history.go();
			 } catch(e) {}
			 }
		</script>
	</cfoutput>

</cfif>	 
