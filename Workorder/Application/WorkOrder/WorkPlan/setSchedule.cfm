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
<cfparam name="url.workschedule" default="">

<cfquery name="getPosition"
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT *
	    FROM   Position
	    WHERE  PositionNo   = '#url.PositionNo#'						
</cfquery>		

<cfquery name="getWorkOrder"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   W.OrgUnitOwner, W.CustomerId, W.ServiceItem
	FROM     WorkOrderLineAction WLA INNER JOIN
             WorkOrder W ON WLA.WorkOrderId = W.WorkOrderId
	WHERE    WorkActionId = '#url.workactionid#'		
</cfquery>

<cfset schedule = dateAdd("h",  0,  url.selecteddate)>

<cfquery name="WorkPlan"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	
		SELECT *
	    FROM   WorkPlan W
	    WHERE  W.Mission      = '#url.mission#'
		AND    W.PositionNo   = '#url.PositionNo#'
		AND    DateEffective  <= #schedule# 
	    AND    DateExpiration >= #schedule#  
				
</cfquery>		
				  
<cfif WorkPlan.recordcount eq "0">
		
	<cf_assignid>
	<cfset workplanid = rowguid>
		
	<!--- create workplan --->
		
	<cfquery name="addWorkPlan"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	
		INSERT INTO WorkPlan 
			
			(WorkPlanId, 
			 Mission, 
			 OrgUnit, 
			 PositionNo, 
			 PersonNo, 
			 DateEffective, 
			 DateExpiration, 		
			 OfficerUserid, 
			 OfficerLastName, 
	         OfficerFirstName)		
		  
		 VALUES
		 
			 ('#workplanid#',
			  '#url.mission#',
			  <cfif getPosition.recordcount eq "1">
			  '#getPosition.OrgUnitOperational#',
			  <cfelse>
			  '#url.orgunit#',
			  </cfif>
			  '#url.PositionNo#',
			  '#url.PersonNo#',
			  #schedule#,
			  #schedule#,
			  '#session.acc#',
			  '#session.last#',
			  '#session.first#'
			  )
				
	</cfquery>			

<cfelse>

	<cfset workplanid = workplan.workplanid>

</cfif>		


<cfparam name="url.hour" default="">
<cfparam name="url.minute" default="">

<cfif url.hour eq "">

	<cfset schedule = dateAdd("h",  form.DateTimePlanning_hour,schedule)>
	<cfset schedule = dateAdd("n",  form.DateTimePlanning_minute,schedule)>
	
<cfelse>

	<cfset schedule = dateAdd("h",  url.hour,schedule)>
	<cfset schedule = dateAdd("n",  url.minute,schedule)>

</cfif>	

<!--- check if the same customer is not schedule twice for the same day and person --->

<cf_tl id="An overlap has been found" var="vExceptionMessage1">
<cf_tl id="An action has been found for this day and the same service" var="vExceptionMessage2">

<cftransaction>

	<cfquery name="getWorkAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM WorkPlanDetail
		WHERE    WorkActionId = '#url.workactionid#' 
	</cfquery>
		
	<cfset dateValue = "">
	<CF_DateConvert Value="#dateformat(getWorkAction.DateTimePlanning,client.dateformatshow)#">
	<cfset DTP = dateValue>
	
	<!--- if the action is on the same date we remove it --->
	
	<cfquery name="undoWorkAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  WorkPlanDetail
		SET     Operational = 0
		WHERE   WorkActionId = '#url.workactionid#' 
	</cfquery>
	
	<!--- if the action is on the same date we remove it, this has been disabled to get the 
	full history logge 
	
	<cfquery name="clearWorkAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM WorkPlanDetail		
		WHERE  WorkActionId            = '#url.workactionid#' 		
		AND    DAY(DateTimePlanning)   = #day(schedule)# 
		AND    MONTH(DateTimePlanning) = #month(schedule)#		
	</cfquery>
	
	---> 
	
	<cfquery name="clearWorkAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM WorkPlanDetail		
		WHERE  WorkActionId            = '#url.workactionid#' 		
		AND    DateTimePlanning        = #schedule# 		
	</cfquery>
	
	
	<!--- check overlap in slots for this position / time --->
	
	<cfset proceed = "1">
	
    <cfif url.workschedule neq "">
	 
	 	<cfquery name="getWorkSchedule" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM    Employee.dbo.WorkSchedule
			WHERE   Code = '#url.workschedule#'		
		</cfquery>
		
		<cfif getWorkSchedule.MultipleActions eq "0">
		
			<cfquery name="checkWorkPlan"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT    WPD.*
				FROM      WorkPlanDetail WPD INNER JOIN
			              WorkOrderLineAction WLA ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
			              WorkOrder W ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
			              WorkPlan WP ON WPD.WorkPlanId = WP.WorkPlanId
				WHERE     W.Mission              = '#url.mission#'				
				AND       WP.PositionNo          = '#url.PositionNo#'		
				AND       WPD.DateTimePlanning   = #schedule# 		
				AND       WPD.Operational        = 1
				AND       WLA.ActionStatus != '9' <!--- cancelled appointments to be excluded --->
				
				<!---  W.ServiceItem = '#getWorkOrder.ServiceItem#' --->    				
			</cfquery>				
			
			<cfif checkworkplan.recordcount gte "1">
					
				<cfoutput>
				<script>					
					alert("#vExceptionMessage1# [1]..")
				</script>
				</cfoutput>
				
				<cfset proceed = "0">			
				
			</cfif>				
		
		</cfif>
		
	 </cfif>	
	 
	<!--- check if the person already has on the same day an action  for the same service ---> 
	
	<cfif proceed eq "1">
			
		<cfquery name="checkWorkPlan"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			SELECT    W.CustomerId, WP.PositionNo, WP.DateEffective, WPD.DateTimePlanning
			FROM      WorkPlanDetail WPD INNER JOIN
		              WorkOrderLineAction WLA ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
		              WorkOrder W ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
		              WorkPlan WP ON WPD.WorkPlanId = WP.WorkPlanId
			WHERE     W.CustomerId   = '#getWorkOrder.Customerid#'
			AND       W.ServiceItem  = '#getWorkOrder.ServiceItem#'
			AND       DAY(WPD.DateTimePlanning)   = #day(schedule)# 
			AND       MONTH(WPD.DateTimePlanning) = #month(schedule)#
			AND       YEAR(WPD.DateTimePlanning) = #year(schedule)#
			AND       WLA.ActionStatus != '9'
			AND       WPD.Operational   = 1
			<!---
			AND       WP.PositionNo = '#url.PositionNo#'
			--->	
		</cfquery>	
		
		<cfif checkworkplan.recordcount gte "1">

			<cfoutput>
			<script>			
				alert("#vExceptionMessage2# [2]..")
			</script>
			</cfoutput>
			
			<cfset proceed = "0">
			
		</cfif>	
		
	</cfif>
	
	<cfif proceed eq "1">	
			
		<cfquery name="addWorkPlanDetail"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
						
			INSERT INTO WorkPlanDetail (
					WorkPlanId, 
					LocationId,
					PlanOrder, 			
					PlanOrderCode,
				    PlanActionMemo, 
					WorkActionId,
					<cfif url.workschedule neq "">
					WorkSchedule,
					</cfif>
				    DateTimePlanning, 	
					OrgUnitOwner,	    		    
				    OfficerUserId, 
				    OfficerLastName, 
		            OfficerFirstName
			      ) VALUES (
				  	'#workplanid#',						
					<cfif form.LocationId neq "">
					'#Form.LocationId#',
					<cfelse>
					NULL,
					</cfif>
					'1',	
					<cfif form.PlanOrderCode neq "">
					'#Form.PlanOrderCode#',
					<cfelse>
					NULL,
					</cfif>
					'Manual',
					'#url.workactionid#',
					<cfif url.workschedule neq "">
					'#url.workschedule#',
					</cfif>
					#schedule#,		
					<cfif getWorkOrder.OrgUnitOwner eq "">
					NULL,
					<cfelse>
					'#getWorkOrder.OrgUnitOwner#',
					</cfif>
					'#session.acc#',
					'#session.last#',
					'#session.first#')			  			
		    </cfquery>	
					
			<cfoutput>	
			
			<script>				
						
				<cfif getWorkAction.dateTimePlanning neq "" and #dtp# neq #schedule#>
					calendarrefreshonly('#day(dtp)#','#urlencodedformat(dtp)#')
				</cfif>			   
				calendarrefreshonly('#day(url.selecteddate)#','#urlencodedformat(url.selecteddate)#')	
				try {
			        parent.workplanaction('#url.workactionid#') } catch(e) {}
				try {
				    //removed by dev as it gave issues on refreshing not needed 10-31-2018
				    //parent.opener.applyfilter('','','#url.workactionid#') 
				    
				    } catch(e) {}	
				 
			</script>
			</cfoutput>	
			
	<cfelse>
	
			<!--- trigger a refresh --->
	
			<cfoutput>	
			
			<script>				
						
				<cfif getWorkAction.dateTimePlanning neq "" and #dtp# neq #schedule#>
					calendarrefreshonly('#day(dtp)#','#urlencodedformat(dtp)#')
				</cfif>			   
				calendarrefreshonly('#day(url.selecteddate)#','#urlencodedformat(url.selecteddate)#')	
				try {
			        parent.workplanaction('#url.workactionid#') } catch(e) {}
				try {
				    //removed by dev as it gave issues on refreshing not needed 10-31-2018
				    //parent.opener.applyfilter('','','#url.workactionid#') 
				    
				    } catch(e) {}	
				 
			</script>
			
			</cfoutput>	
				
	
	</cfif>	

</cftransaction>

<cfoutput>

<cfif url.mode eq "medical">	    
	<cfinclude template="../../Medical/ServiceDetails/WorkPlan/Agenda/ActivityList.cfm">	
</cfif>

</cfoutput>
