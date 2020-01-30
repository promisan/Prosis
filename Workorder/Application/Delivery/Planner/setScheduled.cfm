
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cfquery name="Planned"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		
		SELECT   *
	    FROM     WorkOrder AS W INNER JOIN 
		         WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 							 
	    WHERE    A.ActionClass      = 'Delivery' 				   
	    AND      A.DateTimePlanning = #dts# 	    
	    AND      W.Mission          = '#url.mission#'
		AND      WL.Operational     = 1
		AND      A.WorkActionId IN (
		
					SELECT  WorkActionId
					FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId
					WHERE   W.Mission        = '#url.mission#'
					AND     W.DateEffective  <= #dts# 
					AND     W.DateExpiration >= #dts#
					
					)
</cfquery>	

<cfoutput><b>#Planned.recordcount#</cfoutput>

<cfset client.totalplanned = Planned.recordcount>

<!--- refresh the drivers in the bottom --->

<cfoutput>
<script>
	_cf_loadingtexthtml='';	
	try { document.getElementById('mapplanned').innerHTML = "#Planned.recordcount#" } catch(e) {}
	ptoken.navigate('DeliveryViewActor.cfm?mission=#url.mission#&date=#url.date#','actor')
</script>
</cfoutput>




