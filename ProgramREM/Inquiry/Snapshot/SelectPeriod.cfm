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


<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Period
	FROM   ProgramAllotmentRequest
	WHERE  ProgramCode IN (SELECT ProgramCode FROM Program WHERE Mission = '#url.mission#')
</cfquery>

<cfoutput>
	<select name="Period" class="regularxl">        	
       <cfloop query="Period">
       	<option value="#Period#">#Period#</option>
       	</cfloop>
	</select>
</cfoutput>	