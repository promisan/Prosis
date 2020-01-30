
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>		

<cfquery name="Branch"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT SUM(Requested) as Requested,				  
				   SUM(Planned) as Planned
					  
			FROM (  	   
				  
				<!--- requested and scheduled actions --->   
			
				SELECT   1 as Requested,
					  	 						 				 
					 	 <!--- check if the action has been scheduled for today --->
						 (
						 SELECT    COUNT(*) 
						 FROM      WorkPlan AS W INNER JOIN
	                               WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId
						 WHERE     W.Mission        = '#url.mission#'
						 AND       W.DateEffective  <= #dts# 
						 AND       W.DateExpiration >= #dts#
						 AND       D.WorkActionId = A.WorkActionId ) as Planned
						
						 
			    FROM     WorkOrder AS W INNER JOIN						
		                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
		                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine
						 
			    WHERE    W.Mission          = '#url.mission#'
				AND      A.ActionClass      = 'Delivery' 
				AND      A.DateTimePlanning = #dts#  			    	
				AND      WL.Operational     = '1'
				AND      W.ActionStatus    != '9'
				AND      OrgUnitOwner       = '#url.orgunit#'
			
			) F
					      
</cfquery>
	
<cfoutput query="Branch">
	
	<cfif requested eq planned>
		<cfset cl = "white">
	<cfelse>
		<cfset cl = "ffffaf">	
	</cfif>

	<table>
		<tr class="labelit">			
		<td align="right"  bgcolor="#cl#" style="padding-left:3px">#Requested#</td>	
		<td align="center" bgcolor="#cl#" style="width:3px;padding-left:3px;padding-right:3px">|</td>			
		<td align="left"   bgcolor="#cl#" style="padding-right:3px">#Planned#</td>	
		</tr>
	</table>	
								
</cfoutput>		

<!--- we check if the total has changed then we reload the top, the map and the drivers on the left --->	

<cfquery name="Total"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT SUM(Requested) as Requested,				  
				   SUM(Planned) as Planned
					  
			FROM (  	   
				  
				<!--- requested and scheduled actions --->   
			
				SELECT   1 as Requested,
					  	 						 				 
					 	 <!--- check if the action has been scheduled for today --->
						 (
						 SELECT    COUNT(*) 
						 FROM      WorkPlan AS W INNER JOIN
	                               WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId
						 WHERE     W.Mission        = '#url.mission#'
						 AND       W.DateEffective  <= #dts# 
						 AND       W.DateExpiration >= #dts#
						 AND       D.WorkActionId = A.WorkActionId ) as Planned
						
						 
			    FROM     WorkOrder AS W INNER JOIN						
		                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
		                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine
						 
			    WHERE    W.Mission          = '#url.mission#'
				AND      A.ActionClass      = 'Delivery' 
				AND      A.DateTimePlanning = #dts#  			    	
				AND      WL.Operational     = '1'
				AND      W.ActionStatus    != '9'
				
			) F
					      
</cfquery>

<cfoutput>

	<cfparam name="client.totalplanned" default="0">
	
	<cfif Total.Planned neq client.TotalPlanned>
		
		<!--- 31/7/2015 disabled as it caused information for the planner that is working to be refreshed at a moment that he/she is working on it
			
		<script language="JavaScript">		
			reloadcontent('full')		
			ptoken.navigate('Planner/setScheduled.cfm?mission=#url.mission#&date=#url.date#','scheduled')
		</script>				
		
		--->
		
		<script language="JavaScript">		
		    if (document.getElementById("menu").value == "map")	{	
			   reloadcontent('limited')	// refreshes the map itself
			}
			ptoken.navigate('Planner/setScheduled.cfm?mission=#url.mission#&date=#url.date#','scheduled')			
			
		</script>		
	
	</cfif>

</cfoutput>