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
<cfquery name="Flow"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_EntityClass
	WHERE  EntityCode = 'VacCandidate'
	AND    EntityClass IN (SELECT EntityClass 
	                       FROM Vacancy.dbo.DocumentCandidate 
						   WHERE DocumentNo IN (SELECT DocumentNo 
						                        FROM   Vacancy.dbo.Document 
												WHERE  Status != '9'
												<cfif url.mission neq "all">
												AND    Mission = #PreserveSingleQuotes(url.Mission)#
												</cfif>
											   )	
						)					   
</cfquery>

<select name="Flow" class="regularxxl">
    <option value="All" selected>All</option>
    <cfoutput query="Flow">
	<option value="#EntityClass#">
	#EntityClassName#
	</option>
	</cfoutput>
</select>