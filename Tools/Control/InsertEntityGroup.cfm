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

<!--- check role --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_EntityGroup
	WHERE   EntityCode  = '#Attributes.EntityCode#'
	AND     EntityGroup = '#Attributes.EntityGroup#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cftry>

    <cfquery name="InsertGroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_EntityGroup
	         (EntityCode, 
		      EntityGroup,
			  EntityGroupName)
	VALUES ('#Attributes.EntityCode#',
	        '#Attributes.EntityGroup#',
			'#Attributes.EntityGroupName#')
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>
				
<cfelse>

	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityGroup
		SET    EntityGroupName   = '#Attributes.EntityGroupName#',
		       Operational       = 1
		WHERE  EntityCode      = '#Attributes.EntityCode#'
		AND    EntityGroup     = '#Attributes.EntityGroup#'	   
	</cfquery>

</cfif>
