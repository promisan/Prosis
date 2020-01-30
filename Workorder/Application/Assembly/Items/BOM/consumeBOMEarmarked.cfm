
<cfinvoke component="Service.Process.WorkOrder.WorkOrderLineResource" 
	  method		= "BOMConsumption" 
      workorderid   = "#workorderId#"
	  workorderline = "#workorderline#">				  
	  
<!--- refresh --->

<cfquery name="Workorder" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT    *
			FROM      Workorder
		    WHERE     WorkorderId = '#workorderid#'    									  
		</cfquery>		

<cfset url.mission = workorder.mission>

<cfinclude template="ItemListingContent.cfm">

<script>
	Prosis.busy('no')
</script>
