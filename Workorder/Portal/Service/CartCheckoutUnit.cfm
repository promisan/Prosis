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
<cfquery name="Unit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Organization
	  WHERE  OrgUnit = '#URL.OrgUnit#' 
</cfquery>

<cfoutput>

	<input type="text" class="regular" name="orgunitname1" value="#Unit.OrgUnitName#" size="60" maxlength="60" readonly>
	<input type="hidden" name="orgunit1" value="#Unit.OrgUnit#">
	
</cfoutput>
