
<!--- set workschedule from listing --->

<cfoutput>

<cfquery name="check" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   WorkOrderLineSchedulePosition
	WHERE  ScheduleId = '#url.scheduleid#'
	AND    PositionNo = '#url.positionno#'											
</cfquery>	

<cfswitch expression="url.value">

	<cfcase value="0">
	
		<cfif check.recordcount gte "1">
	
			<cfquery name="clear" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM WorkOrderLineSchedulePosition
					WHERE ScheduleId = '#url.scheduleid#'
					AND   PositionNo = '#url.positionno#'											
			</cfquery>		
		
		</cfif>
	
	</cfcase>
	
	<cfdefaultcase>
	
		<cfif check.recordcount gte "1">
		
			<cfif check.isActor neq url.value>
		
				<cfquery name="reset" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE WorkOrderLineSchedulePosition
						SET    isActor          = '#url.value#',
						       OfficeruserId    = '#session.acc#',
							   OfficerLastName  = '#session.last#',
							   OfficerFirstName = '#session.first#',
							   Created          = getDate()					        
						WHERE  ScheduleId       = '#url.scheduleid#'
						AND    PositionNo       = '#url.positionno#'											
				</cfquery>		
			
			</cfif>
				
		<cfelse>		
		
			<!--- Get current assignment --->
			<cfquery name  = "currentPosition" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
					SELECT 	*
					FROM	Employee.dbo.PersonAssignment PA
					WHERE	PositionNo      = '#url.PositionNo#'
					AND		AssignmentStatus IN ('0','1')
					AND		AssignmentType   = 'Actual'
					AND		Incumbency       > 0
					AND		getDate() BETWEEN DateEffective AND DateExpiration		
			</cfquery>	
			
			<cfquery name="add" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WorkOrderLineSchedulePosition
						(ScheduleId, 
						 PersonNo, 
						 PositionNo, 
						 isActor, 
						 Operational, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
					 VALUES (
						 '#url.scheduleid#',
						 '#currentPosition.PersonNo#',
						 '#url.positionno#',
						 '#url.value#',
						 '1',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')												
			</cfquery>		
					
		</cfif> 	
	
	</cfdefaultcase>
	
</cfswitch>

</cfoutput>
