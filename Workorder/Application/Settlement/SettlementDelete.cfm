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
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrderLineSettlement
	WHERE    WorkOrderSettleId   = '#url.settleId#'		 	  
</cfquery>	

<cfif get.recordCount gt 0>
	
		<cftransaction>
			
			<cfquery name="qDelete"
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 DELETE WorkorderLineSettlement
				 WHERE  WorkOrderSettleId   = '#url.settleId#'				
			</cfquery>
			
			<cfquery name="check"
			 datasource="AppsWorkorder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT	* 
				 FROM	WorkorderLineSettlement
				 WHERE 	WorkOrderId   = '#get.workorderid#'
				 AND    WorkOrderLine = '#get.workorderline#'
				 AND    OrgUnitOwner  = '#get.OrgUnitOwner#'
				 AND    TransactionDate = '#get.TransactionDate#'
				 AND	SettleAmount > 0
			</cfquery>
			
			<cfif get.recordcount eq 0>
			
				<cfquery name="qDelete"
				 datasource="AppsWorkOrder" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 DELETE WorkorderLineSettlement
					 WHERE 	WorkOrderId   = '#get.workorderid#'
					 AND    WorkOrderLine = '#get.workorderline#'
					 AND    OrgUnitOwner  = '#get.OrgUnitOwner#'		
					 AND    TransactionDate = '#get.TransactionDate#'		
					 AND SettleAmount <= 0
				</cfquery>
			</cfif>			
		
		</cftransaction>
	
		<cfinclude template="SettlementLines.cfm">
	
<cfelse>

	<cf_tl id="Error" var="vMesTitle">
	<cf_tl id="This transaction does not exist anymore" var="vMessage">
	<cfoutput>
		<script>
			Prosis.notification.show('#vMesTitle#','#vMessage#','error',5000);
		</script>
	</cfoutput>
	<cfset url.transactiontime = "#url.transactiontime#">
	<cfinclude template="SettlementLines.cfm">

</cfif>
  

 
 