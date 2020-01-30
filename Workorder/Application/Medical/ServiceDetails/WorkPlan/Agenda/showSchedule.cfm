
<cfoutput>

	<table width="100%" height="100%">
	<tr>
	<td bgcolor="#ViewColor#">&nbsp;</td>
	<td class="lcell" align="right">
	<cfswitch expression="#partVal#">				
		<cfcase value="0"><font size="3">#int(CalendarHour)#<font size="2">:00</font></cfcase>
		<cfcase value="25"><font size="2">:15</font></cfcase>
		<cfcase value="33"><font size="2">:20</font></cfcase>
		<cfcase value="50"><font size="2">:30</font></cfcase>
		<cfcase value="66"><font size="2">:40</font></cfcase>
		<cfcase value="75"><font size="2">:45</font></cfcase>				
	</cfswitch>	
	</td>	
	</tr>
	</table>
	
	<cfif HourMode eq "15">
		<cfset end = 15>	
	<cfelseif HourMode eq "20">
		<cfset end = 20>
	<cfelseif HourMode eq "30">
	    <cfset end = 30>
	<cfelseif HourMode eq "60">
	    <cfset end = 60>
	</cfif>
	
	<cfset dte = dateadd("n",min,dte)>	
	<cfset dtf = dateadd("n",end,dte)>
	<cfset vNextInitHour = dtf>
	
	<cfquery name="nextSchedule"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 WSH.CalendarHour
		FROM     WorkSchedulePosition AS WSP INNER JOIN
		         WorkScheduleDateHour AS WSH ON WSP.WorkSchedule = WSH.WorkSchedule AND WSP.CalendarDate = WSH.CalendarDate INNER JOIN
				 WorkSchedule AS W ON W.Code = WSP.WorkSchedule 
		WHERE    WSP.CalendarDate = '#dateformat(url.selecteddate,client.dateSQL)#' 
		AND      WSP.PositionNo   = '#positionno#'
		AND 	 WSH.CalendarHour > '#CalendarHour#'
		ORDER BY WSH.CalendarHour ASC
	</cfquery>	
		
	<cfif nextSchedule.recordCount eq 1>
	
		<cfset vNextInitHour = dateadd("h",nextSchedule.CalendarHour,url.selecteddate)>
		<cfset npart = nextSchedule.CalendarHour-int(nextSchedule.CalendarHour)>
		<cfset npartVal = INT(npart*100)>
		
		<cfswitch expression="#npartVal#">				
			<cfcase value="0">
				<cfset nmin = "0">					
			</cfcase>
			<cfcase value="25">
			    <cfset nmin = "15">
			</cfcase>
			<cfcase value="33">
			    <cfset nmin = "20">
			</cfcase>
			<cfcase value="50">
				<cfset nmin = "30">
			</cfcase>
			<cfcase value="66">
			    <cfset nmin = "40">
			</cfcase>
			<cfcase value="75">
				<cfset nmin = "45">
			</cfcase>				
		</cfswitch>
		<cfset vNextInitHour = dateadd("n",nmin,vNextInitHour)>
	</cfif>
	
</cfoutput>	