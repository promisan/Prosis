<cfquery name="Exist" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   stAnnouncement
	  WHERE  VacancyNo   = '#URL.ReferenceNo#' 
</cfquery>

<cfquery name="FO" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  FunctionOrganization
		WHERE ReferenceNo   = '#URL.ReferenceNo#' 
</cfquery>

<cfif Exist.recordCount eq 0 and FO.recordcount eq "0">

	<font color="FF0000">Job opening details must be recorded!</font>
	
<cfelseif FO.recordcount gte "1">

	<font color="FF0000">Job Opening Track has been already issued!</font>
			  
</cfif>	  