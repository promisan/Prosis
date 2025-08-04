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
<cfparam name="url.width" 			default="328">

<cfparam name="url.RequestAction"	default="">
<!--- show the valid actions --->
<cfquery name="check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_RequestWorkflowWarehouse	
		WHERE  RequestType = '#url.requesttype#'
		AND    Warehouse   = '#url.warehouse#'
</cfquery>		

<cfif check.recordcount eq "0">
			
	<cfquery name="RequestWorkflow" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_RequestWorkflow	
			WHERE  RequestType = '#url.requesttype#'
	</cfquery>		
	
<cfelse>

	<cfquery name="RequestWorkflow" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_RequestWorkflow	S
			WHERE  RequestType = '#url.requesttype#'
			AND    RequestAction IN (
			                         SELECT RequestAction
			                         FROM   Ref_RequestWorkflowWarehouse
								     WHERE  RequestType   = '#url.requesttype#'								    
								     AND    Warehouse     =  '#url.warehouse#'
									 AND    RequestAction = S.RequestAction
								    )
	</cfquery>		

</cfif>			

<cfset vWidth = "">
<cfif url.width neq "">
	<cfset vWidth = "width:#url.width#;">
</cfif>

<select name="RequestAction" id="RequestAction" class="regularxl" style="<cfoutput>#vWidth#</cfoutput>">
	<cfoutput query="RequestWorkflow">
		<option value="#RequestAction#" <cfif url.RequestAction eq RequestAction>selected</cfif>>#RequestActionName#</option>
	</cfoutput>
</select>