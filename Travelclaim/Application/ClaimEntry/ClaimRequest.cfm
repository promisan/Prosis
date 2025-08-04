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

<cfparam name="URL.ClaimRequestId" default="">
<cfparam name="URL.hide" default="0">

<cfif URL.ClaimRequestId eq "">

	<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Claim
		WHERE  ClaimId = '#URL.ClaimId#'
	</cfquery>	
	<cfset URL.ClaimRequestId = Claim.ClaimRequestId>

</cfif>

<cfquery name="Object" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  OrganizationObject 
	WHERE ObjectKeyValue4 = '#URL.ClaimId#' 
	AND   Operational = 1
</cfquery>	

<cfset URL.ClaimRequestId = Claim.ClaimRequestId>
<cfparam name="processWF" default="0">
<cfparam name="pdf" default="0">
<cfparam name="advance" default="1">

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
	WHERE  ClaimRequestId = '#URL.ClaimRequestId#'
	AND C.ActionStatus = R.Status
	AND C.ActionPurpose = P.Code
	AND C.OrgUnit *= Org.OrgUnit 
	AND R.StatusClass = 'ClaimRequest'
</cfquery>

<script language="JavaScript">
		
	function maximizereq(itm){
		
	 try {
  	
		 se   = document.getElementsByName(itm)		
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 
		 count = 0
		 	 
		 if (se[0].className == "regular") {
		 
		 while (se[count]) { 
		    se[count].className = "hide"; 
		    count++
		  }		   
		 icM.className = "hide";
		 icE.className = "regular";
		 
		 } else {
		 
		 while (se[count]) {
		   
		    se[count].className = "regular"; 
		    count++
		  }	
		 icM.className = "regular";
		 icE.className = "hide";			
		 }
		 
		 } catch(e) {}
	 
  }  
  
  function show(itm) {
  
  try { 
  se = document.getElementById(itm)
  if (se.className == "regular") {
     se.className = "hide"
  } else {
     se.className = "regular"
  }
  
  } catch(e) {} 
  
  }
		  
</script> 

<cfset travel = "1">


<table width="100%"
       border="0"
       cellspacing="0"
       align="center"
       bordercolor="#C0C0C0"
       rules="rows">

	<tr>
	  <td height="25">
	 	 	  
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td width="22" align="center">
	   
	    <cfoutput>
		
		<cfif pdf eq "1">

				<cfset cl = "regular">
				<cfset clt = "hide">
			
			<div class="hide">
				<img src="#SESSION.root#/Images/icon_expand.gif" 
				id="requestExp">
				
				<img src="#SESSION.root#/Images/icon_collapse.gif" 
				id="requestMin">		
			</div>
			
		<cfelse>
		
			<cfif url.hide eq 1>
				<cfset cl  = "hide">
				<cfset clt = "regular">
			<cfelseif Claim.ActionStatus lt "2" or claim.actionStatus eq "6">
				<cfset cl  = "regular">
				<cfset clt = "hide">
			<cfelse>
				<cfset cl  = "hide">
				<cfset clt = "regular">
			</cfif>
						
			<img src="#SESSION.root#/Images/icon_expand.gif" 
			alt="Show request details"  
			id="requestExp" border="0" class="#clt#" 
			align="absmiddle" style="cursor: hand;" 
			onClick="maximizereq('request')">
				
			<img src="#SESSION.root#/Images/icon_collapse.gif" 
			id="requestMin" 
			alt="Hide request details"  border="0" 
			align="absmiddle" class="#cl#" style="cursor: hand;" 
			onClick="maximizereq('request')">		
			
		</cfif>	
				
		</td>
				
		<td width="158">&nbsp;&nbsp;			
		    <a href="javascript:maximizereq('request')" title="Show travel request">
			  <font face="Verdana" color="4E6FBA"><b>Travel Request
			</a>
			</td>
			
			<td>#ClaimTitle.DocumentNo# (#ClaimTitle.Mission#)</td>
			<td width="100" align="right"><b>IMIS Status:&nbsp;</b></td>
			<cfif ClaimTitle.PointerStatus eq "0">
			<td><table cellspacing="0" cellpadding="0"><tr><td>
			        <img src="#SESSION.root#/Images/status_alert1.gif" align="absmiddle" alt="" border="0">
					</td><td>
				   <font color="FF0000"><b>#ClaimTitle.StatusDescription#
				   </td></tr></table>
			</td>
			<cfelse>
			<td><table cellspacing="0" cellpadding="0"><tr><td>
			   <img src="#SESSION.root#/Images/status_ok1.gif" align="absmiddle" alt="" border="0">
			   </td><td>
				   &nbsp;#ClaimTitle.StatusDescription#
				 </td></tr></table>  
			</td>	   
				   
			</cfif>
			</td>
			<td width="75" align="right"><b>Purpose:&nbsp;</b></td>
			<td>#ClaimTitle.Purpose#</td>	
			
			</cfoutput>
		 
		 </tr>		  
		 </table>
	  
	</tr>
		
	
	<tr><td>
			
	<table width="100%" border="0" cellspacing="0" cellpadding="0">		
				
		<tr><td height="2"></td></tr>
							
		<tr><td>
			
		<table width="100%" cellspacing="0" cellpadding="1" align="center">
		
		<cfquery name="ClaimRequest" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   L.Currency AS Currency, 				 
		         SUM(L.RequestAmount) AS RequestAmount, 
				 R.Description AS ClaimCategoryDescription, 
				 R.ClaimAmount AS ClaimAmount, 
	             R.DefaultIndicatorCode AS DefaultIncatorCode, 
				 R.Code,
				 P.LastName, 
				 P.FirstName, 
	             P.IndexNo,
				 P.PersonNo
		FROM     ClaimRequestLine L INNER JOIN
	             Ref_ClaimCategory R ON L.ClaimCategory = R.Code INNER JOIN
	             stPerson P ON L.PersonNo = P.PersonNo
		WHERE    L.ClaimRequestId = '#ClaimTitle.ClaimRequestId#'
		GROUP BY L.Currency, P.PersonNo, R.Description, R.DefaultIndicatorCode, R.ClaimAmount, R.ListingOrder, R.Code,
		         P.LastName, P.FirstName, P.IndexNo 
		ORDER BY R.ListingOrder, R.Code 
	    </cfquery>		
			
		<tr id="request" class="<cfoutput>#cl#</cfoutput>">
		    <td height="2" colspan="5"></td>
		</tr>
		
		<tr><td height="1" colspan="5" bgcolor="e4e4e4"></td></tr>
		
		<tr bgcolor="FFFFFF" id="request" class="<cfoutput>#cl#</cfoutput>">
		    <td colspan="1" height="24">&nbsp;&nbsp;&nbsp;&nbsp;Prepared by:
			<td colspan="4">
			<table cellspacing="0" cellpadding="0">
				<tr><td>
				<cfif ClaimTitle.OrgUnitName eq "">
				<font color="FF0000"><b>Responsible unit could not be determined</b></font>
				<cfelse>
				<cfoutput>#ClaimTitle.OrgUnitName#</cfoutput>
				</cfif>
				</td>
				<td>&nbsp;</td>
				
				</tr>
			</table>
		    </td>
		</tr>
					

		<cfif ClaimTitle.Description neq "">
						
		<tr><td height="1" colspan="5" height="20" bgcolor="e4e4e4"></td></tr>
				
		<tr bgcolor="FFFFFF" id="request" class="#cl#">
		   	<td colspan="1" height="24">&nbsp;&nbsp;&nbsp;&nbsp;Purpose&nbsp;:
			<td colspan="4">
			<span style="line-height: 20px;">
			   <cfoutput>#ClaimTitle.Description#</cfoutput>
			</span>
		    </td>
		</tr>
		
		</cfif>
			
		<cfoutput query="ClaimRequest">
										
			<cfif ClaimAmount eq "1">
			 <cfset ln = "ffffff">
			<cfelse>
			 <cfset ln = "ECF5FF">   
			</cfif>
			
			<cfquery name="Itinerary" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT I.Itinerary, 
				       I.DateDeparture, 
					   I.DateReturn,
					   RL.Remarks,
					   R.*
				FROM   ClaimRequestItinerary I, 
				       ClaimRequestLine RL,
				       Ref_ClaimCategory R
				WHERE  I.ClaimRequestId      = '#ClaimTitle.ClaimRequestId#'
				AND    RL.ClaimRequestId     = I.ClaimRequestId
				AND    R.Code = '#Code#'
				AND    RL.ClaimRequestLineNo = I.ClaimRequestLineNo
				AND    R.Code = RL.ClaimCategory 
			</cfquery>
						
			<cfif Itinerary.recordcount gte "1">
				
				 <cfif travel eq "1"> 
							
					<cfquery name="TravelSum" 
					 datasource="appsTravelClaim" 
					 username="#SESSION.login#" 
				   	 password="#SESSION.dbpw#">
					  SELECT   sum(RequestAmount) as TravelTotal
					  FROM     ClaimRequestLine RL,
							   Ref_ClaimCategory R
					  WHERE    RL.ClaimRequestId = '#ClaimTitle.ClaimRequestId#'
						AND    RL.ClaimRequestLineNo IN (SELECT ClaimRequestLineNo 
						                             FROM ClaimRequestItinerary 
													 WHERE ClaimRequestId = '#ClaimTitle.ClaimRequestId#') 
						AND    R.Code = RL.ClaimCategory   
					</cfquery>
										
						<tr bgcolor="#ln#" id="request" class="#cl#">
						<td width="170">&nbsp;&nbsp;&nbsp;&nbsp;Travel:</td>
						<td align="left">
						<table cellspacing="0" cellpadding="0">
							<tr>
							<td width="40"><a href="javascript:show('travel')">#Currency# </a>
							<td width="100" align="right"><a href="javascript:show('travel')"><font color="0080FF">#numberFormat(TravelSum.TravelTotal,"_,_.__")#</font></a></td>							
							<td>&nbsp;</td>
							<td><cfif #PersonNo# neq "#ClaimTitle.PersonNo#"><b>#FirstName# #LastName#</cfif></td>	
							<cfset rem = Itinerary.Remarks>
							<td>&nbsp;</td>
							</tr>
						</table>
						</td>
										
					</tr>
				
				</cfif> 
			
			<cfelse>
							
				<tr bgcolor="#ln#" id="request" class="#cl#">
					<td width="170">&nbsp;&nbsp;&nbsp;&nbsp;#ClaimRequest.ClaimCategoryDescription#:</td>					
					<td align="left">
					<table cellspacing="0" cellpadding="0">
							<tr>
							<cfif ClaimRequest.Code neq "TRM">
							<td width="40"><a href="javascript:show('#ClaimRequest.ClaimCategoryDescription#')">#Currency# </a>
							<td width="100" align="right"><a href="javascript:show('#ClaimRequest.ClaimCategoryDescription#')"><font color="0080FF">#numberFormat(RequestAmount,"_,_.__")#</font></a></td>
							<cfelse>
							<td width="40">#Currency#
							<td width="100" align="right">#numberFormat(RequestAmount,"_,_.__")#</td>
							</cfif>
							<td>&nbsp;</td>
							<td><cfif #PersonNo# neq "#ClaimTitle.PersonNo#"><b>#FirstName# #LastName#</cfif></td>		
							<td>&nbsp;</td>
							<td width="200">#Itinerary.Remarks#</td>													
							</tr>
						</table>
					</td>	
										
				</tr>
				
							
			</cfif>
							
			<cfif Code eq "DSA">
				<cfinclude template="ClaimRequestDSA.cfm">
			</cfif>
							
			<cfif Itinerary.recordcount gte "1" and #travel# eq "1">
			 	<cfinclude template="ClaimRequestTravel.cfm">
			</cfif>
							
			<cfif Claim.ActionStatus gte "2" and 
			     client.personNo neq claimTitle.PersonNo>
				
				<cfif pdf eq "0">				 
				<tr id="request"  class="#cl#"><td></td><td colspan="5">			
					<cfinclude template="ClaimRequestFunding.cfm">
				</td></tr>
				</cfif>
			
			</cfif>
			
					
		</cfoutput>
		
		<cfif advance eq "1" and pdf eq "0">
		
		<tr><td height="1" colspan="5" bgcolor="C0C0C0"></td></tr>
						
		<tr>
			
			<td colspan="5">
	
			<cfif Claim.ActionStatus eq "0">
			  <cfset cl = "regular">
			<cfelse>
			  <cfset cl = "regular">  
			</cfif>
	
			<table width="80%" class="#cl#" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver">			   
				<tr><td>
					<cfinclude template="ClaimAdvance.cfm">					
				</td></tr>
			</table>	

		    </td>
		</tr>
		
		</cfif>
								
		</table>
		</td></tr>
							
		</table>
				
		</td></tr>	
		
</table>	