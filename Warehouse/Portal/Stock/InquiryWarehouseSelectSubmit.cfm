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