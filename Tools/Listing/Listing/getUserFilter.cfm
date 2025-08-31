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