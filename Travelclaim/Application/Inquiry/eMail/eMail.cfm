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
<cfset mail = "#Claim.eMailAddress#">

<cfif Claim.eMailAddress eq "">

	<cfquery name="Address" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM  Claim 
		WHERE PersonNo = '#Claim.PersonNo#' 
		AND eMailAddress is not NULL
		ORDER BY DocumentNo DESC
	</cfquery>
	
	<cfif Address.recordcount eq "1">
	
		<cfset mail = "#Address.eMailAddress#">
		

	<cfelse>
			
		<cfset mail = "#client.eMail#">
			
	</cfif>
	
</cfif>	

<cfif mail eq "None">

	<cfset mail = "">

</cfif>
