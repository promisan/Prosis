
<cfparam name="url.drillid" default="">
<cfparam name="url.ajaxid" default="#url.drillid#">

<cfif url.ajaxid eq "">

	<table align="center">
	   <tr><td><font size="2" color="gray">Workflow could not be initialised. Please contact your administrator.</td></tr>
	</table>
	<cfabort>

</cfif>

<cfquery name="Action" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     	SELECT * 
		FROM   EmployeeAction A, Ref_Action R
		WHERE  A.ActionCode       = R.ActionCode
		AND    A.ActionDocumentNo = '#url.ajaxid#'	
</cfquery>

<cfif Action.mission eq "">

<table align="center"><tr><td><font size="2" color="gray">Workflow could not be initialised as entity could not be determined</td></tr></table>

<cfelse>
	
	<cfquery name="Person" 
	 	datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Person
			WHERE  PersonNo = '#Action.ActionPersonNo#' 
	</cfquery>
		
	<cfset link = "#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionDialog.cfm?drillid=#URL.ajaxid#">
		
	<cf_ActionListing 
	    EntityCode       = "PersonAction"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#Action.mission#"
		PersonNo         = "#Action.ActionPersonNo#"
		ObjectReference  = "#Action.Description#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
	    ObjectKey1       = "#Action.ActionDocumentNo#"	
		ObjectFilter     = "PersonAction"
		ajaxId           = "#url.ajaxid#"
		ObjectURL        = "#link#"
		Show             = "Yes"						
		CompleteFirst    = "No">	
		
</cfif>	
		 
		
		
