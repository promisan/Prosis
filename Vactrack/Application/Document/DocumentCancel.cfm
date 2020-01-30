<!--- 

1. set document status = 9
	  
--->

<cftransaction action="BEGIN">

	<cfquery name="Status" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Document
	 SET    Status = '#URL.Status#', 
	        StatusDate = getDate(), 
			StatusOfficerUserid = '#SESSION.acc#',
			StatusOfficerLastName = '#SESSION.last#',
			StatusOfficerFirstName = '#SESSION.first#'
	 WHERE  DocumentNo  = '#URL.ID#' 
	</cfquery>
	
	<cfquery name="Status" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	
		UPDATE    Organization.dbo.OrganizationObject
		SET       EntityStatus = '#URL.Status#'
		WHERE     EntityCode IN ('VacCandidate', 'VacDocument')
		AND       ObjectKeyValue1 = '#URL.ID#'
	</cfquery>	
	     
</cftransaction>

<cflocation url="DocumentEdit.cfm?ID=#URL.ID#" addtoken="No">
