
<cfparam name="url.action" default="">

<cfswitch expression="#url.action#">
	
	<cfcase value="Delete">
	
		<cfquery name= "remove" 
		    datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">      				 
				DELETE FROM WorkScheduleOrganization
				WHERE   WorkSchedule = '#url.workschedule#'		
				AND     OrgUnit      = '#url.orgunit#'				
		</cfquery>
	
	</cfcase>
	
	<cfcase value="Insert">
		
		<cfquery name= "check" 
		    datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">      				 
				SELECT * FROM WorkScheduleOrganization
				WHERE   WorkSchedule = '#url.workschedule#'		
				AND     OrgUnit      = '#url.orgunit#'				
		</cfquery>
		
		<cfif check.recordcount eq "0">
		
		<cfquery name= "add" 
		    datasource= "AppsEmployee" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">      				 
				INSERT INTO WorkScheduleOrganization
				(WorkSchedule,OrgUnit,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
				('#url.workschedule#',
				 '#url.orgunit#',
				 '#session.acc#',
				 '#session.last#',
				 '#session.first#')
		</cfquery>
		
		</cfif>
	
	</cfcase>
	
</cfswitch>

<cfinclude template="ScheduleOrganizationDetail.cfm">

<cfoutput>
	<script>
		ColdFusion.navigate('#session.root#/Staffing/Application/WorkSchedule/Planning/PlanningDateDetailPosition.cfm?workschedule=#url.workschedule#&selecteddate='+document.getElementById('currentDate').value,'positionContainer');
	</script>
</cfoutput>