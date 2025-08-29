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
<cfquery name="clearLines" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   	ServiceItemUnitMissionRemuneration
		WHERE	CostId = '#vThisCostId#'
</cfquery>

<cfquery name="getGrades" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Postgrade
		FROM   	Employee.dbo.Position
		WHERE	Mission = '#Form.Mission#'
</cfquery>

<cfoutput query="getGrades">
	<cfset vPostGradeId = trim(replace(Postgrade," ","_","ALL"))>
	<cfset vPostGradeId = replace(vPostGradeId,"-","_","ALL")>
	
	<cfif isDefined("Form.postgrade_#vPostGradeId#")>
		<cfset vAmount = evaluate("Form.postgrade_#vPostGradeId#")>
		<cfset vAmount = trim(replace(vAmount,",","","ALL"))>

		<cfquery name="insertRemuneration" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ServiceItemUnitMissionRemuneration
					(
						CostId,
						Postgrade,
						Amount,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#vThisCostId#',
						'#Postgrade#',
						'#vAmount#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
		</cfquery>

	</cfif>
</cfoutput>