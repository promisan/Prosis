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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "WorkflowObject Function">
		
	<cffunction name="AuthorisedUsers"
             access="remote"
             returntype="array"
             displayname="AuthorisedUsers">
		
			<cfargument name="ObjectId"   type="string" required="true">
		    <cfargument name="ActionCode" type="string" required="true">
		
			 <!--- Get data --->
		      <cfquery name="User" datasource="AppsSystem">
			      SELECT *
			      FROM UserNames
				  WHERE Account IN (SELECT UserAccount
				                    FROM   Organization.dbo.OrganizationAuthorization
									WHERE  ClassIsAction = 1
									AND    ClassParameter = '#ActionCode#')
				  UNION
				  SELECT *
				  FROM UserNames
				  WHERE Account IN (SELECT UserAccount
				                    FROM Organization.dbo.OrganizationObjectActionAccess
									WHERE ObjectId = '#ObjectId#'
									AND   ActionCode = '#ActionCode#')
			  </cfquery>
		
			<cfset list = arraynew(2)>
		
			<!--- Convert results to array --->
	      	<cfloop index="i" from="1" to="#User.RecordCount#">
    	    	 <cfset list[i][1]=User.Account[i]>
	        	 <cfset list[i][2]="#User.FirstName[i]# #User.LastName[i]#">
	      	</cfloop>
		
		<cfreturn list>
		
	</cffunction>
	
	
</cfcomponent>	