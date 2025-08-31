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
<cfquery name  = "getWorkOrder" 
   	datasource= "AppsWorkOrder" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">
	SELECT  *
	FROM	WorkOrder
	WHERE 	WorkOrderId   = '#url.WorkOrderId#'		
</cfquery>

<cftransaction>

	<!--- Set none responsible : we allow for multiple staff now 
	
	<cfquery name  = "updateSchedulePerson" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
		UPDATE	WorkOrderLineSchedulePosition
		SET		isActor         = '1' 
		FROM	WorkOrderLineSchedulePosition P INNER JOIN WorkOrderLineSchedule S ON P.ScheduleId = S.ScheduleId 
		WHERE 	S.WorkOrderId   = '#url.WorkOrderId#'
		AND		S.WorkOrderLine = '#url.WorkOrderLine#'
		AND		S.ActionClass   = '#url.ActionClass#'
		AND		S.WorkSchedule  = '#url.WorkSchedule#'
		AND		P.isActor       = '2'
	</cfquery>
	
	--->
	
	<!--- Remove the selected person --->
	<cfquery name  = "deleteSchedulePerson" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
		DELETE 	P
		FROM	WorkOrderLineSchedulePosition P INNER JOIN WorkOrderLineSchedule S ON P.ScheduleId = S.ScheduleId
		WHERE 	S.WorkOrderId   = '#url.WorkOrderId#'
		AND		S.WorkOrderLine = '#url.WorkOrderLine#'
		AND		S.ActionClass   = '#url.ActionClass#'
		AND		S.WorkSchedule  = '#url.WorkSchedule#'
		AND		P.PersonNo      = '#Form.PersonNo#'
	</cfquery>
	
	<!--- Get current assignment --->
	<cfquery name  = "currentPosition" 
	   	datasource= "AppsWorkOrder" 
	    username  = "#SESSION.login#" 
		password  = "#SESSION.dbpw#">
			SELECT 	*
			FROM	Employee.dbo.PersonAssignment PA
			WHERE	PositionNo IN (SELECT PositionNo 
			                       FROM   Employee.dbo.Position 
								   WHERE  PositionNo = PA.PositionNo 
								   AND    Mission    = '#getWorkorder.mission#')
								   
			AND     PersonNo         = '#Form.PersonNo#'
			AND		AssignmentStatus IN ('0','1')
			AND		AssignmentType   = 'Actual'
			AND		Incumbency       > 0
			AND		getDate() BETWEEN DateEffective AND DateExpiration		
	</cfquery>
	
	<cfif currentPosition.recordcount eq "0">
	
		<script>
			alert("A active position could not be found for this person. Operation aborted.")
			try {
					ColdFusion.Window.destroy('windowAssignResponsibleWorkSchedule');
				}catch(e){}
		</script>
	
	<cfelse>
	
		<cfquery name="getSchedules" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	  ScheduleId
			FROM 	  WorkOrderLineSchedule 
			WHERE 	  WorkOrderId   = '#url.WorkOrderId#'
			AND		  WorkOrderLine = '#url.WorkOrderLine#'
			AND		  ActionClass   = '#url.ActionClass#'
			AND		  WorkSchedule  = '#url.WorkSchedule#'	
		</cfquery>			
		
		<cfloop query="getSchedules">
					
			<cfquery name="check" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   WorkOrderLineSchedulePosition
				WHERE  ScheduleId = '#scheduleid#'
				AND    PositionNo = '#currentPosition.positionNo#'											
			</cfquery>
			
			<cfif check.recordcount eq "1">
		
				<cfquery name="reset" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE WorkOrderLineSchedulePosition
						SET    isActor = '2'
						WHERE  ScheduleId = '#scheduleid#'
						AND    PositionNo = '#currentPosition.positionNo#'											
				</cfquery>		
				
			<cfelse>		
					
				<cfquery name  = "insertSchedulePerson" 
				   	datasource= "AppsWorkOrder" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
					INSERT INTO WorkOrderLineSchedulePosition (
					           ScheduleId,
					           PersonNo,
					           PositionNo,
							   isActor,
							   Operational,			         
					           OfficerUserId,
				    	       OfficerLastName,
				        	   OfficerFirstName	)
						   
					SELECT	  ScheduleId,
							  '#Form.PersonNo#',
							  '#currentPosition.positionNo#',
							  '2',
							  1,					
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#'
					FROM 	  WorkOrderLineSchedule 
					WHERE 	  ScheduleId    = '#scheduleid#'				
				</cfquery>
				
			</cfif>	
			
		</cfloop>	
								
		<cfoutput>
			<script>
				ColdFusion.navigate('Schedule/ScheduleListing.cfm?workorderid=#url.workOrderId#&workorderline=#url.workorderline#','contentbox1');
				try {
					ColdFusion.Window.destroy('windowAssignResponsibleWorkSchedule');
				}catch(e){}
			</script>
		</cfoutput>
	
	</cfif>		

</cftransaction>
