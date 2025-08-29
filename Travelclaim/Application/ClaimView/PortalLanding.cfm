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
<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Dev van Pelt</proOwn>
<proDes></proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template is the main container for the portal home screen. The screen lists claims per status of submission.

1. Check if the PersonNo passed from the logon screen is a valid personNo, this prevent issues in case the browser would not pass the URL properly. This problem has been noticed several times and the included validation.

2. Check if there are any claims with status = 8 in the database for this users. Status 8 is a temporary status in case a user decides not to continue with the claim. Instead of purging the draft claim immediately the system first sets is action status to 8 before the claim is purged when this screen is reload as part of the go back routine the user opted for. It is a transition status.

3. Check if there are claims with status 6 in the database for this user which do not exist in IMIS (IMP_Claim). Since claims with status 6 are claims not raised with the TCP its sole purpose is to show what is in IMIS. If somehow the claim does not exisit in IMIS, there is no reason to show this claim in TCP either.

4. Check if TCP claims which have been uploaded into IMIS do indeed still exist in IMIS. In case the TCP claim does not exist in IMIS anymore its status is set to 9 (cancelled) and made invisble for the user. In principle this should not happen. In the case the claims would not be available in IMIS due to a temporary outage of IMIS causing the IMP_Claim table to be incomplete or empty this action would be reversed by the batch the next time the batch would run.

5. Check if the claim status is set to at least 3 for claims that have been recorded as export.

Note to the file : All verifications are worst case verifications to prevent claims are show to the user incorrectly. Most of these verifications were driven by a testing/development scenario in which data was manipulated, hence strange things would occur.
</td></tr>
</table>
</proInfo>

</cfsilent>


<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Travel Claims Portal (TCP)</title>

<cfset mode = "home">
<cfparam name="URL.ClaimId" default="">
<cfparam name="URL.Clear" default="">

<cfset url.personNo = client.PersonNo>

<cf_PreventCache>
</head>

<cfquery name="Check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     dbo.ClaimRequest R
	WHERE    R.PersonNo = <cfqueryparam 
						      value="#URL.PersonNo#" 
						      cfsqltype="CF_SQL_VARCHAR" 
						      maxlength="10">
	
</cfquery>

<!--- added based on issue initiated by francois on users not leaving the claim portal using back --->

<cfquery name="Clear" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Claim
	WHERE  PersonNo = '#url.personNo#'			 
	AND    ActionStatus <= '1'
	AND    DocumentNo = '0' 
	AND    ClaimId NOT IN (SELECT ClaimId FROM ClaimEvent)
</cfquery>

<cftry>

	<!--- business rule 0 : requested delete --->	
		
	<cfif url.clear neq "">
	
		<cfquery name="Clear" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Claim
			WHERE  ClaimId = '#URL.Clear#' 
			AND    ActionStatus <= '1'
			AND    DocumentNo = '0' 
		</cfquery>
	
	</cfif>
	
	<cfquery name="Clear8" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Claim
		WHERE  PersonNo = <cfqueryparam 
						      value="#URL.PersonNo#" 
						      cfsqltype="CF_SQL_VARCHAR" 
						      maxlength="10">
		AND  ActionStatus = '8'
		AND  DocumentNo = '0'
	</cfquery>	
	
	<!--- business rule 1 : remove OTHER claims that are not in IMIS anymore --->	
	
	<cfquery name="ClearOther" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Claim
	WHERE  ActionStatus = '6'
	AND    PersonNo = <cfqueryparam 
						      value="#URL.PersonNo#" 
						      cfsqltype="CF_SQL_VARCHAR" 
						      maxlength="10">
	AND    ReferenceNo NOT IN (SELECT Doc_id FROM IMP_CLAIM)
	</cfquery>
	
	<!--- business rule 2 : remove Portal claims that are not in IMIS upload anymore --->
	
	<cfquery name="Clear" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Claim
		SET    ActionStatus = '9'
		WHERE  ActionStatus IN ('4','4c','5')
		AND    PersonNo = <cfqueryparam 
							      value="#URL.PersonNo#" 
							      cfsqltype="CF_SQL_VARCHAR" 
							      maxlength="10">
		AND    ReferenceNo NOT IN (SELECT Doc_id FROM IMP_CLAIM)
	</cfquery>
	
	<!--- Note for the file : reappearing claim will be reset through the DTS --->
	
	<!--- business rule 3 : exported claims should have a status 3 or higher --->
	
	<cfquery name="Reset" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Claim
		SET    ActionStatus = '3'
		WHERE  ActionStatus IN ('0','1','2')
		AND    PersonNo = <cfqueryparam 
							      value="#URL.PersonNo#" 
							      cfsqltype="CF_SQL_VARCHAR" 
							      maxlength="10">
		AND    ExportNo IN (SELECT ExportNo FROM stExportFile WHERE ActionStatus != '9')
	</cfquery>

	<cfcatch></cfcatch>

</cftry>

<cfparam name="URL.ClaimId" default="">

<cfif URL.ClaimId neq "">

	<cfquery name="Claim" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ClaimSection 
			SET ProcessStatus = 0
		    WHERE  ClaimId =  <cfqueryparam
						        value="#URL.ClaimId#"
						        cfsqltype="CF_SQL_IDSTAMP">
								
			AND    ClaimSection IN (SELECT Code 
			                     FROM REF_ClaimSection 
								 WHERE ResetOnUpdate = 1)
		</cfquery>

</cfif>

<cfset url.personNo = client.PersonNo>

<cf_LoginTop FunctionName = "TravelClaim">
  
<cf_wait1 icon="circle" text="Retrieving your information">	

<table width="96%" align="center" cellspacing="0" cellpadding="0">
<tr><td><cfinclude template="ClaimViewBanner.cfm"></td></tr>
<tr><td><cfinclude template="ClaimViewBody.cfm"></td></tr>
</table>

<cf_waitEnd>

<cf_LoginBottom FunctionName = "TravelClaim">

</html>