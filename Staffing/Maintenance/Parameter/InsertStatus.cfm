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

<cfparam name="Attributes.CustomForm" default="">


<!--- check class --->

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_Status
WHERE   Class = '#Attributes.Class#'
AND     Status = '#attributes.Status#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_Status
	       (Class,Status,Description) 
	VALUES ('#Attributes.Class#',
	        '#Attributes.Status#',
	        '#Attributes.Description#')
	</cfquery>
	
<cfelse>
		
	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Status
		SET    Description  = '#Attributes.Description#'		
		WHERE   Class = '#Attributes.Class#'
		AND     Status = '#attributes.Status#'
	</cfquery>
	
</cfif>

