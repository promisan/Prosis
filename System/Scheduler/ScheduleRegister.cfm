
<!--- check role --->

<cfparam name="Attributes.SystemModule" default="">
<cfparam name="Attributes.ScheduleName" default="">
<cfparam name="Attributes.ScheduleMemo" default="">
<cfparam name="Attributes.ScheduleTemplate" default="">
<cfparam name="Attributes.ScheduleStartDate" default="">
<cfparam name="Attributes.ScheduleStartTime" default="">
<cfparam name="Attributes.ApplicationServer" default="">
<cfparam name="Attributes.ScheduleInterval" default="daily">

<cfif Attributes.ScheduleName neq "">
	
	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM    Schedule
	WHERE   ScheduleName = '#Attributes.ScheduleName#'	        
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Schedule
		       ( SystemModule,
			     ScheduleName,
				 ScheduleMemo,
				 ScheduleTemplate,
				 ScheduleStartDate,
				 ScheduleStartTime,
				 ApplicationServer,
				 ScheduleInterval,
				 ScheduleClass,
				 OfficerUserId)  
		VALUES ('#Attributes.SystemModule#',
		        '#Attributes.ScheduleName#',
				'#Attributes.ScheduleMemo#',
				'#Attributes.ScheduleTemplate#',
				'#Attributes.ScheduleStartDate#',
				'#Attributes.ScheduleStartTime#',
				'#Attributes.ApplicationServer#',
				'#Attributes.ScheduleInterval#',
				'System',
				'administrator')
		</cfquery>
		
	<cfelse>
	
	<cfquery name="Update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Schedule
		SET    SystemModule     = '#Attributes.SystemModule#', 
			   ScheduleMemo     = '#Attributes.ScheduleMemo#', 
			   ScheduleTemplate = '#Attributes.ScheduleTemplate#',
			   ScheduleClass    = 'System'
	 	WHERE ScheduleName = '#Attributes.ScheduleName#' 
		</cfquery>	
	
	</cfif>

</cfif>