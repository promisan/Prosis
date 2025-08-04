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
<!--- this template fils 3 variables to serve the workflow framework
		mailsubject;mailtext;mailatt (optional) --->
	
<cfobject action="create"
		type="java"
		class="coldfusion.server.ServiceFactory"
		name="factory">

<cfset dsService = factory.getDataSourceService()>
<cfset DataSources = dsService.getDatasources()>
<cfset DatabaseName = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Database >
<cfset DatabaseServer = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Host>

	<cfset db = "#DatabaseName#.dbo.">
	
<cfquery name="Claim" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      #db#Claim  C INNER JOIN #db#stPerson  P ON C.PersonNo = P.PersonNo
	WHERE     C.ClaimId = '#Object.ObjectKeyValue4#'
</cfquery>	

<cfquery name="Request" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      #db#ClaimRequest C
	WHERE     C.ClaimRequestId = '#Claim.ClaimRequestId#'
</cfquery>	

<cfset mailsubject = "Travel Claim APPROVAL - TCP #Claim.DocumentNo# against TVRQ #Request.DocumentNo# - #Claim.IndexNo# - #Claim.FirstName# #Claim.LastName#">

<cfoutput>
<cfif att neq "">
	<cfsavecontent variable="mailtext">

	<table width="100%" cellspacing="2" cellpadding="2">		   			
	<tr><td>
		This is to confirm the approval of your claim (TCP No:#Claim.DocumentNo#) against Travel Request No: #Request.DocumentNo#.
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>
		For details please see the attached Travel Claim Document (requires Adobe 6.0 or higher).
	</td></tr>
	</table>

	</cfsavecontent>
<cfelse>
	<cfsavecontent variable="mailtext">

	<table width="100%" cellspacing="2" cellpadding="2">
	<tr><td>
		This is to confirm the approval of your claim (TCP No:#Claim.DocumentNo#) against Travel Request No: #Request.DocumentNo#.
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	</table>

	</cfsavecontent>
</cfif>	
</cfoutput>

<!--- end of template --->