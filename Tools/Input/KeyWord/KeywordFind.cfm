
<cfif #URL.Code# neq "">
	
	<!--- Query returning search results --->
	<cfquery name="SearchResult" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  R.ExperienceFieldId, C.Description AS Class, R.Description
	FROM    Ref_Experience R INNER JOIN
	        Ref_ExperienceClass C ON R.ExperienceClass = C.ExperienceClass
	WHERE   R.ExperienceFieldId = '#URL.Code#'
	</cfquery>
	
	<cfset l = #len(SearchResult.Class)#>
	<cfset k = #len(SearchResult.Description)#>
	
	<cfoutput>
	    <cfif #SearchResult.recordcount# eq "1">
			<input size="80" 
			       type="text" 
				   name="Keyword" 
				   id="Keyword"
				   value="#SearchResult.Class# - #SearchResult.Description#" 			   
				   readonly class="regular1">
				 
		<cfelse>
			&nbsp;Not found&nbsp;
		</cfif>
		
	</cfoutput>

</cfif>

	