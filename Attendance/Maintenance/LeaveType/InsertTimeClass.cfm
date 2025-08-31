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
<cfparam name="Attributes.TimeClass" default="">
<cfparam name="Attributes.Description" default="">

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_TimeClass
WHERE TimeClass = '#Attributes.TimeClass#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_TimeClass
	       (TimeClass, 
		    Description)
	VALUES ('#Attributes.TimeClass#',
	        '#Attributes.description#')
	</cfquery>
			
<cfelse>

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_TimeClass
       SET Description = '#Attributes.description#'
	WHERE TimeClass = 	'#Attributes.TimeClass#'	   
	</cfquery>

</cfif>
