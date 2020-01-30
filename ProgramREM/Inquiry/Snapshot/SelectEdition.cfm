

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT *
   FROM Ref_AllotmentEdition 
   WHERE EditionId IN (SELECT EditionId
						FROM ProgramAllotmentRequest
						WHERE ProgramCode IN (SELECT ProgramCode 
						                      FROM   Program 
											  WHERE   Mission = '#url.mission#'
											 )
					 )						 
</cfquery>

<cfoutput>
	<select name="EditionId" class="regularxl">        	
       <cfloop query="Edition">
       	<option value="#EditionId#">#Description#</option>
       	</cfloop>
	</select>
</cfoutput>	