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

<cfparam name="attributes.mode" default="single">

<cfif attributes.systemfunctionid neq "" and attributes.systemfunctionid neq "00000000-0000-0000-0000-000000000000">
	
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
		
		    <cftry>	
				  		 			
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
			
			<cfcatch></cfcatch>
			
			</cftry>
		
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