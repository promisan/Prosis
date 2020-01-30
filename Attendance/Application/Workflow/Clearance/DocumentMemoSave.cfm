
<cfset val = evaluate("Form.Memo_#url.personno#")>
		
<cfquery name="save" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  OrganizationActionPerson
		SET     Remarks          = '#val#'
		WHERE   OrgUnitActionId  = '#url.id#' 
		AND     PersonNo         = '#url.personno#'
</cfquery>	
	