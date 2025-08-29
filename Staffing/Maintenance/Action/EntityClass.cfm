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
<cfset vActionSource = url.ActionSource>
<cfset vEntityCode = "">

<cfif vActionSource eq "Assignment">
	<cfset vEntityCode = "Assignment">
<cfelseif vActionSource eq "Dependent">
	<cfset vEntityCode = "Dependent">
<cfelseif vActionSource eq "SPA">
	<cfset vEntityCode = "PersonSPA">
<cfelseif vActionSource eq "Person">
	<cfset vEntityCode = "PersonAction">
<cfelse>
	<cfset vEntityCode = "">
</cfif>

<cfif vEntityCode neq "">

	<cfquery name="WF" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_EntityClass
			WHERE	EntityCode = '#vEntityCode#'
	</cfquery>
	<select name="EntityClass" class="regularxxl">		
		<cfoutput query="WF">
			<option value="#EntityClass#" <cfif EntityClass eq url.entityClass>selected</cfif>>#EntityClassName#</option>
		</cfoutput>
	</select>
	
<cfelse>

    <table>
	<tr><td class="labelmedium2">Standard</td></tr>    
	</table>
	<input name="EntityClass" type="Hidden" value="Standard">
	
</cfif>