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
<html>
<head>
	<title>Express claim</title>
</head>

<body leftmargin="0" topmargin="0" rightmargin="0">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset advance = 0>

<cfoutput>

<cfform action="ExpressEntrySubmit.cfm?claimid=#URL.ClaimId#&class=Express" method="post" name="claim" id="claim">
	
	<cfquery name="Parameter" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	    FROM Parameter
	</cfquery>
	
	<cfquery name="Claim" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Claim 
		WHERE ClaimId = '#URL.ClaimId#' 
	</cfquery>
	
	<cfquery name="UpdateExpress" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Claim 
		SET ClaimAsIs = 1
		WHERE ClaimId = '#URL.ClaimId#' 
	</cfquery>
	
	<cfif Claim.recordcount neq "1">
		
		<cf_message message="We are sorry, pleaseSorry, your claim could not be located" return="No">
		<cfabort>
		
	</cfif>
	
	<cfquery name="Lines" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT count(*) as Total
	    FROM ClaimRequestItinerary
	    WHERE ClaimRequestId = '#Claim.ClaimRequestId#'		 
	</cfquery>
		
	<cfif Lines.total lte "1">
		
		<cf_message message="Sorry, but the Requested Itinerary is not complete (city table)." return="No">
		<cfabort>
		
	</cfif>
				
	<cfinclude template="../EventEntry/ClaimEventInit.cfm">
	
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
		WHERE  ClaimRequestId = '#Claim.ClaimRequestId#'
		AND C.ActionStatus *= R.Status
		AND C.ActionPurpose *= P.Code
		AND C.OrgUnit *= Org.OrgUnit 
		AND R.StatusClass = 'ClaimRequest'
	</cfquery>
	
	<script language="JavaScript">
	
	 function goback() {
	       if (confirm("You did not agree to the conditions described.  You will be redirected to previous screen and you may chose to file a Detailed Claim. Continue ?")) {
			window.location = "#SESSION.root#/TravelClaim/Application/ClaimEntry/ClaimEntry.cfm?ActionStatus=0&ClaimId=#URL.ClaimId#&RequestId=#Claim.ClaimRequestId#&PersonNo=#Claim.PersonNo#"
			}
		   }	
		   
	 function hl(itm,fld){
				
			se = document.getElementById(itm)
					 			 	 		 	
			if (fld != false){
						
			 se.className = "highLight2";
			 					 
			 }else{
						
			 se.className = "regular";		
			 
			 }
		  }	   
		  
	function process() {
	   window.claim.submit()
	}	  
		
	function step(s0,s1,s2,s3) {
						
					se = document.getElementById("intro");
					se.className = s0;			
					se = document.getElementById("condition");
					se.className = s1;
					se = document.getElementById("submitclaim");
					se.className = s2;	
					se = document.getElementById("calculateclaim");
					se.className = s3;						
	}	
						
				
	function addevent(event) {
			    alert("You will now be redirected to the detailed claim information page.")
		    	window.location= "../EventEntry/ClaimEventEntry.cfm?ClaimId=#URL.ClaimID#&ID1={00000000-0000-0000-0000-000000000000}&ID2=" + event;
	}
				
	 
	</script>
	
	<cfset IDClaim = "#URL.ClaimId#">
	
	<cf_LoginTop FunctionName = "TravelClaim" Graphic="No">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td><cfinclude template="../ClaimView/ClaimViewBanner.cfm"></td></tr>
	<tr><td>	
	
	<table width="90%" align="center" frame="hsides" border="0" cellspacing="0" cellpadding="0" bordercolor="e4e4e4">
	<tr><td>
			
			<table width="100%" cellspacing="1" cellpadding="1">			
								
			<tr><td> 
					 <cfinclude template="../ClaimEntry/ClaimRequest.cfm"> 
			</td></tr>
						
						
			<tr><td>
				<table width="98%" border="0" cellspacing="1" cellpadding="1" align="center">				
					<tr><td height="10"></td></tr>				
					<tr><td bgcolor="gray"></td></tr>
					<tr><td height="22" bgcolor="C7C7C7">&nbsp;<font size="2">Step 2 of 3 : Claim Preparation</font></td></tr>
					<tr><td bgcolor="gray"></td></tr>								
					<tr><td height="10"></td></tr>				
					<tr id="intro"><td>		
					<cfinclude template="ExpressEntryIntro.cfm">							
					</td></tr>				
					<tr id="condition" class="hide"><td>						
					<cfinclude template="ExpressEntryCondition.cfm">				
					</td></tr>				
					<tr id="submitclaim" class="hide"><td colspan="2">		
					<cfinclude template="ExpressEntryDetails.cfm">
					</td></tr>		
					<tr id="calculateclaim" class="hide"><td colspan="2">					
					<cfinclude template="ExpressEntryCalculate.cfm">				
					</td></tr>				
				</table>
			
			</td></tr>			
			
			</table>
						
	</td></tr>
	</table>
	
	</td></tr>
	</table>
	
	<cf_LoginBottom FunctionName = "TravelClaim" Graphic="No">

</cfform>

</cfoutput>

</body>
</html>
