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

<!--- set selected attribut values --->

<cfparam name="url.passtru" default="">
<cfparam name="url.mission" default="">

<cfparam name="url.conditionfield" default="mission">
<cfparam name="url.conditionvalue" default="#url.mission#">

<cfloop index="itm" from="1" to="3">
	
	<cfparam name="url.conditionvalueattribute#itm#" default="">
		
	<cfset val = evaluate("url.conditionvalueattribute#itm#")>
	
	<cfif isValid("GUID",url.systemfunctionid)>
				
		<cfquery name="MissionList" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE   UserModuleCondition 
			SET      ConditionValueAttribute#itm# = '#val#'
			WHERE    Account            = '#SESSION.acc#'
			AND      SystemFunctionId   = '#url.SystemFunctionId#' 
			AND      ConditionField     = '#url.conditionfield#' 	
			AND      ConditionValue     = '#url.conditionvalue#'  	
			    
		</cfquery>
	
	</cfif>
	
</cfloop>

<cfif url.passtru neq "">
	<cfinclude template="#url.passtru#">
</cfif>	

