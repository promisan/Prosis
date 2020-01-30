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