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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head><title>Saving</title></head>

<body>

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<!--- verification 
0. Arrival date/time entered
1. Arrival date/time after departure date/time
2. Arrival city != Departure city
3. Verify the stopovers, if the fall within the overall arrival/departure
4. Verify the stopovers, if they coincide with the cities
--->

<cftransaction> 
	
	<cfparam name="Form.EventDescription" default="">
	
	<cfquery name="Parameter" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
	    FROM   Parameter 
	</cfquery>
	
	<cfquery name="Claim" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
	    FROM   Claim R, 
		       ClaimRequest Req
	    WHERE  ClaimId = '#URL.ClaimId#'
		AND    R.ClaimRequestId = Req.ClaimRequestId
	</cfquery>
	
	<cfquery name="SetClaim" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Claim 
		SET ClaimAsIs = 0
	    WHERE ClaimId = '#URL.ClaimId#'
	</cfquery>
	
	<cfif URL.Topic eq "Trip">
	
	<cfset dateValue = "">
	 		  
		<CF_DateConvert value="#Form.DepartureDate#">
		<cfset DEP = #dateValue#> 
		   	  
		<CF_DateConvert Value="#Form.DateArrival_0#">
		<cfset ARR = #dateValue#>
	
		<cfif ParameterExists(Form.addstopover)>
		
		   <!--- do not perform this check --->
		   
		<cfelse>
	 	  
		  <cfif Form.HourArrival_0 eq "" or Form.DepartureHour eq "" or
		  	Form.MinuteArrival_0 eq "" or Form.DepartureMinute eq "">
		  
		     <cf_message message = "You have not entered all departure or arrival times" return="back">
			 <cfabort>
		    		 
		   </cfif>	
				   
	       <!--- overal check start and enddate --->
			
			   <cfif Parameter.EnableGMTTime eq "0">
			 		 	 	  	    	 	  	  	  
				  	<cfif ARR lt DEP>
				  
					     <cf_message message = "Your arrival date/time #dateformat(ARR,CLIENT.DateFormatShow)# must be later than the departure date/time #dateformat(DEP,CLIENT.DateFormatShow)#" return="back">
						 <cfabort>
					 
				  	<cfelseif ARR eq DEP and Form.HourArrival_0 lt Form.DepartureHour>
				  
					  	 <cf_message message = "Your arrival hour should lie after the departure hour" return="back">
					     <cfabort>
						 
					<cfelseif ARR eq DEP and Form.HourArrival_0 eq Form.DepartureHour and 
							Form.MinuteArrival_0 lte Form.DepartureMinute>
				  
					  	 <cf_message message = "Your arrival time #Form.HourArrival_0#:#Form.MinuteArrival_0# should lie after the departure time #Form.DepartureHour#:#Form.DepartureMinute#" return="back">
					     <cfabort>	 
				  
				  	</cfif>
					
			  <cfelse>	
			  
			  <!--- provision for correction based on the city code --->
				
			  </cfif>	
			
		  </cfif> 	
		  
			 <!--- save trip by cleaning prior entries --->
			<cfif URL.ID1 neq "{00000000-0000-0000-0000-000000000000}">
			
				<cfquery name="PriorDSA" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#"> 
				  SELECT * FROM ClaimEventTripIndicator
				  WHERE ClaimEventId = '#URL.ID1#'  
				  AND IndicatorCode NOT IN (SELECT Code 
				                            FROM Ref_Indicator 
											WHERE Category IN ('Arrival','Departure') 
										   ) 
				</cfquery> 
				
						
				<cfquery name="Delete" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE FROM ClaimEventTrip
				  WHERE ClaimEventId = '#URL.ID1#'  
				</cfquery>			
							
				<cfset eventid = URL.ID1>
			
			<cfelse>	
		
		    	<cf_assignId>
			    <cfset eventid = RowGuid>
		  
			</cfif>
			
			
		  
		      <cfparam name="Form.EventDistance" default="">
			  
			  <cf_NavigationReset
			     Alias          = "AppsTravelClaim"
		         Object         = "Claim" 
				 Group          = "TravelClaim" 
				 Reset          = "Default"
				 ResetParent    = "#URL.Section#"
				 Id             = "#URL.ClaimId#">
			  
			  <cfif URL.ID1 neq "{00000000-0000-0000-0000-000000000000}">
			  
			  	<cfquery name="UpdateEvent" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE ClaimEvent
				  SET   EventDateEffective  = #DEP#, 
					    EventDateExpiration = #ARR#,
					    EventDescription    = '#Form.EventDescription#', 
					    EventDistance       = '#Form.EventDistance#',
						EventReference      = '#Form.EventReference#'
				  WHERE ClaimEventId        = '#eventid#'   
				</cfquery>	
			  
			  <cfelse>
		  	  
			  <cfquery name="InsertEvent" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  ClaimEvent
				      (ClaimEventId,
					   ClaimId,
					   EventDateEffective, 
					   EventDateExpiration,
					   EventDescription, 
					   EventDistance,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)
				  VALUES ('#eventid#',
				          '#URL.claimid#',
				          #DEP#,
						  #ARR#,
				          '#Form.EventDescription#', 
						  '#Form.EventDistance#',
						  '#SESSION.acc#', 
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>	
				
				</cfif>
						  
		  <!--- ---------------------------- --->
		  <!--- ---save INITIAL DEPARTURE--- --->
		  <!--- ---------------------------- --->
		 
		  <!--- to be removed 20/2/2008 
		  
		  <cfparam name="Form.depCode" default="">
			  
		  <cfif Form.depCode eq "">
			  
			  <cfquery name="Service" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT TOP 1 ServiceLocation
				FROM ClaimRequestDSA
				WHERE DateExpiration > #DEP#
				AND ClaimRequestId = (SELECT ClaimRequestId 
				                      FROM Claim 
									  WHERE ClaimId = '#URL.ClaimId#')
				ORDER BY DateEffective
			  </cfquery>
				  
				  <!--- if not entered retrieve from request --->
				  <cfset loc = "#Service.ServiceLocation#">
				  
		  <cfelse>
		  
			  <cfset loc = "#Form.DepCode#"> 		  
			  		  
		  </cfif>	
		  
		  --->
		  
		  <cfset dep = DateAdd("h", "#Form.DepartureHour#",   "#DEP#")> 
		  <cfset dep = DateAdd("n", "#Form.DepartureMinute#", "#dep#")>  
		  <cfset event = "#Form.EventCode#">
		  
		  <cfif Parameter.EnableGMTTime eq "1">
		  
		    <cfquery name="GMT" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 *
			    FROM Ref_CountryCityTimeZone
				WHERE CountryCityId = '#Form.depCityId#'
				AND   DateEffective < #dep#  
				ORDER BY DateEffective DESC 
			</cfquery>
											
			<cfif #GMT.recordcount# neq "0">
			    <cfset GMT = DateAdd("h", "#GMT.TimeZoneGMT#",   "#DEP#")> 
			<cfelse>
				<cfset GMT = "NULL">
			</cfif>	
			
		  <cfelse>	
		  
			  <cfset GMT = "NULL">
			
		  </cfif> 	
		  
		  <cfquery name="City" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM  Ref_CountryCity
				WHERE CountryCityId = '#Form.depCityId#'			
		  </cfquery>
		  
		  <cf_assignId>
		  <cfset tripid = rowguid>
		 	  	  
		  <cfquery name="InsertDeparture" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  ClaimEventTrip
				      (ClaimEventId,
					   ClaimTripId,
					   EventCode,
					   ClaimTripDate,
					   ClaimTripMode,
					   LocationDate, 
					   LocationDateGMT, 
					   CountryCityId,
					   LocationCountry,
					   LocationCity,
					   LocationReference,
					   ActionStatus)
				  VALUES ('#eventid#',
				          '#tripid#',
				          '#Form.EventCode#',
						  '#DateFormat(dep, client.dateSQL)#',
				          'Departure',
				          #DEP#, 
						  #GMT#,
						  '#Form.depCityId#',
						  '#City.LocationCountry#',
						  '#City.LocationCity#',
						  '#Form.EventReference#',
						  '1')
		  </cfquery>	
		  
		  <!--- reconnect the DSA indicators --->
		  
		  <cfloop query="PriorDSA">
		  
		  
			   	<cfquery name="InsertDSA" 
					  datasource="appsTravelClaim" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  INSERT INTO  ClaimEventTripIndicator
					      (ClaimEventId,
						   ClaimTripId,
						   IndicatorCode,
						   IndicatorValue)
					  VALUES ('#eventid#',
					          '#rowguid#',
					          '#IndicatorCode#',
							  '#IndicatorValue#')
			     </cfquery>		
				 		
		  	  
		  </cfloop>
		  
		  
		  <cfset fld = "">
		  <cfset category = "'Departure'">
		  <cfinclude template="ClaimEventEntrySubmitPointer.cfm">
		  	  
		  <!--- arrival and stopover --->
		  
		  <cfloop index="stopover" list="1,2,3,4,0" delimiters=",">
		  
		    <cfparam name="Form.StopOver_#stopover#" default="0">
			
			<!--- should take the prior entry --->
			
			<cfparam name="FORM.EventCode_#stopover#" default="">
			<cfparam name="FORM.arrcityid_#stopover#" default="">
			
			<cfset cityid  = Evaluate("FORM.arrcityid_" & #stopover#)>
			
			<cfif cityid neq "">				
			
				<cfquery name="City" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM  Ref_CountryCity
					WHERE CountryCityId = '#CityId#'		
			    </cfquery>		
				
				<cfset code           = "">  <!--- always define the DSA locationcode in the code --->
				<cfset date           = Evaluate("FORM.dateArrival_" & #stopover#)>
				<cfset hour           = Evaluate("FORM.HourArrival_" & #stopover#)>
				<cfif hour eq "">
				   <cfset hour = "23">
				</cfif>
				<cfset min            = Evaluate("FORM.MinuteArrival_" & #stopover#)>
				<cfif min eq "">
				   <cfset min = "59">
				   <cfset sec = "15">
				<cfelse>
				   <cfset sec = "0">   
				</cfif>
				<cfset stop           = Evaluate("FORM.StopOver_" & #stopover#)>
																		
				  <cfif cityid neq "" and date neq "">
				  		
						<CF_DateConvert Value="#date#">
						<cfset ARR = #dateValue#>
					    <cfset arr = DateAdd("h", "#hour#", "#arr#")> 
						<cfset arr = DateAdd("n", "#min#", "#arr#")>  
						<cfset arr = DateAdd("s", "#sec#", "#arr#")> 	
						<cfset arr = DateAdd("s", "30", "#arr#")> 				
						
						<cfif Parameter.EnableGMTTime eq "1">
						
							<cfquery name="GMT" 
								datasource="appsTravelClaim" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT TOP 1 *
								    FROM Ref_CountryCityTimeZone
									WHERE CountryCityId = '#CityId#'
									AND   DateEffective < #dep#  
									ORDER BY DateEffective DESC 
							</cfquery>						
											
							<cfif GMT.recordcount neq "0">
							    <cfset GMT = DateAdd("h", "#GMT.TimeZoneGMT#",   "#arr#")> 
							<cfelse>
								<cfset GMT = "NULL">
							</cfif>	
							
						<cfelse>
						
							<cfset GMT = "NULL">
						
						</cfif>	
										  						  
						<cfif stopover eq "0">
						    <cfset ClaimTripMode = "Arrival">
						<cfelse>
						    <cfset ClaimTripMode = "Arrival">	
						</cfif>
						
						<cfparam name="FORM.OvernightStayDeparture_#stopover#" default="0">
						<cfif parameter.StopoverHours gt "0">
							<cfset night       = Evaluate("FORM.OvernightStayDeparture_" & #stopover#)>
						<cfelse>
						    <cfset night       = 0>								
						</cfif>
						
						<cf_assignId>
						<cfset tripid = rowguid>
						 	 	  
						<cfquery name="InsertArrival" 
						  datasource="appsTravelClaim" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  INSERT INTO  ClaimEventTrip									  
						      (ClaimEventId,
							   ClaimTripId,
							   EventCode,
							   ClaimTripDate,
							   ClaimTripMode,
							   ClaimTripStop,
							   LocationDate, 
							   LocationDateGMT,
							   OvernightStay,
							   CountryCityId,
							   LocationCountry,
							   LocationCity,						  
							   ActionStatus)
						  VALUES ('#eventid#',
						          '#tripid#', 
						          '#Event#',								 
								  '#DateFormat(arr, client.dateSQL)#',
						          '#ClaimTripMode#',
								  '#stopover#',
						          #ARR#, 
								  #GMT#,
								  '#night#',
								  '#CityId#',
								  '#City.LocationCountry#',
								  '#City.LocationCity#',							 
								  '1')
						</cfquery>	
						
						<cfset fld = "Arrival_#stopover#">
						<cfset category = "'Arrival'">
						<cfinclude template="ClaimEventEntrySubmitPointer.cfm">
						  
						<cfif stopover neq "0">
					
							  <cfset date2       = Evaluate("FORM.dateDeparture_" & #stopover#)>
							  <cfset hour2       = Evaluate("FORM.HourDeparture_" & #stopover#)>
							  <cfset min2        = Evaluate("FORM.MinuteDeparture_" & #stopover#)>
							  <cfif hour2 eq "">
								<cfset hour = "08">
								<cfset hour2 = "08">
							  </cfif>
							  <cfif min2 eq "">
								<cfset hour = "00">
								<cfset min2 = "00">
							  </cfif>
							  
							  <cfset event       = Evaluate("FORM.EventCodeDeparture_" & #stopover#)>
							  <cfparam name="FORM.OvernightStayDeparture_#stopover#" default="0">
							  <cfset night       = Evaluate("FORM.OvernightStayDeparture_" & #stopover#)>
							  <cfset ref         = Evaluate("FORM.EventReference_" & #stopover#)>
				  
							  <CF_DateConvert Value="#date2#">
						      <cfset DEP = #dateValue#>
							  
							  <cfset dep = DateAdd("h","#hour2#","#dep#")> 
						      <cfset dep = DateAdd("n","#min2#","#dep#")>  
							  
							  <cf_assignId>
							  <cfset tripid = rowguid>
										  
						   		<cfquery name="InsertDepartureStopover" 
								  datasource="appsTravelClaim" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  INSERT INTO  ClaimEventTrip
								      (ClaimEventId,
									   ClaimTripId,
									   EventCode,
									   ClaimTripDate,
									   ClaimTripMode,
									   ClaimTripStop,
									   LocationDate, 
									   CountryCityId,
									   OvernightStay,
									   LocationCountry,
									   LocationCity,								  
									   LocationReference,
									   ActionStatus)
								  VALUES ('#eventid#',
								          '#tripid#', 
								          '#event#',
										  '#DateFormat(dep, client.dateSQL)#',
								          'Departure',
										  '#stopover#',
								          #DEP#, 
										  '#CityId#',
										  '#night#',
										  '#City.LocationCountry#',
										  '#City.LocationCity#',																			  
										  '#ref#',
										  '1')
						  		</cfquery>	
								
								<cfset fld = "Departure_#stopover#">
								<cfset category = "'Departure'">
								<cfinclude template="ClaimEventEntrySubmitPointer.cfm">
								
								<cfset diff = DateDiff("n", "#arr#", "#dep#")>
								
								<cfif dateformat(arr,CLIENT.DateFormatShow) neq dateformat(dep,CLIENT.DateFormatShow)>
									<cfset span = "1">
								<cfelse>
									<cfset span = "0">
								</cfif>
																																
								<cfif Parameter.StopoverHours neq "0">		
																														
									<cfif diff gte (Parameter.StopoverHours*60)-1 or span gte "1">
									
										<cfquery name="InsertDepartureStopover" 
										  datasource="appsTravelClaim" 
										  username="#SESSION.login#" 
										  password="#SESSION.dbpw#">
										  UPDATE ClaimEventTrip
										  SET    OvernightStay = 1 
										  WHERE  ClaimEventId = '#eventid#'
										  AND    ClaimTripStop ='#stopover#' 							 
								  		</cfquery>		
										
									<cfelse>
									
										<cfquery name="InsertDepartureStopover" 
										  datasource="appsTravelClaim" 
										  username="#SESSION.login#" 
										  password="#SESSION.dbpw#">
										  UPDATE ClaimEventTrip
										  SET    OvernightStay = 0 
										  WHERE  ClaimEventId = '#eventid#'
										  AND    ClaimTripStop ='#stopover#' 							 
								  		</cfquery>								
									
									</cfif>
								
								</cfif>								
					    
					  	</cfif>		
					
				</cfif>	
				
			</cfif>	
							
		</cfloop>	
			 
	<!--- save people --->
		
	<cfquery name="EventPerson" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT DISTINCT P.*, C.ClaimantType 
		 FROM   ClaimRequestLine C, stPerson P 
		 WHERE  ClaimRequestId = '#Claim.ClaimRequestId#' 
		   AND  C.PersonNo = P.PersonNo
	</cfquery>
	
	 <cfquery name="ClearEvent" 
	 	  datasource="appsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  DELETE FROM  ClaimEventPerson
		  WHERE ClaimEventId = '#URL.ID1#' 
	 </cfquery>	  
	
	<cfloop query="EventPerson">
	
	  <cfparam name="Form.PersonNo_#CurrentRow#" default=""> 
	  
	  <cfset person =   Evaluate("Form.PersonNo_#CurrentRow#")>
	  <cfset clm    =   Evaluate("Form.ClaimantType_#CurrentRow#")>
	    
	  <cfif person neq "">
	
		  <cfquery name="InsertEvent" 
	 	  datasource="appsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  INSERT INTO  ClaimEventPerson
				      (ClaimEventId, 
					   PersonNo, 
					   ClaimantType)
		  VALUES ('#eventid#',
		          '#PersonNo#',
				  '#clm#') 
		  </cfquery>	  
	
	  </cfif>
	
	</cfloop>
	
	</cfif>
	
	<cfif URL.Topic neq "Trip">
	
		<cfquery name="Delete" 
		  datasource="appsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  DELETE FROM ClaimEventIndicator
		  WHERE ClaimEventId = '#URL.ID1#' 
		  AND IndicatorCode IN (SELECT Code 
		                        FROM Ref_Indicator 
								WHERE Category = '#URL.Topic#') 
		</cfquery>
	
	</cfif>
	
</cftransaction>

<cfquery name="Updated"
	datasource="appsTravelClaim"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Claim
		SET   PointerClaimUpdated = getDate()
		WHERE ClaimId = '#URL.ClaimId#'				
</cfquery>	

<cfparam name="#URL.Next#" default="1">

<cfif ParameterExists(Form.AddStopover)> 
	
	<cflocation url="ClaimEventEntry.cfm?leg=1&section=#url.section#&Status=Edit&claimId=#URL.claimId#&ID1=#URL.ID1#&Topic=#URL.Topic#" addtoken="No">
		
	<cfelse>	
				
	<cf_Navigation
			 Alias         = "AppsTravelClaim"
			 Object        = "Claim"
			 Group         = "TravelClaim" 
			 Section       = "#URL.Section#"
			 Id            = "#URL.ClaimId#"
			 BackEnable    = "1"
			 HomeEnable    = "1"
			 ResetEnable   = "1"
			 ProcessEnable = "0"
			 NextEnable    = "1"
			 NextMode      = "#URL.Next#"
			 SetNext       = "#URL.Next#"
			 OpenDirect    = "current">
			 
</cfif>		 
 
</body>
</html>
