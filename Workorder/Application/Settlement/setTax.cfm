

<cfquery name="Tax" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     CountryTaxCode
	WHERE    Country   = '#url.country#'
	AND      TaxCode   = '#url.taxcode#' 	  
</cfquery>	

<cfoutput>
<script>  
	document.getElementById('SettleReference').value      = "#Tax.TaxCode#"
	document.getElementById('SettleCustomerName').value   = "#Tax.TaxName#"
</script> 	
</cfoutput>

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
		 SET    SettleReference    = '#Tax.TaxCode#',
				SettleCustomerName = '#Tax.TaxName#'				
		 WHERE  WorkOrderId        = '#get.WorkOrderId#'
		 AND    WorkorderLine      = '#get.WorkOrderLine#'
		 AND    OrgUnitOwner       = '#url.orgunitowner#'			 	 
</cfquery>


