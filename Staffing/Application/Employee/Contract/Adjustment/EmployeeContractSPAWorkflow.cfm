
<cfquery name="ContractSPA" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  PersonContractAdjustment
	WHERE  PostAdjustmentId = '#URL.ajaxId#'
</cfquery>

<cfquery name="ContractSel" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  PersonContract
	WHERE  ContractId = '#ContractSPA.ContractId#'
</cfquery>

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Person
	WHERE  PersonNo = '#ContractSel.PersonNo#' 
</cfquery>

<cfquery name="Action" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
   	 SELECT * FROM EmployeeAction 						
	 WHERE  ActionSourceId = '#URL.ajaxId#'	
</cfquery>	

<cfquery name="wfclass" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">				
	SELECT  *
	FROM    Ref_Action
	WHERE   ActionCode = '#Action.actionCode#' 
 </cfquery>

<!--- to ensure that close actions will not be reopned --->
<cfif ContractSPA.actionStatus eq "9">
    <cfset enf = "Yes">
<cfelse>
	<cfset enf = "No"> 
</cfif>

 <cfset link = "Staffing/Application/Employee/Contract/Adjustment/ContractSPAForm.cfm?contractid=#ContractSPA.ContractId#&postadjustmentid=#URL.ajaxId#">					
	
<cf_ActionListing 
    EntityCode       = "PersonSPA"
	EntityClass      = "#wfclass.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#contractsel.mission#"
	PersonNo         = "#Person.Personno#"
	ObjectReference  = "#ContractSPA.PostAdjustmentLevel#/#ContractSPA.PostAdjustmentStep#"
	ObjectReference2 = "#Person.FirstName# #Person.LastName#" 	
    ObjectKey1       = "#Person.Personno#"
	ObjectKey4       = "#URL.ajaxId#"
	AjaxId           = "#URL.ajaxId#"	
	ObjectURL        = "#link#"
	Show             = "Yes"
	CompleteCurrent  = "#enf#">
 	
	
