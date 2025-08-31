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
<cfquery name="BucketCompetencies" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT FC.CompetenceId
	FROM   Document D 
		   INNER JOIN Applicant.dbo.FunctionOrganization FO
				 ON D.FunctionId = FO.FunctionId
		   INNER JOIN Applicant.dbo.FunctionOrganizationCompetence FC
		   		 ON FO.FunctionId = FC.FunctionId
	WHERE  D.DocumentNo = '#URL.DocumentNo#'

</cfquery>

<cfquery name="Competence" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT C.CompetenceId
	FROM   Applicant.dbo.Ref_Competence C
	WHERE  C.Operational = 1
	<!--- Means that competencies applicable for this track have been defined at the bucket level --->
	<cfif BucketCompetencies.recordcount gt 0>
		AND C.CompetenceId IN (
			#QuotedValueList(BucketCompetencies.CompetenceId)#
		)
	</cfif>
 	ORDER BY C.ListingOrder
	
</cfquery>
			
<cfif Form.DateInterviewStart neq "">

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateInterviewStart#">
	<cfset STR = dateValue>

	<cfset ta = DateAdd("h", "#Form.HourInterviewStart#",   "#STR#")> 
	<cfset ta = DateAdd("m", "#Form.MinuteInterviewStart#", "#ta#")>
	
	<cfset te = DateAdd("h", "#Form.HourInterviewEnd#",   "#STR#")> 
	<cfset te = DateAdd("m", "#Form.MinuteInterviewEnd#", "#te#")>


	 <cfquery name="CandidateStatus" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE DocumentCandidate
			SET   
				<!---
				  DO not update the status automatically, candidate might have attended
				  to the interview but might not be considereted for the selection
				  				  
			      StatusDate             = getDate(),
				  StatusOfficerUserId    = '#SESSION.acc#',
				  StatusOfficerLastName  = '#SESSION.last#',
				  StatusOfficerFirstName = '#SESSION.first#', 
				  Status				 = '#Form.CandidateStatus#',
				  --->
				  TsInterviewStart       = #ta#,
				  TsInterviewEnd         = #te# 
			WHERE DocumentNo = '#URL.DocumentNo#'
			AND   PersonNo   = '#URL.Personno#'
			AND   Status < '3' 
	 </cfquery>	

</cfif>

 <cfquery name="UpdateReview" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE DocumentCandidateReview
		SET    ReviewDate = #now()#,			   
			   ReviewMemo = '#Form.ReviewMemo#'
		WHERE  DocumentNo = '#URL.DocumentNo#'
		AND    PersonNo   = '#URL.Personno#'
		AND    ActionCode = '#URL.ActionCode#'
</cfquery>	
	
<cfoutput query="Competence">

<cfparam name="Form.#CompetenceId#" default="">

		<cfset text  =   Evaluate("Form.#CompetenceId#")>
					
		<cfquery name="Check" 
		   datasource="AppsVacancy" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT *
			FROM   DocumentCandidateInterview
			WHERE  DocumentNo   = '#URL.DocumentNo#'
			AND    PersonNo     = '#URL.Personno#'
			AND    ActionCode   = '#URL.ActionCode#'
			AND    CompetenceId = '#CompetenceId#'
		</cfquery>
		
		<cfif Check.recordcount eq "0">
	
		 <cfquery name="InsertNotes" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO DocumentCandidateInterview
				 (DocumentNo,
				  PersonNo,		  
				  ActionCode,
				  CompetenceId,
				  InterviewNotes,
				  InterviewId,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
			  VALUES ('#URL.DocumentNo#', 
					  '#URL.PersonNo#',		  
					  '#URL.ActionCode#',
					  '#CompetenceId#',
					  '#Text#',
					  '#Form.InterviewId#',
					  '#SESSION.acc#',
					  '#SESSION.last#',		  
					  '#SESSION.first#')
			</cfquery>
	
	    <cfelse>
	
		   <cfquery name="Update" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE DocumentCandidateInterview
				SET    InterviewNotes = '#text#'
				WHERE  DocumentNo     = '#URL.DocumentNo#'
				AND    PersonNo       = '#URL.PersonNo#'	 
				AND    ActionCode     = '#URL.ActionCode#'	
				AND    CompetenceId   = '#CompetenceId#'
			</cfquery>
	
	    </cfif>
	
</cfoutput>
	
<script>	
	parent.parent.opener.history.go()
	parent.parent.ProsisUI.closeWindow('interviewbox')
</script>