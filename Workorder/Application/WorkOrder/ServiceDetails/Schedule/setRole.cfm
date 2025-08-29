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
<cftransaction>
	
	<!--- check if record exists --->
	
	<cfif url.role neq "0">
		
		<cftry>
		
			<cfquery name="resetResponsible" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		    	INSERT INTO WorkOrderLineSchedulePosition
				(ScheduleId,PersonNo,PositionNo,isActor,Operational,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
				('#URL.ScheduleId#','#URL.PersonNo#','#url.positionno#','#url.role#','1','#SESSION.acc#','#SESSION.last#','#SESSION.first#')					
			</cfquery>
			
			<cfcatch></cfcatch>
				
		</cftry>		
	
	</cfif>
	
	<cfif url.role eq "2">
	
		<!---
			<cfquery name="resetResponsible" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    	UPDATE	WorkOrderLineSchedulePosition
					SET		isActor    = '1', 
					        PositionNo = '#url.positionno#'
					WHERE 	ScheduleId = '#URL.ScheduleId#'
					AND     isActor = '2'
			</cfquery>
		--->	
		
	</cfif>
		
	<cfquery name="setResponsible" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	UPDATE	WorkOrderLineSchedulePosition
			SET		isActor    = '#url.role#', 
			        PersonNo   = '#URL.PersonNo#'
			WHERE 	ScheduleId = '#URL.ScheduleId#'
			AND		PositionNo = '#url.positionno#'
			
	</cfquery>
	
</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('PersonList.cfm?accessmode=edit&viewmode=#url.viewmode#&action=&ScheduleId=#url.ScheduleId#&selectedDate=#url.selecteddate#&personNo=#personNo#','dPersonList');
	</script>
</cfoutput>