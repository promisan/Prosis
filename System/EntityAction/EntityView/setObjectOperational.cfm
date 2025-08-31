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
<cftransaction>

<cfquery name="get" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * FROM OrganizationObject
		  WHERE  ObjectId = '#url.objectId#'			  			 
</cfquery>

<cfif get.Operational eq "1">
	
	<cfquery name="set" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE OrganizationObject
			 SET    Operational = 0
			 WHERE  ObjectId = '#url.objectId#'					 
	</cfquery>
	
	<cfquery name="log" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	INSERT INTO OrganizationObjectLog
			( ObjectId, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName )
		    VALUES 
			 ('#url.objectId#', 'Deactivate', '#Session.acc#', '#session.last#','#session.first#')			 
	</cfquery>
	
	<cfoutput>
	<cf_tl id="Reinstate" var="1">	
    <input type="button" name="Reinstate" value="#lt_text#" class="button10g" onclick="_cf_loadingtexthtml='';ptoken.navigate('setObjectOperational.cfm?objectid=#objectid#','process_#objectid#')" style="height:20px;width:76px">
	</cfoutput>
							

<cfelse>

	<cfquery name="set" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE OrganizationObject
			 SET    Operational = 1
			 WHERE  ObjectId = '#url.objectId#'					 
	</cfquery>
	
	<cfquery name="log" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	INSERT INTO OrganizationObjectLog
			( ObjectId, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName )
		    VALUES 
			 ('#url.objectId#', 'Reinstate', '#Session.acc#', '#session.last#','#session.first#')			 
	</cfquery>

</cfif>

</cftransaction>