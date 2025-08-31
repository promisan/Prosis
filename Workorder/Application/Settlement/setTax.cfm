<!--
    Copyright © 2025 Promisan B.V.

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


