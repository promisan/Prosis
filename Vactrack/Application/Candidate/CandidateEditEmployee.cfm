
	<cfquery name="UpdateCandidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Applicant
	SET    IndexNo     = '#url.IndexNo#', 
	       EmployeeNo  = '#url.EmployeeNo#'
	WHERE  PersonNo    = '#url.PersonNo#'
	</cfquery>
