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
Validation Rule :  I05
Name			:  Verify return trip
Steps			:  Three subvalidations
Date			:  05 July 2006
Last date		:  08 March 2008 (enhanced)
--->

<!--- 1. ensure there are three cities in TVRQ --->

<cfquery name="Header" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   count(*) as counted
 FROM     ClaimRequestItinerary
 WHERE    ClaimRequestId = '#URL.RequestId#' 
</cfquery>

<cfset continue = 1>

<cfif Header.counted lt "3">

		<cfset continue = 0>

		<cfquery name="Insert" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ClaimValidation
		       (ClaimId,
			    CalculationId,
				ValidationCode, 
				ValidationMemo) 
		VALUES ('#Claim.ClaimId#',
		        '#rowguid#',
		        '#Code#',
				'#Description#')
		</cfquery>

</cfif>

<!--- 2. ensure departure and return are the same --->

<cfif continue eq "1">

	<cfquery name="LineStart" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimRequestItinerary
	 WHERE    ClaimRequestId = '#URL.RequestId#'
	 ORDER BY DateDeparture, ItineraryLineNo  
	</cfquery>
	
	<cfquery name="LineEnd" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimRequestItinerary
	 WHERE    ClaimRequestId = '#URL.RequestId#'
	 ORDER BY DateReturn DESC, ItineraryLineNo DESC
	</cfquery>
	
	<cfquery name="Departure" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimRequestItinerary
	 WHERE    ClaimRequestId = '#URL.RequestId#'
	 AND      ClaimRequestLineNo = '#LineStart.ClaimRequestLineNo#'
	 ORDER BY DateDeparture, ItineraryLineNo
	</cfquery>
	
	<cfquery name="Return" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   TOP 1 *
	 FROM     ClaimRequestItinerary
	 WHERE    ClaimRequestId = '#URL.RequestId#'
	 AND      ClaimRequestLineNo = '#LineEnd.ClaimRequestLineNo#'
	 ORDER BY DateDeparture DESC, ItineraryLineNo DESC
	</cfquery>

	<cfif Departure.CountryCityId neq Return.CountryCityId>
	
		<cfset continue = 0>
	
		<cfquery name="Insert" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ClaimValidation
		       (ClaimId,
			    CalculationId,
				ValidationCode, 
				ValidationMemo) 
		VALUES ('#Claim.ClaimId#',
		        '#rowguid#',
		        '#Code#',
				'#Description#')
		</cfquery>
		
	 </cfif>	
	 
</cfif>

<!--- 3. ensure the itin has at least one return date entered --->

<cfif continue eq "1">

	<cfquery name="Check" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM    ClaimRequestItinerary
	WHERE   ClaimRequestId = '#Claim.ClaimRequestId#'
	AND     DateReturn is not NULL
	</cfquery>

	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ClaimValidation
		       (ClaimId,
			    CalculationId,
				ValidationCode, 
				ValidationMemo) 
		VALUES ('#Claim.ClaimId#',
		        '#rowguid#',
		        '#Code#',
				'#Description#')
		</cfquery>
		
	 </cfif>	
	 
</cfif>

<cfset continue = 1>	 