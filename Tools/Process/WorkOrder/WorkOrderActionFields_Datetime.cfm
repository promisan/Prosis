
<cfparam name="url.code"		default = "">
<cfparam name="url.val"			default = "">

<cfquery name="getHourMode"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   TOP 1 W.HourMode
		FROM     WorkSchedulePosition AS WSP INNER JOIN
		         WorkScheduleDateHour AS WSH ON WSP.WorkSchedule = WSH.WorkSchedule AND WSP.CalendarDate = WSH.CalendarDate INNER JOIN
				 WorkSchedule AS W ON W.Code = WSP.WorkSchedule
		WHERE    WSP.CalendarDate = '#dateformat(url.val,client.dateSQL)#' 
		AND      WSP.PositionNo IN  (#url.positionno#)

</cfquery>

<cfquery name="getMinHour"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   MIN(WSH.CalendarHour) as MinHour
		FROM     WorkSchedulePosition AS WSP INNER JOIN
		         WorkScheduleDateHour AS WSH ON WSP.WorkSchedule = WSH.WorkSchedule AND WSP.CalendarDate = WSH.CalendarDate INNER JOIN
				 WorkSchedule AS W ON W.Code = WSP.WorkSchedule
		WHERE    WSP.CalendarDate = '#dateformat(url.val,client.dateSQL)#' 
		AND      WSP.PositionNo   IN (#url.positionno#)

</cfquery>

<cfquery name="getMaxHour"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   MAX(WSH.CalendarHour) as MaxHour
		FROM     WorkSchedulePosition AS WSP INNER JOIN
		         WorkScheduleDateHour AS WSH ON WSP.WorkSchedule = WSH.WorkSchedule AND WSP.CalendarDate = WSH.CalendarDate INNER JOIN
				 WorkSchedule AS W ON W.Code = WSP.WorkSchedule
		WHERE    WSP.CalendarDate = '#dateformat(url.val,client.dateSQL)#' 
		AND      WSP.PositionNo   IN (#url.positionno#)

</cfquery>

<cfset jumpMinutes = 1>
<cfif getHourMode.recordCount gt 0>
	<cfif trim(getHourMode.HourMode) neq "">
		<cfset jumpMinutes = getHourMode.HourMode>
	</cfif>
</cfif>

<cfset vMinHour = 0>
<cfif getMinHour.recordCount gt 0>
	<cfif trim(getMinHour.MinHour) neq "">
		<cfset vMinHour = INT(getMinHour.MinHour)>
	</cfif>
</cfif>

<cfset vMaxHour = 23>
<cfif getMaxHour.recordCount gt 0>
	<cfif trim(getMaxHour.MaxHour) neq "">
		<cfset vMaxHour = INT(getMaxHour.MaxHour)>
	</cfif>
</cfif>

<!-- <cfform name="dummy"> -->



	<cf_setCalendarDate name="DatePlanning#url.code#"
	    id="DatePlanning#url.code#"
		key1="result#url.Code#" <!--- button to validate --->		
		font="15" 
		valuecontent="datetime" 
		jumpMinutes="#jumpMinutes#"
		minHour="#vMinHour#"
		maxHour="#vMaxHour#"
		future="Yes" 
		class="regularxl enterastab"
		value="#url.val#" 		
		dialog="Yes"	
		pfunction="workplanverify"
		pfunctionselect="function(d){ workplanverify(d,'','','#url.applyid#');}"	
		mode="datetime">	
		
			
	
<!-- </cfform> -->

<cfset AjaxOnLoad("doCalendar")>