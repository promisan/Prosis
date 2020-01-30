	
<cfquery name="get" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ServiceItemMissionPosting
	WHERE PostingId = '#URL.ajaxId#'
</cfquery>
	
<cfset link = "">			
	
<cf_ActionListing 
    EntityCode       = "SrvClosing"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#get.mission#"	
	ObjectReference  = "#get.ServiceItem#"
	ObjectReference2 = "#get.SelectionDateExpiration#" 	
	ObjectKey4       = "#URL.ajaxId#"
	AjaxId           = "#URL.ajaxId#"
	ObjectURL        = "#link#"	
	Show             = "Yes">	
	
	
