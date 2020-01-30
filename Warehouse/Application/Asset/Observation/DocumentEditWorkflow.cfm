
<!--- establish the workflow object --->

<cfquery name="Observation" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    AssetItemObservation
		WHERE   ObservationId = '#URL.AjaxId#'
</cfquery>



<cfquery name="getFlow" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_AssetActionCategoryWorkflow C
	 WHERE   C.ActionCategory = '#Observation.actioncategory#'		
	 AND     C.Category       = '#Observation.Category#' 
	 AND     C.Code           = '#Observation.Observation#'	
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

<cfset link = "Warehouse/Application/Asset/Observation/DocumentEditWorkflow.cfm?id=#URL.ajaxid#">
	
<cf_ActionListing 
	EntityCode       = "AssObservation"	
	EntityGroup      = "#Object.EntityGroup#" 
	EntityClass      = "#Object.EntityClass#"   <!--- driven by the observation --->
	EntityStatus     = ""		
	Owner            = ""	
	ObjectReference  = "Observation #getFlow.description# under No #Observation.ObservationNo+1#"
	ObjectReference2 = "#SESSION.first# #SESSION.last#"
	ObjectKey4       = "#Observation.ObservationId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	AjaxId           = "#URL.AjaxId#"
	Toolbar          = "Yes"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "No">
	 