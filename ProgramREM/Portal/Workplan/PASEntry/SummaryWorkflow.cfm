<cfset link = "ProgramREM/Portal/Workplan/PAS/PASView.cfm?contractid=#URL.ajaxid#">
			 		
<cfquery name="Contract" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Contract C LEFT OUTER JOIN Ref_ContractPeriod R ON C.Period = R.Code
		WHERE    ContractId = '#URL.ajaxid#'
</cfquery>
   
<cfquery name="Employee" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Person
			WHERE  PersonNo = '#Contract.PersonNo#'
</cfquery>	


<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ContractActor C 
		WHERE    ContractId = '#URL.ajaxid#'
		AND      ActionStatus = '1' 
		AND      Role = 'Evaluation'
		AND      RoleFunction = 'FirstOfficer'
</cfquery>

<cfloop query="Role">

	<cfquery name="Account" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    UserNames
		WHERE   PersonNo = '#PersonNo#'
	</cfquery>

	<cfset acc = Account.account>
	
</cfloop>	
								 
<cf_ActionListing 
	EntityCode       = "EntPAS"
	EntityGroup      = ""
	EntityStatus     = ""
	OrgUnit          = "#Contract.orgunit#"
	PersonNo         = "#Contract.PersonNo#" 
	PersonEMail      = "#Employee.eMailAddress#"
	ObjectReference  = "PAS Approval"
	ObjectReference2 = "#Employee.FirstName# #Employee.LastName#"
	ObjectKey4       = "#url.ajaxid#"
	ObjectURL        = "#link#"
	FlyActor         = "#acc#"
	FlyActorAction   = "PAS02"
	AjaxId           = "#URL.AjaxId#"
	Show             = "Yes"
	Toolbar          = "No"
	Framecolor       = "ECF5FF">	 
					