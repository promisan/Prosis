<cfquery name="Item" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Item 
		 WHERE  ItemNo = '#url.ajaxid#'		
</cfquery>

<cfset link = "Warehouse/Maintenance/Item/RecordEdit.cfm?id=#url.ajaxid#&mode=workflow">

<cf_ActionListing 
    EntityCode       = "WhsItem"
	EntityClass      = "Standard"
	EntityClassReset = "1"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#Item.Mission#"
	OrgUnit          = ""
	ObjectReference  = "#Item.ItemNo#"
	ObjectReference2 = "#Item.ItemDescription#"
	ObjectKey1       = "#Item.ItemNo#"			
  	ObjectURL        = "#link#"
	Show             = "Yes"
	ActionMail       = "Yes"
	AjaxId           = "#URL.AjaxId#"	
	PersonNo         = ""
	PersonEMail      = ""
	TableWidth       = "100%"
	DocumentStatus   = "0">		
	