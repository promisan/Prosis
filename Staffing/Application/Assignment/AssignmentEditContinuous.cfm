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
<cfquery name="Continuous" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT  A.*, O.Mission
	FROM    PersonAssignment A, 
	        Position P,
		    Organization.dbo.Organization O
	WHERE   P.OrgUnitOperational = O.OrgUnit
	  AND   A.PersonNo   = '#URL.ID#'
	  AND   O.Mission    = '#Position.Mission#'
	  AND   A.PositionNo = P.PositionNo
	  AND   A.AssignmentStatus < '8' 
    ORDER BY A.DateEffective 
</cfquery>

<cfset cstr = dateformat(Continuous.DateEffective,client.dateSQL)>
<cfset dte  = dateformat(Continuous.DateExpiration,client.dateSQL)>

<cfloop query="Continuous">

	<cfif DateEffective gt dte+1>
					
		<cfset cstr = DateEffective> 
	
	</cfif>

	<cfset dte = dateformat(DateExpiration,client.dateSQL)>

</cfloop>