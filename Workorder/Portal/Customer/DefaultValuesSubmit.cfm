<!--- Workorder Submit --->

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