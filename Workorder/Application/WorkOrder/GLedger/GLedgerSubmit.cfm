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

<cftransaction>

<cfquery name="Clear" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM WorkOrderGledger
		WHERE  WorkOrderId = '#url.workorderid#' 
</cfquery>

<cfquery name="Ledger" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AreaGledger
	ORDER BY ListingOrder
</cfquery>

<cfloop query="Ledger">

	<cfparam name="Form.#area#GLAccount" default="">

	<cfset gl = evaluate("Form.#area#GLAccount")>
	
	<cfif gl neq "">
	
		<cfquery name="Insert" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrderGledger
			(WorkorderId,Area,GLAccount)
			VALUES ('#url.WorkOrderId#','#area#','#gl#')
		</cfquery>		
	
	</cfif>	
		
</cfloop>

</cftransaction>
