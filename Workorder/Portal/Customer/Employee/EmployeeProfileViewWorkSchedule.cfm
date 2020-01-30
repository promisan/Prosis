<cfquery name="personDetail" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT 	P.*,
				(
					SELECT TOP 1 FunctionDescription 
					FROM 	PersonAssignment 
					WHERE 	PersonNo = P.PersonNo 
					AND 	AssignmentStatus IN ('0','1') 
					AND 	DateEffective <= getDate() 
					AND 	DateExpiration >= getDate()
					ORDER BY Created DESC
				) as FunctionDescription,
				(
					SELECT TOP 1 PositionNo 
					FROM 	PersonAssignment 
					WHERE 	PersonNo = P.PersonNo 
					AND 	AssignmentStatus IN ('0','1') 
					AND 	DateEffective <= getDate() 
					AND 	DateExpiration >= getDate()
					ORDER BY Created DESC
				) as PositionNo,
				(SELECT Description FROM WorkSchedule WHERE Code = '#url.workSchedule#') as WorkScheduleDescription
		FROM	Person P
		WHERE	P.PersonNo = '#url.personno#'
</cfquery>

<cfquery name="entryTime" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT	MIN(CalendarHour) as Hour
		FROM	WorkScheduleDateHour
		WHERE	WorkSchedule  = '#url.workSchedule#'
		AND		CONVERT(varchar(15), CalendarDate, 112) = CONVERT(varchar(15), getDate(), 112)
</cfquery>

<cfquery name="departureTime" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT	MAX(CalendarHour) as Hour
		FROM	WorkScheduleDateHour
		WHERE	WorkSchedule  = '#url.workSchedule#'
		AND		CONVERT(varchar(15), CalendarDate, 112) = CONVERT(varchar(15), getDate(), 112)
</cfquery>

<cfquery name="breakIncrement" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT	ISNULL(PointerBreak,0) as PointerBreak
		FROM	WorkSchedulePosition
		WHERE	WorkSchedule  = '#url.workSchedule#'
		AND		CONVERT(varchar(15), CalendarDate, 112) = CONVERT(varchar(15), getDate(), 112)
		AND		PositionNo = '#personDetail.positionNo#'
</cfquery>

<cfquery name="scheduleIncrement" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT	ISNULL(HourMode,0) AS HourMode
		FROM	WorkSchedule
		WHERE	Code  = '#url.workSchedule#'
</cfquery>


<cfoutput>
			
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td class="labelit" style="height:16;padding-left:7px"><cf_tl id="Date">:</td>
			<td class="labelmedium" style="padding-right:5px; font-weight:bold;" align="right">#dateFormat(now(),client.dateFormatShow)#</td>
		</tr>
		<tr><td class="line" colspan="2"></td></tr>
		
		<tr>
			<td class="labelit" style="height:16;padding-left:7px;"><cf_tl id="Assignment">:</td>
			<td class="labelmedium" style="padding-right:5px;" align="right">
				<cfif personDetail.FunctionDescription neq "">
					#personDetail.FunctionDescription# [#personDetail.PositionNo#]
				<cfelse>
					<span style="font-size:16px; font-weight:bold; color:red;">
					[<cf_tl id="No active assignment">]
					</span>
					
					<cfquery name="lastAssignment" 
						datasource="appsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 
							SELECT TOP 1 * 
							FROM 	PersonAssignment 
							WHERE 	PersonNo = '#url.PersonNo#'
							AND 	AssignmentStatus IN ('0','1') 
							AND 	DateExpiration < getDate()
							ORDER BY Created DESC
					</cfquery>
					
					<br>
					<span style="color:808080; font-style:italic;">
						<cf_tl id="Last Assignment">: #lastAssignment.FunctionDescription# <br> 
						<cf_tl id="Expired">: #dateFormat(lastAssignment.DateExpiration,client.dateFormatShow)#
					</span>
					
				</cfif>
			</td>
		</tr>
		<tr><td class="line" colspan="2"></td></tr>
		
		<cfif entryTime.Hour neq "">
		
			<tr>
				<td width="40%" style="height:16;padding-left:7px" class="labelit"><cf_tl id="Entry Time">:</td>
				<td style="padding-right:5px;" align="right" class="labelmedium">
					<cfset vHour = Int(Abs(entryTime.Hour))>
					<cfset vMinute = Abs(entryTime.Hour) - Int(Abs(entryTime.Hour))>
					<cfset vMinute = Round(vMinute * 60)>
					<cfif vHour lt 10>
						<cfset vHour = "0" & vHour>
					</cfif>
					<cfif vMinute lt 10>
						<cfset vMinute = "0" & vMinute>
					</cfif>
					#vHour#:#vMinute#
				</td>
			</tr>
			
			<cfset vPointerBreak = 0>
			<cfif breakIncrement.recordCount eq 1>
				<cfset vPointerBreak = breakIncrement.PointerBreak>
			</cfif>
			
			<cfsilent>
				<cfoutput>
					<cfsavecontent variable="breaks">
						SELECT	(CalendarHour + #vPointerBreak#) AS CalendarHour
						FROM	WorkScheduleDateHour
						WHERE	WorkSchedule  = '#url.workSchedule#'
						AND		CONVERT(varchar(15), CalendarDate, 112) = CONVERT(varchar(15), getDate(), 112)
						AND		ActionClass = 'Break'
					</cfsavecontent> 
				</cfoutput>
			</cfsilent>
			
			<cfquery name="getBreaks" 
				datasource="appsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
					#preserveSingleQuotes(breaks)#
			</cfquery>
			
			<cfif getBreaks.recordCount gt 0>
			<tr><td colspan="2" class="line"></td></tr>
			<tr>
				<td class="labelit" style="height:16; padding-left:17px; padding-top:3px;" valign="top"><cf_tl id="Breaks">:</td>
				<td style="padding-right:5px;" align="right" class="labelit">
					
					<cf_groupScheduleHours 
						dataSource="AppsEmployee" 
						scheduleQuery="#breaks#" 
						hourField="CalendarHour" 
						hourMode="#scheduleIncrement.hourMode#">
				</td>
			</tr>
			</cfif>
			
			<tr><td colspan="2" class="line"></td></tr>
			
			<tr>
				<td class="labelit" style="height:16;padding-left:7px"><cf_tl id="Departure Time">:</td>
				<td style="padding-right:5px;" align="right" class="labelmedium">
					<cfset vRealHour = departureTime.Hour + (scheduleIncrement.hourMode / 60.0)> <!--- x hours more than last assigned hour --->
					<cfset vHour = Int(Abs(vRealHour))>
					<cfset vMinute = Abs(vRealHour) - Int(Abs(vRealHour))>
					<cfset vMinute = Round(vMinute * 60)>
					<cfif vHour lt 10>
						<cfset vHour = "0" & vHour>
					</cfif>
					<cfif vMinute lt 10>
						<cfset vMinute = "0" & vMinute>
					</cfif>
					#vHour#:#vMinute#
				</td>
			</tr>
			
		<cfelse>
		
			<tr>
				<td colspan="2" class="labelit" align="center">
					[<cf_tl id="No schedule defined for today">]
				</td>
			</tr>
			
		</cfif>
		
	</table>
			
</cfoutput>