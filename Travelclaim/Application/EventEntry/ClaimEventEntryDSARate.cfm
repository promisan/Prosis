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
<cfoutput>

<!--- 
1.1 current or desination city identified in var ; cit
1.2 status of the citi : stopover or regular
2. valid DSA location for cities available in memory var : Query DSABase

In this function :

3.1 if  stp = 1, take next cities DSA codes as well
3.2.if stp = 0, take current citi DSA codes only

4. If determined default DSA code <> recorded DSA code : update ClaimLineDSA
--->

<cfoutput>
<cfsavecontent variable="isValidDSA">
	AND     (DateEffective is NULL or DateEffective = '' or DateEffective <= #dte#)
	AND     (DateExpiration is NULL or DateExpiration = '' or DateExpiration >= #dte#)	
</cfsavecontent>
</cfoutput>

<cfset indicatorCode = "P02">
<cfif editclaim eq "0">
	<cfset dis = "disabled">
<cfelse>
	<cfset dis = ""> 	
</cfif>

<cfparam name="VerDSA.recordcount" default="0">
<cfparam name="stp" default="init">
<cfparam name="returning" default="0">

<!--- if last record, look at the prior date for the DSA --->

<cfif currentrow eq recordcount or (currentrow+1 eq recordcount and stp eq "1")>

	<cfif returning eq "0">
		
		<CF_DateConvert 
		    Value="#DateFormat(calendardate-1, CLIENT.DateFormatShow)#"
			Status = "0">	
			
		<cfset seldte = dateValue>
						
	</cfif>
	
	<cfset returning = 1>
	
</cfif>		

<cfif currentrow eq 1>
	 <cfset departing = 1>	
<cfelse>
     <cfset departing = 0>	 
</cfif>

<cfif cont eq "0" 
     or VerDSA.recordcount eq "init">	
	 	 	 	 		  		   
	       <cfif stp gte "1" or find("Travel",  list)>									
								     
				<!--- 3.1 stopover city, does never have hotel rates --->
				
				<cfquery name="VerDSA" 
			    dbtype="query">
				    SELECT  DISTINCT CountryCityId,LocationCode,LocationCountry,Description
					FROM    DSABase					
					<cfif departing eq "1" and stp eq "0">
					WHERE   CalendarDate > #dte# 
					<cfelseif departing eq "1" and stp eq "1">
					WHERE   CalendarDate >= #dte# and CountryCityId != #depcity#
					<cfelseif returning eq "1">
					WHERE   CalendarDate >= #seldte# and CountryCityId != #depcity#
					<cfelse>
					WHERE   CalendarDate >= #dte# and CountryCityId != #depcity#					
					</cfif>					
					AND     HotelRate = 0
					        #preserveSingleQuotes(isValidDSA)#					
				</cfquery>	
									
												
				<cfquery name="Special" 
			    dbtype="query">
				  	SELECT  DISTINCT CountryCityId, LocationCode, LocationCountry,
					                 Description 
					FROM    DSABase
					<cfif returning eq "0">
					WHERE   CalendarDate >= #dte# 
					<cfelse>
					WHERE   CalendarDate = #seldte# 
					</cfif>							
					AND     (HotelRate = 1 or SeasonalRate = 1)
					#preserveSingleQuotes(isValidDSA)#	
				</cfquery>	
								
			 	
		   <cfelse>	 
		  
			   <!--- 3.2 regular city --->
				
			   	<cfquery name="VerDSA" 
			    dbtype="query">
				  	SELECT  DISTINCT CountryCityId, LocationCode, LocationCountry, Description
					FROM    DSABase
					WHERE   CalendarDate = #dte# 
					#preserveSingleQuotes(isValidDSA)#	
				</cfquery>	
				
				<cfquery name="Special" 
			    dbtype="query">
				  	SELECT  DISTINCT CountryCityId, LocationCode, LocationCountry, Description
					FROM    DSABase
					WHERE   CalendarDate = #dte# 
					AND     (HotelRate = 1 or SeasonalRate = 1)
					#preserveSingleQuotes(isValidDSA)#	
				</cfquery>				
				 
			</cfif>		 
			
											
</cfif>

<cfset dt = dateformat(dte,CLIENT.DateFormatShow)>

<cfif VerDSA.recordcount eq "0">

	 <!--- no rate is found for that date --->	

	 <script>
		  window.location = "ClaimDateIndicatorError.cfm?id=country:#cou#-#DSABase.recordcount#-#VerDSA.recordcount#-#dt#" 
	 </script>
	 <cfabort>
	 	 	 
<cfelseif VerDSA.recordcount eq "1">

		<!--- one rate is found for that date --->			
	
		<cfif verdsa.locationCode neq LocationCode>
		
			<cfif claim.claimasis eq "0">
		
			<cfquery name="Update" 
			 datasource="appsTravelClaim" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE ClaimLineDSA
			 SET     <!--- CountryCityId    = '#cit#', --->
			        LocationCode     = '#verdsa.locationCode#'   
			 WHERE  ClaimId       = '#claimid#' 
			 AND    PersonNo      = '#Per#'
			 AND    CalendarDate  = #dte#
			</cfquery>
			
		   </cfif>	
				
		</cfif>		
										
		#verdsa.locationCode# #verdsa.Description#
		
		<input type="hidden" value="" name="#fld#_#IndicatorCode#">		 
					
<cfelse>

		<!--- determine best possible code
		0. if location <> "", take already recorded location from the running days query		
		else :
		1. case of stopover city, show codes of stopover city first
		2. case of several codes for a stopover city (hotels) take the cde also recorded in request 
		--->
				
		<cfif locationCode neq "">	
		
		     <!--- was aleady updated previosuly when loaded --->	
					
			<cfset def = LocationCode>		
									
		<cfelse>
		
			<!--- A. stopover or travelling --->			
							
			<cfif stp eq "1" or find("Travel",  list)>
					
				<cfquery name="Location" 
			     dbtype="query">
				 SELECT   *
				 FROM     DSABase
				 <cfif returning eq "1">
				 WHERE    CountryCityId = #returncity# 
				 AND      CalendarDate <= #dte#	
				 <cfelse>
				 WHERE    LocationCountry = '#cou#' 
				 AND      CalendarDate >= #dte#	
				 #preserveSingleQuotes(isValidDSA)#	
				 </cfif>								
				 ORDER BY LocationDefault DESC 
				</cfquery>		
				
																			
				<cfparam name="pcou" default="">
									
				<cfif location.recordcount eq "0">
			
					<!--- prior country --->	
				
					<cfif pcou neq "">					
								
						<cfquery name="Location" 
					     dbtype="query">
							 SELECT   *
							 FROM     DSABase
							 WHERE    LocationCountry = '#pcou#' 
							 #preserveSingleQuotes(isValidDSA)#	
							 ORDER BY LocationDefault DESC 
						</cfquery>
						
						<cfif location.recordcount eq "0">
										
							 <script>
							    window.location = "ClaimDateIndicatorError.cfm?id=country:#cou#-#DSABase.recordcount#-#VerDSA.recordcount#-#dt#" 
							 </script>
							 <cfabort>
						 
						</cfif> 
					
					<cfelse>
				
							 <script>
							     window.location = "ClaimDateIndicatorError.cfm?id=country:#cou#-#DSABase.recordcount#-#VerDSA.recordcount#-#dt#" 
							 </script>	
							 <cfabort>
								
					</cfif>
							
	 
				 	<cfset def = Location.LocationCode>		
									
			    <cfelse>								
																					
					<cfquery name="Location" 
					     dbtype="query">
						 SELECT   *
						 FROM     DSABase
						 <cfif returning eq "1">
						 WHERE    CountryCityId = #returncity#
						 <cfelse>
						 WHERE    LocationCountry = '#cou#' 
						 </cfif>
						 #preserveSingleQuotes(isValidDSA)#		
						 ORDER BY LocationDefault DESC  
					</cfquery>
							
					<cfset def = Location.LocationCode>		
															
					<!--- now check for any potential season or hotel dsa rates in the listing --->
										
					<cfif special.recordcount gte "1">
										
					    <!-- find default from claim request --->
																		
						<cfloop query="verdsa">
						 <cfif locationcountry eq cou>
							 <cfif find(locationcode, reqdsa)>							
							    <cfset def = LocationCode>
							 </cfif>	
						 </cfif>				
						</cfloop> 	
					
					</cfif>
				
			   </cfif>
			 
			   
		   <cfelse>
		   				
				<!--- regular travel stop = 0 --->
				
				<!--- xxxxxx ensure the location is valid for the calendar date --->
			
				<cfquery name="Location" 
				     dbtype="query">
					 SELECT   *
					 FROM     DSABase
					 WHERE    LocationCountry = '#cou#' 
					 AND      CalendarDate = #dte#	
					 #preserveSingleQuotes(isValidDSA)#	
					 ORDER BY LocationDefault DESC 
				</cfquery>
				
				<cfset def = Location.LocationCode>	
				
				<!--- find potential better defaults if hotel rates are enable --->				
			
				<cfif special.recordcount gte "1">
								
					    <!-- find default from claim request --->
						
						<cfloop query="verdsa">
						
						 <cfif locationcountry eq cou>
						 	 <cfif find(locationcode, reqdsa)>							
							    <cfset def = LocationCode>
							 </cfif>					
						 </cfif>
						</cfloop> 	
											
				</cfif>
			  			 
			</cfif>	 	
		
		</cfif>				
		
		
		<!--- save the determined default --->	
		
		
		<cfif def neq LocationCode and def neq "">
		
			<cfquery name="Update" 
			 datasource="appsTravelClaim" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 UPDATE ClaimLineDSA
			 SET    LocationCode  = '#def#' 
			 WHERE  ClaimId       = '#claimid#' 
			 AND    PersonNo      = '#Per#'
			 AND    CalendarDate  = #dte#			 
			</cfquery>
				
		</cfif>		
					
								
		<cfif Claim.ActionStatus lt "3">
					   												
				<cfif special.recordcount eq "0" and stp eq "0" and not find("Travel",  list)>
										
					<cfquery name="DSA" 
					 datasource="appsTravelClaim" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT * 
					 FROM   Ref_payrollLocation
					 WHERE  LocationCode = '#def#'			
					</cfquery>
					
				    #DSA.LocationCode# #DSA.Description#
				
					<input type="hidden" value="" name="#fld#_#IndicatorCode#">		 
				
				<cfelse>
												
					<cfif claim.actionStatus gte "2">
					
						<cfquery name="DSA" 
						 datasource="appsTravelClaim" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT *
						 FROM   Ref_payrollLocation
						 WHERE  LocationCode = '#def#'			
						</cfquery>
											
				   		#DSA.LocationCode# #DSA.Description#
											
					<cfelse>
																				
						<select name="#fld#_#IndicatorCode#" style="background: Ffffef;" #dis#
						onchange="savebox('#dateformat(dte,client.datesql)#','#Per#','DSA','#IndicatorCode#',this.value)">						
							<cfloop query="VerDSA">
								<option value="#LocationCode#" 
								<cfif LocationCode eq def>selected</cfif>>#LocationCode# #Description#
								</option>
							</cfloop>
						</select>
											
					</cfif>							
				
				</cfif>
					
		<cfelse>
				
			<cfquery name="DSA" 
			 datasource="appsTravelClaim" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_payrollLocation
			 WHERE  LocationCode = '#LocationCode#'			
			</cfquery>
			
			#DSA.LocationCode# #DSA.Description# 
		
		</cfif>			
		
</cfif>	
			
</cfoutput>
