
<cfset wflink = "Materials/Application/Stock/Inspection/InspectionView.cfm?inspectionid=#url.ajaxid#">
				
<cfquery name="Inspection" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    WarehouseLocationInspection M
	WHERE   InspectionId     = '#url.ajaxid#'	
</cfquery>

<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Warehouse
	WHERE   Warehouse = '#Inspection.Warehouse#'	
</cfquery>
	
<cf_ActionListing 
    EntityCode       = "WhsInspection"
	EntityClass      = "#Inspection.EntityClass#"
	EntityGroup      = "" 
	EntityStatus     = ""
	Mission          = "#Warehouse.Mission#"	
	ObjectReference  = "#Warehouse.WarehouseName#"
	ObjectReference2 = "#Inspection.Reference#"	  
	ObjectKey4       = "#url.ajaxid#"
	Ajaxid           = "#url.ajaxid#"
	Show             = "Yes"
	ToolBar          = "No"
	ObjectURL        = "#wflink#"
	CompleteFirst    = "No"
	CompleteCurrent  = "No">

	



			