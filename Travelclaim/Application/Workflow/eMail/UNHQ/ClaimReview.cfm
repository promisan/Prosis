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

<cfquery name="Validation" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      #db#Claimvalidation
	WHERE    claimId = '#Object.ObjectKeyValue4#'
</cfquery>		


<cfset mailsubject = "Travel Claim Review - TCP #Claim.DocumentNo# against TVRQ #Request.DocumentNo# - #Claim.IndexNo# - #Claim.FirstName# #Claim.LastName#">

<cfoutput>
<cfsavecontent variable="mailtext">
<!---
<cf_screentop label="Review"> 
--->
	<table width="100%" cellspacing="2" cellpadding="2">
	
	<tr><td colspan="2">
		The above travel claim has been submitted from the claimant to your office for review. You can access the claim by clicking 
		<a href="#SESSION.root#/#Object.ObjectURL#&wcls=workflow" target="_parent">here</a> or via the Nova portal
	</td></tr>
	
	<tr><td>Claim validation messages</td></tr>
	<tr><td colspan="2">
	<table width="100%" border="1" cellspacing="2" cellpadding="2">
	<tr><td>#validation.Validationmemo#</td></tr>
	</table>
	<tr><td>Proposed Status:</td>
	    <td><b><cfif claim.ClaimException eq "0">Complete<cfelse>Incomplete</cfif></b></td>
	</tr>
	<cfif #Claim.Remarks# eq "">
	<tr><td>Claimant remarks:</td>
	    <td><cfif claim.remarks eq "">None<cfelse>#Claim.Remarks#</cfif></td>
	</tr>
	</cfif>
		
	<cfif MailText neq "">
	
	<tr><td>Sender remarks:</td>
	    <td>#MailText#</td>
	</tr>
	</cfif>
	
	</table>
	<!---
	<cf_screenbottom>
	--->	
</cfsavecontent>
</cfoutput>

<!--- end of template --->