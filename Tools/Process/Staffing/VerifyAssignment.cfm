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
<cfquery name="BaseSet" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    PersonNo, COUNT(*) AS Expr1
FROM      PersonAssignment
WHERE     (AssignmentStatus IN (0, 1)) AND (AssignmentClass = 'Regular')
AND       PositionNo IN (SELECT PositionNo FROM Position WHERE Mission IN (SELECT Mission  FROM Organization.dbo.Ref_Mission WHERE MissionOwner = 'DPKO'))
AND       DateExpiration > '01/01/2006'
GROUP BY  PersonNo
HAVING    (COUNT(*) > 1)
ORDER BY PersonNo
</cfquery>

<cfset cnt = 1>

<cfloop query="BaseSet" startrow="1">

<cfquery name="Delete" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM PersonAssignment
WHERE       PersonNo = '#PersonNo#'
AND         DateEffective = DateExpiration 
</cfquery>
	
	<cfquery name="Assign" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    AssignmentNo, PersonNo, PositionNo, DateEffective, DateExpiration
	FROM      PersonAssignment
	WHERE     PersonNo = '#PersonNo#'
	AND       AssignmentStatus IN (0, 1) 
	AND       AssignmentClass = 'Regular'
	AND       PositionNo IN (SELECT PositionNo FROM Position WHERE Mission IN (SELECT Mission  FROM Organization.dbo.Ref_Mission WHERE MissionOwner = 'DPKO'))
	AND       PositionNo NOT IN (SELECT PositionNo FROM Position WHERE Mission = 'UN-DPKO-EO')
	AND       PositionNo NOT IN (SELECT PositionNo FROM Position WHERE Mission = 'UN-ECA')
	AND       PositionNo NOT IN (SELECT PositionNo FROM Position WHERE Mission = 'UNMIK' and MandateNo = 'P003')
	ORDER BY  DateEffective
	</cfquery>
	
	<cfset dte = "01/01/1900">
	
	<cfset row = currentrow>
	
	<cfloop query="Assign">
	
		<cfif Assign.DateEffective lte dte and Assign.DateEffective gt "12/12/2005">
					
					<cfoutput>#cnt# : #row#-#PersonNo#-:#AssignmentNo#</cfoutput><br>
					<cfflush>
					<!--- error --->
					<cfset cnt = cnt + 1>
		
		</cfif>
		
		<cfset dte = dateformat(Assign.DateExpiration,client.dateSQL)>
		
	</cfloop>

</cfloop>


