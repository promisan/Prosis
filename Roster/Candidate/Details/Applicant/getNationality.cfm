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
<cfparam name="orgunit" default="">

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Code, Name 
    FROM     Ref_Nation
	WHERE    Operational = '1'
	ORDER BY Name
</cfquery>

<cfquery name="Selected" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT TOP 1 Country
	FROM   Ref_Address
	WHERE  AddressId IN (
		SELECT AddressId
		FROM   Organization.dbo.OrganizationAddress
		WHERE  OrgUnit = '#url.orgunit#'
	)
 </cfquery>
 
<select name="Nationality" id="Nationality" onchange="validate()" required="Yes" message="Select Nationality" class="regularxl enterastab">
	<cfoutput query="Nation">
		<option value="#Code#" <cfif Selected.Country eq Code>selected</cfif>>#Name#</option>
	</cfoutput>
</select>	