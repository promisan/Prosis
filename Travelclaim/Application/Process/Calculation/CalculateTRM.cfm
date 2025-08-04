<!--
    Copyright Â© 2025 Promisan

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

<!--- Prosis template framework --->

<cfsilent>
<proUsr>fodnyhv1</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>Revisited this document on friday 15/8/2008 morning with Francois for the TRM logic re:pt59. </proDes>
<proCom></proCom>
<proCM></proCM>
<proInfo></proInfo>
</cfsilent>

<!--- FDT 28/10/2008 - Incorrect calculation of 6 hours when legs with no TRM (PMV/Taxi) in between --->

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#DSA">

<!--- check cities for authorised itinerary and check if stopover = 1 --->

<cfquery name="Parameter" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   Parameter 
</cfquery>

<cfquery name="DeleteIndicator" 
	datasource="appsTravelClaim"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	DELETE FROM ClaimEventIndicator
	WHERE IndicatorCode = 'TRM'
	AND   ClaimEventId IN (SELECT ClaimEventId 
                           FROM ClaimEvent 
			  			   WHERE ClaimId = '#URL.ClaimId#')	
	
</cfquery>

<cfquery name="EventList" 
	datasource="appsTravelClaim"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	SELECT *
	FROM   ClaimEvent C
	WHERE  C.ClaimId = '#URL.ClaimId#'
</cfquery>		
	
<cfset evid = "#EventList.ClaimEventId#">

<!--- 
ALERT : determine if TRM should be calculated if not obligated at all
Pending feedback francois and flor 29/04/2006 
--->

<cfquery name="InsertIndicator" 
	datasource="appsTravelClaim"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	INSERT INTO ClaimEventIndicator 
		(ClaimEventId, 
		 IndicatorCode, 
		 IndicatorValue,
		 OfficerUserId, 
		 OfficerLastName, 
		 OfficerFirstName)
	SELECT DISTINCT 
	       '#evid#',
	       'TRM',
		   '1',
		   '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#'
	FROM   ClaimRequestLine C,
	       Ref_ClaimCategory R
	WHERE  C.ClaimCategory = R.Code
        <!---  
	AND    R.ClaimAmount = 1 
        --->
	AND    C.ClaimRequestId = '#Claim.ClaimRequestId#' 
	<!--- disabled 28/04
	AND    R.DefaultIndicatorCode IS NOT NULL   
	--->
</cfquery>

<!--- special provision to check TRM for regular TVRQ legs --->

<cfquery name="Review" 
	datasource="appsTravelClaim"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   T.ClaimEventId, 
	         T.ClaimTripId,
	         T.CountryCityId, 
			 T.ClaimTripDate,
			 T.ClaimTripStop,
			 CP.ClaimantType, 
			 T.ClaimTripDate,			
			 CP.PersonNo,
			 T.LocationDate,
			 T.ClaimTripMode, 
			 T.LocationCity
	FROM     ClaimEventTrip T,
	         ClaimEventPerson CP
	WHERE    T.ClaimEventId = CP.ClaimEventId
	<!--- check now all trips now for exclusion 
	AND      T.ClaimTripStop = 0
	--->
	AND 	 T.ClaimEventId IN (SELECT ClaimEventId 
	                              FROM ClaimEvent 
							     WHERE ClaimId = '#URL.ClaimId#')	
	<!--- select only events that require TRM payment, PMV does not quality for TRM etc. --->		
	<!--- FDT 28/10/2008 - Incorrect calculation of 6 hours when legs with no TRM (PMV/Taxi) in between 
	      This Review Query is used only to prepare for the loop which Exclude departure/arrival cities from terminal 
		  for 6 hours rules and AL rule, there is no risk in removing this condition on EventCode
		  The legs with PMV and Taxi no more included here but MUST remain excluded of similar query SelectCities 
		  used for calculation 
	AND      T.EventCode IN (SELECT Code 
	                          FROM Ref_ClaimEvent 
							  WHERE pointerTerminal = 1)				
	---->   		  			  
	ORDER BY PersonNo, LocationDate, CountryCityId	 	 					  
</cfquery>

<!--- FDT 7/08/08: Building a temporary structure from ClaimLineDSA with each day of the overall travel 
We suppose that there is always 1 and 1 only 1 "DSA" record in the table for each day of the travel 
until the last departure. 
Note that there is no record for the last day of travel if after last departure ! 
We could also have build the intermediate table from "scratch" 
(it is simply a table with 1 record by date for all days of the travel) 
--->

<!--- FDT 7/08/08: The AllDays Structure is created as a SQL table
--->

<!--- Hanno 15/08/08: We render the ALIndicator field of the "AllDays" structure 
using the ClaimLineDateIndicator table where the "interface" inclues a record with "P01" 
if the day is entered as an annual leave / personal day
--->

<cfset FileNo = round(Rand()*10)>
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Alldays#FileNo#">
 
<cfquery name="AllDays" 
		datasource="appsTravelClaim"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT	ClaimId, 
		        CalendarDate, 
				PersonNo, 
				ClaimCategory, 
				CountryCityId, 
				LocationCode, 
				Grouping,
				(SELECT count(DISTINCT IndicatorCode) 
				 FROM   ClaimLineDateIndicator E 
				 WHERE  ClaimLineDSA.ClaimId      = E.ClaimId
				 AND 	ClaimLineDSA.PersonNo     = E.PersonNo
				 AND 	ClaimLineDSA.CalendarDate = E.CalendarDate
				 AND 	IndicatorCode = 'P01') as ALIndicator		
		INTO   userQuery.dbo.#SESSION.acc#Alldays#FileNo# 
		FROM 	ClaimLineDSA 
		WHERE   ClaimId = '#URL.ClaimId#' 
		 AND 	ClaimCategory = 'DSA'
</cfquery>

<!--- check if annual leave is taken during this trip Set the Al Indicator  --->

<cfquery name="Check" 
	datasource="appsQuery"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	*
		FROM    #SESSION.acc#Alldays#FileNo# 
		WHERE   ALIndicator = '1'		
</cfquery>

<cfif Check.recordcount eq "0">

	<!--- indicator if annual leave has NOT been taken --->	
	<cfset al = 0>
	
<cfelse>

	<!--- indicator if annual leave has been taken --->	
	<cfset al = 1>	

</cfif>


<!--- FDT 7/08/08: NEW CODE TO DETERMINE IF TERMINAL SHOULD BE PAID 
FOR EACH DEPARTURE AND EACH ARRIVAL OF THE ITINERARY 
INPUT: 
- The "Review" Structure (as in the Hanno's code)
- The "AllDays" Structure (SQL table) used only to know which day are Annual Leave 
OUTPUT:
- A "list" called EXC of the ClaimTripId where no TRM should be paid.
(as in the Hanno's code)
RULES: 
There are 2 cases where Terminal (both on Arrival and Departure) should be EXCLUDED: 
a)	Intermediate Stop of less than 6 hours 
	(including Overnight Stay - as per Accounts clarification).
b)	Staff on Annual Leave for the whole duration of the Intermediate Stop 
LOGIC: We keep the loop on Review by:
a) Person [previous code was not really consistent on this]
b) LocationDate
c) CountryCityId [I still don't understand this last one - FDT]

HANNO : This was added very recently as part of the TRM changes. Essentially it does not harm as the location date
is unique is in combination with the city id. 


--->

<!--- Initialization of variables --->

<!--- List of ClaimTripId Excluded from Terminal payment --->
<cfset exc = "">
<!--- Arrival date/time in the Stop/City --->
<cfset ArrDate = "">    
<!--- Arrival date/time in the Stop/City (only the date not the time) --->
<cfset ArrDay = "">  
<!--- Last Day in the Stop/City (in most cases day before departure day) --->
<cfset LastStopDay = "">  
<!--- Id of the “Trip” representing the arrival in the city --->
<cfset  TripIdArr = "">  
<!--- 1 if the current stop is an intermediate stop --->
<cfset  TripStop = 0>  

<!--- LOOP on all the "trips" (1 trip is a departure or an an Arrival)
	by Person (traveller), Location Date/time (sorted from oldest) and City Id (no clue why) --->
	
<cfoutput query="Review" group="PersonNo">

<cfoutput group="LocationDate">

<cfoutput>
					
	<!---  If the Trip is an Arrival --->
	<Cfif ClaimTripMode eq "Arrival">
	
		<!---  we initialize the variables for the stop based on Review (ClaimEventTrip) --->
		<cfset 	ArrDate 	= LocationDate>   
		<cfset 	ArrDay	 	= ClaimTripDate>    
		<cfset  TripIdArr 	= ClaimTripId>  
		<cfset  TripStop 	= ClaimTripStop>  

	<!---  If the Trip is a Departure --->
	
	<cfelse>	
	
		<!---  If the Trip is not the First Departure --->
		
		<cfif ArrDate neq "">  

			<!--- WE APPLY THE 6 HOURS RULE --->
			<!---  If it is an intermediate stop, we test the Duration of the Stop and if less than 6 hours  
				 We compare Review.LocationDate with the "locationDate" of the arrival storred in ArrDate 
				 Since for historical reasons, 30s were added to the arrival dates, we substract them before comparing.
			--->
			
			<Cfif  TripStop gte 1 
			       and datediff("h", DateAdd("s", "-30", ArrDate), LocationDate) lt Parameter.StopoverHours>
			
				<!---  we exclude the stop (both arrival and departure) from Terminal payments --->
				<cfif exc eq "">
				     <cfset exc = "'#claimtripid#'">
				<cfelse>
				     <cfset exc = "#exc#,'#claimtripid#'">
				</cfif>
				<cfif exc eq "">
				     <cfset exc = "'#TripIdArr#'">
				<cfelse>
				     <cfset exc = "#exc#,'#TripIdArr#'">
				</cfif>
				
			</cfif>

			<!--- THE ANNUAL LEAVE RULE --->
			<!--- We test if all days in the Stop are Annual Leave days--->
			
			<!--- There were discussion on limiting this policy to "intermediate stops" but it is difficult to detect all of them: 
			- #TripStop# (ClaimEventTrip.ClaimTripStop) = 1 detects "intermediate stops" added by "ADD connection/stopover#"
			- But there could be also cases where the "arrival" and "departure" cities defaulted from the Request are modified to "leave" stops
			In these cases, it may be the city entered as Stopover which is the Official Authorized Step !!
			So we apply the rule for all stops
			<Cfif  #TripStop# gte 1 >
			--->

				<!--- FDT 08/08/2007: We Test AL days Only if Traveller stays at least 1 day in the stop --->
				<Cfif  datediff("d", ArrDay, ClaimTripDate) gte 1 > 
				
				<!--- We Initialize LastStopDay - Last Day in the Stop to consider for Annual Leave Purpose 
				We consider that the last day in the stop to consider is the day before 
				the departure date (in line with the DSA policies and TCP day grouping in subsistence screen).
				--->
					<cfset 	LastStopDay	= ClaimTripDate - 1 >    
													
					<!--- We look in ALLDAYS to test 
                      if all days from ArrDate and LastStopDay included are Annual Leave days but only if we do know
					  annual leave has been checked for some days  --->
					  <!--- we test if all the days of the stop are AL only if there is at least 1 AL day in the claim 
					  To be on the safer side , we should also test for whether the claim is express , if it is express
					  then the possiblity of Annual days does not come in effect so we should never worry about 
					  Annual leaves in the case of express -presently that is not done -can be implemented JG3-Francois
					  --->
                      <cfif al eq "1">
				
						<cfquery name="CheckALDays" 
						datasource="appsQuery"  
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	* 
							FROM 	#SESSION.acc#Alldays#FileNo#
							WHERE  	ClaimId   = '#URL.ClaimId#'
		 					AND 	PersonNo  = '#PersonNo#'
		 					AND 	CalendarDate >= '#dateformat(ArrDay,client.dateSQL)#'
		 					AND 	CalendarDate <= '#dateformat(LastStopDay,client.dateSQL)#'
							AND		ALIndicator = 0
						</cfquery>
														
						<!---  if there are no regular working days in the defined period at all --->
						
						<cfif CheckALDays.recordcount eq 0 > 
							<!---  we exclude the stop (both arrival and departure) from Terminal payments --->
							<cfif exc eq "">
					    		 <cfset exc = "'#claimtripid#'">
							<cfelse>
					    		 <cfset exc = "#exc#,'#claimtripid#'">
							</cfif>
							<cfif exc eq "">
					    		 <cfset exc = "'#TripIdArr#'">
							<cfelse>
					 		 <cfset exc = "#exc#,'#TripIdArr#'">
							</cfif>
						</cfif>
						<!--- end of if #CheckALDays.Recordcount# eq 0 --->
					
					</cfif>
					
					
				</cfif>								
				<!--- end of if #LastStopDate# gte #ArrDate#  --->
			
			<!---	
			</cfif>  end of if #TripStop# gte 1 commented since we now test all stops
			--->
			
		  </cfif>
		  <!--- end of if #ArrDate# neq ""  --->
	  </cfif>
	  <!--- end of if #ClaimTripMode# eq "Arrival"  --->
  
</cfoutput>		

</cfoutput>	
</cfoutput>

<!--- Dropping Alldays Temporary Table --->

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Alldays#FileNo#">

<!---  FDT 7/08/08: END OF THE CODE ADDED ---> 

<!--- determine TRM --->

<cfquery name="SelectCities" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	SELECT   T.ClaimEventId, 
	         T.ClaimTripId,
	         T.CountryCityId, 
			 T.ClaimTripDate,
			 CP.ClaimantType, 
			 T.ClaimTripDate,
			 R.LocationCity,
			 CP.PersonNo
	FROM     ClaimEventTrip T,
	         ClaimEventPerson CP,
			 Ref_CountryCity R
	WHERE    T.ClaimEventId = CP.ClaimEventId
	AND      T.CountryCityId = R.CountryCityId 
	AND 	 T.ClaimEventId IN (SELECT ClaimEventId 
	                          FROM ClaimEvent 
							  WHERE ClaimId = '#URL.ClaimId#')	
	AND      T.EventCode IN (SELECT Code 
	                         FROM Ref_ClaimEvent 
							 WHERE pointerTerminal = 1)	
	<cfif exc neq "">						 	
	AND T.ClaimTripId NOT IN (#preservesingleQuotes(exc)#)					 				  			  
	</cfif>
	
	ORDER BY PersonNo, LocationDate		 					  
</cfquery>

<cfoutput query="SelectCities" group="PersonNo">

    <cfset amt = 0>
	
    <cfoutput>
	
	<!--- check if indicator was used --->
	<cfquery name="Check" 
	datasource="appsTravelClaim"	 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM ClaimEventTripIndicator
	WHERE ClaimTripId = '#ClaimTripid#'
	AND IndicatorCode IN (SELECT IndicatorCode 
	                      FROM Ref_ClaimRates 
						  WHERE ClaimCategory = 'TRM') 			  
						  
	</cfquery>
	
	<cfif check.recordcount gte "1">
	     <cfset ind = Check.IndicatorCode>
	<cfelse>
	     <cfset ind = ""> 
	</cfif>			
	
	<cfquery name="CityLocation" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_CountryCityLocation L
		WHERE  L.CountryCityId = '#CountryCityId#' 
		ORDER BY LocationDefault DESC												
	</cfquery> 
					
	<cfset loc = "#CityLocation.LocationCode#">
	
	<!--- find the correct rate --->
		
	<cfquery name="Rate" 
	datasource="appsTravelClaim"	 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ClaimRates
		WHERE   ClaimCategory     = 'TRM' 
		AND     DateEffective     < '#DateFormat(claimTripDate,CLIENT.DateSQL)#'
		AND     ServiceLocation   = '#CityLocation.LocationCode#' 
		AND     (ClaimantType     = '#ClaimantType#' OR ClaimantType is NULL) 
		<cfif ind neq "">
		        AND IndicatorCode = '#Ind#'
		<cfelse>
		        AND IndicatorCode is NULL 
		</cfif>
		ORDER BY DateEffective DESC, ClaimantType DESC
	</cfquery>
	
	<cfif Rate.recordcount eq "0">
	
		<cfquery name="Rate" 
		datasource="appsTravelClaim"		 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_ClaimRates
		WHERE     ClaimCategory   = 'TRM' 
		AND       DateEffective < '#DateFormat(claimTripDate,CLIENT.DateSQL)#'
		AND       ServiceLocation = 'ALL' 
		AND (ClaimantType    = '#ClaimantType#' OR ClaimantType is NULL) 
		<cfif ind neq "">
		        AND IndicatorCode = '#Ind#'
		<cfelse>
		        AND IndicatorCode is NULL 
		</cfif>
		ORDER BY DateEffective DESC, ClaimantType DESC
		</cfquery>
		
	</cfif>		
	
	<!--- 16/8 do not add TRM cost if the day is a personal day, disabled based on topic 399
	
	<cfquery name="CheckPersonal" 
	 	  datasource="appsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT     Date.CalendarDate, 'Personal' AS Expr1
			FROM     Ref_Indicator R INNER JOIN
                     ClaimLineDateIndicator Date ON R.Code = Date.IndicatorCode
			WHERE    R.LinePercentage  = '100' <!--- personal --->
			AND      Date.PersonNo     = '#PersonNo#' 
			AND      Date.CalendarDate = '#DateFormat(claimTripDate,CLIENT.DateSQL)#'
	</cfquery>		
		
	<cfif Rate.recordcount neq "0" and CheckPersonal.recordcount eq "0">
	
	--->
	
	<cfif Rate.recordcount neq "0">
	
		<cfif ind neq "">
		
				<!--- check if indicator was used --->
			<cfquery name="Check" 
			datasource="appsTravelClaim"			 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_Indicator
			WHERE Code = '#ind#'
			</cfquery>
			
			<cfset ref = check.description>
			
		<cfelse>
		
		    <cfset ref  = "">
					
		</cfif>
	
	    <cfquery name="InsertCost" 
			 	  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  ClaimEventIndicatorCost
						      (ClaimEventId, 
							   IndicatorCode,
							   CostLineNo,
							   PersonNo,
							   InvoiceDate,
							   InvoiceCurrency,
							   InvoiceAmount,
							   Description,
							   Reference,ReferenceId)
				  VALUES ('#evid#',
				          'TRM',
						  #currentrow#+200,
						  '#PersonNo#',
						  '#ClaimTripDate#', 
						  '#Rate.Currency#',
						  '#Rate.Amount#',
						  '#LocationCity#',
						  '#ref#','#ClaimTripId#')
		 </cfquery>	
	    
	</cfif>
		
	</cfoutput>

</cfoutput>
