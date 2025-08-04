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

<!--- Hanno 8/8 this will have to be adjusted to work this on the period, in this process we check if the parent 
is indeed enabled for that period, if not, we move this to the top of the hierarchy 

1. I need to check the usage of the hierarchy for the project activity manangement : children 
2. as well as the
children in the budget execution view.
--->

<cfparam name="attributes.Mission" default="">
<cfparam name="attributes.Period" default="">

<cfquery name = "Base" 
   datasource = "AppsProgram" 
   username   = "#SESSION.login#" 
   password   = "#SESSION.dbpw#">
   SELECT   DISTINCT P.Mission, Pe.Period
   FROM     ProgramPeriod Pe INNER JOIN
            Program P ON Pe.ProgramCode = P.ProgramCode
   <cfif Attributes.Mission neq "">
	WHERE   P.Mission = '#attributes.mission#'
	AND     Pe.Period  = '#attributes.period#'
   </cfif>				  
</cfquery>

<cfloop query="Base">		

		<!---
       <cfoutput>
		#mission#-#period#<br>			  
		</cfoutput>
		--->
	
	  <cfquery name = "Reset" 
		   datasource = "AppsProgram" 
		   username   = "#SESSION.login#" 
		   password   = "#SESSION.dbpw#">
		   UPDATE   ProgramPeriod
		   SET      PeriodHierarchy = NULL
		   FROM     ProgramPeriod
		   WHERE    ProgramCode IN (SELECT ProgramCode 
		                            FROM   Program 
								    WHERE  Mission = '#mission#')      
		   AND      Period = '#period#'     						
	  </cfquery>  

	  <cfquery name = "Root" 
	   datasource = "AppsProgram" 
	   username   = "#SESSION.login#" 
	   password   = "#SESSION.dbpw#">
		   SELECT *
		   FROM   Program P
		   WHERE  Mission      = '#mission#'
		   AND    ProgramClass = 'Program' 
		   AND    ProgramCode IN ( 
		                          SELECT ProgramCode 
		                          FROM   ProgramPeriod 
								  WHERE  ProgramCode = P.ProgramCode
								  AND    Period      = '#period#'
								 )
	</cfquery>  
  
    <cfset mis = mission>
    <cfset per = Period>
  
	<cfloop query = "root">
		
		<cfif ListingOrder eq "">
			<cfset ord = "0">
		<cfelse>
			<cfset ord = listingorder>
		</cfif>	
		
		<cfset HierarchyCode = "#ord#_#ProgramCode#">
		
		<cfquery name="UPDATE" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE      ProgramPeriod
			SET         PeriodHierarchy = '#HierarchyCode#'
			WHERE       ProgramCode     = '#ProgramCode#'
			AND         Period          = '#per#'
		</cfquery>
		
		<cfquery name="Child1" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   P.ProgramCode			
			FROM     ProgramPeriod Pe, Program P
			WHERE    Pe.ProgramCode = P.ProgramCode
			AND      P.ProgramCode IN (SELECT ProgramCode 
		                               FROM   Program 
								       WHERE  Mission = '#mission#')    
			AND      Pe.Period = '#per#'		  
			AND      Pe.PeriodParentCode = '#Root.ProgramCode#'			
			ORDER BY P.ListingOrder
		</cfquery>
	
		<cfloop query="Child1">
		
		   <cfif currentRow lt 10>
		     <cfset levelA = "00#currentRow#">
		   <cfelseif currentRow lt 100>
		     <cfset levelA = "0#currentRow#">
		   <cfelse>
		     <cfset levelA = "#currentRow#">
		   </cfif>
		
			<cfquery name="Update" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE      ProgramPeriod
				SET         PeriodHierarchy = '#HierarchyCode#.#levelA#'
				WHERE       ProgramCode = '#Child1.ProgramCode#'
				AND         Period          = '#per#'				
			</cfquery>
			
			<cfquery name="Child2" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT   P.ProgramCode			
				FROM     ProgramPeriod Pe, Program P
				WHERE    Pe.ProgramCode = P.ProgramCode
				AND      P.ProgramCode IN (SELECT ProgramCode 
			                               FROM   Program 
									       WHERE  Mission = '#mis#')    
				AND      Pe.Period = '#per#'		  
				AND      Pe.PeriodParentCode = '#Child1.ProgramCode#'			
				ORDER BY P.ListingOrder			
		    </cfquery>
			
			<cfloop query="Child2">
		
			   <cfif Child2.currentRow lt 10>
			     <cfset levelB = "00#Child2.currentRow#">
			   <cfelseif Child2.currentRow lt 100>
			     <cfset levelB = "0#Child2.currentRow#">
			   <cfelse>
			     <cfset levelB = "#Child2.currentRow#">
			   </cfif>
			   
			   <cfquery name="Update" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE      ProgramPeriod
				SET         PeriodHierarchy = '#HierarchyCode#.#levelA#.#levelB#'
				WHERE       ProgramCode = '#Child2.ProgramCode#'
				AND         Period          = '#per#'				
				</cfquery>
				
				<cfquery name="Child3" 
			    datasource="AppsProgram" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT   P.ProgramCode			
					FROM     ProgramPeriod Pe, Program P
					WHERE    Pe.ProgramCode = P.ProgramCode
					AND      P.ProgramCode IN (SELECT ProgramCode 
				                               FROM   Program 
										       WHERE  Mission = '#mis#')    
					AND      Pe.Period = '#per#'		  
					AND      Pe.PeriodParentCode = '#Child2.ProgramCode#'			
					ORDER BY P.ListingOrder			
			    </cfquery>
								
				<cfloop query="Child3">
		
				   <cfif Child3.currentRow lt 10>
				     <cfset levelC = "00#Child3.currentRow#">
				   <cfelseif Child3.currentRow lt 100>
				     <cfset levelC = "0#Child3.currentRow#">
				   <cfelse>
				     <cfset levelC = "#Child3.currentRow#">
				   </cfif>
				   
				    <cfquery name="Update" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE      ProgramPeriod
						SET         PeriodHierarchy = '#HierarchyCode#.#levelA#.#levelB#.#levelC#'
						WHERE       ProgramCode = '#Child3.ProgramCode#'
						AND         Period          = '#per#'				
					</cfquery>
					
					<cfquery name="Child4" 
					    datasource="AppsProgram" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
							SELECT   P.ProgramCode			
							FROM     ProgramPeriod Pe, Program P
							WHERE    Pe.ProgramCode = P.ProgramCode
							AND      P.ProgramCode IN (SELECT ProgramCode 
						                               FROM   Program 
												       WHERE  Mission = '#mis#')    
							AND      Pe.Period = '#per#'		  
							AND      Pe.PeriodParentCode = '#Child3.ProgramCode#'			
							ORDER BY P.ListingOrder			
					</cfquery>
												
					<cfloop query="Child4">
				
						   <cfif Child4.currentRow lt 10>
						     <cfset levelD = "00#Child4.currentRow#">
						   <cfelseif Child4.currentRow lt 100>
						     <cfset levelD = "0#Child4.currentRow#">
						   <cfelse>
						     <cfset levelD = "#Child4.currentRow#">
						   </cfif>
						   
						   <cfquery name="Update" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								UPDATE      ProgramPeriod
								SET         PeriodHierarchy = '#HierarchyCode#.#levelA#.#levelB#.#levelC#.#levelD#'
								WHERE       ProgramCode     = '#Child4.ProgramCode#'
								AND         Period          = '#per#'				
						  </cfquery>
												
					</cfloop>
				
				</cfloop>
			
			</cfloop>
			
		</cfloop>
	
	</cfloop>
	
</cfloop>	

