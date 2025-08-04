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
<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    stStatus
WHERE Status = '#Attributes.Status#' 
AND ProgramClass = '#Attributes.ProgramClass#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO stStatus
	       (ProgramClass, 
		    Status, 
			Description, 
			ListingOrder, 
			Color,
			Expand)
	VALUES ('#Attributes.ProgramClass#',
	        '#Attributes.Status#',
			'#Attributes.Description#',
			'#Attributes.ListingOrder#',
			'#Attributes.Color#',
			'#Attributes.Expand#') 
	</cfquery>
	
</cfif>
