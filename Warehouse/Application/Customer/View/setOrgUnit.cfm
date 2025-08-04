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

<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM   Organization E
		    WHERE  OrgUnit = '#url.orgunit#'
		</cfquery>


<cfoutput>
	<input type="text" id="orgname" name="orgname" value="#Get.OrgUnitName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:4px">				
	<input type="hidden" name="orgunit" id="orgunit" value="#Get.OrgUnit#" size="10" maxlength="10" readonly>
</cfoutput>
			