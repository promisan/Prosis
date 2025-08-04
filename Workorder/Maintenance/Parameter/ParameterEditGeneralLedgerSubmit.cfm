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

<cfquery name="Area" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_AreaGLedger		
		ORDER BY ListingOrder
</cfquery>

<cfset areaList = "#valuelist(area.area)#">

<cftransaction>

	<cfquery name="Clear" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE 
			FROM 	Ref_ParameterMissionGLedger
			WHERE 	mission = '#URL.ID1#'
	</cfquery>
	
	<cfloop index="vArea" list="#areaList#" delimiters=",">
	
		<cfif isDefined("Form.glaccount_#vArea#")>
		
			<cfset vValidatedGLAccount = trim(evaluate("glaccount_#vArea#"))>
			<cfif vValidatedGLAccount neq "">
				<cfquery name="Clear" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ParameterMissionGLedger
							(
								Mission,
								Area,
								GLAccount,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#url.id1#',
								'#vArea#',
								'#vValidatedGLAccount#',
								'#session.acc#',
								'#session.last#',
								'#session.first#'
							)
				</cfquery>
			</cfif>
			
		</cfif>
		
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('ParameterEditGeneralLedger.cfm?ID1=#url.id1#','contentbox1')
	</script>
</cfoutput>