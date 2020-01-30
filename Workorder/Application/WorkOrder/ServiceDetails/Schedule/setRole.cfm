
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