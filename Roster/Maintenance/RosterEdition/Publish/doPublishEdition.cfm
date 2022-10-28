
<!--- 

Button : PUBLISH

Ref_SubmissionEditionPosition.Publishmode = 1

Generates entries into 

	Applicant.dbo.FunctionOrganization (Bucket) + FunctionOrganizationNotes (text of JO in english/french)
	Vacancy.dbo.Document (Track)

Ref_SubmissionEditionPosition.Publishmode = 0

Generates entries into (so-called direct flow, which is to be discussed)
	
	Vacancy.dbo.Document (Track)
--->

<cfparam name="url.submissionedition" default="">

<cfset SubmissionEdition = url.submissionEdition>

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT SE.*, C.EntityClass AS TrackWF
	FROM   Ref_SubmissionEdition SE
		   INNER JOIN Ref_ExerciseClass C
		   ON SE.ExerciseClass = C.ExcerciseClass
	WHERE  SubmissionEdition = '#SubmissionEdition#'
	
</cfquery>

<cfif Edition.RecordCount eq 0>

		 <cf_message message = "Problem, submission #url.submissionedition# could not be found."
			     return = "back">
				 <cfabort>

</cfif>


<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT *
	FROM   ApplicantFunction
	WHERE  FunctionId IN(
		SELECT FunctionId
		FROM   FunctionOrganization
		WHERE  SubmissionEdition = '#SubmissionEdition#'
	)
	
</cfquery>

<cfif Check.RecordCount gt 0>

		 <cf_message message = "Problem, buckets cannot be recreated because there are candidates recorded already."
			     return = "back">
				 <cfabort>

<cfelse>

	<cfquery name="Validation" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT TOP 1 FunctionId
			FROM   FunctionOrganization
			WHERE  SubmissionEdition = '#SubmissionEdition#'
	</cfquery>
		
	<cfquery name="EditionPosition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT *
		FROM  Ref_SubmissionEditionPosition
		WHERE SubmissionEdition = '#SubmissionEdition#'		
		AND   RecordStatus = '1'  <!--- disabled ones are not published as buckets --->
		ORDER BY Reference
	
	</cfquery>
	
	<cfset step = 1/EditionPosition.RecordCount - 0.001>
	
	<cftransaction>
	
		<cfif Validation.RecordCount gt 0>
	
				<cfquery name="CleanDocument" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM Vacancy.dbo.Document
					WHERE  FunctionId IN
					(
						SELECT FunctionId 
						FROM   Applicant.dbo.FunctionOrganization
						WHERE  SubmissionEdition = '#SubmissionEdition#'
					)
				</cfquery>
			
			
				<cfquery name="CleanFunctionOrganization" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM Applicant.dbo.FunctionOrganization
					WHERE  SubmissionEdition = '#SubmissionEdition#'
				</cfquery>
		
		</cfif>
		
		<cfoutput query="EditionPosition"  group="Reference">
			
			<cfset Session.status = Session.Status + step>
			<cfset Session.message = "Generating bucket: #Reference#">
			
			<cfquery name="AssignNo" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Vacancy.dbo.Parameter 
				SET DocumentNo = DocumentNo+1
			</cfquery>
			
			<cfquery name="LastNo" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Vacancy.dbo.Parameter
			</cfquery>
			
			<cfquery name="Function" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   FunctionTitle
				WHERE  FunctionNo = '#FunctionNo#'
			</cfquery>
			
			<cfquery name="Post" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT P.*, O.OrgUnitName, M.MissionOwner
				FROM   Employee.dbo.Position P 
					   INNER JOIN Organization.dbo.Organization O
					   	 	 ON P.OrgUnitOperational = O.OrgUnit
					   INNER JOIN Organization.dbo.Ref_Mission M
					   	 	 ON M.Mission = P.MissionOperational
				WHERE  PositionNo = #PositionNo#
			</cfquery>
			
			<cfquery name="Grade" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT    R.GradeDeployment
				FROM      Ref_GradeDeployment R INNER JOIN
		                  Employee.dbo.Ref_PostGrade P ON R.PostGradeBudget = P.PostGradeBudget
				WHERE     P.PostGrade = '#Post.PostGrade#'
			</cfquery>
			
			 <cfquery name="getPrior" 
				    datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM FunctionOrganization
					WHERE ReferenceNo = '#Reference#'
			</cfquery>
			
			<cfif getPrior.recordcount eq "0">		 		
			
			<cfquery name="InsertDocument" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Vacancy.dbo.Document
			         (DocumentNo,
					 DocumentNoTrigger,
					 Status,
					 FunctionNo, 
					 FunctionalTitle, 
					 OccupationalGroup,
					 OrganizationUnit,
					 Mission,
					 Owner,
					 PostNumber,
					 PositionNo,
					 DueDate,
					 PostGrade,
					 GradeDeployment,
					 EntityClass,
					 Remarks,
					 Source,
					 OfficerUserId,
					 OfficerUserLastName,
					 OfficerUserFirstName)
			  	VALUES ('#LastNo.DocumentNo#',
			          '0',
			          '0',
					  '#FunctionNo#',
			          '#Function.FunctionDescription#',
					  '#Function.OccupationalGroup#',
					  '#Post.OrgUnitName#',
					  '#Post.MissionOperational#',
					  '#Edition.Owner#',
					  '#Post.MissionOwner#',
					  '#Post.SourcePostNumber#',
					  '#Post.PositionNo#',
					  '#Edition.DateEffective#',
					  '#Post.PostGrade#',
		  			  '#Post.PostGrade#',
					  '#Edition.TrackWF#',
					  '#Edition.EditionDescription#',
					  'Edition',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			  </cfquery>
			  
			  <cfif PublishMode eq "1"> 
				<!--- Applicant.dbo.FunctionOrganization (Bucket) + FunctionOrganizationNotes (text of JO in english/french) --->
				
					<cf_assignid>
					
					<cfquery name="Organization" 
				    datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT OrganizationCode
						FROM   Organization.dbo.Organization
						WHERE  OrgUnit = '#Post.OrgUnitOperational#'
						AND    OrganizationCode IN (SELECT OrganizationCode FROM Ref_Organization)
					
					</cfquery>
					
					<cfif Organization.OrganizationCode neq "">
					    <cfset org = Organization.OrganizationCode>
					<cfelse>
						<cfset org = "[ALL]">
					</cfif>
		
				   <cfquery name="InsertFunctionOrganization" 
				    datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
		
					   INSERT INTO FunctionOrganization (
							 FunctionId,
							 FunctionNo,
							 OrganizationCode,
							 SubmissionEdition,
			      			 GradeDeployment,
			      			 DocumentNo,
			      			 ReferenceNo,
			      			 Mission,
			      			 DateEffective,
			      			 DateExpiration,
			      			 Status,
			      			 OfficerUserId,
			      			 OfficerLastName,
			      			 OfficerFirstName)
						VALUES (
							'#rowguid#',
							'#FunctionNo#',
							'#org#',
							'#SubmissionEdition#',
							<cfif Grade.GradeDeployment neq "">
							'#Grade.GradeDeployment#',
							<cfelse>
							NULL,
							</cfif>
							'#LastNo.DocumentNo#',
							'#Reference#',
							'#Post.MissionOperational#',
							'#Edition.DateEffective#',
							'#Edition.DateExpiration#',
							'1',
							'#SESSION.Acc#',
							'#SESSION.Last#',
							'#SESSION.First#'
						)
						
					</cfquery>				
					
					<!--- post to competencies as well 16/8/2014 --->
										
				    <cfquery name="PositionParentProfile" 
				    datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO FunctionOrganizationCompetence
								(FunctionId,CompetenceId,Officeruserid,OfficerLastName,OfficerFirstName)
						SELECT '#rowguid#',
						       CompetenceId,
							   Officeruserid,
							   OfficerLastName,
							   OfficerFirstName
						FROM   Ref_SubmissionEditionPositionCompetence
						WHERE  PositionNo        = '#PositionNo#'
						AND    SubmissionEdition = '#SubmissionEdition#' 
					</cfquery>					
				 
				    <!--- cross reference to Document ---->
				    <cfquery name="PositionParentProfile" 
				    datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Vacancy.dbo.Document
						SET    FunctionId = '#rowguid#'
						WHERE  DocumentNo = '#LastNo.DocumentNo#'
					</cfquery>
				 
				   <cfquery name="PositionParentProfile" 
				    datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
							SELECT *
							FROM   Employee.dbo.PositionParentProfile
							WHERE  PositionParentId = '#Post.PositionParentId#'
					</cfquery>
					
					<cfloop query="PositionParentProfile">
						
							<cfquery name="InsertFunctioNotes" 
						    datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
									
									INSERT INTO FunctionOrganizationNotes 
											(FunctionId,
											 LanguageCode,
											 TextAreaCode,
											 ProfileNotes,
											 OfficerUserId,
											 OfficerLastName,
											 OfficerFirstName,
											 Created)
									VALUES(
										'#rowguid#',
										'#LanguageCode#',
										'#TextAreaCode#',
										'#JobNotes#',
										'#SESSION.Acc#',
										'#SESSION.Last#',
										'#SESSION.First#',
										getdate()
									)
									
							</cfquery>
						
					</cfloop>
				
						
			  <cfelseif PublishMode eq "0">
				<!--- Generates entries into (so-called direct flow, which is to be discussed) --->
				
		      </cfif>
							  
				 <cfoutput> <!--- Groupig by Ref_SubmissionEditionPosition.Reference --->
				 
				   	<cfquery name="Post" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Employee.dbo.Position
						WHERE  PositionNo = #PositionNo#	
					</cfquery>
				 
					<cfquery name="InsertDocumentPost" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Vacancy.dbo.DocumentPost
						         (DocumentNo,
								 PositionNo,
								 PostNumber,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
					  VALUES ('#LastNo.DocumentNo#',
					          '#PositionNo#',
					          '#Post.SourcePostNumber#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
					  </cfquery>	
				
				</cfoutput>
			
			 </cfif>
			
			
		</cfoutput>
	
	</cftransaction>
	
		<cfquery name="Document" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
				SELECT D.*, P.OrgUnitOperational
				FROM  Document D
					INNER JOIN Employee.dbo.Position P
						ON D.PositionNo = P.PositionNo
				WHERE  D.PositionNo IN
				(
					SELECT PositionNo
					FROM   Applicant.dbo.Ref_SubmissionEditionPosition
					WHERE  SubmissionEdition = '#SubmissionEdition#'
				)
				
		</cfquery>
		
		
		<cfloop query="Document">
		
		   <cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#Document.DocumentNo#">
		 
		   <!--- ---------------------- --->	
		   <!--- create workflow object --->
		   <!--- ---------------------- --->
		   					
		 <cf_ActionListing 
		    TableWidth       = "100%"
		    EntityCode       = "VacDocument"
			EntityClass      = "#Document.EntityClass#"
			EntityGroup      = "#Document.Owner#"
			EntityStatus     = ""		
			Mission          = "#Document.Mission#"
			OrgUnit          = "#Document.OrgUnitOperational#"
			ObjectReference  = "#Document.FunctionalTitle#"
			ObjectReference2 = "#Document.Mission# - #Document.PostGrade#"
			ObjectKey1       = "#Document.DocumentNo#"
			Show             = "No"	
		  	ObjectURL        = "#link#"
			DocumentStatus   = "0">
		
		</cfloop>

	
	<cfset Session.status = 1>
	
	<script>
		ColdFusion.ProgressBar.stop('pBar') ;
		ColdFusion.ProgressBar.hide('pBar') ;
	</script>
	
	Buckets have been generated. You can continue now.
		
</cfif>



<!---
	
Button SEND

- we have the edition, which links to the Ref-ExerciseClass -> TreePublish = UNMembers

- retrieve the nodes (Organization, OrganziationAddress) [we validate on the effective/expiration date]

- generate document of note verbale (combinate standard and variable text, check with Giorgia)

- retrieve the associated Buckets 
   
    create the JO text in english / french from the table FunctionOrganizationtNotes 
	
- trigger the email
- save eMail action in Ref_SubmissionEditionPublish
	[Jorge, how can we capture we delivery confirmation ?]
- Prevent sending eMails twice, unless Ref_SubnmissionEditionPublish allows for it.

 --->