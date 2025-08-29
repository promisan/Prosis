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
<cfswitch expression="#url.field#">

	<cfcase value="total">
					
		<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Program
			WHERE  ProgramCode = '#url.programCode#' 	
		</cfquery>	
		
		<cfquery name="Parameter" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = '#Program.mission#' 	
		</cfquery>	
					
		<cfquery name="Resource" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT SUM(P.Amount) AS Amount
			FROM   ProgramAllotmentDetail P INNER JOIN Ref_Object O ON P.ObjectCode = O.Code 
			WHERE  P.ProgramCode = '#url.programCode#' 
			  AND  P.Period      = '#url.period#' 
			  AND  P.EditionId   = '#url.editionid#' 
			  AND  P.Status IN ('0', '1')
			  <cfif parameter.budgetEarmarkMode eq "1">
			  AND  O.Resource = '#url.resource#'	
			  </cfif>
		</cfquery>				
	
		<cfquery name="Earmark" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
	          SELECT Percentage 
		      FROM   ProgramAllotmentEarmark
		      WHERE  ProgramCode     = '#url.programCode#' 
	          AND    Period          = '#url.period#' 
			  AND    Resource        = '#url.resource#'
			  AND    EditionId       = '#url.editionid#' 
			  AND    ProgramCategory = '#url.category#'						
		</cfquery>	
		
		<cfif Earmark.Percentage neq "">
				
			<cfoutput>
				#numberformat((earmark.percentage/100)*Resource.amount,"__,__.__")#
			</cfoutput>
		
		<cfelse>
		
			<!--- nada --->
		
		</cfif>

	</cfcase>
	
	<cfcase value="percentage">
	
		<cfquery name="Earmark" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
	          SELECT sum(Percentage) as Percentage
		      FROM   ProgramAllotmentEarmark
		      WHERE  ProgramCode     = '#url.programCode#' 
	          AND    Period          = '#url.period#' 
			   AND   EditionId       = '#url.editionid#' 
			  AND    Resource        = '#url.resource#'			  				
		</cfquery>	
		
		  <cfoutput>
		  
		  <cfif earmark.percentage neq 100>
			   <font color="FF0000">#numberformat((earmark.percentage),"__._")#</font>
		  <cfelse>
				#numberformat((earmark.percentage),"__._")#
		  </cfif>
		 		
		  </cfoutput>
		
	</cfcase>

</cfswitch>



