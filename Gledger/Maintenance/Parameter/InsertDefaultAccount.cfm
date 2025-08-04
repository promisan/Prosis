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

<!--- check class --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_SystemAccount
WHERE Code = '#Attributes.Area#'
</cfquery>

<cfif Check.recordcount eq "0">

   <cfif attributes.operational eq "1">

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_SystemAccount
		       (Code,Description,Operational) 
		VALUES ('#Attributes.Area#',
		        '#Attributes.Description#',
				'#attributes.operational#')
	</cfquery>
	
	</cfif>
	
<cfelse>

	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemAccount
		SET    Description = '#Attributes.Description#', 
		       Operational = '#attributes.operational#'
		WHERE  Code = '#Attributes.Area#'
	</cfquery>
	
</cfif>

