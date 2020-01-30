
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Check" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM OrganizationObject
		WHERE ObjectKeyValue1 = '#URL.ID#'
		AND ObjectKeyValue2 = '#URL.ID1#'
		AND Operational  = 1
</cfquery>

<cfif check.recordcount eq "0">

	 <cfquery name="Status" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE DocumentCandidate
	 SET    Status = '0'
	 WHERE  DocumentNo  = '#URL.ID#' 
	 AND    PersonNo = '#URL.ID1#'
	 </cfquery>
 
<cfelse>

	<cfquery name="Status" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE DocumentCandidate
	 SET    Status = '2s'
	 WHERE  DocumentNo  = '#URL.ID#' 
	 AND    PersonNo = '#URL.ID1#'
	 </cfquery>

</cfif> 
 
<cfoutput>

	<script language="JavaScript">
	 	window.location = "DocumentEdit.cfm?ID=#url.id#";
	</script> 

</cfoutput>


