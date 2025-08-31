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
<cf_compression>

<cfif url.action eq "Delete">
		
	<cfquery name="ResetPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM  PositionCategory
	  WHERE  PositionNo = '#url.PositionNo#'
	  AND    OrganizationCategory = '#url.category#'
	</cfquery>

</cfif>

<cfif url.action eq "Insert">

	<cfquery name="ResetPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM  PositionCategory
	  WHERE  PositionNo = '#url.PositionNo#'
	  AND    OrganizationCategory = '#url.category#'
	</cfquery>
		
	<cfquery name="InsertPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO PositionCategory 
		         (PositionNo,
				 OrganizationCategory,
				 Status,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		SELECT   '#url.positionNo#',
		         '#url.category#',
		         '1',
		         '#SESSION.acc#',
			     '#SESSION.last#',
			     '#SESSION.first#'		
	</cfquery>

</cfif>
	

