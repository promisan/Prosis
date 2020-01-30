
<cfparam name="Form.MarginTop" default="2">

<cfquery name="Doc" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE OrganizationObjectActionReport 
	SET    DocumentMarginTop = '#Form.MarginTop#'
	WHERE  DocumentId        = '#url.documentid#'
</cfquery>	

<cf_compression>