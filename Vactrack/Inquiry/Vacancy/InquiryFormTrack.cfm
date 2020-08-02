

<cfquery name="Flow"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_EntityClass
	WHERE  EntityCode = 'VacCandidate'
	AND    EntityClass IN (SELECT EntityClass 
	                       FROM Vacancy.dbo.DocumentCandidate 
						   WHERE DocumentNo IN (SELECT DocumentNo 
						                        FROM   Vacancy.dbo.Document 
												WHERE  Status != '9'
												<cfif url.mission neq "all">
												AND    Mission = #PreserveSingleQuotes(url.Mission)#
												</cfif>
											   )	
						)					   
</cfquery>

<select name="Flow" class="regularxxl">
    <option value="All" selected>All</option>
    <cfoutput query="Flow">
	<option value="#EntityClass#">
	#EntityClassName#
	</option>
	</cfoutput>
</select>