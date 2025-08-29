<!--
    Copyright Â© 2025 Promisan B.V.

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
 <proOwn>M Kirk McDonough</proOwn>
 <proDes>12-Nov-2008	Removed the cfquery that deleted all entries from ClaimLineDateIndicator
 on the first day of travel.</proDes>
</cfsilent>
<cfset cols = 5>
<!--- prepare script --->

<cfquery name="Indicator" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Indicator
	WHERE   Category IN (SELECT Code 
	                     FROM   Ref_IndicatorCategory 
						 WHERE  ClaimSection = 'Period')
	AND Operational = 1					 
</cfquery>	

<script language="JavaScript">

 function hl(itm,fld,trg,code,excl,batch) {
	  
	   if (trg == "1") { 
		se = document.getElementsByName(itm)
		
		 if (excl == "1") {
			   x = batch
			   y = x.substring(0,x.length-4)
			   exclusive(y,code)
			   }
		
		count = 0
		while (se[count]) {	
		    if (se[count].disabled == false) {
			    se[count].checked = fld; }	
				
		    if (excl == "1") {
			   x = se[count].name
			   y = x.substring(0,x.length-4)
			   exclusive(y,code)
			   }
			   			
		     count++}
		}
	  }
	  
  function exclusive(name,code) {
  
  ex = document.getElementById(name+"_"+code);

  if (ex.checked == true) {
    	
 	<cfoutput query="Indicator">
	if (code != "#Code#") {
	
	try {
	f = document.getElementsByName(name+"_#code#")
	f[0].checked = false
	f[0].disabled = true
	}
	catch(e) {}
	}
 	</cfoutput>
		 
  } else {
 
 
  <cfoutput query="Indicator">
	if (code != "#Code#")
	{
	try
	{
	f = document.getElementsByName(name+"_#code#")
	f[0].disabled = false
	}
	catch(e) {}
	}
   </cfoutput>
  
  }
    
  }
  	  
</script>

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cf_wait1 text="Preparing DSA recapitulation" icon="circle" flush="Force">

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   Claim R
    WHERE  ClaimId = '#URL.ClaimId#'
</cfquery>

<cfquery name="DSA" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT max(Created) as Created
    FROM   ClaimLineDSA 
    WHERE  ClaimId = '#URL.ClaimId#'
</cfquery>

<cfquery name="Event" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT max(Created) as Created
    FROM  ClaimEventTrip
	WHERE ClaimEventId IN (SELECT ClaimEventId 
	                       FROM ClaimEvent 
						   WHERE ClaimId = '#URL.ClaimId#')
</cfquery>

<cfquery name="Preset" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT DISTINCT Ind.IndicatorCode, 
		                Trip.CountryCityId,
						Trip.ClaimTripId
		FROM    ClaimEventTripIndicator Ind,
		        ClaimEventTrip Trip
		WHERE   Ind.ClaimEventId IN (SELECT ClaimEventId 
				                 FROM ClaimEvent 
								 WHERE ClaimId = '#URL.ClaimId#')
		AND 	Ind.ClaimEventId   = Trip.ClaimEventId 
		AND     Ind.ClaimTripId    = Trip.ClaimTripId 
</cfquery>	

<cfif DSA.created eq "">
     <cfset reqinit = 1>	
<cfelse>
     <cfset reqinit = 0>
</cfif>

<cfif DSA.Created lt Event.Created>

	<cf_waitEnd>
	<cf_wait1 text="Initializing data." icon="circle" flush="Force">
	
	<cfset URL.Class = "Regular">
	<cfset clearDSA  = "1">
	<cfset line      = 99>
				
	<!--- create dates only --->
	<cfinclude template="../Process/Calculation/CalculateDSA.cfm">
		
</cfif>

<cfquery name="RequestDSA" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
	SELECT    ServiceLocation
	FROM      ClaimRequestDSA
	WHERE     ClaimRequestId = '#Claim.ClaimRequestid#'
</cfquery>	

<cfset reqdsa = "">

<cfloop query="RequestDSA">
	 <cfif reqdsa eq "">
	    <cfset reqdsa = "#ServiceLocation#">
	 <cfelse>
	    <cfset reqdsa = "#reqdsa#,#ServiceLocation#">
	 </cfif>
</cfloop>


<cfif reqinit eq "1">

		<!--- populate only first time the travel request info for each date --->

		<cfquery name="Pointer" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT DISTINCT R.Code AS IndicatorCode, DateEffective, DateExpiration
			FROM     ClaimRequestLineIndicator TRV INNER JOIN
                     Ref_Indicator R ON TRV.IndicatorCode = R.ParentCode
			WHERE    ClaimRequestId = '#Claim.ClaimRequestid#' 
		</cfquery>		
		
		<cfloop query="Pointer">

			<cfquery name="InsertReqPointer" 
			 datasource="appsTravelClaim" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				INSERT INTO ClaimLineDateIndicator
				(ClaimId, PersonNo,CalendarDate,IndicatorCode,IndicatorValue)
				SELECT    ClaimId, PersonNo, CalendarDate, '#IndicatorCode#', '1'
				FROM      ClaimLineDSA
				WHERE     ClaimId = '#URL.ClaimId#' 
				<cfif dateeffective neq "">
				AND       CalendarDate >= '#dateformat(DateEffective,client.dateSQL)#'  
				</cfif>
				<cfif dateexpiration neq "">
				AND       CalendarDate <= '#dateformat(DateExpiration,client.dateSQL)#'
				</cfif>
			</cfquery>	
			
		</cfloop>	
		
		<!--- special settings for home leave based on portal settings --->
	
		<cfquery name="DeletePointer" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 DELETE FROM ClaimLineDateIndicator
		 WHERE ClaimId = '#URL.ClaimId#'
		 AND   IndicatorCode IN (SELECT DefaultIndicator
		                         FROM   ClaimRequest Req,
								 		Ref_ClaimPurpose R
								 WHERE  Req.ActionPurpose = R.Code
								 AND    R.DefaultIndicator IS NOT NULL 
								 AND   	ClaimRequestId = '#Claim.ClaimRequestId#')
	    </cfquery>	
	  
	    <cfquery name="InsertPointer" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO ClaimLineDateIndicator
                     (ClaimId,PersonNo,CalendarDate,IndicatorCode,IndicatorValue)
		 SELECT  DSA.ClaimId, DSA.PersonNo, DSA.CalendarDate, DefaultIndicator,'1'
		 FROM    Claim C INNER JOIN
                 ClaimRequest Req ON C.ClaimRequestId = Req.ClaimRequestId INNER JOIN
                 ClaimLineDSA DSA ON C.ClaimId = DSA.ClaimId LEFT OUTER JOIN
                 Ref_ClaimPurpose R ON Req.ActionPurpose = R.Code
		 WHERE   C.ClaimId = '#URL.ClaimId#' 
		 AND     R.DefaultIndicator IS NOT NULL
		</cfquery>	

</cfif>

<cfquery name="Traveller" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT Distinct E.*
FROM   ClaimEventPerson P, 
       stPerson E
WHERE  P.PersonNo = E.PersonNo
AND    ClaimEventId IN (SELECT ClaimEventId FROM ClaimEvent WHERE ClaimId = '#URL.ClaimId#')
ORDER BY LastName, FirstName
</cfquery>

<cf_waitEnd>

<cfset init = "1">

<div class="screen">
<body leftmargin="5" topmargin="0" rightmargin="0" bottommargin="0">
	
<table width="98%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0">	

<cfform 
	action="ClaimEventEntryDSASubmit.cfm?Section=#URL.Section#&ClaimId=#URL.ClaimId#&ID1=#URL.ID1#&Category=period" 
	method="POST" 
	name="entry">

<tr><td valign="top">

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<cfset group = "0">
	
	<tr><td height="6"></td></tr>
	
	<cfoutput query="Traveller">
	
	<!--- prepare data per traveller --->
	<cfsilent>
		<cfinclude template="ClaimEventEntryDSAPrepare.cfm">
	</cfsilent>
	
	<tr><td height="1" colspan="#cols#">
	 	  <cfinclude template="ClaimPreparation.cfm">
		</td>
	</tr>
	
	<tr>
	
	<td colspan="#cols#" valign="top">
		<table width="100%">
		
		<tr>
		<td width="25"><cfoutput><img src="#SESSION.root#/images/join.gif" alt="" border="0"></cfoutput></td>
						
		<td height="24"><font face="Verdana" size="2"><b>Subsistence Details:</b> 
		
			<font face="Verdana" color="002350">#FirstName# #LastName#</td>
			
			</td>
			</tr>
		</table>
	</tr>	
	
	<!--- check for same day travel 10 - 24 hour provision --->
	
	<cfif Period.Expiration lte Period.Start>
	
		<!--- Portal indicates same day travel --->
		
		<cfquery name="TimeStart"
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   LocationDate as TimeStart
		FROM     ClaimEvent     Ev,
	    	     ClaimEventTrip C
		WHERE    Ev.ClaimEventId = C.ClaimEventId 
		AND      Ev.ClaimId      = '#URL.ClaimId#'
		ORDER BY EventOrder, LocationDate
		</cfquery>
		
		<cfquery name="TimeEnd"
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   LocationDate as TimeEnd
		FROM     ClaimEvent     Ev,
	    	     ClaimEventTrip C
		WHERE    Ev.ClaimEventId = C.ClaimEventId 
		AND      Ev.ClaimId      = '#URL.ClaimId#'
		ORDER BY EventOrder DESC, LocationDate DESC
		</cfquery>
			
		<cfset hours = DateDiff("h", TimeStart.TimeStart, TimeEnd.TimeEnd)>
		
		<cfif hours lt "0">
				
			<tr><td colspan="#cols#" align="center" bgcolor="FDD6D0">Incorrect Itinerary</td></tr>
				
		<cfelseif hours lt "10">
			
			<!--- case 1 : less than 10 hours no 40% applied --->
		
			<tr><td colspan="#cols#" align="center" bgcolor="FDD6D0">Journey completed in less than 10 hours</td></tr>
					
		<cfelse>
		
			<!--- verify travel request if 40% is granted --->
		
			<cfquery name="DSARequest" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ClaimRequestDSA
				WHERE  ClaimRequestId = '#Claim.ClaimRequestId#' 
			</cfquery>
			
			<cfif DSARequest.RequestDays eq "1" and DSARequest.recordcount eq "1">
			
			<cftry>
				<cfquery name="Event" 
				datasource="appsTravelClaim">
					INSERT INTO ClaimLineDSA
					       (ClaimId,CalendarDate,PersonNo,ClaimCategory)
					VALUES ('#URL.ClaimId#','#Dateformat(Period.Start,client.dateSQL)#','#PersonNo#','DSA') 
				</cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
			
			<!--- determine the correct DSA location --->
			
			<cfquery name="City" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    TOP 1 CET.CountryCityId, CE.EventDateEffective
			FROM      ClaimEvent CE INNER JOIN
		              ClaimEventTrip CET ON CE.ClaimEventId = CET.ClaimEventId
			WHERE     CET.ClaimTripMode = 'Arrival' 
			AND       CE.ClaimId = '#URL.ClaimId#'
			ORDER BY CET.LocationDate
			</cfquery>
			
			<!--- find effective, with rates and ideally default location for this city --->
			
			<cfset eff = dateformat(city.EventDateEffective,client.dateSQL)>
			
			<cfquery name="Location" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    R.LocationCode
			FROM      Ref_PayrollLocation R INNER JOIN
	                  Ref_CountryCityLocation L ON R.LocationCode = L.LocationCode
			WHERE     L.CountryCityId = '#city.countrycityid#' 
	 	    AND       (R.DateEffective <= '#eff#' OR R.DateEffective IS NULL)		
			AND       R.LocationCode IN
	                          (SELECT     C.ServiceLocation
	                            FROM          Ref_ClaimRates C
	                            WHERE      DateEffective <= '#eff#' 
								AND (DateExpiration IS NULL OR DateExpiration >= '#eff#')
							  )			 	    
			ORDER BY L.LocationDefault DESC
			</cfquery>
						
			<cfif Location.recordcount gte "1">
			
				<cfquery name="Update" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 UPDATE ClaimLineDSA
					 SET    LocationCode  = '#Location.LocationCode#' 
					 WHERE  ClaimId       = '#url.claimid#' 	
				</cfquery>
				
				<cfset loc = Location.LocationCode>

			<cfelse>
					
				<cfquery name="Update" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 UPDATE ClaimLineDSA
					 SET    LocationCode  = '#DSARequest.ServiceLocation#' 
					 WHERE  ClaimId       = '#url.claimid#' 		
				</cfquery>
				
				<cfset loc = DSARequest.ServiceLocation>
			
			</cfif>
			
			<cfquery name="Location" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 SELECT * FROM Ref_PayrollLocation
					 WHERE LocationCode = '#loc#' 			
				</cfquery>
			
			
			<!--- case 2 : apply 40 rate --->
					
			<!--- post update --->
			
			<tr><td height="1" colspan="#cols#" bgcolor="C0C0C0"></td></tr>
			<tr><td colspan="#cols#" height="40" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<font color="0D86FF">Attention:</font> <b><font color="0080C0">A 40% DSA rate for location <font color="red">#location.Description# #Location.locationCountry#</font> will be applied for this trip.</td></tr>
			
			<tr><td colspan="3"></td><td colspan="#cols-3#">
			
			<cf_ClaimEventEntryIndicatorPointer
			 Category  = "'SameDay'"
			 width    = "100%"
			 class    = "hide"
			 value    = "checked"
			 line     = "1"
			 status   = "#claim.actionstatus#"
			 tripid   = "#Preset.ClaimTripId#">
			 		 
			 </td></tr>
					
			<cfelse>
					
			<tr><td colspan="3"></td><td colspan="#cols-3#" align="center">
			
			<!--- determine the correct DSA location --->
			
			<cfquery name="City" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    TOP 1 CET.CountryCityId, CE.EventDateEffective
			FROM      ClaimEvent CE INNER JOIN
		              ClaimEventTrip CET ON CE.ClaimEventId = CET.ClaimEventId
			WHERE     CET.ClaimTripMode = 'Arrival' 
			AND       CE.ClaimId = '#URL.ClaimId#'
			ORDER BY CET.LocationDate
			</cfquery>
			
			<!--- find effective, with rates and ideally default location for this city --->
			
			<cfset eff = dateformat(city.EventDateEffective,client.dateSQL)>
			
			<cfquery name="Location" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    R.LocationCode
			FROM      Ref_PayrollLocation R INNER JOIN
	                  Ref_CountryCityLocation L ON R.LocationCode = L.LocationCode
			WHERE     L.CountryCityId = '#city.countrycityid#' 
	 	    AND       (R.DateEffective <= '#eff#' OR R.DateEffective IS NULL)		
			AND       R.LocationCode IN
	                          (SELECT     C.ServiceLocation
	                            FROM          Ref_ClaimRates C
	                            WHERE      DateEffective <= '#eff#' 
								AND (DateExpiration IS NULL OR DateExpiration >= '#eff#')
							  )			 	    
			ORDER BY L.LocationDefault DESC
			</cfquery>
				
			
			<cfif Location.recordcount gte "1">
			
				<cfquery name="Update" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 UPDATE ClaimLineDSA
					 SET    LocationCode  = '#Location.LocationCode#' 
					 WHERE  ClaimId       = '#url.claimid#' 	
				</cfquery>
				
				<cfset loc = Location.LocationCode>
			
			<cfelse>
					
				<cfquery name="Update" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 UPDATE ClaimLineDSA
					 SET    LocationCode  = '#DSARequest.ServiceLocation#' 
					 WHERE  ClaimId       = '#url.claimid#' 		
				</cfquery>
				
				<cfset loc = DSARequest.ServiceLocation>
			
			</cfif>
			
			  <cf_ClaimEventEntryIndicatorPointer
			 Category  = "'SameDay'"
			 width    = "100%"
			 class    = "regular"
			 value    = "checked"
			 line     = "1"
			 status   = "#claim.actionstatus#"
			 tripid   = "#Preset.ClaimTripId#">
			
			 +</td></tr>
			 
			 <!--- case 3 : optional based on the answer --->
			
			</cfif>				
		
		</cfif>
		
	<cfelse>	
	
		<tr><td colspan="#cols#" bgcolor="ffffff">
		
		    <cf_ClaimEventEntryIndicatorPointer
			 ClaimSection  = "Subsistence"
			 width     = "100%"
			 line      = "1"
			 editclaim = "#editclaim#"
			 status    = "#claim.actionstatus#"
			 tripid    = "#Preset.ClaimTripId#">
			
		</td></tr>   
	
		<tr>
	      <td colspan="#cols#" height="35" width="96%">
			
			  <table width="100%" height="16" bgcolor="ffffff" border="1" cellspacing="1" cellpadding="1" bordercolor="E1E1E1" align="center" rules="rows">
			      
				<tr><td>
				
				</td>
			    <td>
			      <img src="#SESSION.root#/images/finger.gif" 
				     alt="" 
					 border="0" 
					 align="absmiddle"> Use the check boxes to indicate Accommodation and/or Meals provided by the UN, Government or related institution, and any annual or other leave days taken
	
				</td>
				</tr>
			  </table>		
				
		   </td>
		 </tr>	
		 
			 
		 <cfsilent>
		  			
			<!--- populate input table for each calendar date --->
			
				<cfset diff = DateDiff("d", "#Period.Start#", "#Period.Expiration#")>
				
				<!--- populate table with dates --->
				<cfloop index="day" from="0" to="#diff-1#"> 
								
					<cfset d = DateAdd("d", "#day#", "#Period.Start#")> 
															
						<cftry>
									
							<cfquery name="Insert" 
							datasource="appsTravelClaim">
								INSERT INTO userQuery.dbo.clm#SESSION.acc#Trip
								(EventOrder,ClaimTripDate,PersonNo)
								VALUES ('0',#d#,'#PersonNo#') 
							</cfquery>
							
							<cfcatch></cfcatch>
						
						</cftry>
													
				</cfloop>				
								
				<cfset per = PersonNo>
				
				<!--- determine the last available information for each trip calendar date ---> 
				
				<!---
				<cfquery name="Days" 
					datasource="appsTravelClaim">
					SELECT D.ClaimId, D.CalendarDate, D.PersonNo, D.ClaimCategory, D.CountryCityId, D.LocationCode, 
					       MIN(Tr.Overnightstay) as overnightStay, 
						   Ev.ClaimId AS Travel
					FROM   ClaimEvent Ev INNER JOIN
	                       ClaimEventTrip Tr ON Ev.ClaimEventId = Tr.ClaimEventId RIGHT OUTER JOIN
	                       ClaimLineDSA D ON Tr.ClaimTripDate = D.CalendarDate AND Ev.ClaimId = D.ClaimId
					WHERE  D.ClaimId = '#URL.ClaimId#' 
					AND    D.PersonNo = '#Per#'	
					GROUP BY D.ClaimId, D.CalendarDate, D.PersonNo, D.ClaimCategory, D.CountryCityId, D.LocationCode, Ev.ClaimId
					ORDER BY D.CalendarDate			
				</cfquery>
				--->
				
				<cfquery name="Days" 
					datasource="appsTravelClaim">
					SELECT D.ClaimId, D.CalendarDate, D.PersonNo, D.ClaimCategory, D.CountryCityId, D.LocationCode
					FROM   ClaimLineDSA D
					WHERE  D.ClaimId = '#URL.ClaimId#' 
					AND    D.PersonNo = '#Per#'	
					ORDER BY D.CalendarDate			
				</cfquery>
				
				</cfsilent>
							
				<input type="hidden" name="#PersonNo#_Count" value="#days.Recordcount#">
				
				<cfquery name="Departure" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	  TOP 1 T.*
							FROM      ClaimEvent Ev,
							          ClaimEventTrip T
							WHERE     Ev.ClaimId = '#URL.ClaimId#'
							AND       Ev.ClaimEventId = T.ClaimEventId
							ORDER BY  LocationDate ASC 	
				</cfquery>
				
				<cfset depcity = Departure.CountryCityId>
				
				<cfquery name="Return" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	  TOP 1 T.*
							FROM      ClaimEvent Ev,
							          ClaimEventTrip T
							WHERE     Ev.ClaimId = '#URL.ClaimId#'
							AND       Ev.ClaimEventId = T.ClaimEventId
							AND       CountryCityId != '#depcity#'
							AND       ClaimTripStop = '0'
							ORDER BY  LocationDate DESC 	
				</cfquery>
				
				<cfset returncity = Return.CountryCityId>
																									
				<cfloop query="Days">
				
					<cfquery name="CheckTravel" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    *
						FROM      ClaimEvent Ev INNER JOIN
	                    		  ClaimEventTrip Tr ON Ev.ClaimEventId = Tr.ClaimEventId
						WHERE     (Ev.ClaimId = '#URL.ClaimId#')
						AND       ClaimTripDate = '#dateformat(calendardate,client.dateSQL)#' 
				    </cfquery>
															
					<cfif checktravel.recordcount gte "1">	
													
						<cfquery name="LastMoment" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT 	  T.*, C.*	
							FROM      ClaimEvent Ev,
							          ClaimEventTrip T,
									  Ref_CountryCity C
							WHERE     Ev.ClaimId = '#URL.ClaimId#'
							AND       Ev.ClaimEventId = T.ClaimEventId
							AND       T.ClaimTripDate = '#calendardate#'
							AND       T.ClaimEventId IN (SELECT ClaimEventId 
							                             FROM   ClaimEventPerson 
														 WHERE  PersonNo = '#PersonNo#')
							AND       C.CountryCityId = T.CountryCityId
							<!--- does not consider short stopovers here for DSA OvernightStay = 1 !! 
							this might need to be revisted based on Terry's email. Pending
							--->
							AND       (T.ClaimTripStop = 0 OR T.OvernightStay = 1)						
							ORDER BY  LocationDate DESC 	
						</cfquery>
											
						<cfset eventcode = LastMoment.EventCode>
						<cfset ClaimTripStop = LastMoment.ClaimTripStop>
										
					<cfelse>
									  
						<cfset eventcode = "">
						<cfset ClaimTripStop = "">
					
					</cfif>		
												
									
					<!--- define header --->
					
					<!--- exclude the last row return date --->
							
					<cfif CurrentRow lte Recordcount> 
						 				 
							 <cfif EventCode eq "">
							
								 <cfparam name="Prior" default="#EventCode#"> 
							 	 <cfset Event = Prior>
								 <cfif init eq "1">
								   <cfset trigger = "1">
								 <cfelse>
								   <cfset trigger = "0"> 
								 </cfif>
								 <cfset init    = "0">
															 
							 <cfelse>
							 
							      <cfset Event   = "#EventCode#">
							  	  <cfset prior   = "#EventCode#"> 
								  <cfset trigger = "1">
								  <cfset init    = "0">
								  <cfset group   = group+1>
								  
							 </cfif>
																			 
							 <cfset fld = "#Per#_#CurrentRow#">
							 <cfset id  = "#Per#_#group#">
														 						
							 <CF_DateConvert 
							    Value="#DateFormat(calendardate, CLIENT.DateFormatShow)#"
								Status = "0">
								
							 <cfset dte = dateValue>
											 
							 <cfif Trigger eq "1">
														 
								<!--- runs only in a few cases to improve performance --->
													
								<!--- 29/09. limit run only for change of city before it ran for change of event --->
								
								<!--- valid DSA codes --->
								
							<cfquery name="DSABase" 
								datasource="appsTravelClaim" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT DISTINCT 
	       								     D.CalendarDate,
									         R.CountryCityId, 
									         R.LocationCode, 
											 R.LocationDefault,
											 L.Description,
											 L.LocationCountry,		
											 L.HotelRate,
											 L.SeasonalRate,								 
											 R.DateEffective,
											 R.DateExpiration 									 
									FROM     ClaimLineDSA D INNER JOIN
				                             Ref_CountryCityLocation R ON D.CountryCityId = R.CountryCityId INNER JOIN
				                             Ref_PayrollLocation L ON R.LocationCode = L.LocationCode
									WHERE    PersonNo  = '#Per#'
									 AND     ClaimId   = '#Claim.ClaimId#'
									 <!--- DSA location effective, usually null --->
									 AND    (R.DateEffective <= D.CalendarDate OR  R.DateEffective IS NULL) 	
									 AND     R.LocationCode IN (SELECT C.ServiceLocation
									                            FROM   Ref_ClaimRates C
																WHERE  DateEffective <= D.CalendarDate 
														        AND   (DateExpiration IS NULL or DateExpiration >= D.CalendarDate)
																)																									
									   
								</cfquery>
<!--- MKM - July 10, 2008
Changed #dte# to D.CalendarDate in the above query to allow for DSA Rates that expire and are replaced by a new DSA Rate

Original Where Clause From the Above Query
									WHERE    PersonNo  = '#Per#'
									 AND     ClaimId   = '#Claim.ClaimId#'
									 <!--- DSA location effective, usually null --->
									 AND    (R.DateEffective <= #dte# OR  R.DateEffective IS NULL) 	
									 AND     R.LocationCode IN (SELECT C.ServiceLocation
									                            FROM   Ref_ClaimRates C
																WHERE  DateEffective <= #dte# 
														        AND   (DateExpiration IS NULL or DateExpiration >= #dte#)
																)																									

--->

								<cfset l = "">
								
								<cfloop query="DSABase">
								    <cfif l eq "">
										<cfset l = "#locationCode#">
									<cfelse>
										<cfset l = "#l#:#locationCode#">
									</cfif>
								</cfloop>
								
								<cfquery name="EventIndicator" 
								 datasource="appsTravelClaim" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								  SELECT *
								  FROM   Ref_ClaimEventIndicator I, 
								         Ref_Indicator R 
								  WHERE  I.IndicatorCode = R.Code 
								  AND    I.EventCode   = '#Event#' 										 
								  AND    R.Category  IN (SELECT Code 
								                         FROM Ref_IndicatorCategory 
														 WHERE ClaimSection = 'Period')
								  AND    R.Code IN (SELECT I.IndicatorCode 
								                    FROM   Ref_ClaimCategoryIndicator I, 
													       ClaimRequestLine R
													WHERE  I.ClaimCategory = R.ClaimCategory
													 AND   R.ClaimRequestId = '#Claim.ClaimRequestid#') 
								  AND   R.Operational = 1	
								  AND   LinePercentage > 0				 
								  ORDER BY R.CheckExclusive DESC,
								           R.LineInterface, 
								           R.Category, 
										   R.ListingOrder 
								</cfquery>
											
							
							</cfif>
													 
						    <cfset claimid = URL.ClaimId>
							
							<cfif DayofWeek(CalendarDate) eq "7" or  DayofWeek(CalendarDate) eq "1">
							 	<cfset col = "ffffbf">
							<cfelse>
							 	<cfset col = "ffffff">
							</cfif> 										
							
							<cfparam name="top" default="1">		
																										
								<cfif ClaimTripStop neq "">
								
									   <!--- header section --->
																																		
										<cfif top eq "1">
																			
											<tr>	
										
											  <td align="center" width="20" height="30"
											   style="border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver;"></td>
											   
											  <td width="80" 
											  style="border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver;" 
											  height="30" align="left">&nbsp;<b>Date</td>
											  
											  <td style="border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver;" 
											  align="left" height="30">&nbsp;<b>City/Country 
											  </td>	
											  
											  <td style="border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver;" 
											  align="left" height="30"><b>&nbsp;DSA Location rate</b>
											  </td>	
																					  										  
											  <td style="border-left: 0px solid silver; border-top: 1px solid silver; border-bottom: 1px solid silver;" 
											  align="right" height="30"> 
											  <cfset header = 1>	
											 
											  <cfinclude template="ClaimDateIndicator.cfm"> 
											  <cfif top eq "1">
											       <cfset top = 0>
											  </cfif>
											  </td>	
											  										  
									  	 </tr>
																												
										</cfif>			
										
										<!--- group banner section : check box --->																
																															
										<tr bgcolor="ECF5FF">
										
										     <td align="center" width="20" 
											   style="border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 1px solid silver;">
											 </td>
											   
											 <td width="80" 
											  style="border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 1px solid silver;" 
											  align="center"></td>
											  
											 <td width="15%" style="border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 1px solid silver;" 
											  align="center">
																					
											    <cfset cont = "0">
												<cfset cou = LastMoment.LocationCountry>
												<cfset cit = LastMoment.CountryCityId>
												<cfset loc = LocationCode>											
											
												&nbsp;					
												<cfif LastMoment.ClaimTripMode eq "Departure">		
																					   
												    <cfset pointer = "1">
																									
													<cfquery name="NextMoment" 
													datasource="appsTravelClaim" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
																						
														SELECT 	  TOP 1 T.*, C.*	
														FROM      ClaimEvent Ev,
														          ClaimEventTrip T,
																  Ref_CountryCity C
														WHERE     Ev.ClaimId = '#URL.ClaimId#'
														AND       Ev.ClaimEventId = T.ClaimEventId
														AND       T.ClaimTripDate > '#calendardate#'
														AND       T.ClaimEventId IN (SELECT ClaimEventId 
														                             FROM   ClaimEventPerson 
																					 WHERE  PersonNo = '#PersonNo#')
														AND       C.CountryCityId = T.CountryCityId
														<!--- take the last time for a date in a location --->
														AND       T.ClaimTripDate IN (
																			SELECT 	  TOP 1 ClaimTripDate	
																			FROM      ClaimEvent Ev,
																					  ClaimEventTrip T
																			WHERE     Ev.ClaimId = '#URL.ClaimId#'
																			AND       Ev.ClaimEventId = T.ClaimEventId
																			AND       T.ClaimTripDate > '#calendardate#'																															
																			ORDER BY  LocationDate )																		
														ORDER BY  LocationDate DESC, ClaimTripStop			
													</cfquery>																								
													
																									
													<cfif NextMoment.recordcount eq "1">
													  <cfset list = "Travelling to #NextMoment.LocationCity#">
													  <cfset cit = NextMoment.CountryCityId>
													  <cfset stp = NextMoment.ClaimTripStop>
													  <cfset cou = NextMoment.LocationCountry>	
													<cfelse>
													  <cfset list = "Travelling from #LastMoment.LocationCity#">
													</cfif>

<!---	MKM: 12-Nov-2008				This is bad.								
	It always removes entries for the first travel day. 
	
													 <!--- remove meal entries --->
													  <cfquery name="Meal" 
														datasource="appsTravelClaim" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
													  DELETE FROM ClaimLineDateIndicator
													  WHERE ClaimId = '#URL.ClaimId#'
													  AND CalendarDate = '#calendardate#'
													  AND IndicatorCode IN('T04', 'T041', 'T042', 'T043')
													  </cfquery>			
--->																									
											    <cfelseif LastMoment.ClaimTripStop neq "0">
													<cfset pointer = "1">
													<cfset cit = LastMoment.CountryCityId>
													<cfset stp = LastMoment.ClaimTripStop>
													<cfset list = "#LastMoment.LocationCity#">
											    <cfelseif CurrentRow eq Recordcount>
												    <cfset pointer = "0">	
													<cfset cit = LastMoment.CountryCityId>
													<cfset stp = LastMoment.ClaimTripStop>
													<cfset list = "#LastMoment.LocationCity#">
													<!---	9/12/07										
													<cfset list = "return">
													--->
												<cfelse>
													<cfset pointer = "1">
													<cfset cit = LastMoment.CountryCityId>
													<cfset stp = LastMoment.ClaimTripStop>
													<cfset list = "#LastMoment.LocationCity#">
												</cfif>
												
											 <td width="25%"
											  style="border-left: 1px solid silver; border-top: 0px solid silver; border-bottom: 1px solid silver;" 
											  align="right"><cfif editclaim eq "1">Select all:</cfif></td>
																						
											<td align="right" 
													style="border-top: 0px solid silver; border-left: 0px solid silver;border-bottom: 1px solid silver;">
													
													  <cfset header = 1>													  										  						 						
													  <cfinclude template="ClaimDateIndicator.cfm">														
											</td>
																							
										</tr>
																
									<cfelse>
									
											<cfset cont = "1">		
											<cfparam name="list" default="">
											<cfparam name="cou" default="">
											<!--- disabled 29/3/2008 --->											
											<cfset cou  = cou>									
										
									</cfif>
									
									<!--- lines --->
																																	
										<tr bgcolor="#col#">
																					
											<td align="center" 
											
											style="<cfif #cont# is 0>border-top: 1px solid d4d4d4</cfif>; border-left: 1px solid d4d4d4; border-right: 1px solid d4d4d4;">
											#CurrentRow#</td>
											<td style="<cfif #cont# is 0>border-top: 1px solid d4d4d4</cfif>;border-left: 1px solid d4d4d4;">
											     &nbsp;#DateFormat(CalendarDate,"DDD DD MMM")#											
											</td>
											
											<input type="hidden" 
											       name="#Per#_#CurrentRow#_CalendarDate" 
												   value="#DateFormat(CalendarDate, CLIENT.DateFormatShow)#">
																												
											<td style="<cfif #cont# is 0>border-top: 1px solid d4d4d4</cfif>;border-left: 1px solid d4d4d4;">
												   &nbsp;#list# [#cou#]								
											</td>												 
											<td style="<cfif #cont# is 0>border-top: 1px solid d4d4d4</cfif>;border-left: 1px solid d4d4d4;">
												   &nbsp;	
												   <cfinclude template="ClaimEventEntryDSARate.cfm">											
										     </td>									
										
											<td align="right" style="<cfif #cont# is 0>border-top: 1px solid d4d4d4</cfif>">
											 	<cfset header = "0"> 																		  							 
												<cfinclude template="ClaimDateIndicator.cfm">
											</td>
										
									</tr>
																							
						 </cfif>
											
						<tr><td colspan="5" height="1" bgcolor="EAEAEA"></td></tr>
						
						<cfset pcou = cou>
						
						</cfloop>												
			
			</cfif>
			
	</cfoutput>
	</table>
<cfoutput>
<cfif claim.actionStatus lte "1" and editclaim eq "1">
   <tr><td height="1" colspan="#cols#" valign="bottom" bgcolor="C0C0C0"></td></tr>
   <tr><td valign="bottom" colspan="#cols#" height="35" align="center">

	   <cfif Object.recordcount eq "0" and Claim.ExportNo is "">
		    <cfset reset = "1">			
		<cfelse>
	    	<cfset reset = "0">		
		</cfif>
		
			 
	   <cf_Navigation
			 Alias         = "AppsTravelClaim"
			 Object        = "Claim"
			 Group         = "TravelClaim" 
			 Section       = "#URL.Section#"
			 Id            = "#URL.ClaimId#"
			 ButtonClass   = "ButtonNav1"
			 BackEnable    = "1"
			 HomeEnable    = "#reset#"
			 ResetEnable   = "#reset#"
			 ProcessEnable = "0"
			 NextSubmit    = "1"
			 NextEnable    = "1"
			 SetNext       = "0"
			 NextMode      = "1">
					 
	</td></tr>	 
</cfif>		
</cfoutput>
</cfform>
</table> 