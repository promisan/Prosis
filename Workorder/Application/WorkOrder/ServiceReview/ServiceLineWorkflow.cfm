
<cfquery name="get" 
datasource="appsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  WorkOrderEvent
	WHERE WorkOrderEventId = '#URL.ajaxId#'
</cfquery>

<cfquery name="GetObject" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   OrganizationObject
  WHERE  ObjectKeyValue4 = '#get.WorkOrderEventId#'
</cfquery>

<cfquery name="workorder" 
datasource="appsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  WorkOrder
	WHERE WorkOrderId = '#get.WorkOrderId#'
</cfquery>

<cfquery name="serviceitem" 
datasource="appsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ServiceItem
	WHERE Code = '#workorder.serviceitem#'
</cfquery>
	
<cfset link = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#get.WorkOrderId#&selected=servicelevel">			
		
<cf_ActionListing 
	    EntityCode       = "WrkEvent"
		EntityClass      = "#getObject.EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#workorder.mission#"				
		ObjectReference  = "#get.EventReference#"
		ObjectReference2 = "#serviceitem.description#" 			    
		ObjectKey4       = "#URL.ajaxId#"
		AjaxId           = "#URL.ajaxId#"
		ObjectURL        = "#link#"
		Reset            = "Limited"
		Show             = "Yes">	
	
	
