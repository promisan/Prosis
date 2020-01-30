
<cfquery name="Unit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ProgramPeriod
	WHERE    ProgramCode = '#URL.ProgramCode#'
	AND      Period      = '#URL.Period#'
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Organization
	WHERE    OrgUnit = '#Unit.OrgUnit#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Mission.Mission#'
</cfquery>

<!--- Hanno 2008, limit the entry of periods based on the period class to which a tree
belongs, check how this is used for the Program Module indicator --->

<cfif Mission.recordcount eq "0">
 
  <cf_message status="Notification"
      message = "Tree or Program for this preparation period (#url.period#) was not initiated" 
	  return = "no">
  <cfabort>

</cfif>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Period 
	WHERE    Period = '#URL.Period#'	
</cfquery>


<cfquery name="PlanPeriod" 
	datasource="AppsProgram">
	    SELECT *
		FROM   Ref_Period
		WHERE  Period = '#URL.Period#' 
</cfquery>	 


<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE    E.Version     = V.Code
	AND      E.ControlEdit = 1		
	AND      E.Mission     = '#Mission.Mission#'   	
	AND      E.Version     = '#URL.Version#' 	
		
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
												 AND    PP.Mission   = '#url.mission#'    
												 <!--- not like the correct period --->
												 AND    PP.Period   != '#url.period#'
												 AND    Re.IsPlanningPeriod = 1 
												 AND    PP.isPlanPeriod = 1)		
											  
									 	
													   
						   												
						  )							
			 )
			 
	AND      E.EditionId IN (SELECT EditionId FROM Ref_AllotmentEditionFund WHERE EditionId = E.EditionId)	
	
	<cfif url.editionid neq ""> 
	AND      E.EditionId   = '#URL.EditionId#' 
	</cfif>	
	
	ORDER BY E.ListingOrder, Period	
	
</cfquery>

<!---

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition E, 
	         Ref_AllotmentVersion V
	WHERE    E.Version     = V.Code
	AND      E.ControlEdit = 1	
	AND      E.Mission     = '#Mission.Mission#'   	
	AND      E.Version     = '#URL.Version#' 
	<cfif url.editionid neq ""> 
	AND      E.EditionId   = '#URL.EditionId#' 
	</cfif>
	AND      (E.Period is NULL 
	              or 
		      E.Period IN (SELECT Period 
			               FROM   Ref_Period 
						   WHERE  DateEffective >= (SELECT DateEffective 
						                            FROM   Ref_Period  
													WHERE  Period = '#URL.Period#')
						  )							
			 )
	ORDER BY E.ListingOrder, Period 
</cfquery>

--->


<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Mission.Mission#'
</cfquery>

<cfif Edition.recordcount eq "0">

  <cf_tl id="No allotment editions were defined for" var="1" class="Message">
  <cfset vMessage=#lt_text#>
  
  <cf_tl id="fund/version" var="1">
  <cfset vFund=#lt_text#>  
  
  <tr><td>
  
  <cf_message status="Notification" message = "<cfoutput>#vMessage# #vFund# : #URL.Fund# #URL.Version#.</cfoutput>"
  return = "no">
  
  </td></tr>
  <cfabort>
  
<cfelse>

	<!--- make a stringlist --->	
	<cfset editionList   = "">
	<cfset editionSubmit = "">
	<cfset objectfilter  = "1">

	<cfoutput query="Edition">

    	<cfif editionlist eq "">
	    	<cfset editionlist = EditionId>
		<cfelse>
		    <cfset editionlist = "#editionlist#,#EditionId#">
		</cfif>
		
		<cfif BudgetEntryMode eq "0">		    
		    <cfset objectfilter = 0>
		</cfif>
			 
	</cfoutput> 

</cfif>