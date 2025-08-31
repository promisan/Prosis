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
<cfquery name="CleanOwners" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_ApplicantSectionOwner
		WHERE	Code = '#url.currentCode#'
</cfquery>

<cfquery name="GetOwners" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ParameterOwner
		WHERE	Operational = 1
</cfquery>

<cfoutput query="GetOwners">

	<cfset ownerId = replace(owner," ","","ALL")>
	<cfset ownerId = replace(ownerId,"-","","ALL")>

	<cfif isDefined("Form.cb_#ownerId#")>
	
		<cfset vALRead = evaluate("Form.alr_#ownerId#")>
		<cfset vALEdit = evaluate("Form.ale_#ownerId#")>
	
		<cfquery name="insertOwner" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ApplicantSectionOwner
					(
						Code,
						Owner,
						Operational,
						AccessLevelRead,
						AccessLevelEdit,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.currentCode#',
						'#Owner#',
						1,
						'#vALRead#',
						'#vALEdit#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
		</cfquery>
	
	</cfif>

</cfoutput>