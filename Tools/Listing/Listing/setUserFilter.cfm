
<cfparam name="attributes.mode" default="single">

<cfif attributes.systemfunctionid neq "">
	
	<cfquery name="getValue" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   UserModuleCondition
			WHERE  Account = '#SESSION.acc#'
			AND    SystemFunctionId = '#attributes.systemfunctionid#'	
			AND    ConditionClass   = 'Filter'
			AND    ConditionField   = '#attributes.field#'		
			<cfif attributes.mode eq "multi">
			AND    ConditionValue   = '#attributes.value#' 
			</cfif>			
	</cfquery>	
	
	<cfif attributes.mode eq "single" and getValue.recordcount neq 0>
	
			<cfquery name="DeleteMultipleValues" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE 
					FROM   UserModuleCondition
					WHERE  Account 		    = '#SESSION.acc#'
					AND    SystemFunctionId = '#attributes.systemfunctionid#'	
					AND    ConditionClass   = 'Filter'
					AND    ConditionField   = '#attributes.field#'		
			</cfquery>	

			<cfquery name="getValue" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   UserModuleCondition
					WHERE  Account          = '#SESSION.acc#'
					AND    SystemFunctionId = '#attributes.systemfunctionid#'	
					AND    ConditionClass   = 'Filter'
					AND    ConditionField   = '#attributes.field#'		
			</cfquery>		
			
	</cfif>	
	
	<cfif getValue.recordcount eq "0">
			
		<cfif attributes.value neq "">				
				  		 			
		    <cfquery name="setfilter" 
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
						'Filter',
						'#attributes.field#',
						'#attributes.value#')			
			</cfquery>	
		
		</cfif>
						
	<cfelse>
	
		<!--- update the value, not likely to happen as we clean before hand --->
	
		<cftry>
		
			<cfquery name="getValue" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE   UserModuleCondition
				SET      ConditionValue   = '#attributes.value#'
				WHERE    Account          = '#SESSION.acc#'
				AND      SystemFunctionId = '#attributes.systemfunctionid#'	
				AND      ConditionClass   = 'Filter'
				AND      ConditionField   = '#attributes.field#'					
		     </cfquery>	
		 
		 	<cfcatch></cfcatch>
		 
		 </cftry>
	
	</cfif>	

<cfelse>

	<!--- nada --->

</cfif>