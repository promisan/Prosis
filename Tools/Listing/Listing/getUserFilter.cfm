
<cfparam name="attributes.filter"        default="yes">
<cfparam name="attributes.delimiter"     default=",">

<cfif attributes.systemfunctionid neq "">

	<cfif attributes.filter eq "no">
			
		<cfquery name="check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#attributes.systemfunctionid#'	
				AND    ConditionClass   = 'Filter'	
				AND    (ConditionValueAttribute1 <> 'initial filter' or ConditionValueAttribute1 is NULL)		
		</cfquery>
												
		<cfif check.recordcount eq "0">
						
			<cfquery name="getValue" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT ConditionValue as Value
				FROM   UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#attributes.systemfunctionid#'	
				AND    ConditionClass   = 'Filter'
				AND    ConditionField   = '#attributes.field#'					
		    </cfquery>	
				
			<cfset caller.getval = ValueList(getValue.value,attributes.delimiter)>
									
		<cfelse>
		
			<cfquery name="cleanPriorFilter" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM UserModuleCondition
					WHERE  Account = '#SESSION.acc#'
					AND    SystemFunctionId = '#url.systemfunctionid#'	
					AND    ConditionClass   = 'Filter'			
					AND    ConditionField   = '#attributes.field#'						
			</cfquery>	
									
			<cfset caller.getval = "">
		
		</cfif>
	
	<cfelse>
		
		<cfquery name="getValue" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT ConditionValue as Value
				FROM   UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#attributes.systemfunctionid#'	
				AND    ConditionClass   = 'Filter'
				AND    ConditionField   = '#attributes.field#'					
		</cfquery>	
				
	<cfset caller.getval = ValueList(getValue.value,attributes.delimiter)>	
		
	</cfif>	
	
<cfelse>

	<cfset caller.getval = "">
	
</cfif>			