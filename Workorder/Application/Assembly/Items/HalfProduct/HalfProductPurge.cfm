
<cfquery name="get" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM    WorkOrderLineItem
		WHERE	WorkOrderId   = '#url.workorderid#' 
		AND     WorkOrderLine = '#url.workorderline#'
		AND		ItemNo        = '#url.itemNo#'
		AND		UoM           = '#url.uom#'	
</cfquery>

<cfquery name="check" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Purchase.dbo.RequisitionLine
		 WHERE  RequirementId = '#get.workorderitemid#' 
		 AND    ActionStatus >= '3' AND ActionStatus < '9'
</cfquery>		 

<cfif check.recordcount gte "1">

	<script>
	  alert("One or more valid Procurement obligations were raised for this sales line. Operation has been aborted!")
	</script>
	
<cfelse>
					
	<cfquery name="resetProcurementLine" 
		datasource="AppsPurchase"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
			DELETE FROM RequisitionLine			
			WHERE  RequirementId = '#get.workorderitemid#' 					
			AND    ActionStatus < '9'
			
	</cfquery>	
	
	<cfloop query="get">
	
		<cfquery name="resetProcurement" 
			datasource="AppsPurchase"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				UPDATE  RequisitionLine
				SET     RequirementId = NULL
				WHERE	RequirementId  = '#workorderitemid#' 
						
		</cfquery>	
		
		<cfquery name="resetReceipt" 
			datasource="AppsPurchase"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				UPDATE  PurchaseLineReceipt
				SET     RequirementId = NULL
				WHERE	RequirementId  = '#workorderitemid#' 
						
		</cfquery>	
		
		<cfquery name="resetStock" 
			datasource="AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				UPDATE  ItemTransaction
				SET     RequirementId = NULL
				WHERE	RequirementId  = '#workorderitemid#' 
						
		</cfquery>	
			
		<cfquery name="delete" 
			datasource="AppsWorkOrder"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				DELETE  
				FROM    WorkOrderLineItem
				WHERE	WorkOrderItemId  = '#workorderitemid#' 
						
		</cfquery>
	
	</cfloop>
	
</cfif>

<cfoutput>
	<script>
	    _cf_loadingtexthtml='';	
		ptoken.navigate('#session.root#/workorder/application/Assembly/Items/HalfProduct/HalfProductListing.cfm?workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','topSection');
	</script>
</cfoutput>	