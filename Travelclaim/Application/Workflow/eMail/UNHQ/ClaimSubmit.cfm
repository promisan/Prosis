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
	FROM      #db#Claim C INNER JOIN #db#stPerson P ON C.PersonNo = P.PersonNo
	WHERE     C.ClaimId = '#Object.ObjectKeyValue4#' 
</cfquery>	
 

<cfquery name="Request" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      #db#ClaimRequest 
	WHERE     ClaimRequestId = '#Claim.ClaimRequestId#'
</cfquery>	

<cfset mailsubject = "Travel Claim SUBMISSION - TCP #Claim.DocumentNo# against TVRQ #Request.DocumentNo# - #Claim.IndexNo# - #Claim.FirstName# #Claim.LastName#">

<cfoutput>
<cfsavecontent variable="mailtext">
<!---
<cf_screentop label="Confirmation"> 
--->
	<table width="100%" cellspacing="2" cellpadding="2">
	
	<tr><td>
		This is to confirm receipt of your claim (TCP No:#Claim.DocumentNo#) against Travel Request No: #Request.DocumentNo#
	</td></tr>
	<cfif Object.EntityClass eq "ClaimAsIs">
		<tr><td>Your claim has been pre-cleared for approval in IMIS.</td></tr>	
	
<!--- Add logic that checks if Object.EntityClass eq " ClaimAccount"
If so, text: Your claim has been forwarded to Accounts for review.
--->
   
    <cfelseif Object.EntityClass eq "ClaimAccount">
	<tr><td>Your claim has been forwarded to Accounts for review.</td></tr>	
	<cfelse>
		<tr><td>Your claim has been forwarded to your EO for certification.</td></tr>

	</cfif>
	<tr><td>
	You will be notified by email upon approval of your claim in IMIS, or if any further action on your part is required.
	</td></tr>
	</table>
	<!---
<cf_screenbottom>	
--->

</cfsavecontent>
</cfoutput>

<!--- end of template --->
