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

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Claims"> 
 			             
<cfquery name="FactTable" 
   datasource="AppsIncident" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   NEWID() AS FactTableId, 
            PersonNo AS PersonNo_dim, 
			IC.Mission AS Mission_dim, 
			IC.Casualty AS Casualty_dim, 
			P.FirstName, 
			P.LastName 
	INTO    userquery.dbo.#SESSION.acc#Claims		
	FROM    Claim C, PersonClaim PC, IncidentClaim IC, Employee.dbo.Person P
	where C.ClaimId=PC.Claimid and PC.ClaimId=IC.ClaimId 
	and C.PersonNo=P.PersonNo
</cfquery>
	
<cfset client.table1_ds = "#SESSION.acc#Claims">
