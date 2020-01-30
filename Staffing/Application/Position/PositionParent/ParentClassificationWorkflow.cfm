
<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#URL.ajaxid#'	 
</cfquery>

<cfset link = "Staffing/Application/Position/PositionParent/ParentClassificationWorkflow.cfm?id2=#url.ajaxid#">			
	
<cf_ActionListing 
    EntityCode       = "PostClassification"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	tablewidth       = "98%"
	Mission          = "#Parent.mission#"	
	ObjectReference  = "Classification"
	ObjectReference2 = "#Parent.PostGrade#" 	
    ObjectKey1       = "#url.ajaxid#"	
	AjaxId           = "#URL.ajaxId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	HideCurrent      = "No">
 	
	
