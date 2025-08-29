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
<cfset actionform = "VA">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM Parameter 
</cfquery>

<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  D.*, 
	        F.FunctionId     as VAId, 
			F.ReferenceNo    as VAReferenceNo,
			F.DateEffective  as VAEffective,
			F.DateExpiration as VAExpiration
    FROM  	Document D LEFT OUTER JOIN Applicant.dbo.FunctionOrganization F ON D.FunctionId = F.FunctionId
	WHERE 	D.DocumentNo = '#Form.Key1#'	
</cfquery>

<cfif Doc.VAid eq "">

		<cfquery name="Owner" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner 
		WHERE Owner IN (SELECT MissionOwner 
		                FROM Organization.dbo.Ref_Mission 
						WHERE Mission = '#Doc.Mission#')
		</cfquery>
	
		<cfif Owner.DefaultSubmission eq "">
	
		 <cf_message message = "Problem, roster has not been configured."
			     return = "back">
				 <cfabort>
	
		</cfif>
		
		<cfparam name="Form.DateEffective" default="#dateformat(now(),client.dateformatshow)#">
		<cfparam name="Form.DateExpiration" default="#dateformat(now()+30,client.dateformatshow)#">
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DateEffective#">
		<cfset STR = dateValue>
					
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DateExpiration#">
		<cfset END = dateValue>

		<!--- insert bucket --->
		
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     FunctionOrganization 
			WHERE    ReferenceNo = '#Form.ReferenceNo#'
		</cfquery>
		
		<cfif Check.recordcount eq "1" and Check.GradeDeployment neq Doc.GradeDeployment>
	
		 	<cf_message message = "Problem, Vacancy Announcement <cfoutput>#Form.ReferenceNo#</cfoutput> is already in use for level: <cfoutput>#Check.GradeDeployment#</cfoutput>">
			 <cfabort>
			 
		<cfelseif Check.recordcount eq "1">	 
		
			<cfquery name="UpdateRosterFunction" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE FunctionOrganization
				SET    FunctionNo        = '#Doc.FunctionNo#',
				       OrganizationCode  = '#Parameter.DefaultOrganization#', 
					   SubmissionEdition = '#Owner.DefaultSubmission#', 
					   DocumentNo        = '#Doc.DocumentNo#', 
					   DateEffective     = #STR#,
					   DateExpiration    = #END#,
					   Status            = '8r'
				WHERE  FunctionId        = '#Check.FunctionId#'
			</cfquery>
			
			<cfset id = Check.FunctionId>
		
		<cfelse>		
		
			<cftry>
		
				<cfquery name="InsertRosterFunction" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO FunctionOrganization (
							 FunctionNo, 
							 OrganizationCode, 
							 SubmissionEdition, 
							 GradeDeployment, 
							 DocumentNo, 
							 ReferenceNo, 
							 DateEffective,
							 DateExpiration,
							 Status, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName  )
					VALUES ( '#Doc.FunctionNo#', 
							 '#Parameter.DefaultOrganization#', 
							 '#Owner.DefaultSubmission#',
							 '#Doc.GradeDeployment#',
							 '#Doc.DocumentNo#', 
							 '#Form.ReferenceNo#',
							 #STR#,
							 #END#,
							 '8',
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#' )
				</cfquery>
			
			   <cfcatch>
			
			    	<cf_message message = "Problem, Vacancy Announcement Bucket (dbo.FunctionOrganization) could not be recorded. Please contact your administrator.">									
				    <cfabort>
				
			  </cfcatch>
			
			</cftry>
			
			<cfquery name="select" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  FunctionId
				FROM    FunctionOrganization
				WHERE   ReferenceNo = '#Form.ReferenceNo#'
				ORDER BY Created DESC
			</cfquery>
		
			<cfset id = Select.FunctionId>
			
		</cfif>
		
		<cfquery name="UpdateDoc" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Document
			SET    FunctionId = '#id#'
			
			<!--- removed , 
			       ReferenceNo = '#Form.ReferenceNo#'
				   --->
			WHERE  DocumentNo = '#Form.Key1#'
		</cfquery>
				
<cfelse>

		<cfquery name="updateBucket" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE FunctionOrganization
			SET    GradeDeployment = '#Doc.GradeDeployment#',
				   ReferenceNo     = '#Form.ReferenceNo#',
				   DocumentNo      = '#Doc.DocumentNo#',
				   FunctionNo      = '#Doc.FunctionNo#'
			WHERE  FunctionId      = '#Doc.VAId#'
		</cfquery>
		
		<!--- disabled 05/06/2008 
		
		<cfquery name="UpdateDoc" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Document
			SET    ReferenceNo = '#Form.ReferenceNo#'
			WHERE  DocumentNo = '#Form.Key1#'
		</cfquery>
		
		--->
				
		<cfset id = Doc.VAId>
		
</cfif>

<!--- competencies --->


<cfquery name="cleanCompetence" 
	 datasource="AppsSelection" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">	 
	 	DELETE FROM FunctionOrganizationCompetence
		WHERE FunctionId = '#id#'			 
</cfquery>

<cfparam name="Form.Competence" default="">

<cfloop index="com" list="#Form.Competence#">

	 <cfquery name="AddCompetence" 
		 datasource="AppsSelection" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">	 
	 	INSERT INTO FunctionOrganizationCompetence
		(FunctionId, CompetenceId, OfficerUserId, OfficerLastName, OfficerFirstName)
		VALUES (
			'#id#',
			'#com#',
			'#SESSION.Acc#',
			'#SESSION.First#',
			'#SESSION.Last#' )	 
	 </cfquery>
	 
</cfloop>	 

<!--- update text --->

<cf_ApplicantTextArea
		Table           = "FunctionOrganizationNotes" 
		Domain          = "JobProfile"
		FieldOutput     = "ProfileNotes"
		Mode            = "Save"
		Key01           = "FunctionId"
		Key01Value      = "#id#"
		Officer         = "N">
	
		