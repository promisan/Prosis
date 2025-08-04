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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 
<!--- register access to authorised user for step --->

<cfquery name="Bucket" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  FunctionOrganization
	WHERE DocumentNo = '#URL.ID#'
</cfquery>

<cfif Bucket.recordcount eq "1">

	<cfquery name="Check" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   RosterAccessAuthorization
		WHERE  FunctionId = '#Bucket.FunctionId#'
		AND    UserAccount = '#SESSION.acc#'
		AND    AccessLevel = '#URL.Status#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO RosterAccessAuthorization
				(FunctionId,UserAccount,AccessLevel,Source,Role,OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
				('#Bucket.FunctionId#','#SESSION.acc#','#URL.Status#','Vactrack','RosterClear','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>
			
	</cfif>
	
	<cfquery name="Check" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM    RosterAccessAuthorization
		WHERE   FunctionId = '#Bucket.FunctionId#'
		AND     UserAccount = '#SESSION.acc#'
		AND     AccessLevel = '#URL.Status#'
	</cfquery>
	
	<!--- open dialog for initial or technical --->

	<cflocation url="../../../Roster/RosterSpecial/CandidateView/FunctionViewLoop.cfm?IDFunction=#Check.FunctionId#" addtoken="No">
	
<cfelse>

	<cf_message 
	    message="Problem, roster bucket process dialog can not be located.">

</cfif>


