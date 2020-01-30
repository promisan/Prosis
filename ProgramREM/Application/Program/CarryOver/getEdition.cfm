
<!--- show relevant editions --->

<cfquery name="Period" 
	datasource="AppsProgram"  
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	SELECT *
		FROM   Ref_Period
		WHERE  Period = '#URL.Period#' 
</cfquery>	 
  
<cfquery name="EditionList" 
	  datasource="AppsProgram"  
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	
		    SELECT  E.*, 
			        R.Description as VersionName
			FROM    Ref_AllotmentEdition E INNER JOIN 
			        Ref_AllotmentVersion R ON  R.Code = E.Version
				    LEFT OUTER JOIN Ref_Period P ON P.Period = E.Period
			WHERE   E.Mission     = '#URL.Mission#'		
			
			AND     (
			
			         <!--- select the periods to show for allotment entry, which may or may not be the actual execution  --->
					 
			         E.Period IN (
		                    
							SELECT Period 
		                    FROM   Ref_Period 
							
							<!--- expiration date of period lies after the start date of the planning period --->
						    WHERE  DateExpiration  >= '#Period.DateEffective#'
							
							<cfif Period.isPlanningPeriodExpiry neq "">
							<!--- expiration date of period lies before the scope of the planning period --->
							AND    DateExpiration <= '#Period.isPlanningPeriodExpiry#'						
							</cfif>
																		
							<!--- period is NOT a planning period itself 
							Hanno 10/10/2012 : this needs review, better to drop the isPlanning period and
							let is be defined on the dbo.missionperiod level if a period is a plan period.
							The below prevents for example in OICT to show B14-15 to be recorded under
							plan period B12-13, which is not the intention hence it was removed.
							
							
							AND    Period NOT IN (SELECT PP.Period 
							                      FROM   Organization.dbo.Ref_MissionPeriod PP, 
												         Ref_Period RE
												  WHERE  PP.Mission   = '#url.mission#'
												  AND    PP.Period    = Re.Period
												  AND    PP.Period   != '#URL.Period#'
												  AND    Re.IsPlanningPeriod = 1)		
												  
												   --->							
												  
																		  								
							) 
							
													
					OR 
					
					   E.Period is NULL
				    )
				   
			AND     EditionClass  = 'Budget'			
				
			ORDER BY PeriodClass,DateEffective
</cfquery>	
		  						
<select id="editionselect" name="editionselect" class="regularxl">						
	<cfoutput query="editionList">
		<option value="#editionid#" <cfif period eq url.period>selected</cfif>>#Description# <cfif period neq "">(#Period#)</cfif></option>
	</cfoutput>
</select>