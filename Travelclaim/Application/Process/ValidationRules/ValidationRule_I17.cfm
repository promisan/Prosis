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

<!--- 
Validation Rule :  I17
Name			:  Verify return trip to same city
Steps			:  Compare first and last city id from entered itinerary
Date			:  05 November 2007
--->

<cfif claim.claimAsIs eq "0">


	<cfquery name="LineStart" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimEvent
	 WHERE    ClaimId = '#Claim.ClaimId#'
	 ORDER BY EventOrder
	</cfquery>
	
	<cfquery name="LineEnd" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimEvent
	 WHERE    ClaimId = '#Claim.ClaimId#'
	 ORDER BY EventOrder DESC
	</cfquery>
	
	<cfquery name="Start" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimEvent Ev INNER JOIN
	          ClaimEventTrip TR ON Ev.ClaimEventId = TR.ClaimEventId
	 WHERE    Ev.ClaimId = '#Claim.ClaimId#' 
	 AND      Ev.EventOrder = '#LineStart.EventOrder#' 
	 ORDER BY TR.LocationDate 
	</cfquery>
	
	<cfquery name="End" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimEvent Ev INNER JOIN
	          ClaimEventTrip TR ON Ev.ClaimEventId = TR.ClaimEventId
	 WHERE    Ev.ClaimId = '#Claim.ClaimId#'
	 AND      Ev.EventOrder = '#LineEnd.EventOrder#' 
	 ORDER BY TR.LocationDate DESC 
	</cfquery>
	
	<cfif Start.CountryCityId neq End.CountryCityId>
				
		 <cfset submission = "0">
				 
		 <tr><td valign="top" bgcolor="C0C0C0"></td></tr>
				 <tr>
				  <td valign="top" bgcolor="FDDFDB">
				  <table width="94%" cellspacing="2" cellpadding="2" align="center">
				  <tr><td valign="top" height="30">
				      <font color="FF0000"><b>Problem</b></font>
				      <br>
					    <cfoutput>#MessagePerson#</cfoutput>
					  <br>							  
					  </td></tr>
				  </table>
				  </td>	  
		</tr>   
			
	</cfif>

</cfif>
