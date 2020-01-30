
<!--- determine action --->

<cfoutput>

<input type="hidden" 
   name="workflowlink_#URL.ajaxId#" 
   id="workflowlink_#URL.ajaxId#"
   value="BatchViewTransactionLineWorkflow.cfm">			   

<input type="hidden" 
   name="workflowlinkprocess_#URL.ajaxId#" 
   id="workflowlinkprocess_#URL.ajaxId#"
   onclick="ColdFusion.navigate('BatchViewTransactionLineStatus.cfm?transactionid=#URL.ajaxId#','status_#URL.ajaxId#')">
   
</cfoutput>   

<cfquery name="get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ItemTransaction
	WHERE TransactionId = '#URL.ajaxId#'
</cfquery>

<cfquery name="type" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_TransactionType
	WHERE TransactionType = '#get.TransactionType#'
</cfquery>
													
<cfquery name="Check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemWarehouseLocationTransaction 
	WHERE    Warehouse       = '#get.warehouse#'
	AND      Location        = '#get.Location#'
	AND      ItemNo          = '#get.itemno#'
	AND      UoM             = '#get.transactionuom#'
	AND      TransactionType = '#get.transactiontype#'
</cfquery>

<cfquery name="warehouse" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Warehouse
	WHERE warehouse = '#get.Warehouse#'
</cfquery>	
	
<cfset link = "Warehouse/Application/Stock/Batch/BatchView.cfm?mission=#get.Mission#&batchno=#get.Transactionbatchno#">
			
<cf_ActionListing 
	    EntityCode       = "WhsTransaction"		
		EntityClass      = "#check.EntityClass#"
		EntityGroup      = ""
		EntityStatus     = ""		
		Mission          = "#get.Mission#"															
		ObjectReference  = "#type.description# Discrepancy #warehouse.warehousename#"
		ObjectReference2 = "#get.ItemDescription#" 											   
		ObjectKey4       = "#url.ajaxid#"
		ObjectURL        = "#link#"
		Ajaxid           = "#url.ajaxid#"
		Show             = "Yes">
	
