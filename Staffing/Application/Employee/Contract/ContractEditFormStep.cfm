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
<cfquery name="Grade" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_PostGrade
		WHERE  PostGrade = '#url.grade#'
	</cfquery>

<cfoutput>

<cfif grade.PostGradeSteps lte "1">

<input type="hidden" name="contractstep" value="01">

<cfelse>
	
	<select name="contractstep" class="regularxl" style="width:50px;border-top:0px;border-bottom:0px;border-right:0px;border-left:0px">
	
		<cfloop index="st" from="1" to="#grade.PostGradeSteps#">
			<option value="#st#" <cfif url.step eq st>selected</cfif>>#st#</option>
		</cfloop>	
		
	</select>	
	
</cfif>

</cfoutput>