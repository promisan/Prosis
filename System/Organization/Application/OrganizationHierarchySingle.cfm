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
<cfparam name="URL.Mission" default="">
<cfparam name="URL.Mandate" default="">
<cfparam name="URL.OrgUnit" default="">
<cfparam name="URL.ParentOrgUnit" default="">

 <cfquery name="parent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Organization 
		WHERE 	Mission   = '#URL.Mission#'
		AND 	MandateNo = '#URL.Mandate#'
		AND		OrgUnit = '#url.ParentOrgUnit#'
		ORDER BY TreeOrder
</cfquery>

<cfif parent.recordCount eq 0>
	
	<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Organization 
			SET 	HierarchyCode = '#Level1#', 
					HierarchyRootUnit = OrgUnitCode
			WHERE 	OrgUnit = '#URL.OrgUnit#'
	</cfquery>

<cfelse>
	
</cfif>


