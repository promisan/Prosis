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
<cfquery name="qFunction" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM   	Ref_ModuleControl
		WHERE  	SystemFunctionId = '#URL.ID#'
</cfquery>

<cfquery name="qValidation" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	V.*
	    FROM   	Ref_Validation V
		WHERE  	V.SystemModule = '#qFunction.SystemModule#'
</cfquery>
	
<cfoutput query="qValidation">

	<cftransaction>

		<cfquery name="clean" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE
			    FROM   	Ref_ModuleControlValidation
				WHERE  	SystemFunctionId = '#URL.ID#'
				AND		ValidationCode = '#ValidationCode#'
		</cfquery>
		
		<cfif isDefined("vc_#ValidationCode#")>
		
			<cfset vClass = evaluate("Form.class_#validationCode#")>
			<cfset vOrder = evaluate("Form.order_#validationCode#")>
		
			<cfquery name="insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    INSERT INTO Ref_ModuleControlValidation
						(	SystemFunctionId,
							ValidationCode,
							ValidationClass,
							ListingOrder,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES	(
							'#URL.ID#',
							'#validationCode#',
							'#vClass#',
							'#vOrder#',
							'#session.acc#',
							'#session.last#',
							'#session.first#' )
			</cfquery>
			
			<cfquery name="missionList" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   	SELECT DISTINCT
							M.*
					FROM 	Organization.dbo.Ref_Mission M
					WHERE	M.Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = '#qFunction.SystemModule#')
			</cfquery>
			
			<cfquery name="cleanMissions" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    DELETE
				    FROM   	Ref_ModuleControlValidationMission
					WHERE  	SystemFunctionId = '#URL.ID#'
					AND		ValidationCode = '#ValidationCode#'
			</cfquery>
			
			<cfloop query="missionList">
			
				<cfif isDefined("Form.mission_#mission#_#qValidation.validationCode#")>
				
					<cfset vMission = evaluate("Form.mission_#mission#_#qValidation.validationCode#")>
				
					<cfquery name="insertMission" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    INSERT INTO Ref_ModuleControlValidationMission (
									SystemFunctionId,
									ValidationCode,
									Mission,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName )
							VALUES ('#URL.ID#',
									'#qValidation.validationCode#',
									'#vMission#',
									'#session.acc#',
									'#session.last#',
									'#session.first#' )
					</cfquery>
				</cfif>
			
			</cfloop>
	
		</cfif>
	
	</cftransaction>
	
</cfoutput>

<cfoutput>
	<script>
		ColdFusion.navigate('Validation/FunctionValidation.cfm?id=#url.id#','contentbox1');
	</script>
</cfoutput>