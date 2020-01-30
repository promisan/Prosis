
<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT AuditId
	FROM   ProgramIndicatorAudit 
	WHERE  AuditId = '#URL.ID1#'
	<!---  AND    AuditStatus != '0' --->
	UNION ALL
	SELECT AuditId
	FROM   ProgramAllotmentRequestQuantity 
	WHERE  AuditId = '#URL.ID1#'	
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Purge" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_Audit 
		WHERE  AuditId = '#URL.ID1#'
	</cfquery>
	
<cfelse>

	<cf_message message="You have one or more observations or allotment request under this audit moment. Operation not allowed.">	
	<cfabort>

</cfif>

<cfinclude template="Audit.cfm">		  


	

