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

<cfif parameter.budgetEarmarkMode eq "0"> 
	
	<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ProgramAllotmentEarmark
	    WHERE  ProgramCode     = '#url.programCode#' 
	    AND    Period          = '#url.period#' 
	    AND    ProgramCategory = '#url.category#'
		AND    EditionId       = '#url.editionid#'	
	</cfquery>

	<cfif check.recordcount gte "2">

	<cfquery name="Delete" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ProgramAllotmentEarmark		
		WHERE  ProgramCode      = '#url.programCode#' 
	    AND    Period           = '#url.period#' 
	    AND    ProgramCategory  = '#url.category#'
		AND    EditionId        = '#url.editionid#'		
	</cfquery>
	
	</cfif>
	
</cfif>	

<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Percentage 
	FROM   ProgramAllotmentEarmark
    WHERE  ProgramCode     = '#url.programCode#' 
    AND    Period          = '#url.period#' 
    AND    ProgramCategory = '#url.category#'
	AND    EditionId       = '#url.editionid#'
	<cfif parameter.budgetEarmarkMode eq "1"> 
	AND    Resource        = '#url.resource#'
	</cfif>
</cfquery>

<cfif not LSIsNumeric(url.percentage)>

    <script>	
		 alert("Incorrect percentage")
	</script>
	<cfabort>
</cfif>

<cfif check.recordcount eq "1">

	
	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentEarmark
		SET    Percentage       = '#url.percentage#',
		       OfficerUserId    = '#SESSION.acc#',
			   OfficerLastName  = '#SESSION.last#',
			   OfficerFirstName = '#SESSION.first#' 
		WHERE  ProgramCode      = '#url.programCode#' 
	    AND    Period           = '#url.period#' 
	    AND    ProgramCategory  = '#url.category#'
		AND    EditionId        = '#url.editionid#'
		AND    Resource         = '#url.resource#' 
	</cfquery>
		
<cfelseif check.recordcount eq "0">

	<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramAllotmentEarmark
				(ProgramCode,
				 Period, 
				 EditionId, 
				 Resource, 
				 ProgramCategory, 
				 Percentage, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
		VALUES ('#url.programCode#',
		        '#url.period#',
				'#url.editionid#',				
				'#url.resource#',
				'#url.category#',
				'#url.percentage#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#') 
				
	</cfquery>

</cfif>	

<!--- apply values --->

<cfoutput>

	<script>
		ColdFusion.navigate('#SESSION.root#/programrem/Application/Budget/Earmark/CostAllocationUpdate.cfm?field=total&programcode=#url.programCode#&period=#url.period#&editionid=#url.editionid#&resource=#url.resource#&category=#url.category#','#url.editionid#_#url.row#_#url.rowline#')
		ColdFusion.navigate('#SESSION.root#/programrem/Application/Budget/Earmark/CostAllocationUpdate.cfm?field=percentage&programcode=#url.programCode#&period=#url.period#&editionid=#url.editionid#&resource=#url.resource#&category=#url.category#','#url.editionid#_#url.row#_percentage')
		ColdFusion.navigate('#SESSION.root#/programrem/Application/Budget/Earmark/CostAllocationChart.cfm?programcode=#url.programCode#&period=#url.period#&editionid=#url.editionid#&area=#url.area#','chart_#url.editionid#')
	</script>
	
</cfoutput>
