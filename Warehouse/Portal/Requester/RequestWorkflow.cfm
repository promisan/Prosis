
<cfquery name="Request" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM RequestHeader		
	WHERE  RequestHeaderid = '#url.ajaxid#'	
</cfquery>

<cfquery name="RequestType" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Request		
	WHERE  Code = '#Request.RequestType#'	
</cfquery>
	
<cfparam name="url.action" default="">	
			
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
	
<cfset wflink = "Warehouse/Application/StockOrder/Request/Create/Document.cfm?drillid=#url.ajaxid#">
					
<cf_ActionListing 
	EntityCode       = "WhsRequest"
	EntityClass      = "#Request.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#Request.mission#"
	OrgUnit          = "#Request.orgunit#"		
	PersonEMail      = "#Request.EmailAddress#"
	ObjectReference  = "#Request.Reference#"
	ObjectReference2 = "#RequestType.description#"						
	ObjectKey4       = "#url.ajaxid#"
	AjaxId           = "#url.ajaxid#"
	ObjectURL        = "#wflink#"
	Reset            = "No"
	Show             = "Yes"
	ToolBar          = "Hide">
		
</td></tr>			
</table>