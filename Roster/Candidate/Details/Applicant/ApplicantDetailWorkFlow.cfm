<cfquery name="Candidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT   A.*, 
		         R.Description
   		FROM     Applicant A LEFT OUTER JOIN Ref_ApplicantClass R ON A.ApplicantClass = R.ApplicantClassId
	    WHERE    PersonNo = '#URL.ajaxid#'
</cfquery>

<!--- based on the source --->
	
<cfquery name="Source" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT   *
   		FROM     Ref_Source
		WHERE    Source = '#candidate.source#'	
</cfquery>	
	
<cfif source.entityClass neq "">	
	
	 <cfset link = "Roster/Candidate/Details/PHPView.cfm?id=#URL.ajaxid#">
	 
	 <!--- candidate enrollment flow, include creating useraccount and customer record --->
	 							
	 <cf_ActionListing 
	    EntityCode        = "Candidate"
		EntityCodeForce  = "Yes"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		OrgUnit          = ""
		PersonNo         = "#URL.ajaxid#"
		PersonEMail      = "#Candidate.EMailAddress#"
		ObjectReference  = "Person Enrollment"
		AjaxId           = "#url.ajaxid#"
		ObjectReference2 = "#Candidate.FirstName# #Candidate.LastName#"
		ObjectKey1       = "#URL.ajaxid#"			    
		ObjectURL        = "#link#">	
	
</cfif>		