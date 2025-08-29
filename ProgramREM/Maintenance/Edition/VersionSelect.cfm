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
<cfquery name="Version"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AllotmentVersion
	WHERE Mission = '#URL.Mission#' or Mission is NULL
	ORDER BY ListingOrder
</cfquery>

<select name="version" onchange="selected(period.value,mission.value,this.value)" class="regularxl">
   <option value="">--- select ---</option>
   <cfoutput query="Version">
     	<option value="#Code#">#Description#</option>
  	</cfoutput>
</select>