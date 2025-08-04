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

<!--- set the selected account --->

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
	FROM   Organization
	WHERE  OrgUnit = '#URL.orgunit#'
</cfquery>

<cfoutput>
		
	<script>
		document.getElementById("orgunit").value        = '#get.OrgUnit#'		
		document.getElementById("orgunitname").value    = '#get.OrgUnitName#'
		document.getElementById("orgunitcode").value    = '#get.OrgUnitCode#'
		document.getElementById("orgunitclass").value   = '#get.OrgUnitClass#'
		//	document.getElementById("mission").value        = '#get.Mission#'
		//  document.getElementById("mandateno").value      = '#get.MandateNo#'		
	</script>	

</cfoutput>