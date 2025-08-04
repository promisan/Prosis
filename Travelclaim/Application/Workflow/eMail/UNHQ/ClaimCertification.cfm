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

<cfset mailsubject = "Travel Claim Certification - TCP #Claim.DocumentNo# against TVRQ #Request.DocumentNo# - #Claim.IndexNo# - #Claim.FirstName# #Claim.LastName#">

<cfoutput>
<cfsavecontent variable="mailtext">

<!---
<cf_screentop label="Claim Certification"> 
--->
	<table width="100%" cellspacing="2" cellpadding="2">
	
	<tr><td colspan="2">
	    <cfif Object.TriggerActionType eq "SendBack">
		
			<cfquery name="step" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     Step.*
			FROM       OrganizationObjectAction OA INNER JOIN
		               Ref_EntityActionPublish Step ON OA.ActionPublishNo = Step.ActionPublishNo
					                               AND OA.ActionCode = Step.ActionCode
			WHERE     (OA.ActionId = '#Object.TriggerActionId#')
			</cfquery>	
					
			The above travel claim has been <b>returned</b> from #step.ActionReference# to your office for review and action. You can access the claim by clicking 
			<a href="#SESSION.root#/#Object.ObjectURL#&wcls=workflow">here</a> or via the Nova portal
			
		<cfelse>
		
			The above travel claim has been submitted to your office for certification. You can access the claim by clicking 
			<a href="#SESSION.root#/#Object.ObjectURL#&wcls=workflow">here</a> or via the Nova portal
			
		</cfif>
	</td></tr>
	
	<tr><td colspan="2">Claim validation messages</td></tr>
		
	<tr><td>Proposed Status:</td>
	    <td><b><cfif claim.ClaimException eq "0">Complete<cfelse>Incomplete</cfif></b></td>
	</tr>
	<tr><td>Claimant remarks:</td>
	    <td><cfif Claim.Remarks eq "">None<cfelse>#Claim.Remarks#</cfif></td>
	</tr>
	<cfif MailText neq "">
	<tr><td>Sender remarks:</td>
	    <td>#MailText#</td>
	</tr>
	</cfif>
		
	</table>
	<!---
	<cf_screenbottom>	
	---->
</cfsavecontent>
</cfoutput>

<!--- end of template --->