
<!--- -------------------------------------- --->
<!--- set the resource mode from the listing --->
<!--- -------------------------------------- --->

<cfquery name="set" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE WorkOrderLineResource			
		SET    ResourceMode = '#url.value#'
		WHERE  ResourceId = '#url.ResourceId#'		
</cfquery>	


