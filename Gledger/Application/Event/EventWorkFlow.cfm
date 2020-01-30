
<!--- worflow object --->

<cfset link = "Gledger/Application/Event/EventView.cfm?ID=#url.ajaxid#">

<cfquery name="Get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Event
		WHERE  EventId = '#URL.AjaxId#'
</cfquery>
		
<cf_ActionListing 
	EntityCode       = "GLEvent"
	EntityClass      = "#get.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""		
	Mission          = "#get.mission#"
	OrgUnit          = "#get.OrgUnit#"
	ObjectReference  = "#Get.EventDescription#"			   
	ObjectKey4       = "#Get.EventId#"
	AjaxId           = "#Get.EventId#"
	ObjectURL        = "#link#"
	Show             = "Yes"		
	Toolbar          = "Yes">