
<!--- determine the default source for the owner and if not we take the detault of the parameter --->

<cfquery name="Doc" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#url.documentNo#' 
</cfquery>
		
<cf_ComparisonView 
    personNo="#url.PersonNo#" 
	hideperson="Yes" 
	owner="#doc.owner#" 
	layout="vertical">					
		