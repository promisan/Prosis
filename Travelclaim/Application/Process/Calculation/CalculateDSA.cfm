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
<!--- this calculation is for DSA only, it creates day records for each travel day, except for the return
date and it will determine the DSA code (Express) and elborate on the available DSA code as entered
in the detailed claim.

The templated used to clear and create records, the clearning has been disabled for detailed claims
as the info is generated and updated by the subsistencance detail screen, deletion would mean the option
to revoke what has been done through this screen, unlike for express claim

--->

<!--- calculation travel request source --->
<cfset reqi = "DSA">

<!--- indicator used for alternate rate/code --->
<cfset indi  = "P02">
<cfset dsa40 = "R04">

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#DSA">

<cfquery name="Parameter" 
datasource="appsTravelClaim">
	SELECT *  FROM Parameter 
</cfquery>

<cfparam name="clearDSA" default="0">

<cfif URL.Class eq "Express" or clearDSA eq "1">
	
	<cfquery name="Clear" 
	datasource="appsTravelClaim">
		DELETE FROM ClaimLineDSA
		WHERE  ClaimId = '#URL.ClaimId#' 
	</cfquery>

</cfif>

<!--- DSA calculation for person only if entitled by the request --->

<cfquery name="Person" 
datasource="appsTravelClaim">
	SELECT  DISTINCT R.PersonNo, C.ClaimRequestId
	FROM    Claim C, ClaimRequestLine R
	WHERE   C.ClaimRequestId = R.ClaimRequestId
	AND     C.ClaimId        = '#URL.ClaimId#' 
	AND     R.ClaimCategory  = '#reqi#'    
</cfquery>

<cfloop query = "Person">

	<!--- run cycle for DSA and HZA per person --->	
	<!--- Note : HZA only considered if city at 23:59 has pointer HazardPay = 1 --->	
		
	<!--- disabled HZA calculation <cfloop index="cat" list="DSA,HZA" delimiters=","> --->
	
	<cfloop index="cat" list="DSA" delimiters=",">
	
		<cfset calcstop = "0">
		<cfset calcEvent = "">
		   
	    <!--- define the number o days already paid to determine the rate pointer --->
		
		<cfquery name="DaysPaid" 
			  datasource="appsTravelClaim">
			  SELECT count(*)
			  FROM   ClaimLineDSA
	  		  WHERE  PersonNo      = '#PersonNo#'
			  AND    ClaimCategory = '#cat#'
			  AND    ClaimId IN (SELECT ClaimId 
			                     FROM   Claim 
								 WHERE  ClaimRequestId = '#Claim.ClaimRequestId#')
			  AND    Amount > '0'
		</cfquery>
		
		<cfset daysPaid = '#DaysPaid.recordcount#'>
		
		<!--- define the first travel date and define the last travel date of this claim --->
		<!--- regular claim take the itinerary, express claim, take the claim request line --->
		
		<cfset base = "100">
		
		<cfif URL.Class eq "Regular" or cat eq "HZA">
		
		    <!--- event DSA date range based on events --->
	
			<cfquery name="Dates" 
			datasource="appsTravelClaim">
				SELECT  MIN(E.ClaimTripDate) as Effective, 
				        MAX(E.ClaimTripDate) as Expiration
				FROM    ClaimEvent C,
				        ClaimEventTrip E, 
				        Ref_ClaimEvent R,
						ClaimEventPerson P
				WHERE   R.Code = E.EventCode
				AND     E.ClaimEventId = P.ClaimEventId
				AND     C.ClaimEventId = E.ClaimEventId
				AND     C.ClaimId = '#URL.ClaimId#'	
				AND     P.PersonNo = '#PersonNo#' 
			</cfquery>
			
			<!--- provision for test cases only, CAN BE REMOVED --->
			
			<cfif Dates.Effective eq "">
							
				<cfquery name="Dates" 
				datasource="appsTravelClaim">
					SELECT  MIN(E.ClaimTripDate) as Effective, 
					        MAX(E.ClaimTripDate) as Expiration
					FROM    ClaimEvent C,
					        ClaimEventTrip E, 
					        Ref_ClaimEvent R,
							ClaimEventPerson P
					WHERE   R.Code = E.EventCode
					AND     E.ClaimEventId = P.ClaimEventId
					AND     C.ClaimEventId = E.ClaimEventId
					AND     C.ClaimId = '#URL.ClaimId#'						
				</cfquery>			
			
			</cfif>
							
			<cfif Dates.Effective neq "">
				<cfset diff = DateDiff("d", "#Dates.Effective#", "#Dates.Expiration#")>
			<cfelse>
			    <cfset diff = "0">
			</cfif>	
									
			<cfif diff eq "0">		
						
				<!--- same day --->
								
				<cfquery name="Eligible" 
				datasource="appsTravelClaim">
				SELECT     R.*
				FROM       ClaimEventTripIndicator R INNER JOIN
                           ClaimEventTrip EVT ON R.ClaimEventId = EVT.ClaimEventId AND R.ClaimTripId = EVT.ClaimTripId INNER JOIN
                           ClaimEvent EV ON EVT.ClaimEventId = EV.ClaimEventId INNER JOIN
                           ClaimEventPerson P ON EV.ClaimEventId = P.ClaimEventId
                 WHERE     (R.IndicatorCode = '#dsa40#') 
				 AND       (R.IndicatorValue = '1') 
				 AND       (EV.ClaimId = '#URL.ClaimId#') 
				 AND       (P.PersonNo = '#PersonNo#')    
				</cfquery>
				
				<cfif eligible.recordcount gte "1">												
				    	<cfset diff = "1">	
						<cfset base = "40">						
				<cfelse>				
						<cfset diff = "1">	
						<cfset base = "0">											
				</cfif>	
									
			</cfif>
				
		<cfelse>
		
		   <!--- express claim DSA range --->
		   
		   <cfquery name="Dates" 
			datasource="appsTravelClaim">
				SELECT  MIN(D.DateEffective) as Effective, 
				        MAX(D.DateExpiration) as Expiration
				FROM    ClaimRequestLine L,
				        ClaimRequestDSA D
				WHERE   L.ClaimRequestId     = '#Claim.ClaimRequestId#'	
				AND     D.ClaimRequestId     = L.ClaimRequestId
				AND     D.ClaimRequestLineNo = L.ClaimRequestLineNo   
				AND     L.PersonNo           = '#PersonNo#' 
			</cfquery>
			
			<cfset diff = DateDiff("d", "#Dates.Effective#", "#Dates.Expiration+1#")>
		
		</cfif>
			
		<!--- initially populate table with dates for this person/category --->
				
		<cfloop index="day" from="0" to="#diff-1#"> 
					
			<cfset d = DateAdd("d", "#day#", "#Dates.Effective#")> 			
						
			<cftry>			
				
				<cfquery name="Event" 
				datasource="appsTravelClaim">
					INSERT INTO ClaimLineDSA
					       (ClaimId,CalendarDate,PersonNo,ClaimCategory)
					VALUES ('#URL.ClaimId#',#d#,'#PersonNo#','#cat#') 
				</cfquery>
				
				<cfcatch></cfcatch>			
							
			</cftry>
			
						
		</cfloop>
			
		<!--- now we are ready loop through the dates for this person and define the rate --->
		
		<cfquery name="Days" 
		datasource="appsTravelClaim">
		  SELECT *
		  FROM   ClaimLineDSA
		  WHERE  ClaimId       = '#URL.ClaimId#'
		  AND    PersonNo      = '#PersonNo#'  
		  AND    ClaimCategory = '#cat#'
		  ORDER BY CalendarDate
		</cfquery>
		
		<cfquery name="Percent" 
		 datasource="appsTravelClaim">
			SELECT  DISTINCT Ev.ClaimId, EP.PersonNo, R.LinePercentage
			FROM    ClaimEventPerson EP INNER JOIN
               		Ref_Claimant R ON EP.ClaimantType = R.Code INNER JOIN
		            ClaimEvent Ev ON EP.ClaimEventId = Ev.ClaimEventId
			WHERE   Ev.ClaimId = '#URL.ClaimId#' 
			AND     EP.PersonNo = '#PersonNo#'
		</cfquery>
		
		<cfset dayPaidDSA = "0">
		<cfset dayPaidMSA = "0">
		<cfset priorcity = "#Days.CountryCityId#">
		
		<cfloop query="Days">
			<cfif URL.Class eq "Regular" or cat eq "HZA">
			
				<cfquery name="Event" 
				datasource="appsTravelClaim">
					SELECT   TOP 1
					         E.EventDateEffective, 
					         E.EventDateExpiration,
				        	 ED.*
					FROM     ClaimEvent E, 
					         ClaimEventTrip ED,
							 ClaimEventPerson P
					WHERE    E.ClaimEventId    = ED.ClaimEventId					
					AND      E.ClaimEventId    = P.ClaimEventId
					AND      ClaimId           = '#URL.ClaimId#'	
					AND      P.PersonNo        = '#PersonNo#'
					AND      ED.ClaimTripDate <= '#CalendarDate#' 
					ORDER BY LocationDate DESC 
				</cfquery>
				
				<cfset loc  = Days.LocationCode>
				<cfset cit  = Event.countrycityId>
				
				<!--- 17/12 same day travel correction, take city upong arriving --->
				
				<cfif days.recordcount eq "1">
				
					<cfquery name="Event" 
					datasource="appsTravelClaim">
						SELECT   TOP 1
						         E.EventDateEffective, 
						         E.EventDateExpiration,
					        	 ED.*
						FROM     ClaimEvent E, 
						         ClaimEventTrip ED,
								 ClaimEventPerson P
						WHERE    E.ClaimEventId    = ED.ClaimEventId					
						AND      E.ClaimEventId    = P.ClaimEventId
						AND      ClaimId           = '#URL.ClaimId#'	
						AND      P.PersonNo        = '#PersonNo#'
						AND      ED.ClaimTripDate <= '#CalendarDate#' 
						AND      E.EventOrder = 1
						ORDER BY LocationDate DESC 
					</cfquery>
					
					<cfset cit  = Event.countrycityId>				
				
				</cfif>				
				
				<cfset perc = Percent.LinePercentage>
							
			    <!--- determine the event (=where is he/she) situation per calendar date
				from the event transactions --->
				  
				<!--- 28/9 : Hanno 
				disable older section as this is determined in Subsistence portion --->
																												
			<cfelse>
			
				<!--- express calculation based on requests --->
			
				<cfquery name="Event" 
				datasource="appsTravelClaim">
					SELECT TOP 1 
					       D.ServiceLocation as LocationCode, 
					       CL.LinePercentage,
						   0 as CountryCityId
					FROM   ClaimRequestLine L,
						   ClaimRequestDSA D,
						   Ref_Claimant Cl
					WHERE  L.ClaimRequestId     = '#Claim.ClaimRequestId#'	
					AND    L.PersonNo           = '#PersonNo#'
					AND    D.ClaimRequestId     = L.ClaimRequestId
				    AND    D.ClaimRequestLineNo = L.ClaimRequestLineNo
					AND    L.ClaimantType       = Cl.Code
					AND    (D.DateEffective    <= '#CalendarDate#') 
					AND    (D.DateExpiration   >= '#CalendarDate#') 
					AND    L.ClaimCategory      = '#reqi#' 
					ORDER BY D.DateEffective
				</cfquery>
				
				<cfset loc  = Event.locationCode>
				<cfset cit  = Event.countrycityId>
				<cfset perc = Event.LinePercentage>
									
			</cfif>		
						
			<cfif loc neq "">
			
				 <cfif url.class eq "Express">
				 
				    <cfquery name="City" 
					  datasource="appsTravelClaim">
				  	  	SELECT  TOP 1 *
						FROM    ClaimEventTrip
                        WHERE   ClaimEventId IN (SELECT ClaimEventId 
						                         FROM   ClaimEvent 
												 WHERE  ClaimId = '#Claim.ClaimId#')
						AND     ClaimTripDate <= '#CalendarDate#'
						ORDER BY LocationDate DESC 
				    </cfquery>		
					
					<cfif City.recordcount eq "0">
					
						 <cfquery name="City" 
						  datasource="appsTravelClaim">
					  	  	SELECT  TOP 1 *
							FROM    ClaimEventTrip
	                        WHERE   ClaimEventId IN (SELECT ClaimEventId 
							                         FROM   ClaimEvent 
													 WHERE  ClaimId = '#Claim.ClaimId#')
							ORDER BY LocationDate 
					    </cfquery>
					
					</cfif>
				 
				 	<cfset cit   = City.CountryCityId>
											 
				 </cfif>			    
																 					 
				 <cfif URL.Class eq "Regular" or cat eq "HZA">
				 
					  <!--- verify alternative rate was requested in subsistence section --->					  
									 
						 <cfquery name="Alternative" 
						  datasource="appsTravelClaim">
						  SELECT     *
						  FROM  ClaimLineDateIndicator
						  WHERE ClaimId         = '#URL.ClaimId#'
						  AND   PersonNo        = '#PersonNo#'
						  AND   CalendarDate    = '#CalendarDate#' 
						  AND   IndicatorCode   = '#indi#'
						  AND   IndicatorValue is not NULL
			 			 </cfquery>
																		 
					 	 <cfif Alternative.recordcount eq "1">
					           <cfset loc   = Alternative.IndicatorValue>						  
					     </cfif>
										
				 </cfif>
				 
				  <!--- define rate based on the period 30, 60, 90 --->
				  
				  <!--- determine rate --->				  
								  
				  <cfif cat eq "DSA">
				  
					  <cfif diff gt "30">
					  			  
						  <!--- determine DSA into MSA if indicator was set by user for this date --->
					  
						  <cfquery name="MSA" 
						  datasource="appsTravelClaim">
						  SELECT  R.Category
						  FROM    ClaimLineDateIndicator I,
				                  Ref_Indicator R 
						  WHERE   I.IndicatorCode = R.Code
				          AND     R.Category = 'MSA'
						  AND     I.ClaimId      = '#URL.ClaimId#'
						  AND     I.PersonNo     = '#PersonNo#'
						  AND     I.CalendarDate = '#CalendarDate#'
						 </cfquery>
						 
						 <cfif MSA.recordcount eq "1">
						     <cfset rte = "MSA">
							 <cfset dayPaidMSA = dayPaidMSA + 1>
							 <cfset dno = dayPaidMSA>
						 <cfelse>
						     <cfset rte = "DSA">
							 <cfset dayPaidDSA = dayPaidDSA + 1>
							  <cfif priorcity neq countryCityId>
							     <cfset dayPaidDSA = 2>									 				   
							 </cfif>	
							 <cfset dno = dayPaidDSA>
						 </cfif>
					 
					 <cfelse>
					 
						 <cfset rte = "DSA">
						 <cfset dayPaidDSA = dayPaidDSA + 1>
						 <cfif priorcity neq countryCityId>
						     <cfset dayPaidDSA = 2>									 				   
						 </cfif>						 
						 <cfset dno = dayPaidDSA>
					 
					 </cfif>
					 
				 <cfelseif cat eq "HZA">
				 
						  <cfquery name="CityCheck" 
						  datasource="appsTravelClaim">
							  SELECT  *
							  FROM    Ref_CountryCity
							  WHERE   CountryCityId = '#Event.CountryCityId#'
				          </cfquery>
						  
						  <cfif CityCheck.HazardPay eq "1">
						  			 
							 <cfset rte = "HZA">
							 <cfset dayPaidDSA = dayPaidDSA + 1>
							 <cfset dno = "1"> <!--- does not apply --->
							 							 
						  <cfelse>
						   
						     <cfset rte = "None">
							 <cfset dno = "1"> 
														 
							 <!--- not rate will be defined here and entry will be removed --->
						  	 							 
						  </cfif>	 				   
				 				 
				 </cfif> 
											  			
				 <cfquery name="Criteria" 
				  datasource="appsTravelClaim">
				  SELECT   TOP 1 *
				  FROM     Ref_ClaimRates
				  WHERE    ClaimCategory    = '#rte#' 
				    AND    ServiceLocation  = '#loc#'
					AND    DateEffective   <= '#CalendarDate#' 					
					AND    RatePointer     >= #dno# 
				  ORDER BY DateEffective DESC, RatePointer  
				 </cfquery>
				 				 			 		 
				 <cfif Criteria.recordcount gte "1">
				 			
					 <!--- only oif the last rate is not expired --->
					 			 
					 <cfif Criteria.DateExpiration eq "" 
					      or Criteria.DateExpiration gte CalendarDate>
					 
					 	<cfset dsaAmt     = Criteria.Amount>
					 	<cfset dsaAmtBase = Criteria.AmountBase>
						
					 <cfelse>
					 
					 	<cfset dsaAmt     = 0>
					 	<cfset dsaAmtBase = 0>
					 
					 </cfif>	
					
				 <cfelse> 
				 
					 <cfquery name="Criteria" 
					  datasource="appsTravelClaim">
					  SELECT   TOP 1 *
					  FROM     Ref_ClaimRates
					  WHERE    ClaimCategory    = '#rte#' 
					    AND    ServiceLocation  = '#loc#'
						AND    DateEffective   <= '#CalendarDate#' 
					  ORDER BY DateEffective DESC, RatePointer 
					 </cfquery>
					 
					 <cfif Criteria.recordcount eq "1">
										 
						 <cfset dsaAmt     = Criteria.Amount     * Parameter.DSARate999>
					 	 <cfset dsaAmtBase = Criteria.AmountBase * Parameter.DSARate999>
					 
					 <cfelse>
					 
						 <cfset dsaAmt     = 0>
					 	 <cfset dsaAmtBase = 0>
					 
					 </cfif>
				 			 
				 </cfif>				 			 
				 
				 <cfset pnt   = Criteria.RatePointer>								  
				 <cfset curr  = Criteria.Currency>
				 <cfset perc  = perc*(base/100)>
								 
				 <!--- person type --->
				 <cfset rte   = dsaAmt>
				 <cfset amt   = dsaAmt*(perc/100)>
				 <cfset amtP  = dsaAmt*(perc/100)>
				 <cfset amtB  = dsaAmtBase*(perc/100)>
				 								 			 			 			 		
				 <!--- ------------------------------------------ --->		   
				 <!--- a percentage correction for the indicators (acc/meal) type --->
				 
				 <cfif cat eq "DSA">
				 
					 <cfquery name="Correction" 
					  datasource="appsTravelClaim">
						  SELECT  sum(R.LinePercentage) as Percentage 
						  FROM    ClaimLineDateIndicator I,
				                  Ref_Indicator R 
						  WHERE   I.IndicatorCode = R.Code
				          AND     R.LinePercentage IS NOT NULL
						  AND     I.ClaimId      = '#URL.ClaimId#'
						  AND     I.PersonNo     = '#PersonNo#'
						  AND     I.CalendarDate = '#CalendarDate#'
					 </cfquery>
					 
					 <cfif Correction.recordcount eq "1" and Correction.Percentage neq "">
					 			 
					     <cfset perc  = perc*(1-Correction.Percentage/100)>
						 <cfset perc  = perc*(base/100)>
						 <cfif perc lt "0">
						    <cfset perc = 0>
						 </cfif>
						 <cfset amt   = amt*(perc/100)>
						 <cfset amtP  = amtP*(perc/100)>
						 <cfset amtB  = amtB*(perc/100)>			 	
					 </cfif>
				 
				 </cfif>
										 				 		 		 		 
				 <!--- NEW add only if date/personNo does not exist yet from other claim --->
						 
				 <cfif Curr eq Claim.PaymentCurrency>
				 
				 	 <cfif Claim.PaymentCurrency eq "USD">
					 
					 	<cfset currB  = 1>
					 
					 <cfelse>
				 
					 	 <cfquery name="Exchange" 
						  datasource="AppsLedger">
						  SELECT   TOP 1 *
						  FROM     CurrencyExchange
						  WHERE    Currency         = '#Claim.PaymentCurrency#' 
						    AND    EffectiveDate   <= '#Claim.ClaimDate#'
						  ORDER BY EffectiveDate DESC 
						 </cfquery>						 
					 
					 	 <cfset currB  = Exchange.ExchangeRate>
						 
					</cfif>	 
				 					 
					 <!--- no further adjustments made at this point --->
				 
				 <cfelseif Claim.PaymentCurrency eq "USD">
							 
				     <!--- take USD component --->
				     <cfset curr   = "USD">
					 <cfset amt    = amtB>
					 <cfset rte    = dsaAmtBase>
				 	 <cfset amtP   = amtB>
					 <cfset currB  = 1>
											 
				 <cfelse>
								 
					 <!--- take US base rate amount and make conversion to payment currency 
					 based on the claim date
					 --->
					 
					 <cfquery name="Exchange" 
					  datasource="AppsLedger">
					  SELECT   TOP 1 *
					  FROM     CurrencyExchange
					  WHERE    Currency         = '#Claim.PaymentCurrency#' 
					    AND    EffectiveDate   <= '#Claim.ClaimDate#'
					  ORDER BY EffectiveDate DESC 
					 </cfquery>
					
					 <cfset curr   = "USD">
					 <cfset rte    = dsaAmtBase>				 
					 <cfset amt    = amtB>
					 <cfif amtB neq "" and Exchange.ExchangeRate neq "">
						 <cfset amtP = amtB*Exchange.ExchangeRate>
					 </cfif>
					 <cfset currB  = Exchange.ExchangeRate>
				 			
				 </cfif>
				 
				 <cfif amt eq "0">
				    <!--- do not count as a DSA date and for the 30,60 range --->
				    <cfset dayPaidDSA = dayPaidDSA - 1>
				 </cfif>
				 
				 <cfquery name="Check" 
				  datasource="appsTravelClaim">
					  SELECT *
					  FROM  ClaimLineDSA
			  		  WHERE  CalendarDate  = '#CalendarDate#'
					  AND    PersonNo      = '#PersonNo#'
					  AND    ClaimCategory = '#cat#'
					  AND    Amount > '0'
				 </cfquery>
					
				 <!---			 
				 <cfif Check.recordcount eq "0">
				 --->
				 				 
					 <cfquery name="UpdateDSADetails" 
					  datasource="appsTravelClaim">
					  UPDATE ClaimLineDSA
			  		  SET    Currency      = '#curr#',  
					         LocationCode  = '#loc#',
							 CountryCityId = '#cit#',   
							 RatePointer   = '#pnt#',
					         Rate          = '#rte#',  
							 Percentage    = '#perc#',  
						     Amount        = '#amt#', 
							 AmountPayment = '#amtP#'
							 <cfif Line neq "99">
							 ,ExchangeRate  = '#CurrB#'
							 </cfif>
					  WHERE  ClaimId       = '#URL.ClaimId#'
					  AND    CalendarDate  = '#CalendarDate#'
					  AND    PersonNo      = '#PersonNo#'
					  AND    ClaimCategory = '#cat#'
					 </cfquery>
				
				 <!---					 
				 </cfif>
				 --->
				 
			<cfelse>
			
				<!--- initial setup only --->
				
				<cfif cit neq "">
					
				    <cfquery name="UpdateTemp" 
						  datasource="appsTravelClaim">
						  UPDATE ClaimLineDSA
				  		  SET    CountryCityId = '#cit#'
						  WHERE  ClaimId       = '#URL.ClaimId#'
						  AND    CalendarDate  = '#CalendarDate#' 
						  AND    PersonNo      = '#PersonNo#'
						  AND    ClaimCategory = '#cat#'
					</cfquery>
				
				</cfif>
							  
			</cfif>
			
			<cfset priorcity = countryCityId>
			
		</cfloop>	
		
	</cfloop>

</cfloop>	

<cfquery name="ClearEmptyLinesHZA" 
datasource="appsTravelClaim">
	DELETE FROM ClaimLineDSA
	WHERE  ClaimId = '#URL.ClaimId#'
	AND    ClaimCategory != 'DSA' 
	AND    AmountPayment < 0.01
</cfquery>

<!--- finishing 1 of 2 --->

<cfif Line neq "99">
	
	<!--- save the results per person as an accumulated claim line --->
	
	<cfloop query = "Person">
	
		<cfset line = line+1>
		
		<cfquery name="TotalDSA" 
		datasource="appsTravelClaim">
			SELECT Sum(AmountPayment) as AmountPayment 
			FROM   ClaimLineDSA
			WHERE  ClaimId  = '#URL.ClaimId#' 
			AND    PersonNo = '#PersonNo#' 
		</cfquery>
								
		 <!--- define US amount for funding --->
		 		
			 <cfif Claim.PaymentCurrency eq "USD">
				 
				 	 <cfset currB = 1>
					 <cfset amtT = TotalDSA.AmountPayment>
							 
			 <cfelse>
					 
					 <cfquery name="Exchange" 
					  datasource="AppsLedger">
					  SELECT   TOP 1 *
					  FROM     CurrencyExchange
					  WHERE    Currency         = '#Claim.PaymentCurrency#' 
					    AND    EffectiveDate   <= getDate()
					  ORDER BY EffectiveDate DESC
					 </cfquery>
					 
					 <cfif Exchange.recordcount eq "0">
					      <cfset currB = 1>
						  <cfset amtT = TotalDSA.AmountPayment>
					 <cfelse>
					     <cfset currB = Exchange.ExchangeRate>
						  <cfset amtT = TotalDSA.AmountPayment/Exchange.ExchangeRate>
					 </cfif>					
				 			
			</cfif>
			
			<cftry>
		
			<cfquery name="Insert" 
			  datasource="appsTravelClaim">
			  INSERT INTO ClaimLine
			  (ClaimId, 
			   ClaimLineNo, 
			   ClaimRequestId, 
			   PersonNo,
			   ExpenditureDate,
			   ClaimCategory,
			   Currency,
			   AmountClaim,
			   ExchangeRate,
			   AmountClaimBase,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
			  VALUES ('#URL.ClaimId#',
			          '#line#',
					  '#Claim.ClaimRequestId#',
					  '#PersonNo#',
					  '#DateFormat(now(), client.dateSQL)#',
					  'DSA',
					  '#Claim.PaymentCurrency#',
					  '#TotalDSA.AmountPayment#',
					  '#currB#',
					  '#amtT#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
	
	</cfloop>

</cfif>

<!--- finishing 2 of 2 --->

<!--- create a grouping field purely for the export file on the total amount per day --->

<cfquery name="TotalPerDay" 
	datasource="appsTravelClaim">
    SELECT    PersonNo,
	          CalendarDate,
			  LocationCode,
			  sum(AmountPayment) as AmountPayment
    FROM      ClaimLineDSA
	WHERE     ClaimId = '#Claim.ClaimId#'
	GROUP BY  PersonNo,CalendarDate,LocationCode
	ORDER BY  PersonNo, CalendarDate,LocationCode
</cfquery>
   
<cfset grp = 0>
<cfset amt = "">
<cfset loc = "">
   
<cfloop query="TotalPerDay">
   
	<cfif amt neq AmountPayment or loc neq LocationCode>
	    <cfset grp = grp+1>		
	</cfif>	
		
	<cfquery name="Update" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  ClaimLineDSA
		SET     Grouping = #grp#
		WHERE   ClaimId = '#URL.ClaimId#'
		AND     CalendarDate  = '#CalendarDate#' 
		AND     PersonNo      = '#PersonNo#'
    </cfquery>
	
	<cfset loc = LocationCode>
	<cfset amt = AmountPayment>			      
	
</cfloop>

