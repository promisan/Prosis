
<cfif url.action eq "true">
   <cfset status = "1">
<cfelse>
   <cfset status = "0">
</cfif>

<cfquery name="Notes" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  OrganizationObjectActionMail
		SET ActionStatus = '#status#'
		WHERE    Threadid = '#url.id#'		
</cfquery>	