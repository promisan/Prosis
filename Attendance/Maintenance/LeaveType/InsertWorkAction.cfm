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
<cfparam name="Attributes.ActionClass" default="">
<cfparam name="Attributes.Description" default="">
<cfparam name="Attributes.ActionParent" default="">
<cfparam name="Attributes.ListingOrder" default="1">
<cfparam name="Attributes.ProgramLookup" default="0">

<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_WorkAction
WHERE ActionClass = '#Attributes.ActionClass#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_WorkAction
	       (ActionClass, 
		    ActionDescription,
			ActionParent,
			ListingOrder,
			ProgramLookup,
			OfficerUserId,
			OfficerLastName,
			OfficerFirstName)
	VALUES ('#Attributes.ActionClass#',
	        '#Attributes.Description#',
			'#Attributes.ActionParent#',
			'#Attributes.ListingOrder#',
			'#Attributes.ProgramLookup#',
			'#SESSION.acc#',
			'#SESSION.last#',
			'#SESSION.first#')
	</cfquery>
			
<cfelse>

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_WorkAction
       SET   ActionDescription = '#Attributes.Description#',
	   		 ActionParent = '#Attributes.ActionParent#',
	   		 ListingOrder = '#Attributes.ListingOrder#',
	   		 ProgramLookup = '#Attributes.ProgramLookup#'
	WHERE ActionClass = '#Attributes.ActionClass#'	   
	</cfquery>

</cfif>
