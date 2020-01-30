
<cfparam name="Form.Remarks" default="">
<cfparam name="Form.DocumentNo" default="0">

<cfif Len(Form.Remarks) gt 250>
	 <cf_alert message = "Your entered Remarks that exceed the allowed size of 250 characters."
	  return = "back">
	  <cfabort>
</cfif>
		
<cfquery name="UpdateCandidate" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE DocumentCandidate
	SET Remarks             = '#Form.Remarks#'
	<!--- , 
	PostNumber          = '#Form.PostNumber#'
	--->
	WHERE DocumentNo        = '#Form.DocumentNo#'	
	AND   PersonNo          = '#Form.PersonNo#'
</cfquery>

<cf_compression>
