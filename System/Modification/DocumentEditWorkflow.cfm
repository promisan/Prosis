
<!--- establish the workflow object --->

<cfquery name="Observation" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Observation
		WHERE   ObservationId = '#URL.AjaxId#'
</cfquery>

<cfquery name="Requester" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    UserNames
		WHERE   Account = '#Observation.Requester#'
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

<cfset link = "System/Modification/DocumentView.cfm?id=#URL.AjaxId#">
	
<cf_ActionListing 
	EntityCode       = "#Object.EntityCode#"	
	EntityGroup      = "#Object.EntityGroup#" 
	EntityClass      = "#Object.EntityClass#"
	PersonEmail      = "#Object.PersonEmail#"	
	EntityStatus     = ""		
	Owner            = "#Observation.Owner#"	
	ObjectReference  = "#Object.ObjectReference#"
	ObjectReference2 = "#Requester.firstName# #Requester.lastName#"
	ObjectKey4       = "#Observation.ObservationId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	AjaxId           = "#URL.AjaxId#"
	Toolbar          = "Yes"
	Annotation       = "No"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "No">