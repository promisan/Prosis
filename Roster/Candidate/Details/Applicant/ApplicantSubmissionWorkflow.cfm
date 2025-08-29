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
<cfquery name="Submission" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT APPS.*, A.FirstName, A.LastName, A.EMailAddress 
		FROM   ApplicantSubmission APPS
	    INNER  JOIN Applicant A    ON APPS.PersonNo = A.PersonNo
		WHERE  APPS.ApplicantNo = '#URL.AjaxId#'
			
</cfquery>
	
<cfquery name="Edition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT   *
   		FROM     Ref_SubmissionEdition
		WHERE    SubmissionEdition = '#Submission.SubmissionEdition#'
</cfquery>	
	
<cfif Edition.EntityClass neq "">	
	
	 <cfset link = "Roster/Candidate/Details/PHPView.cfm?id=#Submission.PersonNo#">
							
	 <cf_ActionListing 
	    EntityCode       = "CanSubmission"
		EntityClass      = "#Edition.EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		OrgUnit          = ""s
		PersonEMail      = "#Submission.EMailAddress#"
		ObjectReference  = "Candidate Submission - #Edition.EditionDescription#"
		AjaxId           = "#url.ajaxid#"
		ObjectReference2 = "#Submission.FirstName# #Submission.LastName#"
		ObjectKey1       = "#URL.ajaxid#"			    
		ObjectURL        = "#link#">	
	
</cfif>		