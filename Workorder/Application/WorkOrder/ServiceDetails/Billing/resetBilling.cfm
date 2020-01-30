<cfparam name="url.unitclass"   default="">
<cfparam name="url.costid"      default="">
<cfparam name="url.quantity"    default="1">


<cfquery name="resetwol" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
     	UPDATE		WorkOrderLine
     	SET 		ActionStatus 	= '1'
	 	WHERE   	WorkOrderId     = '#url.workorderid#'	
	 	AND     	WorkOrderLine   = '#url.workorderline#'		
</cfquery>


