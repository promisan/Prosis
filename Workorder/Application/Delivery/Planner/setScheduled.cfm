<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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




