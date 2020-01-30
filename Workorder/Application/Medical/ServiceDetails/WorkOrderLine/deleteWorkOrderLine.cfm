
<!--- delete workplan, delete actions, delete workorderline --->


<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     WorkOrderLine WL INNER JOIN
	             WorkOrder W ON WL.WorkOrderId = W.WorkOrderId 
		WHERE    WorkOrderLineId = '#url.drillid#'		
	</cfquery>	 
	
<cfset vDate = "">	
	
<cfif get.actionStatus eq "3">	

	<cfoutput>
	<script>
	 alert("This action is no longer supported")	 
	</script>
	</cfoutput>

<cfelse>

	<cftransaction>

		<cfquery name="getPlan" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT * FROM WorkPlanDetail
			  WHERE WorkActionId IN (
				SELECT   WorkActionId 
				FROM     WorkOrderLineAction
				WHERE    WorkOrderId   = '#get.WorkOrderId#'		
				AND      WorkOrderLine = '#get.WorkOrderLine#'
				)
		</cfquery>	 	

		<cfset vDate = GetPlan.DateTimePlanning>

		
		<cfquery name="deleteplan" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE FROM WorkPlanDetail
			  WHERE WorkActionId IN (
				SELECT   WorkActionId 
				FROM     WorkOrderLineAction
				WHERE    WorkOrderId   = '#get.WorkOrderId#'		
				AND      WorkOrderLine = '#get.WorkOrderLine#'
				)
		</cfquery>	 	
			
		<cfquery name="deleteaction" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE   FROM WorkOrderLineAction
			  WHERE    WorkOrderId   = '#get.WorkOrderId#'		
			  AND      WorkOrderLine = '#get.WorkOrderLine#'
		</cfquery>	 	
		
		<cfquery name="deleteline" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  UPDATE   WorkOrderLine
			  SET      Operational = 0, 
			           ActionStatus = '9'
			  WHERE    WorkOrderId   = '#get.WorkOrderId#'		
			  AND      WorkOrderLine = '#get.WorkOrderLine#'
		</cfquery>	 

		<cfquery name="checkWO" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM    	WorkOrderLine 
			  WHERE    	WorkOrderId   = '#get.WorkOrderId#'	
			  AND 		actionStatus  !='9'
		</cfquery>	 
		<cfif checkWo.recordcount lte 0>
			<cfquery name="deletewo" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  UPDATE   WorkOrder
			  SET      ActionStatus 	= '9'
			  WHERE    WorkOrderId   	= '#get.WorkOrderId#'
			</cfquery>
		</cfif>
	
	</cftransaction>
	
	<cfoutput>
	<script>
	 <cfif vDate neq "">
	 	try { opener.calendardetail('#URLEncodedFormat(vDate)#')} catch(e) {}
	 </cfif>	
	 try { opener.applyfilter('','','content') } catch(e) {}
	 
	 ptoken.location('#session.root#/WorkOrder/Application/Medical/ServiceDetails/WorkOrderLine/WorkOrderLineView.cfm?drillid=#url.drillid#')
	</script>
	</cfoutput>
	
</cfif>	



	


	
