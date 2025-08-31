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
<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_StatusCode
WHERE Owner = '#Attributes.Owner#'
AND   Status = '#Attributes.Status#'
AND   Id = '#Attributes.Id#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO StatusCode
	       (Owner, Id, Status, RosterAction, AccessLevel, Meaning, TextHeader) 
	VALUES ('#Attributes.Owner#',
	        '#Attributes.Id#',
			'#Attributes.Status#',
			'#Attributes.RosterAction#'
			'#Attributes.AccessLevel#',
			'#Attributes.Meaning#',
			'#Attributes.TextHeader#')
	</cfquery>
	
</cfif>

