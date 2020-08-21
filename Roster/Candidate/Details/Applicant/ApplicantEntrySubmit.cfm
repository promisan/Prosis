
<cf_assignid>

<cfparam name="url.mode"         default="entry">

<cfparam name="form.submissionid" default="#rowguid#">
<cfparam name="url.submissionid"  default="#form.submissionid#">

<!--- mode ciopy is from employee --->

<cfif url.mode neq "Copy">
	
	<cf_DialogStaffing>	
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	<cf_screentop html="No">
	
</cfif>

<cfset CLIENT.Submission = "Manual">

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 DefaultRoster
	FROM   Ref_ParameterOwner 
	WHERE  DefaultRoster IS NOT NULL
</cfquery>

<cfparam name="Form.SubmissionEdition"     default="#Edition.DefaultRoster#">
<cfparam name="Form.Mission"               default="">
<cfparam name="Form.Source"                default="Manual">
<cfparam name="Form.eMailAddress"          default="">
<cfparam name="Form.DOB"                   default="">
<cfparam name="Form.MobileNumber"          default="">
<cfparam name="Form.Nationality"           default="USA">
<cfparam name="Form.NationalityAdditional" default="">
<cfparam name="Form.OrgUnit"			   default="">
<cfparam name="Form.ApplicantClass"        default="2">
<cfparam name="Mode"                       default="Entry">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DOB#">
<cfset DOBdate = dateValue>

<cfif FORM.DOB eq "" or NOT isDate(DOBDate)>

	<cf_tl id="You must enter a Date of Birth" var="1" class="message">
	<cf_message message="#lt_text#" return="back">
	<cfabort>
	
</cfif>

<!--- verify is candidate applicant record exist --->

<cfquery name="ExerciseClass" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_SubmissionEdition
	WHERE  SubmissionEdition = '#Form.SubmissionEdition#'
</cfquery>

<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT(PersonNo)
	FROM   Applicant
	WHERE  LastName          = '#Form.LastName#' 
	AND    LEFT(FirstName,1) = '#left(Form.FirstName,1)#'
	AND    DOB               = #DOBDate#
	AND    Nationality       = '#Form.Nationality#'
</cfquery>

<!--- check also if the source was found --->

<cfquery name="Application" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ApplicantNo, PersonNo
	FROM   ApplicantSubmission S
	WHERE  S.PersonNo          = '#Candidate.PersonNo#'
	AND    S.SubmissionEdition = '#Form.SubmissionEdition#'
	AND    S.Source            = '#Form.Source#'
</cfquery>

<cfset customerid = "">

<cfif Candidate.recordCount gte 1 and Application.recordcount gte "1"> 

    <!--- we have 2 people or one person with the same source --->

    <cfif mode eq "Entry">

		<cf_tl id="Candidate with this lastname, firstname, DOB and nationality already exists" var="1" class="message">
		<cfset msg1 = lt_text>
		<cf_tl id="Please contact administrator" var="1" class="message">
		<cfset msg2 = lt_text>
		
		<cf_message message="#msg1# : #Form.FirstName# #Form.LastName#" return="back">
		<cfabort>
	
	</cfif>

<cfelseif Candidate.recordCount is 1 and Application.recordCount is 0> 
	
	     <!--- temp measure --->
	     <cfquery name="Last" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		    SELECT    TOP 1 ApplicantNo AS LastNo
		    FROM      ApplicantSubmission
			ORDER BY  ApplicantNo DESC
	     </cfquery>
		 
		 <cfif Last.LastNo neq "">
		    <cfset new = Last.LastNo+1>
		 <cfelse>	
		    <cfset new = "1">
		 </cfif>    
		 
	      <!--- Submit a profile submission record --->
		  
		 <cftransaction>
	
	     <cfquery name="InsertApplicant" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
	     	INSERT INTO ApplicantSubmission
		         (PersonNo,
				 ApplicantNo,
		  		 SubmissionDate,
				 ActionStatus,
				 Source,
				 SubmissionEdition,
				 <cfif Form.OrgUnit neq "">
					 OrgUnit,
				 </cfif>
				 eMailAddress,
 				 SubmissionId,
				 LanguageId,
			 	 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
	       VALUES ('#Candidate.PersonNo#',
		       '#new#', 
	           '#DateFormat(Now(),CLIENT.DateSQL)#',
			  '0',
			  '#Form.Source#',
			  '#Form.SubmissionEdition#',
			  <cfif Form.OrgUnit neq "">
				  '#Form.OrgUnit#',
			  </cfif>
			  '#Form.eMailAddress#',
			  '#url.submissionid#',
			  '001',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	     </cfquery>
		 
		 <cfquery name="AssignNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	UPDATE Parameter 
			SET    ApplicantNo = #new#
	     </cfquery>
		 
		 </cftransaction>
		 
		 <cfset CLIENT.PersonNo = Candidate.PersonNo>
		 <cfset personNo        = Candidate.PersonNo>
	
<cfelse>

		<cftransaction>
	
	     <!--- temp measure --->
	     <cfquery name="Last" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT    TOP 1 ApplicantNo AS LastNo
		    FROM      ApplicantSubmission
			ORDER BY  ApplicantNo DESC
	     </cfquery>
		 
		 <cfif Last.LastNo neq "">
		    <cfset new = Last.LastNo+1>
		 <cfelse>	
		    <cfset new = "1">
		 </cfif> 
	
	     <cfquery name="AssignNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	    	 UPDATE Parameter SET ApplicantNo = #new#
	     </cfquery>
	     
	     <cfquery name="AssignNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     UPDATE Parameter SET PersonNo    = PersonNo+1
		 </cfquery>
		 	
	     <cfquery name="LastNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Parameter
		 </cfquery>
		 
		 <cfquery name="Check" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 	SELECT * 
			FROM   Applicant 
			WHERE  PersonNo = '#lastno.Personno#'
		 </cfquery>
		 
		 <cfloop condition="#check.recordcount# eq 1">
		 
			 <cfquery name="AssignNo" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     UPDATE Parameter 
				 SET    PersonNo    = PersonNo+1
			 </cfquery>
			 	
		     <cfquery name="LastNo" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     SELECT *
			     FROM   Parameter
			 </cfquery>
			 
			 <cfquery name="Check" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT  * 
			 FROM    Applicant 
			 WHERE   PersonNo = '#LastNo.PersonNo#'
			 </cfquery>
		 
		 </cfloop>		
		 
		 <cfquery name="Check" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		   		SELECT *
				FROM   Organization.dbo.Ref_Entity
		   		WHERE  EntityCode = 'Candidate'
		</cfquery>
		
		<cfquery name="Source" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		   		SELECT   *
		   		FROM     Ref_Source
				WHERE    Source = '#Form.source#'	
		</cfquery>	 
		
		<cfif check.operational is "1" and source.entityClass neq "">		
			  <cfset st = "0">		
		<cfelse>		
			  <cfset st = "1">	<!--- no workflow --->	
		</cfif>		
		 	
	     <cfquery name="InsertApplicant" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 		 
	     	INSERT INTO Applicant 
		         (PersonNo,
				 IndexNo, 
				 EmployeeNo,
				 LastName,
				 LastName2,
				 MaidenName,
				 FirstName,
				 MiddleName,
				 DOB,
				 Gender,
				 Nationality,
				 NationalityAdditional,				 
				 CandidateStatus,
				 ApplicantClass,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Remarks,	
				 Source,
				 eMailAddress,
				 MobileNumber
				 <cfif FORM.MaritalStatus neq "">
					 ,MaritalStatus
				 </cfif>
				 )
	      	VALUES ('#LastNo.PersonNo#',
		          '#Form.IndexNo#',
				  '#Form.EmployeeNo#',
				  '#Form.LastName#',
				  '#Form.LastName2#',
				  '#Form.MaidenName#',
				  '#Form.FirstName#',
				  '#Form.MiddleName#',
				  #DOBDate#,
				  '#Form.Gender#',
				  '#Form.Nationality#',
				  '#Form.NationalityAdditional#',				 
				  '#st#', <!--- if no workflow it is cleared directly with status = 1 --->
				  '#Form.ApplicantClass#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  '#Form.Remarks#',
				  '#ExerciseClass.ExerciseClass#',
			      '#Form.eMailAddress#',
				  '#Form.MobileNumber#'
				  <cfif FORM.MaritalStatus neq "">
				  	,'#Form.MaritalStatus#'
				  </cfif>	
				  )
		  </cfquery>
			  
	      <!--- Submit submission --->
	
	     <cfquery name="InsertApplicant" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		
	     	INSERT INTO ApplicantSubmission
		         (PersonNo,
				 ApplicantNo,
		  		 SubmissionDate,
				 ActionStatus,
				 Source,
				 SubmissionEdition,
				 <cfif Form.OrgUnit neq "">
					 OrgUnit,
				 </cfif>
				 eMailAddress,
				 SubmissionId,
				 LanguageId,
			 	 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	      	VALUES ('#LastNo.PersonNo#',
		         '#LastNo.ApplicantNo#', 
	             '#DateFormat(Now(),CLIENT.DateSQL)#',
			     '0',
			     '#Form.Source#',
			     '#Form.SubmissionEdition#',
				  <cfif Form.OrgUnit neq "">
					  '#Form.OrgUnit#',
				  </cfif>
			     '#Form.eMailAddress#',
				 '#url.submissionid#',
			     '001',
			     '#SESSION.acc#',
	    	     '#SESSION.last#',		  
		  	     '#SESSION.first#')
	     </cfquery>
		
			 
		 <cfset CLIENT.PersonNo = LastNo.PersonNo>
		 <cfset personNo = LastNo.PersonNo>
		 
		 <cfif form.mission neq "" and Form.ApplicantClass eq "4">
		  
			  <!--- create customer profile --->
			  
			  <cf_assignid>
			  
			   <cfquery name="InsertSubmission" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			  	   INSERT INTO WorkOrder.dbo.Customer
				         	(CustomerId,
							PersonNo,
						 	Mission,
							Reference,
				  		 	CustomerName, 					 		 	
						 	eMailAddress,					 	
					 	 	OfficerUserId,
						 	OfficerLastName,
						 	OfficerFirstName,	
						 	Created)
			      	VALUES ('#rowguid#',
					    '#LastNo.PersonNo#',
				       	'#Form.Mission#', 
						<cfqueryparam value="#form.IndexNo#"       cfsqltype="CF_SQL_CHAR" maxlength="20">,
			           	'#form.firstname# #form.lastname#',				  		  	
					  	<cfqueryparam value="#Form.eMailAddress#"  cfsqltype="CF_SQL_CHAR" maxlength="50">,						
					  	'#SESSION.acc#',
			    	  	'#SESSION.last#',		  
				  	  	'#SESSION.first#',
					  	getDate())
			  </cfquery>
			  
			  <cfset customerid = rowguid>
			  		  
		  </cfif>
		  
		  </cftransaction>
		  
		   <!--- save topics in this form --->
		 		 
		 <cfquery name="Topics" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				
				SELECT    *							   
				FROM      Ref_SourceTopic 
				WHERE     Source = '#form.source#' AND  Operational = 1 
						
		 </cfquery>	
		
		 <cfset url.topics = quotedvalueList(Topics.Topic)>	
		 <cfset url.parent = "Miscellaneous">		 
		 <cfset url.applicantNo = LastNo.ApplicantNo>
		 <cfset url.embed = "1">
		 <cfinclude template="../../../PHP/PHPEntry/Topic/TopicSubmit.cfm">
		 
</cfif>	 
	
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfif Mode eq "Entry">
	
	<cfoutput>
	
		<cfswitch expression="#URL.Next#"> 
		
			<cfcase value="Default">
				 
				<script>	
				
					<cfif form.submissionedition eq "Generic">				  
					
					  ptoken.location("#session.root#/Roster/Candidate/Details/Applicant/ApplicantEntry.cfm?id=&idmenu=#url.idmenu#&source=#form.source#&submissionedition=#form.submissionedition#")
					  ShowCandidate('#personNo#')
					
					<cfelse>
					
					  ptoken.location("#session.root#/Roster/Candidate/Details/Applicant/ApplicantEntryBucket.cfm?id=#personNo#&source=#form.source#&submissionedition=#form.submissionedition#")
					  try {
					  opener.document.getElementById("listingrefresh").click()		
					  } catch(e) {}
					   				
					</cfif>					
							
				</script>	
			
			</cfcase>  
			
			<cfcase value="Patient">
			
				<script>
					ptoken.location("#session.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?context=schedule&mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#&customerid=#customerid#&date=#url.date#")				
					
				</script>
					
			</cfcase>  
			
			<cfcase value="Event">
			
			  <script>			  
				    w = #CLIENT.width# - 100;
				    h = #CLIENT.height# - 150;
					ptoken.open("#SESSION.root#/Roster/Candidate/Events/DocumentEdit.cfm?PersonNo=#personNo#", "eventdialog", "left=30, top=30, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=yes, resizable=no");					
			  </script>	
			
			</cfcase>
			
			<cfcase value="Bucket">
			
			  <!--- now record this directly into the bucket --->
			
			  <script>
			
				  window.location = "#SESSION.root#/Roster/Candidate/Details/Functions/ApplicantManualSubmit.cfm?ID=#URL.ID#&PersonNo=#personNo#"
				  <!--- added 7/7/2010 Hanno to close and refresh the bucket dialog for manual people --->				 
				  returnValue = "refresh"
				  window.close()
				
			  </script>	
			
			</cfcase>
			
			<cfcase value="Vacancy">
			
			  <!--- now record this directly into the vactrack but only if this is enabled --->
			
			  <script>
							
				  window.location = "#SESSION.root#/Vactrack/Application/Document/DocumentCandidateRegister.cfm?ID=#URL.ID#&PersonNo=#personNo#"
				  window.close()
				
			  </script>	
			
			</cfcase>
			
			<cfcase value="SSA">
			
			  <!--- now record this directly into the vactrack but only if this is enabled --->
			
			  <script>
						
				  window.location = "#SESSION.root#/Procurement/Application/Quote/Candidates/CandidateRegister.cfm?ID=#URL.ID#&PersonNo=#personNo#"
				  window.close()
				
			  </script>	
			
			</cfcase>
		
		</cfswitch>
	
	</cfoutput>
	
</cfif>	

