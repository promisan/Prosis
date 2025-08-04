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
<cfquery name="clean" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM UserModuleCondition		
		WHERE  	Account = '#session.acc#'
		AND		SystemFunctionId = '#url.systemFunctionId#'
		AND		ConditionClass = 'Default'
		AND		ConditionField = 'Warehouse' 
</cfquery>

<cfparam name="Form.Warehouse" default="">

<cfquery name="validate" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	UserModuleCondition
		WHERE  	Account          = '#session.acc#'
		AND		SystemFunctionId = '#url.systemFunctionId#'
		AND		ConditionClass   = 'Default'
		AND		ConditionField   = 'Warehouse' 
</cfquery>

<cfif validate.recordCount eq 0>

	<cfquery name="validateModule" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	UserModule
			WHERE  	Account = '#session.acc#'
			AND		SystemFunctionId = '#url.systemFunctionId#'
	</cfquery>
	
	<cfif validateModule.recordCount eq 0>
	
		<cfquery name="insertModule" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO UserModule 
					(	Account,
						SystemFunctionId,
						OrderListing,
						Status )
				VALUES (
						'#session.acc#',
						'#url.systemFunctionId#',
						'0',
						'1' )
		</cfquery>	
	
	</cfif>

	<cfquery name="insertDefault" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserModuleCondition (
					Account,
					SystemFunctionId,
					ConditionClass,
					ConditionField,
					ConditionValue )
			VALUES ('#session.acc#',
					'#url.systemFunctionId#',
					'Default',
					'Warehouse',
					'#Form.Warehouse#')
	</cfquery>
	

<cfelse>

	<cfif form.Warehouse neq "">

		<cfquery name="updateWO" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE 	UserModuleCondition
				SET		ConditionValue   = '#Form.Warehouse#'
				WHERE  	Account          = '#session.acc#'
				AND		SystemFunctionId = '#url.systemFunctionId#'
				AND		ConditionClass   = 'Default'
				AND		ConditionField   = 'Warehouse' 
		</cfquery>
	
	</cfif>

</cfif>	