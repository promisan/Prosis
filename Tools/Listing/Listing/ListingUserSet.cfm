
<cfparam name="attributes.modefield" default="sorting">

<cfif attributes.modefield eq "sorting">
	<cfset mlist = "listorder,listorderfield,listorderalias,listorderdir">
<cfelse>
	<cfset mlist = "listgroup,listgroupfield,listgroupsort,listgroupalias,listgroupdir,listgrouptotal,listcolumn1,datacell1">
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
		<cfif itm eq "datacell1">
			<cfset att1 = evaluate("URL.#itm#formula")>
			<cfset att2 = "">
		<cfelseif itm eq "listcolumn1">
			<cfset att1 = evaluate("URL.#itm#_type")>
			<cfset att2 = evaluate("URL.#itm#_typemode")>	
								
		<cfelse>
			<cfset att1 = "">	
			<cfset att2 = "">
		</cfif>
		
			
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
						 ConditionValue,
						 ConditionValueAttribute1,
						 ConditionValueAttribute2)
				VALUES ('#SESSION.acc#',
				        '#attributes.SystemFunctionId#',
						'#attributes.modefield#',
						'#itm#',
						'#val#',
						'#att1#',
						'#att2#')			
			</cfquery>		
		
		<cfelse>
		
			<cfquery name="set" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserModuleCondition
				SET    ConditionValue           = '#val#',
				       ConditionValueAttribute1 = '#att1#',
					   ConditionValueAttribute2 = '#att2#'
				WHERE  Account                  = '#SESSION.acc#'
				AND    SystemFunctionId         = '#url.systemfunctionid#'	
				AND    ConditionClass           = '#attributes.modefield#'
				AND    ConditionField           = '#itm#'						
			</cfquery>		
		
		</cfif>
		
	</cfloop>
	
</cfif>	