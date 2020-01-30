
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrderLine
	WHERE    WorkOrderLineid   = '#url.workorderlineId#' 	  
</cfquery>	

<cfquery name="qUpdate"
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE WorkOrderLineSettlement
		 SET    SettleReference    = '#Form.SettleReference#',
		        SettleCustomerName = '#Form.SettleCustomerName#'		 
		 WHERE  WorkOrderId     = '#get.WorkOrderId#'
		 AND    WorkorderLine   = '#get.WorkOrderLine#'
		 AND    OrgUnitOwner    = '#url.orgunitowner#'		 
</cfquery> 	