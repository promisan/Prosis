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
<cfquery name="Schedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_PriceSchedule
</cfquery>

<cfquery name="Currency" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Currency
		WHERE	EnableProcurement = 1
		AND		Operational = 1 
</cfquery>

<cftransaction>

	<cfquery name="clear" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM 	ItemPriceSchedule 
			WHERE 	ItemNo = '#url.itemno#'
			AND		Mission = '#url.mission#'
	</cfquery>
	
	<cfloop query="Schedule">
	
		<cfloop query="Currency">
		
			<cfif isDefined("Form.cb_#Schedule.code#_#Currency.Currency#")>
			
				<cfquery name="insert" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO ItemPriceSchedule 
							(
								ItemNo,
								Mission,
								PriceSchedule,
								Currency,
								Operational,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#url.itemno#',
								'#url.mission#',
								'#Schedule.code#',
								'#Currency.currency#',
								1,
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>
			
			</cfif>
		
		</cfloop>
	
	</cfloop>
	
	<cfif isDefined("Form.inherit") or isDefined("Form.sync")>
		<cfinclude template="ItemPriceShceduleInherit.cfm">
	</cfif>

</cftransaction>

<cfoutput>
	<script>
		ptoken.navigate('PriceSchedule/ItemPriceScheduleDetailForm.cfm?itemNo=#url.itemno#&mission=#url.mission#','divItemPriceSchedule');
	</script>
</cfoutput>