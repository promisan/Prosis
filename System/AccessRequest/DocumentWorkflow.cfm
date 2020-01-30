
<!--- establish the workflow object --->

<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   UserRequest	
	WHERE  RequestId = '#url.ajaxid#'		
</cfquery>

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    OrganizationObject
		WHERE   ObjectkeyValue4 = '#URL.AjaxId#'
</cfquery>

<!--- 1. test EntityGroup and EntityClass at runtime from the table itself 
2. do I need to submit both ?
3. what happens if group changes

--->

<cfset link = "System/AccessRequest/DocumentEntry.cfm?drillid=#url.ajaxid#">
	
<cf_ActionListing 
		EntityCode       = "AuthRequest"		
		EntityClass      = "Standard"
		EntityStatus     = "0"			
		PersonEmail      = "#Object.PersonEmail#"	
		ObjectReference  = "Authorization Request #get.Application# under No #get.Reference#"
		ObjectReference2 = "#get.OfficerFirstName# #get.OfficerLastName#"
		ObjectKey4       = "#get.RequestId#"
		ObjectURL        = "#link#"
		Show             = "Yes"
		Ajaxid           = "#url.ajaxid#"
		Toolbar          = "Yes"
		Framecolor       = "ECF5FF"
		CompleteFirst    = "Yes">	

	 