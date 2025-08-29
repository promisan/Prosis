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
<!--- define travel mode air, see, land, currently air default --->

<cfset EventCode = "Air">

<!--- verify existing entries in table, if null generate records --->

	<cfquery name="Event" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   ClaimEvent 
    WHERE  ClaimId = '#URL.ClaimId#' 
	</cfquery>
	
	<!--- provision for NULL return dates --->
				
	<cfquery name="Update" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  ClaimRequestItinerary
	SET     DateReturn     = DateDeparture
	WHERE   ClaimRequestId = '#Claim.ClaimRequestId#'
	AND     DateReturn is NULL
	</cfquery>
			
	<!--- end of provision --->
		
	<cfquery name="Transportation" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   Ref_ClaimEvent 
    WHERE  PointerDefault = 1 
	</cfquery>
	
	<cfset refmenu = "#Event.recordcount#">
	
	<cfif Event.recordcount eq "0">
	
		<cfquery name="TripLine" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT min(C.ClaimRequestLineNo) as ClaimRequestLineNo, 
			       C.ClaimCategory, 
				   R.Description, 
				   I.DateDeparture
		    FROM   ClaimRequestItinerary I, 
			       ClaimRequestLine C, 
				   Ref_ClaimCategory R
		    WHERE  I.ClaimRequestId     = '#Claim.ClaimRequestId#' 
			AND    C.ClaimRequestId     = I.ClaimRequestId
			AND    C.ClaimRequestLineNo = I.ClaimRequestLineNo
			AND    C.ClaimCategory      = R.Code
			GROUP BY C.ClaimCategory, R.Description, I.DateDeparture
			ORDER BY DateDeparture 
			</cfquery>
		
		<cfloop query="TripLine">
		
		    <cfset reqline = ClaimRequestLineNo>
			<cfset memo    = Description>
			<cfset clmcat  = ClaimCategory>
			<cfset clmdte  = DateDeparture>
					   	
			<cfquery name="Lines" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT count(*) as Total
		    FROM   ClaimRequestItinerary
		    WHERE  ClaimRequestId = '#Claim.ClaimRequestId#' 
			AND    ClaimRequestLineNo = '#reqLine#' 
			</cfquery>
			
			<cfif Lines.total lte "1">
			
				<cf_message message="Sorry, but the requested itinerary is not complete (city table)." return="No">
				<cfabort>
			
			</cfif>
			
			<cfset ln = "1">
						
		    <cfloop index="itn" from="1" to="#Lines.Total-1#">
					
				<cfquery name="Itinerary" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 2 *
			    FROM     ClaimRequestItinerary
			    WHERE    ClaimRequestId = '#Claim.ClaimRequestId#' 
				AND      ClaimRequestLineNo = '#reqLine#'
				AND      ItineraryLineNo >= '#ln#' 
				ORDER BY ClaimRequestLineNo, ItineraryLineNo 
				</cfquery>
						
				<cfif Itinerary.recordcount eq "2">
								
					   <!--- generate event --->					   			   
									 				  
					  <cfif ln eq "1">
					  
						  <cfset eff = "#Itinerary.DateDeparture#">
						  
					  <cfelse>
					  								  				  
						  <!--- an 21/7/2007 improved method to define 
						  the initial dates --->
						  
						  <cfquery name="City" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   TOP 1 *
						    FROM     ClaimRequestItinerary
						    WHERE    ClaimRequestId = '#Claim.ClaimRequestId#' 
							AND      ClaimRequestLineNo = '#reqLine#'
							AND      ItineraryLineNo >= '#ln#' 
							AND      ItineraryLineNo <= '#ln+1#'
							ORDER BY ItineraryLineNo DESC 
							</cfquery>
							
							<!--- determine the best possible date for the trip from DSA table --->
							
							<cfquery name="PossibleDate" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    Itn.ClaimRequestId, 
							          ReqDSA.DateEffective, 
									  City.LocationCity, 
									  City.LocationCountry, 
									  Loc.LocationCode, 
									  City.CountryCityId
							FROM      Ref_PayrollLocation Loc INNER JOIN
				                      ClaimRequestItinerary Itn INNER JOIN
                      				  Ref_CountryCity City ON Itn.CountryCityId = City.CountryCityId ON Loc.LocationCountry = City.LocationCountry INNER JOIN
			                          ClaimRequestDSA ReqDSA ON Loc.LocationCode = ReqDSA.ServiceLocation AND Itn.ClaimRequestId = ReqDSA.ClaimRequestId
							WHERE     Itn.ClaimRequestId     = '#Claim.ClaimRequestId#' 
							AND       Itn.ClaimRequestLineNo = '#reqline#' 
							AND       Itn.ItineraryLineNo   >= '#ln#' 
							AND       Itn.CountryCityId      = '#city.countrycityid#'
							AND       ReqDSA.DateEffective > #effd#												
							</cfquery>
							
							<cfif Possibledate.recordcount gte "1">						 					
							   <cfset eff = "#PossibleDate.DateEffective#">																
							<cfelse>							
							   <!--- default date --->						  
						 	   <cfset eff = "#Itinerary.DateReturn#">	
							</cfif>												
					  		  				  
					  </cfif> 
					  
					 <cfset dateValue = "">
					 <CF_DateConvert Value="#DateFormat(eff,CLIENT.DateFormatShow)#">
				     <cfset effd = dateValue>						  
					  					  
					 <cfset effdate = eff>
					 				 				  
					 <cf_assignId>
					 <cfset eventid = RowGuid>
					  
					 <cftransaction>					  
					 						
						<!--- exclusion for same day travel --->
						
						<cfif tripline.recordcount lte "2">
						
							 <cfset nos = itn> 	
						
						<cfelse>
						
							<cfquery name="Last" 
							  datasource="appsTravelClaim" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  SELECT *
							  FROM  ClaimEvent
							  WHERE ClaimId            = '#URL.claimid#'
							  AND   EventDateEffective <= '#eff#'	
							  ORDER BY EventOrder DESC				
							</cfquery>	 
							
							<cfif last.recordcount eq "0">
							  <cfset nos = itn> 						  
							<cfelse>
							  <cfset nos = last.EventOrder>				
							</cfif> 
						
						</cfif>
						
					   <!--- check event if it was not already recorded --->
					   
					   <cfquery name="CheckEvent" 
						  datasource="appsTravelClaim" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  SELECT * FROM ClaimEvent
						  WHERE ClaimId = '#URL.ClaimId#'
						  AND   EventDateEffective = '#eff#'	
						  AND   EventOrder = '#nos#'					
					   </cfquery>	  
					   
					   <cfif CheckEvent.recordcount eq "0">
						  									  		
						  <cfquery name="InsertEvent" 
							  datasource="appsTravelClaim" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  INSERT INTO  ClaimEvent
							      (ClaimEventId,
								   ClaimId,
								   EventDateEffective, 
								   EventDateExpiration,
								   EventMemo,
								   EventOrder,
								   RecordReference,
								   OfficerUserId,
								   OfficerLastName,
								   OfficerFirstName)
							  VALUES ('#eventid#',
							          '#URL.claimid#',
							          '#eff#',
									  '#eff#',
									  '#memo#',
									  '#nos#',
									  '#claimrequestlineNo#',
							          '#SESSION.acc#', 
									  '#SESSION.last#',
									  '#SESSION.first#')
							</cfquery>	  

							<cfquery name="EventPerson" 
							 datasource="appsTravelClaim" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT DISTINCT P.*, C.ClaimantType 
								 FROM   ClaimRequestLine C,  stPerson P 
								 WHERE  ClaimRequestId  = '#Claim.ClaimRequestId#'
								   AND  C.ClaimCategory = '#clmcat#'
								   AND  C.ClaimRequestId IN (SELECT ClaimRequestId 
								                           FROM   ClaimRequestItinerary 
														   WHERE  ClaimRequestId = '#Claim.ClaimRequestId#'
														   AND    DateDeparture = '#clmdte#')
								   AND  C.PersonNo      = P.PersonNo
							</cfquery>
			
							<cfloop query="EventPerson">
							 	
								  <cfquery name="InsertEvent" 
							 	  datasource="appsTravelClaim" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  INSERT INTO  ClaimEventPerson
										      (ClaimEventId, 
											   PersonNo, 
											   ClaimantType)
								  VALUES ('#eventid#','#PersonNo#','#ClaimantType#')
								  </cfquery>	  
							
							</cfloop>
						
						    <cfloop query="Itinerary">
							
								<cfquery name="CityLocation" 
									datasource="appsTravelClaim" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT *
									FROM   Ref_CountryCityLocation L
									WHERE  L.CountryCityId = '#CountryCityId#' 
									ORDER BY LocationDefault DESC												
								</cfquery> 
								
								<cfquery name="City" 
									datasource="appsTravelClaim" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT *
									FROM   Ref_CountryCity L
									WHERE  L.CountryCityId = '#CountryCityId#' 																			
								</cfquery> 
							
								<cfset loc = "#CityLocation.LocationCode#">
																							 							
								<cfset effdate = DateAdd("h", "4","#effdate#")> 
								
								<!--- provision to identify a better effdate based on 
								DSA records --->
															
								<cfif currentRow eq "1">
								  <cfset mode = "Departure">
								<cfelse>
								  <cfset mode = "Arrival">
								</cfif> 
								
								<!--- check --->
								
							
							 	<cfquery name="InsertRecord" 
								  datasource="appsTravelClaim" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  INSERT INTO  ClaimEventTrip
								      (ClaimEventId,
									   EventCode,
									   ClaimTripMode,
									   ClaimTripDate,
									   CountryCityId,
									   LocationDate, 
									   LocationCountry,
									   <!--- disabled does not belong here 
									   <cfif loc neq "">
									   LocationCode,
									   </cfif>
									   --->
									   LocationCity)
								  VALUES ('#eventid#',
								          '#Transportation.Code#',
								          '#mode#',
										  '#DateFormat(eff, client.dateSQL)#',
										  '#CountryCityId#',
								          #effdate#, 
										  '#City.LocationCountry#',
										  <!--- disabled does not belong at this moment yet
										  <cfif loc neq "">
										  '#loc#',
										  </cfif>
										  --->
										  rtrim('#City.LocationCity#')
										  )
								  </cfquery>	
							  
							      <cfset ln = "#ItineraryLineNo#">
								 								
						     </cfloop>
							 
						 </cfif>	
						 
						 </cftransaction>
				
				</cfif>
				
			</cfloop>	
			
		</cfloop>		
					
	</cfif>
	