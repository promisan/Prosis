
<!--- publication workflow --->

<cfquery name="Publication" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    *
	FROM      Publication
	WHERE     PublicationId = '#url.ajaxid#'  
</cfquery>	

<cfquery name="WorkOrder" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrder
	WHERE     1=1
		<cfif TRIM(Publication.WorkOrderId) neq "">
			AND WorkOrderId = '#Publication.WorkOrderId#'  
		<cfelse>
			AND WorkOrderId = '00000000-0000-0000-0000-000000000000'  
		</cfif>

</cfquery>	

<cfif WorkOrder.recordcount gte 1>

<cfset link = "WorkOrder/Application/Activity/Publication/PublicationWorkFlow.cfm?publicationid=#URL.Ajaxid#">

<cf_ActionListing 
    EntityCode      = "WrkPublish"
	EntityClass     = "Standard"
	EntityGroup     = ""
	EntityStatus    = ""
	AjaxId          = "#url.ajaxid#"
	Mission         = "#WorkOrder.Mission#"
	OrgUnit         = "#WorkOrder.OrgUnitOwner#"
	ObjectReference = "#Publication.Description#"   
	ObjectKey4      = "#url.ajaxid#"
	ObjectURL       = "#link#">

</cfif>