	
<cfquery name="get" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   	SELECT 	  L.Mission, 
	          L.ServiceItem,
			  S.Description AS ServiceItemDescription,
			  L.ServiceUsageSerialNo,
			  L.SelectionDateStart,
			  L.SelectionDateEnd,
			  L.Memo,
			  L.ActionStatus,
			  L.UsageLoadId
	FROM 	  ServiceItemLoad L
	INNER JOIN ServiceItem S ON S.Code = L.ServiceItem
	WHERE UsageLoadId = '#URL.ajaxId#'
</cfquery>
	
<cfset link = "">			
	
 <cf_ActionListing 
    EntityCode       = "WorkOrderLoad"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#get.mission#"	
	ObjectReference  = "#get.ServiceItem#"
	ObjectReference2 = "#get.ServiceItemDescription#" 	
	ObjectKey1       = "#get.ServiceUsageSerialNo#"
	ObjectKey4       = "#URL.ajaxId#"
	AjaxId           = "#URL.ajaxId#"
	ObjectURL        = "#link#"	
	Show             = "Yes">
	
	
