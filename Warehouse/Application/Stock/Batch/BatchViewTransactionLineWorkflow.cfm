<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
	
