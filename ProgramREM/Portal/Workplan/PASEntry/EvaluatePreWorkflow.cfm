
<cfquery name="Evaluate" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ContractEvaluation
		WHERE    EvaluationId = '#URL.ajaxid#'
</cfquery>

<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT OOA.ActionId
		FROM   OrganizationObject AS OO INNER JOIN
		       OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId
		WHERE  OO.ObjectKeyValue4 = '#Evaluate.ContractId#' 
		AND    OO.ObjectKeyValue1 = 'midterm' 
		AND    OO.Operational = 1 
		AND    OOA.ActionStatus = '0'
</cfquery>

<cfif workflow.recordcount eq "0">

	<!--- has been completed --->
	
	<cfquery name="setEvaluate" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE   ContractEvaluation
			SET      ActionStatus = '2'
			WHERE    EvaluationId = '#URL.ajaxid#'
	</cfquery>

</cfif>

<!--- check for pending workflows --->
			 		
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
		AND    RoleFunction   = 'FirstOfficer'
</cfquery>
		
<cfloop query="Role">

		<cfset per = PersonNo>	
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
					 
<cfset link = "ProgramREM/Portal/Workplan/PAS/PASView.cfm?contractid=#Contract.ContractId#">
				 				 										 
<cf_ActionListing 
	EntityCode       = "EntPASEvaluation"
	EntityClass      = "#Evaluate.EvaluationType#"
	EntityGroup      = ""
	EntityStatus     = ""
	OrgUnit          = "#Contract.orgunit#"
	PersonNo         = "#Contract.PersonNo#" 
	PersonEMail      = "#Employee.eMailAddress#"
	ObjectReference  = "PAS Midpoint"
	ObjectReference2 = "#Employee.FirstName# #Employee.LastName#"
	ObjectKey1       = "#Evaluate.EvaluationType#"
	ObjectKey4       = "#Evaluate.ContractId#"
	ObjectURL        = "#link#"
	AjaxId           = "#url.ajaxid#"
	Show             = "Yes"
	Toolbar          = "No"				
	Framecolor       = "ECF5FF">						