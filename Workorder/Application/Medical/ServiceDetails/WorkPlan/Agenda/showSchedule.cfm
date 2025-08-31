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
<cfoutput>

	<table width="100%" height="100%">
	<tr>
	<td bgcolor="#ViewColor#">&nbsp;</td>
	<td class="lcell" align="right">
	<cfset vHoursStyle = "font-size:15px;">
	<cfset vMinutesStyle = "font-size:11px;">
	<cfswitch expression="#partVal#">				
		<cfcase value="0"><span style="#vHoursStyle#">#int(CalendarHour)#<span style="#vMinutesStyle#">:00</span></cfcase>
		<cfcase value="25"><span style="#vMinutesStyle#">:15</span></cfcase>
		<cfcase value="33"><span style="#vMinutesStyle#">:20</span></cfcase>
		<cfcase value="50"><span style="#vMinutesStyle#">:30</span></cfcase>
		<cfcase value="66"><span style="#vMinutesStyle#">:40</span></cfcase>
		<cfcase value="75"><span style="#vMinutesStyle#">:45</span></cfcase>				
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