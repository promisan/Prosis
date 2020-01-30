
<!--- Script to apply all the items of the request based on the defined template --->

<cfquery name="get"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Request
	WHERE    RequestId = '#Object.ObjectKeyValue4#'	 
</cfquery>		

<cfquery name="getType"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_Request
	WHERE    Code = '#get.RequestType#'	 
</cfquery>		

<cfif getType.TemplateApply neq "">
	<cfinclude template="#getType.TemplateApply#">
</cfif>

