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
	
	<cfquery name="getAccount" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
		    FROM 	PersonAccount
			WHERE 	PersonNo = '#vPersonNo#'
			AND 	AccountId = '#vAccountId#'
	</cfquery>

	<cfquery name="getMissions" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ParameterMission
	</cfquery>

	<cfquery name="clearAccountMission" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM 	PersonAccountMission
	      	WHERE 	PersonNo  = '#vPersonNo#'
	      	AND 	AccountId = '#vAccountId#'
	</cfquery>

	<cfoutput query="getMissions">
	 		
			<cfif isDefined("Form.Bank_#Mission#")>
				<cfset vBankId = evaluate("Form.Bank_#Mission#")>
				
				<cfif vBankId neq "">
				
					<cfquery name="insertAccountMission" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO [dbo].[PersonAccountMission]
							           (PersonNo,
							            AccountId,
							            Mission,
							            BankId,
							            OfficerUserid,
							            OfficerLastName,
							            OfficerFirstName)
							     VALUES ('#vPersonNo#',
							             '#vAccountId#',
							             '#Mission#',
							             '#vBankId#',
							             '#session.acc#',
							             '#session.last#',
							             '#session.first#')
					</cfquery>
				
				</cfif>
				
			</cfif>
			
	</cfoutput>

</cftransaction>