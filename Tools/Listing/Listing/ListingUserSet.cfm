
<cfparam name="attributes.modefield" default="sorting">

<cfif attributes.modefield eq "sorting">

	<cfset mlist = "listorder,listorderfield,listorderalias,listorderdir">

<cfelse>

	<cfset mlist = "listgroup,listgroupfield,listgroupalias,listgroupdir">

</cfif>

<cfif session.acc neq "" and attributes.systemfunctionid neq "00000000-0000-0000-0000-000000000000">
	
	<cfloop index="itm" list="#mlist#">
	
		<cfquery name="check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   UserModuleCondition
			WHERE  Account = '#SESSION.acc#'
			AND    SystemFunctionId = '#attributes.systemfunctionid#'	
			AND    ConditionField   = '#itm#'					
		</cfquery>	
		
		<cfset val = evaluate("URL.#itm#")>
			
		<cfif check.recordcount eq "0">
		
			<cfquery name="set" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO UserModuleCondition
						(Account,
						 SystemFunctionId,
						 ConditionClass,
						 ConditionField,
						 ConditionValue)
				VALUES ('#SESSION.acc#',
				        '#attributes.SystemFunctionId#',
						'#attributes.modefield#',
						'#itm#',
						'#val#')			
			</cfquery>		
		
		<cfelse>
		
			<cfquery name="set" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserModuleCondition
				SET    ConditionValue    = '#val#'
				WHERE  Account           = '#SESSION.acc#'
				AND    SystemFunctionId  = '#url.systemfunctionid#'	
				AND    ConditionClass    = '#attributes.modefield#'
				AND    ConditionField    = '#itm#'						
			</cfquery>		
		
		</cfif>
		
	</cfloop>
	
</cfif>	