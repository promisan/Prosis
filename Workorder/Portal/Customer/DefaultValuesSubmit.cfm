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
<cfquery name="validateWO" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	UserModuleCondition
		WHERE  	Account          = '#session.acc#'
		AND		SystemFunctionId = '#form.systemFunctionId#'
		AND		ConditionClass   = 'Default'
		AND		ConditionField   = 'WorkOrder' 
</cfquery>

<cfif validateWO.recordCount eq 0>

	<cfquery name="validateModule" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	UserModule
			WHERE  	Account = '#session.acc#'
			AND		SystemFunctionId = '#form.systemFunctionId#'
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
						'#form.systemFunctionId#',
						'0',
						'1' 	)
		</cfquery>	
	
	</cfif>

	<cfquery name="insertWO" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserModuleCondition (
					Account,
					SystemFunctionId,
					ConditionClass,
					ConditionField,
					ConditionValue )
			VALUES (
					'#session.acc#',
					'#form.systemFunctionId#',
					'Default',
					'WorkOrder',
					'#Form.WorkOrderId#' )
	</cfquery>

<cfelse>

	<cfquery name="updateWO" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	UserModuleCondition
			SET		ConditionValue = '#Form.WorkOrderId#'
			WHERE  	Account = '#session.acc#'
			AND		SystemFunctionId = '#form.systemFunctionId#'
			AND		ConditionClass = 'Default'
			AND		ConditionField = 'WorkOrder' 
	</cfquery>

</cfif>

<!--- Date Submit --->
<cf_DateConvert Value="#form.specificDate#">
<cfset vSpecificDate = dateValue>

<cfset vDateValue = form.dateCriteria>
<cfif form.dateCriteria eq "4">
	<cfset vDateValue = createDate(year(vSpecificDate), month(vSpecificDate), day(vSpecificDate)) + 0>
</cfif>

<cfquery name="validateDate" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	UserModuleCondition
		WHERE  	Account = '#session.acc#'
		AND		SystemFunctionId = '#form.systemFunctionId#'
		AND		ConditionClass = 'Default'
		AND		ConditionField = 'Date' 
</cfquery>

<cfif validateDate.recordCount eq 0>

	<cfquery name="insertDate" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO UserModuleCondition	(
					Account,
					SystemFunctionId,
					ConditionClass,
					ConditionField,
					ConditionValue )
			VALUES (
					'#session.acc#',
					'#form.systemFunctionId#',
					'Default',
					'Date',
					'#vDateValue#' )
	</cfquery>

<cfelse>

	<cfquery name="updateWO" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	UserModuleCondition
			SET		ConditionValue = '#vDateValue#'
			WHERE  	Account = '#session.acc#'
			AND		SystemFunctionId = '#form.systemFunctionId#'
			AND		ConditionClass = 'Default'
			AND		ConditionField = 'Date' 
	</cfquery>

</cfif>

<cfoutput>

	<script>
		ColdFusion.navigate('#session.root#/WorkOrder/Portal/Customer/default.cfm?id=#url.id#','contentbox1');
	</script>
	
</cfoutput>