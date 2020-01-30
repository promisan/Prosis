

<cfquery name="Evaluate" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ContractEvaluation
		WHERE    EvaluationId = '#URL.ajaxid#'
</cfquery>
		 		
<cfquery name="Contract" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Contract  
		WHERE    ContractId = '#Evaluate.ContractId#'
</cfquery>

<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ContractActor
		WHERE  Contractid     = '#Evaluate.ContractId#' 
		AND    Role           = 'Evaluation'						
		AND    ActionStatus   = '1'
 </cfquery>
		
 <cfloop query="Role">
		<cfset per = PersonNo>	
		<cfset fun = RoleFunction>
		<cfinclude template="../PASView/CreateEvaluationAccessWorkflow.cfm">					
 </cfloop>
  	 
 <cfquery name="Employee" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Person
		WHERE  PersonNo = '#Contract.PersonNo#'
 </cfquery>	
	 
 <cfset link = "ProgramREM/Portal/Workplan/PAS/PASView.cfm?contractid=#Evaluate.ContractId#">		 
							 
 <cf_ActionListing 
		EntityCode       = "EntPASEvaluation"
		EntityClass      = "#Evaluate.EvaluationType#"
		EntityGroup      = ""
		EntityStatus     = ""
		OrgUnit          = "#Contract.orgunit#"
		PersonNo         = "#Contract.PersonNo#" 
		PersonEMail      = "#Employee.eMailAddress#"
		ObjectReference  = "PAS Recommendation and Review"
		ObjectReference2 = "#Employee.FirstName# #Employee.LastName#"
		ObjectKey1       = "#Evaluate.EvaluationType#"
		ObjectKey4       = "#Evaluate.ContractId#"					
		ObjectURL        = "#link#"
		AjaxId           = "#url.ajaxid#"
		Show             = "Yes"
		CompleteFirst    = "No"
		Toolbar          = "No"				
		Framecolor       = "ECF5FF">	