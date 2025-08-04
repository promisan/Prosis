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
<cfquery name="getUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE    OrgUnit = '#URL.OrgUnit#'
</cfquery>

<cfoutput>
	<script>
		$('##orgunitclass').val('#getUnit.orgunitclass#');
		$('##mission').val('#getUnit.mission#');
		$('##orgunitcode').val('#getUnit.orgunitcode#');
		$('##orgunit').val('#getUnit.orgunit#');
		$('##orgunitname').val('#getUnit.OrgUnitName#');
	</script>
</cfoutput>