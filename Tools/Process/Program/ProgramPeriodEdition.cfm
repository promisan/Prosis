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
<cfparam name="attributes.Mission" default="">
<cfparam name="attributes.Period" default="">
<cfparam name="attributes.Version" default="">
<cfparam name="attributes.EditionId" default="">

<cfif attributes.editionid neq "">

	<cfquery name="get" 
		datasource="AppsProgram">
		    SELECT *
			FROM   Ref_AllotmentEdition
			WHERE  EditionId = '#attributes.EditionId#' 
	</cfquery>	

	<cfset version = get.Version>

<cfelse>

	<cfset version = attributes.Version>

</cfif>

<cfquery name="PlanPeriod" 
	datasource="AppsProgram">
	    SELECT *
		FROM   Ref_Period
		WHERE  Period = '#attributes.Period#' 
</cfquery>	

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE    E.Version     = V.Code
	AND      E.ControlEdit = 1		
	AND      E.Mission     = '#attributes.Mission#'   	
	AND      E.Version     = '#Version#' 	
	
		
	AND      (
	          E.Period is NULL 
	              or 
		      E.Period IN (
			               SELECT Period 
			               FROM   Ref_Period 
						   WHERE  DateExpiration >= '#PlanPeriod.DateEffective#'
						   <cfif PlanPeriod.isPlanningPeriodExpiry neq "">
						   AND   DateExpiration  <= '#PlanPeriod.isPlanningPeriodExpiry#'
						   </cfif>								   
						  						 						   
						   <!--- Period is not a plan period itself in Mission Period --->
						   
						   AND    Period NOT IN (SELECT PP.Period 
							                     FROM   Organization.dbo.Ref_MissionPeriod PP, 
												        Ref_Period RE
												 WHERE  PP.Period    = Re.Period
												 AND    PP.Mission   = '#attributes.mission#'    
												 <!--- not like the correct period --->
												 AND    PP.Period   != '#attributes.period#'
												 AND    Re.IsPlanningPeriod = 1 
												 AND    PP.isPlanPeriod = 1)	
													   
						   												
						  )							
			 )
			 
	AND      E.EditionId IN (SELECT EditionId FROM Ref_AllotmentEditionFund WHERE EditionId = E.EditionId)		
	
	ORDER BY E.ListingOrder, Period	
	
</cfquery>



<cfset caller.edition = edition>


