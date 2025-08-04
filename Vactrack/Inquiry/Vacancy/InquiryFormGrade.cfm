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

<cfquery name="grade" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   DISTINCT D.PostGrade, P.PostOrder
FROM     Document D, Employee.dbo.Ref_PostGrade P
WHERE    D.PostGrade = P.PostGrade
<cfif url.mission neq "all">
AND      D.Mission = #PreserveSingleQuotes(url.Mission)#
</cfif>
AND      D.Status != '9'
ORDER BY P.PostOrder
</cfquery>

<select name="PostGrade" class="regularxxl">
    <option value="All" selected><cf_tl id="All"></option>
    <cfoutput query="Grade">
	<option value="'#PostGrade#'">
	#PostGrade#
	</option>
	</cfoutput>
</select>