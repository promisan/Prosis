

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Period
	FROM   ProgramAllotmentRequest
	WHERE  ProgramCode IN (SELECT ProgramCode FROM Program WHERE Mission = '#url.mission#')
</cfquery>

<cfoutput>
	<select name="Period" class="regularxl">        	
       <cfloop query="Period">
       	<option value="#Period#">#Period#</option>
       	</cfloop>
	</select>
</cfoutput>	