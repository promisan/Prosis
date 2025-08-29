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
<cftransaction>
	 
	<cfquery name="validateDelete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   AccountId
	    FROM     EmployeeSettlementDistribution
		WHERE    PersonNo = '#URL.ID#' 
		AND      AccountId = '#URL.ID1#'
		UNION ALL
		SELECT   AccountId
	    FROM     PersonDistribution
		WHERE    PersonNo = '#URL.ID#' 
		AND      AccountId = '#URL.ID1#'
	</cfquery>

	<cfif validateDelete.recordCount eq 0>
		<cfquery name="deleteAccount" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   DELETE
			   FROM PersonAccount 
			   WHERE PersonNo = '#URL.ID#' AND AccountId  = '#URL.ID1#' 
		</cfquery>
	</cfif>

</cftransaction>

<cf_SystemScript>
<cfoutput>	
<script>
	 ptoken.location("EmployeeBankAccount.cfm?ID=#url.id#");
</script>	
</cfoutput>