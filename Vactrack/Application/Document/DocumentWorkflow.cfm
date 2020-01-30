
<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Document
	WHERE DocumentNo = '#URL.ajaxId#'
</cfquery>

<cfquery name="Position" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Position
	WHERE PositionNo = '#Doc.PositionNo#'
</cfquery>

<cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#url.ajaxid#&IDCandlist=ZoomIn&ActionId=undefined">
 					
<cf_ActionListing 
    ReadMode         = "read_uncommitted"     
    TableWidth       = "100%"
    EntityCode       = "VacDocument"
	EntityClass      = "#Doc.EntityClass#"
	EntityGroup      = "#Doc.Owner#"
	EntityStatus     = ""		
	Mission          = "#Doc.Mission#"
	OrgUnit          = "#Position.OrgUnitOperational#"
	ObjectReference  = "#Doc.FunctionalTitle#"
	ObjectReference2 = "#Doc.Mission# - #Doc.PostGrade#"
	ObjectKey1       = "#Doc.DocumentNo#"	
	AjaxId           = "#URL.ajaxId#"
  	ObjectURL        = "#link#"
	DocumentStatus   = "#Doc.Status#">
		
