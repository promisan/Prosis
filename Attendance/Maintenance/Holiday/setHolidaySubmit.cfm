
<cfparam name="Form.HolidayId" default="''">
<cfparam name="url.action"     default="">
<cfparam name="url.idmenu"     default="">

<cfif url.action eq "remove">
	
	<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT * FROM Ref_Holiday
			WHERE   Mission = '#url.mission#'
			AND  	HolidayId IN (#FORM.HolidayId#)
	</cfquery>
	
	<cfquery name="check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			DELETE	FROM Ref_Holiday
			WHERE   Mission = '#url.mission#'
			AND  	HolidayId IN (#FORM.HolidayId#)
	</cfquery>
	
	<cfoutput query="get">

		<script>
		 		 		  
		   try {    
		      ColdFusion.navigate('#SESSION.root#/Attendance/Maintenance/Holiday/getHoliday.cfm?mission=#url.mission#&calendardate=#DateFormat(get.calendardate,client.dateSQL)#','calendarday_#day(get.calendardate)#')
		    } catch(e) {}
			
		   <cfif get.recordcount eq currentrow>		
		  
		   try {    
		      ColdFusion.navigate('#SESSION.root#/Attendance/Maintenance/Holiday/HolidayList.cfm?mission=#url.mission#&startyear=#year(get.calendardate)#','holidaylistcontent')
		    } catch(e) {}
				
			</cfif>
		
		</script>	
	
	</cfoutput>
		
<cfelseif url.action eq "cluster">

	<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT * FROM Ref_Holiday
			WHERE   Mission = '#url.mission#'
			AND  	HolidayId IN (#FORM.HolidayId#)
	</cfquery>
	
	<cftransaction>
	
		<cfquery name="reset" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				UPDATE  Ref_Holiday
				SET     ClusterId = NULL
				WHERE   Mission = '#url.mission#'
				AND  	HolidayId IN (#FORM.HolidayId#)
		</cfquery>
		
		<cfquery name="reset" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				DELETE  Ref_HolidayCluster
				WHERE   ClusterId NOT IN (SELECT ClusterId FROM Ref_Holiday WHERE ClusterId is not NULL)			
		</cfquery>
		
		<cf_assignid>
		
		<cfquery name="set" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				INSERT INTO Ref_HolidayCluster
					(Mission,
					 ClusterId,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES
				('#url.mission#','#rowguid#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
		
		<cfquery name="set" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				UPDATE  Ref_Holiday
				SET     ClusterId = '#rowguid#'
				WHERE   Mission = '#url.mission#'
				AND  	HolidayId IN (#FORM.HolidayId#)
		</cfquery>
	
	</cftransaction>
	
	<!--- refresh the content --->
	
	<cfif get.Recordcount gte "1">
	
		<cfoutput>
		
			<script>
			  
			   try {    
			      ColdFusion.navigate('#SESSION.root#/Attendance/Maintenance/Holiday/HolidayList.cfm?mission=#url.mission#&idmenu=#url.idmenu#&startyear=#year(get.CalendarDate)#','holidaylistcontent')
			    } catch(e) {}
			
			</script>
		
		</cfoutput>
	
	</cfif>
	
<cfelse>
		<!---return to screen--->
		
		<cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_Holiday
				WHERE   Mission = '#url.mission#'
				AND 	CalendarDate = '#DateFormat(url.selecteddate,client.dateSQL)#'
		</cfquery>
	
	<cfif check.recordcount eq "1">
	
		<!--- update --->
		
		<cfif form.description eq "">
		
			<cfquery name="check" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					DELETE FROM Ref_Holiday				
					WHERE  Mission      = '#url.mission#'
					AND    CalendarDate = '#DateFormat(url.selecteddate,client.dateSQL)#'
			</cfquery>
		
		<cfelse>
	
			<cfquery name="check" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					UPDATE 	Ref_Holiday
					SET    HoursHoliday = '#FORM.HoursHoliday#',
						   Description  = '#FORM.Description#'
					WHERE  Mission      = '#url.mission#'
					AND    CalendarDate = '#DateFormat(url.selecteddate,client.dateSQL)#'
			</cfquery>
		
		</cfif>
	
	<cfelse>
	
		<cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				INSERT INTO	Ref_Holiday
				(CalendarDate, Mission, HoursHoliday, Description, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
				VALUES ('#DateFormat(url.selecteddate,client.dateSQL)#', '#url.mission#', '#FORM.HoursHoliday#', '#FORM.Description#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
		</cfquery>
				
	</cfif>
	
	<cfinclude template="setHoliday.cfm">
			
	<!--- refresh the content --->
	
	<cfoutput>
	
	<script>
	  
	   try {    
	      ColdFusion.navigate('#SESSION.root#/Attendance/Maintenance/Holiday/getHoliday.cfm?mission=#url.mission#&calendardate=#DateFormat(url.selecteddate,client.dateSQL)#','calendarday_#day(url.selecteddate)#')
	      ColdFusion.navigate('#SESSION.root#/Attendance/Maintenance/Holiday/HolidayList.cfm?mission=#url.mission#&startyear=#year(url.selecteddate)#','holidaylistcontent')
	    } catch(e) {}
	
	</script>
	</cfoutput>

</cfif>

