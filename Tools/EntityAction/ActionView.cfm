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
<cftry>
	
	<cfquery name="Object" 
	 datasource="AppsOrganization">
	 SELECT *
	 FROM OrganizationObject 		
	 WHERE (ObjectId = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> 
	 OR ObjectKeyValue4 = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> )
	 AND Operational  = 1 
	</cfquery>
	
	<cfif Object.recordcount gte "1" and Object.ObjectURL neq "">
		
	<cflocation url="../../#Object.ObjectURL#&mycl=1" addtoken="No"> 
	
	<cfelse>
	
	<title>Problem</title>

	<font color="gray"><b>Attention:</b> Requested document has been processed already or does not longer exist.

	
	</cfif>

<cfcatch>
	
	<title>Problem</title>

	<font color="FF0000">Requested document could not be loaded. <p>Please contact your administrator if the problem persists.

</cfcatch>

</cftry>

