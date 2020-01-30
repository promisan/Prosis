
<!--- inherit from the parent object --->

<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObject
	   WHERE   ObjectId IN (SELECT ObjectId 
	                        FROM OrganizationObjectAction 
							WHERE ActionId = '#URL.AjaxId#')	
</cfquery>

<cfquery name="Class" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     R.EmbeddedClass
     FROM       OrganizationObjectAction OA INNER JOIN
                Ref_EntityActionPublish R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode
	 WHERE      ActionId = '#URL.AjaxId#' 				
</cfquery>

<cfset link = "#Object.ObjectURL#">
									
<cf_ActionListing 
	EntityCode       = "#Object.EntityCode#"
	EntityClass      = "#Class.EmbeddedClass#"
	EntityGroup      = "#Object.EntityGroup#"
	EntityStatus     = "#Object.EntityStatus#"
	Mission          = "#Object.mission#"
	OrgUnit          = "#Object.orgunit#"
	PersonNo         = "#Object.PersonNo#" 
	PersonEMail      = "#Object.PersonEMail#"
	ObjectReference  = "#Object.ObjectReference#"
	ObjectReference2 = "Embedded workflow"
	ObjectKey4       = "#URL.AjaxId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	AjaxId           = "Embed"
	Toolbar          = "Yes"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "No">