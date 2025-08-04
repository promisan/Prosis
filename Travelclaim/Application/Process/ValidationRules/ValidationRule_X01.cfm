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
Validation Rule :  X01
Name			:  verify if express claim can be shown
	   1. claim category : parameter table
	   2. no multi-lines for multi-traveller
	   3a. reasons to believe that a percentage is used : disabled
	   3b. one of the cities has a valid MSA rate.
	   4. same day travel
	   5. has one of more accomodation or melas
	   6  has more than one itinerary line
	   
Steps			:  Determine if traveller in the header <> Household memmber
Date			:  05 April 2006
Last date		:  05 June 2006
--->

<!--- condition 1 --->
	  
	  <cfquery name="Condition1" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    DISTINCT Req.ClaimRequestId
	    FROM      ClaimRequestLine Req,
		          Ref_ClaimCategory R
		WHERE     Req.ClaimCategory = R.Code
	    AND       R.DisableExpress = '1'
		AND       Req.ClaimRequestId = '#URL.RequestId#'
	    </cfquery>
		
		<cfif #condition1.recordcount# gt "0">
		   <cfset express = 0>
		
		</cfif>
		
<!--- condition 2 --->		
		
<cfif express eq "1">
		
		<cfquery name="Condition2" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    PersonNo, COUNT(*) AS Counted
		FROM      ClaimRequestLine
		WHERE     ClaimRequestId = '#URL.RequestId#'
		AND       ClaimCategory = 'DSA'
		GROUP BY  PersonNo
		ORDER BY Counted DESC
		</cfquery>
			
		<cfif #condition2.recordcount# gt "1" <!--- traveller --->
		   and #Condition2.Counted# gt "1"> <!--- multirecord --->

			 <cfset express = 0>
			
		</cfif>
		
</cfif>	

<!--- condition 3 --->	

<!--- DISABLED 	

<cfif express eq "1"> 
			
		<!--- Attention : only if currency is USD, 
		 as I found a record FRA110, obligated in CHF but the                  DSA currency in the table was = EURO, so only for USD --->
					
		<!--- disabled by Hanno as result of the new table ?? --->
					
		<!--- this query will only work for the first 30 or 60 days --->
					
		<cfquery name="Condition3" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     TOP 1 
		           REQ.ClaimRequestId, 
				   REQ.ClaimRequestLineNo,
		           REQ.PersonNo, 
				   REQ.Currency, 
				   DSA.RequestDays, 
				   DSA.RequestAmount, 
				   DSA.ServiceLocation, 
				   R.DocumentDate,
				   Rate.AmountBase AS Rate, 
				   Rate.DateEffective, 
				   Rate.RatePointer 
		FROM       ClaimRequest R,
		           ClaimRequestLine REQ, 
				   ClaimRequestDSA DSA,
		           Ref_ClaimRates Rate
		WHERE      R.ClaimRequestId       = '#URL.RequestId#'	
		AND        REQ.ClaimCategory      = 'DSA'	   
		AND        REQ.ClaimRequestId     = DSA.ClaimRequestId
		AND        Req.ClaimRequestLineNo = DSA.ClaimRequestLineNo
		AND        REQ.ClaimCategory      = Rate.ClaimCategory 
		AND        DSA.ServiceLocation    = Rate.ServiceLocation
		AND        REQ.ClaimRequestId     = R.ClaimRequestId 
		AND        Rate.DateEffective    <= R.DocumentDate
		AND        Rate.RatePointer      >= RequestDays
		AND        REQ.Currency           = 'USD'
		ORDER BY   Rate.DateEffective DESC, RatePointer 
		</cfquery>
		
		<cfif #Condition3.recordcount# gte "1">
		
		<cfloop query="Condition3">
		
			<!--- determine acc/meals correction --->
			
			<cfquery name="Deduct" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(R.LinePercentage) AS Percentage
			FROM     ClaimRequestLineIndicator I INNER JOIN
					 Ref_Indicator R ON I.IndicatorCode = R.Code
			WHERE    I.ClaimRequestId = '#URL.RequestId#'
			AND      I.ClaimRequestLineNo = '#ClaimRequestLineNo#' 
			</cfquery>
			
			<cfif #Deduct.Percentage# neq "">
			   <cfset perc = 100-#Deduct.Percentage#>
			<cfelse>
			   <cfset perc = 100>
			</cfif>
			
			<cfset calc = #RequestDays#*#Rate#*(#perc#/100)>
			<cfif #calc# neq #RequestAmount#>
				<cfset express = 0>
			
				<cfquery name="Insert" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ClaimValidation
			       (ClaimId,
					ValidationCode, 
					ValidationMemo) 
				VALUES ('#Claim.ClaimId#',
		    		'X01',
					'Reasons to believe an ad-hoc rate was used')
				</cfquery>
				
			</cfif>
					
		</cfloop>
				
		</cfif>			
		
		<!---
		<cfquery name="Condition3" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		</cfquery>
		
		<cfif #condition2.recordcount# gt "1" and #Condition2.Counted# gt "1">
		 <cfset express = 0>
		</cfif>
		
		--->
				
</cfif>

--->

<!--- condition deprecated 

<cfif express eq "1"> 

	<cfquery name="Condition4" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
	SELECT   *
	FROM     ClaimRequestItinerary Itin INNER JOIN
             Ref_CountryCity City ON Itin.CountryCityId = City.CountryCityId INNER JOIN
             Ref_CountryCityLocation Loc ON City.CountryCityId = Loc.CountryCityId AND Itin.DateDeparture > Loc.DateEffective INNER JOIN
             Ref_ClaimRates Rate ON Loc.DateEffective = Rate.DateEffective
	WHERE  	 ClaimRequestId = '#URL.RequestId#'	
	AND      Rate.ClaimCategory = 'MSA' 
	AND      (Rate.DateExpiration IS NULL OR Rate.DateExpiration > Itin.DateDeparture)
	</cfquery>
	
	<cfif condition4.recordcount gt "0">
		<cfset express = 0>
		
	</cfif>
		
</cfif>		

--->		

<!--- condition 4 : same day travel --->		

<cfif express eq "1"> 

	<cfquery name="Condition5" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     ClaimRequestItinerary Itin 
			WHERE  	 ClaimRequestId = '#URL.RequestId#'	
	</cfquery>
	
	<cfif condition5.datedeparture eq condition5.datereturn>
		<cfset express = 0>
		
	</cfif>
		
</cfif>		

<!--- condition deprecated  : 1 DSA day only 

<cfif express eq "1"> 

	<cfquery name="Condition6" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   sum(Requestdays) as Total
			FROM     ClaimRequestDSA 
			WHERE  	 ClaimRequestId = '#URL.RequestId#'	
	</cfquery>
	
	<cfif condition6.total lte "1">
		<cfset express = 0>
		
	</cfif>
		
</cfif>		

--->	

<!--- condition 5 --->
	  
	  <cfquery name="Condition5" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      ClaimRequestLineIndicator
		WHERE     ClaimRequestId = '#URL.RequestId#'
	    </cfquery>
		
		<cfif condition5.recordcount gt "0">
		   <cfset express = 0>		
		</cfif>	
		
<!--- condition 6 --->
	  
	  <cfquery name="Condition6" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  ClaimCategory
		FROM      ClaimRequestLine
		WHERE     ClaimRequestId = '#URL.RequestId#' 
		AND       ClaimCategory IN ('ITIN', 'SFT', 'NOC')		
	    </cfquery>
		
		<cfif condition6.recordcount gt "1">
		   <cfset express = 0>		
		</cfif>			