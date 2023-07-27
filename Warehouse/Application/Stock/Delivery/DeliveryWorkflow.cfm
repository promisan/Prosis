   
<cfquery name="get"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	  	SELECT    *
		FROM      WorkOrderLineAction WLA INNER JOIN WorkOrder W ON WLA.WorkOrderid = W.WorkOrderId
		WHERE     WorkActionId = '#url.AjaxId#' 			
</cfquery>	

<cfset link = "Warehouse\Application\Stock\Delivery\DeliveryView.cfm?ajaxid=#url.ajaxid#">
		
<cf_ActionListing 
	    EntityCode       = "Workorder"
		EntityClass      = "Deliver"
		EntityGroup      = ""
		EntityStatus     = ""		
		Mission          = "#get.Mission#"
		OrgUnit          = "#get.OrgUnitOwner#"
		ObjectReference  = "Delivery"			    
		ObjectKey4       = "#get.WorkActionId#"
		AjaxId           = "#get.WorkActionId#"
		ObjectURL        = "#link#"
		Show             = "Yes"		
		Toolbar          = "Yes">
				
		
	