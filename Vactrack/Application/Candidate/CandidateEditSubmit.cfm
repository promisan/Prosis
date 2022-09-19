
<cfquery name="get" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM DocumentCandidate	
	WHERE DocumentNo        = '#Form.DocumentNo#'	
	AND   PersonNo          = '#Form.PersonNo#'
</cfquery>

<cfparam name="Form.Remarks"             default="">
<cfparam name="Form.DateArrivalExpected" default="#dateformat(get.DateArrivalExpected,client.dateformatshow)#">
<cfparam name="Form.DocumentNo"          default="0">

<cfset dateValue = "">
<cfif form.dateArrivalExpected neq "">
	<CF_DateConvert Value="#Form.DateArrivalExpected#">
	<cfset arr = dateValue>
<cfelse>
	<cfset arr = "NULL">	
</cfif>	

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
	SET    Remarks             = '#Form.Remarks#',
	       DateArrivalExpected = #arr#	
	WHERE DocumentNo        = '#Form.DocumentNo#'	
	AND   PersonNo          = '#Form.PersonNo#'
</cfquery>

<cf_compression>
