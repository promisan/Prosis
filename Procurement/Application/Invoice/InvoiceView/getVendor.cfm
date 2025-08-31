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
	<cfquery name="Vendor" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT OrgUnit, OrgUnitName
		FROM  Organization
		WHERE OrgUnit IN (SELECT OrgUnitVendor 
		                  FROM   Purchase.dbo.Purchase 
		                  WHERE  Mission='#URL.Mission#'
						  <cfif url.period neq "">
						  AND    Period = '#URL.Period#'
						  </cfif>)
	    ORDER BY OrgUnitName
	</cfquery>
	 
    <select name="orgunitvendor" id="orgunitvendor" size="1" style="width:400px" class="regularxl">
	<option value="" selected><cf_tl id="Any"></option>
    <cfoutput query="Vendor">
		<option value="#OrgUnit#">#OrgUnitName#</option>
	</cfoutput>
    </select>