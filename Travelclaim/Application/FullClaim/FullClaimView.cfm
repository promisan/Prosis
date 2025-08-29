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
<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Travel Claim Portal (TCP)</title>

<link rel="stylesheet" type="text/css" href="#SESSION.root#/<cfoutput>#client.style#</cfoutput>">

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

<cfparam name="URL.source"  default="Standard">
<cfparam name="URL.home"    default="Portal">
<cfparam name="URL.mycl"    default="">
<cfparam name="URL.Id"      default="830A064C-DAD0-421F-B371-ACC4D18F013A">
<cfparam name="URL.claimid" default="#URL.ID#">
<cfparam name="URL.ID1"     default="{00000000-0000-0000-0000-000000000000}">
<cfset URL.ClaimId = replace("#URL.ClaimId#"," ","","ALL")>

</head>

<cftry>
	
	<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Claim
	WHERE    ClaimId = '#URL.ClaimId#' 
	</cfquery>

	<cfcatch>
		<cf_message message="Access Denied" return="no">
		<cfabort>
	</cfcatch>

</cftry>

<cfif Claim.recordcount eq "0">

	<cf_message message="Sorry, this claim has been revoked." return="no">
	<cfabort>

</cfif>

<cfif Claim.ClaimAsIs eq "1" and Claim.ActionStatus gte "2">

    <!--- generate entries --->
	<cfquery name="Entries" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ClaimSection
	(ClaimId,ClaimSection)
	SELECT '#URL.ClaimId#', Code
	FROM Ref_ClaimSection
	WHERE Operational = 1
	AND  Code NOT IN (SELECT ClaimSection 
	                  FROM ClaimSection 
					  WHERE ClaimId = '#URL.ClaimId#')
	</cfquery>

	<!--- update entries --->
	<cfquery name="Update" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    ClaimSection
	SET       ProcessStatus  = '1', 
	          ProcessDate    = getDate(), 
			  OfficerUserId  = 'ClaimAsIs'       
	WHERE     ClaimId        = '#URL.ClaimId#'  
	AND       ProcessStatus  = '0'
	</cfquery>

</cfif>

<cfquery name="Event" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM ClaimEvent C
	WHERE ClaimId = '#URL.ClaimId#' 
	ORDER BY EventDateEffective
</cfquery>

<cfquery name="Section" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ClaimSection R, ClaimSection C
	WHERE  TriggerGroup = 'TravelClaim'
	AND    R.Code *= C.ClaimSection
	AND    C.ClaimId = '#URL.ClaimId#'
	AND    R.Operational = 1
	ORDER BY ListingOrder
</cfquery>
			
<cfloop query="Section">

        <cfquery name="Check" 
		datasource="appsTravelClaim">
			SELECT  * 
			FROM    ClaimRequestLine
			WHERE   ClaimRequestId = '#Claim.ClaimRequestId#'	
			<cfif #showcondition# neq "">
			AND     #PreserveSingleQuotes(ShowCondition)#
			</cfif>
		</cfquery> 
		
		<cfif #Check.recordcount# eq "0">
		
				<cfquery name="Delete" 
				datasource="appsTravelClaim">
					DELETE FROM ClaimSection 
					WHERE ClaimId = '#URL.ClaimId#'
					AND   ClaimSection = '#Code#'
				</cfquery> 
				
		<cfelse>					
		 	
			<cftry>
		
				<cfquery name="Insert" 
				datasource="appsTravelClaim">
					INSERT INTO ClaimSection 
					(ClaimId,ClaimSection)
					VALUES ('#URL.ClaimId#','#Code#')
				</cfquery> 
					
				<cfcatch></cfcatch>
		
			</cftry>
		
		</cfif>

</cfloop>		

<cfquery name="Check" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   TOP 1 *
FROM    Ref_ClaimSection R INNER JOIN
        ClaimSection C ON R.Code = C.ClaimSection
WHERE   R.TriggerGroup = 'TravelClaim' 
AND     C.ClaimId = '#URL.ClaimId#' 
AND     C.ProcessStatus = '0'
ORDER BY R.ListingOrder 
</cfquery>

<cfif #Check.recordcount# eq "0">

	<cfquery name="Check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     Ref_ClaimSection
	WHERE    TriggerGroup = 'TravelClaim' 
	ORDER BY ListingOrder DESC 
	</cfquery>

</cfif>

<cfoutput>

<cfif url.home eq "Close">
 <cfset ht = 67>
<cfelse>
 <cfset ht = 107> 
</cfif>

<body style="overflow: auto;">

	<cfif url.source eq "OLAPDrill">
	
	  <cf_screentop height="100%" scroll="Yes" html="Yes" label="Travel Claim Drill down">
		<table width="100%" height="100%" border="0" bordercolor="silver" cellspacing="1" cellpadding="2">
			<tr>
				<td>
					<iframe src="../#Check.TemplateURL#?home=#URL.Home#&w=100&Section=#Check.Code#&Topic=#Check.TemplateTopicId#&ClaimId=#URL.ClaimID#&RequestId=#Claim.ClaimRequestId#&ID1=#Event.ClaimEventId##Check.TemplateCondition#"
			        name="right"
			        id="right"
			        width="100%"
			        height="100%"
					scrolling="no"
			        frameborder="0"></iframe>
				</td>
			</tr>
		</table>
		<cf_screenbottom>
	
	<cfelse>
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
		<tr><td height="#ht#">
		<cfset url.PersonNo = Claim.PersonNo>
		
		<cfinclude template="FullClaimBanner.cfm">
		
		</td></tr>
		
		<tr><td>
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" width="181">
				<iframe src="FullClaimMenu.cfm?Section=#Check.code#&PersonNo=#Claim.PersonNo#&Id=#URL.ClaimId#"
		        name="left" id="left" width="100%" height="100%" scrolling="no"
		        frameborder="0"></iframe>
				</td>
				<td>
					<iframe src="../#Check.TemplateURL#?home=#URL.Home#&w=100&Section=#Check.Code#&Topic=#Check.TemplateTopicId#&ClaimId=#URL.ClaimID#&RequestId=#Claim.ClaimRequestId#&ID1=#Event.ClaimEventId##Check.TemplateCondition#"
			        name="right"
			        id="right"
			        width="100%"
			        height="100%"
					scrolling="no"
			        frameborder="0"></iframe>
				</td>
			</tr>
		</table>
		
		</td></tr>
		</table>
	
	</cfif>
	
	
</cfoutput>
</body>

</html>