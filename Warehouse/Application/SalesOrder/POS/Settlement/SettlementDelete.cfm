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

<cfquery name="getCustomer"
 datasource="AppsTransaction" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT	* 
	 FROM	Settle#URL.Warehouse#
	 WHERE 	TransactionId  = '#url.transactionid#'
</cfquery>

<cfif getCustomer.recordCount gt 0>

	<cfif trim(getCustomer.customerid) neq "">

		<cftransaction>
			
			<cfquery name="qDelete"
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 DELETE Settle#URL.Warehouse#
				 WHERE TransactionId  = '#url.transactionid#'
			</cfquery>
			
			<cfquery name="get"
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT	  * 
				 FROM	  Settle#URL.Warehouse#
				 WHERE 	  RequestNo = '#getCustomer.RequestNo#'
				 AND	  SettleAmount > 0
			</cfquery>
			
			<cfif get.recordcount eq 0>
			
				<cfquery name="qDelete"
				 datasource="AppsTransaction" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 DELETE Settle#URL.Warehouse#
					 WHERE  RequestNo = '#getCustomer.RequestNo#'
					 AND    SettleAmount <= 0
				</cfquery>
				
			</cfif>			
		
		</cftransaction>
	
	<cfelse>
	
		<cf_tl id="Error" var="vMesTitle">
		<cf_tl id="This transaction does not have a customer associated" var="vMessage">
		<cfoutput>
			<script>
				Prosis.notification.show('#vMesTitle#','#vMessage#','error',5000);
			</script>
		</cfoutput>

	</cfif>

<cfelse>

	<cf_tl id="Error" var="vMesTitle">
	<cf_tl id="This transaction does not exist anymore" var="vMessage">
	<cfoutput>
		<script>
			Prosis.notification.show('#vMesTitle#','#vMessage#','error',5000);
		</script>
	</cfoutput>

</cfif>

<cfset url.requestNo = getCustomer.RequestNo> 
<cfinclude template="SettlementLines.cfm">
 