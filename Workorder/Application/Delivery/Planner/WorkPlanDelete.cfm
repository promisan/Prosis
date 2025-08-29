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
<cfparam name="form.personno" default="">
<cfparam name="url.action" default="apply">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cftransaction>
		
	<cfquery name="get" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT  * 
		FROM    WorkPlanDetail W, WorkPlan D
		WHERE   W.WorkPlanId = D.WorkPlanId
		AND     WorkActionId  = '#url.workactionid#'
		AND     D.WorkPlanId IN (SELECT WorkPlanId
		                       FROM   WorkPlan
							   WHERE  Mission = '#url.mission#'
							   AND    DateEffective  <= #dts# 
                               AND    DateExpiration >= #dts# )
	    	  
	</cfquery>		
			
	<cfquery name="Set" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		DELETE FROM WorkPlanDetail
		WHERE     WorkActionId  = '#url.workactionid#'
		<!--- action was also planned for today --->
		AND       WorkPlanId IN (SELECT WorkPlanId
		                         FROM   WorkPlan
								 WHERE  Mission = '#url.mission#'
								 AND    DateEffective  <= #dts# 
                                 AND    DateExpiration >= #dts# )
	    	  
	</cfquery>
	
	<!--- we rework the number --->
						
	<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
		   method           = "setWorkPlanOrder" 
		   WorkPlanId       = "#get.workplanid#">   									
						
</cftransaction>
		
<cfoutput>
		
	<script>
		try {		
			positionselect('#get.positionno#','#url.dts#','limited') } catch(e) { }
		//  reload scheduled
		    ptoken.navigate('Planner/setScheduled.cfm?mission=#url.mission#&date=#url.dts#','scheduled')	
	</script>
		
</cfoutput>	