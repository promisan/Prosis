
 <cfquery name="Document" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM  EmployeeAction
	WHERE ActionSourceNo = '#url.ajaxid#' 		
	AND   ActionSource = 'Assignment'
 </cfquery>

 <cfset link = "">
	  
 <cfquery name="Person" 
 	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT *
			FROM Person
			WHERE PersonNo = '#Document.ActionPersonNo#' 
 </cfquery>
		
 <cf_ActionListing 
	    EntityCode       = "Assignment"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#Document.mission#"
		PersonNo         = "#Document.ActionPersonNo#"											
		ObjectReference  = "Move to another position"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
		ObjectFilter     = "#document.ActionCode#"
		ajaxid           = "#Document.ActionSourceNo#"
	    ObjectKey1       = "#Document.ActionSourceNo#"							
		ObjectURL        = "#link#"
		Show             = "Yes"> 