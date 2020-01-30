
<cfset wflink = "System/Organization/Customer/Action/ActionListing.cfm?CustomerActionId=#url.ajaxid#">
				
<cfquery name="CustomerAction" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    CustomerAction 
	WHERE   CustomerActionId = '#url.ajaxid#'	
</cfquery>

<cfquery name="Customer" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Customer
	WHERE   CustomerId = '#CustomerAction.customerid#'	
</cfquery>

<cfquery name="Object" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Organization.dbo.OrganizationObject
	WHERE   ObjectKeyValue4 = '#url.ajaxid#'	
</cfquery>
	
<cfquery name="Action" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Ref_Action
	WHERE   Code = '#CustomerAction.ActionClass#'	
</cfquery>

<cf_ActionListing 
    EntityCode       = "WrkCustomer"
	EntityClass      = "#Object.EntityClass#"
	EntityGroup      = "" 
	EntityStatus     = ""
	Mission          = "#Customer.Mission#"	
	ObjectReference  = "#Customer.CustomerName#"
	ObjectReference2 = "#Action.Description#"	  
	ObjectKey4       = "#url.ajaxid#"
	Ajaxid           = "#url.ajaxid#"
	Show             = "Yes"
	ToolBar          = "Yes"
	ObjectURL        = "#wflink#"
	CompleteFirst    = "No"
	CompleteCurrent  = "No"> 

	



			