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
<cfparam name="url.documentNo"   default="">
<cfparam name="url.objectid"     default="">

<cfif url.objectId neq "">
	
	<cfquery name="check" 
	     datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   OrganizationObject
			 WHERE  ObjectId = '#url.objectid#'
	</cfquery>
	
	<cfset url.documentno = check.ObjectKeyValue1>

</cfif>

<cfparam name="url.personno"     default="">
<cfparam name="url.actionCode"   default="">
<cfparam name="url.competenceid" default="">

<cfif url.personno neq "" and url.competenceid neq "">
	
	<cfquery name="user" 
	     datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   UserNames
			 WHERE  Account = '#url.useraccount#'
	</cfquery>
	
	<cfif url.documentno neq "">
		
		<cfquery name="getReview" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   DocumentCandidateReview
			 WHERE  DocumentNo = '#url.documentno#'
			 AND    PersonNo   = '#url.personNo#'
			 AND    ActionCode = '#url.actionCode#'
		</cfquery>
		
		<cfif getReview.recordcount eq "0">
		
			<cfquery name="Insert" 
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO DocumentCandidateReview
						 (DocumentNo,
						  PersonNo,		  
						  ActionCode,							 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.documentno#',		  
						  '#url.personNo#',							 
						  '#url.actionCode#',
						  '#user.account#',
						  '#user.lastname#',		  
						  '#user.firstname#')
			</cfquery>	
		
		</cfif>
		
		<cfquery name="getReviewCompetence" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   DocumentCandidateReviewCompetence
			 WHERE  DocumentNo   = '#url.documentno#'
			 AND    PersonNo     = '#url.personNo#'
			 AND    ActionCode   = '#url.actionCode#'
			 AND    CompetenceId = '#url.CompetenceId#'
		</cfquery>
		
		<cfif getReviewCompetence.recordcount eq "0">
		
			<cfquery name="Insert" 
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO DocumentCandidateReviewCompetence
						 (DocumentNo,
						  PersonNo,		  
						  ActionCode,	
						  CompetenceId,		
						  CompetenceMode,				 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.documentno#',		  
						  '#url.personNo#',							 
						  '#url.actionCode#',
						  '#url.competenceid#',
						  'Topic',
						  '#user.account#',
						  '#user.lastname#',		  
						  '#user.firstname#')
			</cfquery>	
		
		</cfif>
		
		<cfquery name="getAssessment" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   DocumentCandidateAssessment
			 WHERE  DocumentNo    = '#url.documentno#'
			 AND    PersonNo      = '#url.personno#'
			 AND    ActionCode    = '#url.actionCode#'
			 AND    Competenceid  = '#url.competenceid#'
			 AND    OfficerUserid = '#user.account#'  
		</cfquery>
		
		<cfif getAssessment.recordcount eq "1">
		
			<cfset val = evaluate("form.#url.formfield#")>	
		
			<cfquery name="updateAssessment" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE DocumentCandidateAssessment
				 SET    <cfif url.field eq "score">
					    AssessmentScore = '#val#'
					    <cfelse>
					    AssessmentMemo  = '#val#'
					    </cfif>
				 WHERE  DocumentNo      = '#url.documentNo#'
				 AND    PersonNo        = '#url.personno#'
				 AND    ActionCode      = '#url.actionCode#'
				 AND    Competenceid    = '#url.competenceid#'
				 AND    OfficerUserid   = '#user.account#' 
		     </cfquery>
			
		<cfelse>
		
			<cfset val = evaluate("form.#url.formfield#")>		
		
			<cfquery name="Insert" 
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO DocumentCandidateAssessment
							 (DocumentNo,
							  PersonNo,		  
							  ActionCode,							 
							  Competenceid,						  
							  <cfif url.field eq "score">
							  AssessmentScore,
							  <cfelse>
							  AssessmentMemo,
							  </cfif>
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
					  VALUES ('#url.documentNo#',		  
							  '#url.personno#',							 
							  '#url.actionCode#',
							  '#url.competenceid#',
							  '#val#',
							  '#user.account#',
							  '#user.lastname#',		  
							  '#user.firstname#')
				</cfquery>			
			
		 </cfif>
		
	</cfif>	
	
</cfif>	

<cfquery name="getSubmission" 
     datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   DocumentCandidateAssessment
	 WHERE  DocumentNo    = '#url.documentno#'
	 AND    PersonNo      = '#url.personno#'
	 AND    ActionCode    = '#url.actionCode#'
	 AND    Competenceid  = '#url.competenceid#'
	 AND    OfficerUserid = '#user.account#'  
</cfquery>


<cfif url.modality eq "Interview">
			
		<cfoutput>
		<script>			
			try { 
			$("##Score#url.Personno#_#url.competenceid#_#url.useraccount#", window.parent.document).val('#getSubmission.AssessmentScore#')
		<!--- $("##Memo#url.Personno#_#url.competenceid#_#url.useraccount#", window.parent.document).val('#getSubmission.AssessmentMemo#')	--->
			} catch(e) {}
		</script>
		</cfoutput>
	
<cfelse>

	<!--- calculate total score for the person --->
	
	<cfquery name="getPhrases" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       FunctionOrganizationTopic
		WHERE 	   FunctionId IN (SELECT FunctionId 
		                          FROM   Functionorganization 
								  WHERE  Documentno = '#url.documentno#')           
		AND        Operational = 1 
		ORDER BY   TopicOrder
	</cfquery>
	
	
	<cfquery name="getScore" 
	     datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT       PersonNo, ROUND(AVG(AssessmentScore),0) AS Score
			FROM         DocumentCandidateAssessment
			WHERE        DocumentNo = '#url.documentno#' 
			AND          ActionCode = '#url.actionCode#'
			AND          AssessmentScore > 0
			AND          CompetenceId IN (SELECT TopicId FROM Applicant.dbo.FunctionOrganizationTopic) 
			GROUP BY     PersonNo
	</cfquery>
	
	<cfset scoreresult = "">
	
	<cfloop query="getScore">
		
		<cfquery name="setScore" 
		    datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE DocumentCandidateReview
				SET     ReviewScore = '#Score#'
				WHERE        DocumentNo = '#url.documentno#' 
				AND          ActionCode = '#url.actionCode#' 
				AND          PersonNo   = '#personno#' 	
		</cfquery>
		
		<cfoutput>
		<cfif personno eq url.personno>		
			<cfset scoreresult = "#Score#">	
		</cfif>
		</cfoutput>
	
	</cfloop>	
	
	<cfoutput>
	
	<!--- test result score --->
	
	<cfif len(url.competenceid) gte "10">
		
		<script>	
			try { 	
			<cfif getPhrases.TopicRatingPass lte scoreresult>
			$("##ReviewStatus_#url.Personno#", window.parent.document).prop('checked', true);
			<cfelse>
			$("##ReviewStatus_#url.Personno#", window.parent.document).prop('checked', false);
			</cfif>
			$("##Score#url.Personno#", window.parent.document).val('#scoreresult#')
			$("##Score#url.Personno#_#left(url.competenceid,8)#_#url.useraccount#", window.parent.document).val('#getSubmission.AssessmentScore#')
			<!--- $("##Memo#url.Personno#_#left(url.competenceid,8)#_#url.useraccount#", window.parent.document).val('#getSubmission.AssessmentMemo#') --->
			} catch(e) {}
			
		</script>
	
	</cfif>	
	
	</cfoutput>
	
</cfif>	
