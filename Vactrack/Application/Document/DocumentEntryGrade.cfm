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
<cfquery name="Grd" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_PostGrade
		WHERE    PostGrade IN (SELECT PostGrade FROM Position WHERE Mission = '#url.mission#')			
		ORDER BY PostOrder
</cfquery>		
		
<select name="postgrade" id="postgrade" class="regularxxl" style="font-size:20px;height:34px;border:0px;background-color:f1f1f1;">
			 
	 <cfoutput query="Grd">
			<option value="#PostGrade#">#PostGrade#</option>
	 </cfoutput>
		
</select>
	
	