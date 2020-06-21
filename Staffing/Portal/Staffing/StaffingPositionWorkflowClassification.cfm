
<cfquery name="Parent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#positionparentid#'	 
</cfquery>

<cfset link = "Staffing/Application/Position/PositionParent/ParentClassificationWorkflow.cfm?id2=#positionparentid#">			
		
<cf_ActionListing 
    EntityCode       = "PostClassification"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	tablewidth       = "100%"
	Mission          = "#Parent.mission#"	
	ObjectReference  = "Classification"
	ObjectReference2 = "#Parent.PostGrade#" 	
    ObjectKey1       = "#Parent.PositionParentId#"	
	AjaxId           = "#URL.ajaxId#"
	ObjectURL        = "#link#"
	Show             = "Mini"
	HideCurrent      = "No">
 	
 		
	
	
	