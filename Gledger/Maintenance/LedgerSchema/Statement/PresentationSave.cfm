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
	
	<cfquery name="removePrevious" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  
			FROM 	Ref_StatementAccountUnit 
			WHERE   Mission = '#url.mission#'
			AND		GlAccount = '#url.GlAccount#'
			AND		OrgUnit = '#url.OrgUnit#'
	</cfquery>

	<cfif trim(url.statementCode) neq "">
		
		<cfquery name="insertNew" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_StatementAccountUnit
					(
						Mission,
						StatementCode,
						GLAccount,
						OrgUnit,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#URL.Mission#',
						'#URL.StatementCode#',
						'#URL.GLAccount#',
						'#URL.OrgUnit#',
						'#SESSION.ACC#',
						'#SESSION.LAST#',
						'#SESSION.FIRST#'
					)
		</cfquery>

	</cfif>

</cftransaction>

<cf_tl id="Saved">