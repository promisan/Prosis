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
<proDes>Laster update installed</proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template is part of the application framework and defines the menu to be presented to the user accessing the application section of the Module travel Claim
</td></tr>
</table>
</proInfo>

</cfsilent>

<html><head><title>Travel Claims Portal (TCP)</title></head>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<div class="screen">
<body leftmargin="5" topmargin="0" rightmargin="0" bottommargin="0">

<cfparam name="URL.wcls"             default="">
<cfparam name="URL.actionStatus"     default="">  <!--- enforce a status to be reset --->
<cfparam name="URL.complete"         default="no">
<cfparam name="URL.claimid"          default="">
<cfparam name="URL.RequestId"        default="">
<cfparam name="URL.section"          default="">
<cfparam name="URL.home"             default="">
<cfset color0 = "6688AA">
<cfset color1 = "EFEB9A">
<cfset color2 = "e4e4e4">

<cfset url.claimId   = replace(URL.ClaimId,' ','','ALL')>	 
<cfset url.requestid = replace(URL.Requestid,' ','','ALL')>	 

<cfif url.requestId eq "" or url.claimid neq "">
	
	<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Claim
		WHERE  ClaimId = '#URL.ClaimId#'
	</cfquery>	
	
	<cfset URL.RequestId = Claim.ClaimRequestId>
	
	<cfif claim.recordcount eq "0">
		 <cf_message message="Operation aborted as your Claim could not be located.">
		 <cfabort>
	</cfif>

</cfif>

<cfif url.actionstatus neq "" and url.claimid neq "">

	<cfquery name="Update" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Claim 
			SET    ActionStatus = '#URL.ActionStatus#' 
			WHERE  ClaimId = '#URL.ClaimId#'
	</cfquery>

</cfif>
 
<cfquery name="ClaimTitle" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT C.*, 
	       R.PointerStatus, 
		   R.Description as StatusDescription, 
		   P.Description as Purpose,
		   Org.OrgUnitName
	FROM   ClaimRequest C, 
	       Ref_Status R, 
		   Ref_ClaimPurpose P,
		   Organization.dbo.Organization Org
	WHERE  ClaimRequestId = '#URL.RequestId#'
	AND C.ActionStatus *= R.Status
	AND C.ActionPurpose *= P.Code
	AND C.OrgUnit *= Org.OrgUnit 
	AND R.StatusClass = 'ClaimRequest' 
</cfquery>

<cfif ClaimTitle.recordcount eq "0">
	 <cf_message message="Operation aborted. Travel Request could not be located.">
	 <cfabort>
</cfif>

<cfparam name="URL.PersonNo" default="#ClaimTitle.PersonNo#">
<cfparam name="URL.Mode" default="0">

<cfoutput>
<SCRIPT LANGUAGE = "JavaScript">

function showclaim(id) {
   window.location = "ClaimEntry.cfm?PersonNo=#URL.PersonNo#&ClaimId="+id+"&RequestId=#URL.RequestId#";
}
	
</SCRIPT>	
</cfoutput>

<cfquery name="Parameter" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM Parameter
</cfquery>

<cfoutput>

<cf_dialogStaffing>

<cfif URL.ClaimId eq "">

	<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT TOP 1 * 
	FROM  Claim 
	WHERE ClaimRequestId = '#URL.RequestId#'	
	</cfquery>
	
	<cfif Claim.recordcount eq "0">
	
		 <cfquery name="AddressMode" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
		    FROM   Ref_PaymentMode
			WHERE  TriggerGroup = 'TravelClaim'
	   	</cfquery>
		
		 <cfquery name="Duty" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
		    FROM   Ref_DutyStation
			WHERE  Mission  = '#ClaimTitle.Mission#'
	   	</cfquery>
				
		<cfquery name="Insert" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    INSERT INTO Claim 
	     	(ClaimRequestId,
			PersonNo, 
			DocumentNo,
			PaymentMode,
			PaymentCurrency,
			PointerClaimFinal,
			ClaimDate, 			 
			OfficerUserId, 
			OfficerLastName, 
			OfficerFirstName)
		VALUES ('#URL.RequestId#',
		        '#URL.PersonNo#',
		        '0',
				'#AddressMode.Code#',
				'#Duty.PaymentCurrency#',
				'#Parameter.FinalClaimDetailed#',	
		        '#DateFormat(now(),client.dateSQL)#',			
				'#SESSION.acc#', 
				'#SESSION.last#', 
				'#SESSION.first#') 
		</cfquery>
								
		<cfquery name="Claim" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM  Claim 
		WHERE PersonNo       = '#URL.PersonNo#' 
		AND   ClaimRequestId = '#URL.RequestId#'		
		</cfquery>
	
	</cfif>
	
	<cfset IDclaim = "#claim.claimId#">
			
<cfelse>

	<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM  Claim 
		WHERE ClaimId = '#URL.ClaimId#' 
	</cfquery>
	
	<cfif Claim.recordcount eq "0">
	
		<cf_waitEnd>
		<cf_message Message="Problem, this claim has been cancelled. Please contact your administrator." return="No">
		<cfabort>
	
	</cfif>
	
	<cfset IDclaim = "#URL.ClaimId#">
	
</cfif>
 
<!--- check if user may edit the claim --->

<cfif client.personNo neq Claim.PersonNo>

	<cfquery name="Parameter" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Parameter		
	</cfquery>
	
	<cfif Parameter.enableActorSubmit eq "1">
		<cfset editclaim = 1>
	<cfelse>
	    <cfset editclaim = 0>  			
	</cfif>
	
<cfelse>
	
	 <!--- user = claimant --->
	 <cfset editclaim = 1>  	
	
</cfif>	  

<cfset client.claimlast = IDClaim>
<cfset URL.ClaimId = IDClaim>

<cfquery name="Calc" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   ClaimCalculation
	WHERE  ClaimId = '#IDClaim#'
	ORDER BY Created DESC 
</cfquery>	

<cfquery name="Employee" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   stPerson
    WHERE  PersonNo = '#Claim.PersonNo#' 
</cfquery>

<cfparam name="URL.w" default="0">

<cf_waitEnd>

<cfif Claim.ActionStatus eq "0">
	<cfset w = "94%"> 
	<cf_LoginTop FunctionName = "TravelClaim">	
	
<cfelseif Claim.ClaimAsIs eq "1" and url.w neq "100" and url.section eq "">
    <cf_LoginTop FunctionName = "TravelClaim" Graphic="No">	
	
	<cfset w = "95%"> 
<cfelseif Claim.ActionStatus eq "6">	
	<cf_LoginTop FunctionName = "TravelClaim" Graphic="No">
	
	<cfset w = "97%"> 
<cfelse>
	<body leftmargin="7" topmargin="5" rightmargin="3" bottommargin="0" onLoad="window.focus()">	
	<cfset w = "100%">
</cfif>

<cfform action="ClaimEntrySubmit.cfm?claimid=#idclaim#" method="POST" name="entry">

<table width="100%" cellspacing="2" cellpadding="2">

    <cfif (Claim.ClaimAsIs eq "1" or Claim.ActionStatus eq "0" or Claim.ActionStatus eq "6") and url.home eq "">
	 <tr><td><cfinclude template="../ClaimView/ClaimViewBanner.cfm"></td></tr>	
	</cfif>
	
<tr><td>

	<table width="<cfoutput>#w#</cfoutput>" align="center" height="97%" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td valign="top">
	
	<table width="<cfoutput>#w#</cfoutput>" 
	       align="center" 
		   border="0" 
		   frame="hsides" 
		   bordercolor="d1d1d1" 
		   cellspacing="0" 
		   cellpadding="0">
	
	<tr>
	<td height="20" valign="top">	
	
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="1" bordercolor="d4d4d4">
			<tr><td>
				<cfinclude template="ClaimRequest.cfm">  
				</td>
			</tr>
		</table>	
		
	</td></tr>
	
	<cfparam name="adv" default="0">
	
								
	<tr><td valign="top" height="4">
	
	<cfif ClaimTitle.PointerStatus eq "4" and Claim.ActionStatus eq "0">
	
		<cf_Message message="You are currently not authorised to issue a claim" return="back">
	
	<cfelse>
					
			<cfif Claim.PointerUpload eq "0" and Claim.ActionStatus lte "1">
						
				<cfinclude template="../Process/ValidationRules/ValidationInitial.cfm">
					
				<!--- check for messages --->
				
				<cfquery name="Message" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     DISTINCT 
				           R.Description, 
						   R.MessagePerson,
						   R.MessageAuditor,
				           R.Color, 
						   LV.ValidationMemo
			    FROM       ClaimValidation LV INNER JOIN
			               Ref_Validation R ON LV.ValidationCode = R.Code
				WHERE      LV.ClaimId = '#Claim.ClaimId#'
				AND        ValidationCode IN (SELECT Code 
				                              FROM   Ref_Validation 
											  WHERE  ValidationClass = 'Initial'
											  AND    Operational = 1)
				</cfquery>	
								
				<cfif Message.recordcount gte "1">				
													
					<table width="95%"
				       border="0"
				       cellspacing="2"
				       cellpadding="2"
				       align="center"
				       bordercolor="C0C0C0">
									
						<tr><td align="center" height="50">
						<table>
						<tr><td>
						<img src="#SESSION.root#/Images/close3.gif" alt="Problem" border="0" align="absmiddle">
						</td>
						<td>
						    <font face="Verdana"
						      size="2"
						      color="800000">
						    <b>You may <font size="3">NOT</font> prepare this claim for the following reason<cfif message.recordcount gt 1>s</cfif>:</b></font>
						</td>
						</tr>
						</table>
						</td>
						</tr>
						
						<tr><td height="1" bgcolor="C0C0C0"></td></tr>
						
						<cfloop query="message">
						
						<tr height="22" bgcolor="ffffcf"><td>
							<table width="91%" cellspacing="2" cellpadding="2" align="center">
							<tr><td width="20">#currentrow#.</td><td>#MessagePerson#</td></tr>
							</table>
							</td>
						</tr>
						
						</cfloop>					
											
						<tr><td height="1" bgcolor="C0C0C0"></td></tr>
						
						<tr><td align="left" height="40">				
							 <button class="button10g"  onClick="window.location='../ClaimView/ClaimView.cfm?Clear=#claim.claimid#&PersonNo=#Claim.PersonNo#'">
							 &nbsp;Back</button>		
				
						</td></tr>	
					
					</table>
					
					<cfquery name="Reset" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Claim						
						SET    ActionStatus = '8'
						WHERE  ClaimId = '#Claim.ClaimId#'
					</cfquery>		
																					
				<cfelse>				
			
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver">
						<tr><td><cfinclude template="ClaimInfo.cfm"></td></tr>
					</table>					
				
				</cfif>
									
			<cfelse>
			
			     <table width="100%" align="center" border="0" cellspacing="0" cellpadding="1" bordercolor="silver">
					<tr><td><cfinclude template="ClaimInfo.cfm"></td></tr>
				 </table>
							
			</cfif>
			
	</cfif>
	
	</td>
	
	</tr>	
					
	<cfquery name="Object" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  OrganizationObject 
			WHERE ObjectKeyValue4 = '#URL.ClaimId#' 
			AND   Operational = 1
	</cfquery>
	
	<cfif Object.recordcount eq "0">
	    <cfset reset = "1">			
	<cfelse>
	   	<cfset reset = "0">		
	</cfif>
	
	<cfif Claim.ActionStatus eq "1" and editclaim eq "1">
	
		<tr><td height="1" colspan="2" valign="top" bgcolor="C0C0C0"></td></tr>
	
		<tr><td valign="bottom" height="30">
	
	   <cfif URL.ClaimId neq "" and Claim.ClaimAsIs eq "0">	
	   	   	
		   <cf_Navigation
				 Alias         = "AppsTravelClaim"
				 Object        = "Claim"
				 Group         = "TravelClaim" 
				 Section       = "last"
				 Id            = "#URL.ClaimId#"
				 BackEnable    = "1"
				 <!---
				 RefreshLeftMenu = "1"
				  removed this as behavior for claimant did not allow to move back properly --->
				 BackScript    = "window.location='../ClaimView/ClaimView.cfm?PersonNo=#Claim.PersonNo#'"				 
				 HomeEnable    = "1"
				 ResetEnable   = "#reset#"
				 ButtonClass   = "ButtonNav1"
				 ProcessEnable = "0"
				 Reload        = "1"
				 SetNext       = "1"
				 NextEnable    = "0"
				 NextMode      = "1">											
			 
		<cfelseif Claim.ClaimAsIs eq "1">
			
			<cf_Navigation
				 Alias         = "AppsTravelClaim"
				 Object        = "Claim"
				 Group         = "TravelClaim" 
				 Section       = "Last"
				 Id            = "#URL.ClaimId#"
				 BackEnable    = "1"
				 BackScript    = "window.location='../ClaimView/ClaimView.cfm?PersonNo=#Claim.PersonNo#'"
				 HomeEnable    = "1"
				 ButtonClass   = "ButtonNav1"
				 ResetEnable   = "#reset#"
				 ProcessEnable = "0"
				 NextEnable    = "0"
				 NextMode      = "1"
				 RefreshLeftMenu  = "0">				 
									 
		 <cfelseif Claim.ActionStatus eq "0">
				
		   <!--- locally --->
			 
		 <cfelse>  
					  		  
			  <cf_Navigation
				 Alias         = "AppsTravelClaim"
				 Object        = "Claim"
				 Group         = "TravelClaim" 
				 Section       = "Last"
				 Id            = "#IdClaim#"
				 ButtonClass   = "ButtonNav1"
				 BackEnable    = "0"
				 HomeEnable    = "0"
				 ResetEnable   = "0"
				 ResetName     = "Home"
				 ResetIcon     = "Nav_home.gif"
				 ResetQuestion = "0"
				 ProcessEnable = "0"
				 NextEnable    = "0"
				 NextMode      = "0"
				 RefreshLeftMenu  = "0">	 
				 		 
		</cfif>	 
			
		</td></tr>
			 
	</cfif>		
	
	</table> 
	
	</td></tr>
	</table>	
			
	</td>
</tr>

</cfform>

</table>	

<cfif Claim.ActionStatus eq "0">
	<cf_LoginBottom FunctionName = "TravelClaim" Graphic="No">
<cfelseif Claim.ActionStatus eq "6">	
	<cf_LoginBottom FunctionName = "TravelClaim" Graphic="No">	
<cfelseif Claim.ClaimAsIs eq "1" and url.w neq "100" and url.section eq "">	
    <cf_LoginBottom FunctionName = "TravelClaim" Graphic="No">
</cfif>	

</cfoutput>

</body>
</html>

<cf_waitEnd>
