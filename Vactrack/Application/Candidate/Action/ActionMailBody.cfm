
<!--- view --->

<cfquery name="mail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT      TOP 1 *
	    FROM        OrganizationObjectActionMail
		WHERE       ThreadId = '#url.Threadid#'	
		AND         SerialNo = '#url.serialNo#'				
</cfquery>

<cfoutput>
#Mail.MailBody#		
</cfoutput>
