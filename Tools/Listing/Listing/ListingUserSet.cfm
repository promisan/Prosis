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