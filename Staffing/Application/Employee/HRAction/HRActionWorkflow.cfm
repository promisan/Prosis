
<cfquery name="get" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  PersonAction
	WHERE PersonActionId = '#URL.ajaxId#'
</cfquery>

<cfquery name="getAction" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_Action
	WHERE ActionCode = '#get.ActionCode#'
</cfquery>

<!--- determine action --->

<cfquery name="Action" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  EmployeeActionSource
	WHERE ActionSource   = '#getAction.ActionSource#'
	AND   ActionSourceId = '#URL.ajaxId#'
</cfquery>

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#get.PersonNo#' 
</cfquery>	
	
<cfset link = "Staffing/Application/Employee/HRAction/HRActionEdit.cfm?id=#Person.personNo#&id1=#url.ajaxid#">			

<cfparam name="url.show" default="yes">
		
<cf_ActionListing 
	    EntityCode       = "HRAction"
		EntityClass      = "#get.EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#get.mission#"		
		PersonNo         = "#Person.Personno#"
		SourceActionNo   = "#Action.ActionDocumentNo#"
		ObjectReference  = "#getAction.Description#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
		ObjectFilter     = "#get.ActionCode#"  
	    ObjectKey1       = "#Person.Personno#"
		ObjectKey4       = "#URL.ajaxId#"
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Reset            = "Limited"
		Show             = "#url.show#">	
	
