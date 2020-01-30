
<cfquery name="getSchema" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM    WorkOrderLineScheduleSchema
		WHERE   ScheduleId = '#url.scheduleId#'
		ORDER BY SchemaSerialNo DESC
</cfquery>

<table width="100%"  cellspacing="0" cellpadding="0">

<tr><td>

<cf_ViewTopMenu label="Inherit Schedule" bannerheight="75" user="hide" background="gray">

</td></tr>
<tr><td bgcolor="white">
		  
<table width="91%" cellspacing="0" cellpadding="0" align="center">

	<tr><td height="10"></td></tr>
	<tr id="tr_CopyDetail">
		<td>
			<cfform name="frmInheritSchedule">
			<table width="100%" align="center">
			
				<tr>
					<td class="labelmedium"><cf_tl id="Apply until">:</td>
					<td colspan="2" style="padding-left:2px">
					
						<cfquery name="maxDate" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT	MAX(CalendarDate) AS CalendarDate
								FROM	WorkScheduleDate
								WHERE	WorkSchedule = (SELECT WorkSchedule FROM WorkOrder.dbo.WorkOrderLineSchedule WHERE ScheduleId = '#url.ScheduleId#')
						</cfquery>
						
						<cfset vMaxDate = url.selecteddate>
						<cfif maxDate.recordCount gt 0>
							<cfif maxDate.CalendarDate neq "">
								<cfset vMaxDate = maxDate.CalendarDate>
							</cfif>
						</cfif>
						
						<cfif getSchema.recordCount eq 1>
							<cfset vMaxDate = getSchema.DateExpiration>
						</cfif>
					
						<cf_intelliCalendarDate9
							FieldName="upToDate" 
							class="regularxl"
							Default="#dateformat(vMaxDate, '#CLIENT.DateFormatShow#')#"
							AllowBlank="False">
					</td>
				</tr>
				<tr><td height="4"></td></tr>
				<tr>
					<td width="25%" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Repeat every">:&nbsp;&nbsp;</td>
					<td>
						<table>
							<tr>
								<td>
									<input type="radio" name="everyNSelector" value="day" <cfif getSchema.Periodicity eq "day" or getSchema.recordCount eq 0>checked="checked"</cfif>>
								</td>
								<td style="padding-left:5px;">
									<cfoutput>
									<select name="everyNDays" class="regularxl" id="everyNDays" onchange="$('input[name=everyNSelector][value=day]').prop('checked', true);">
										<cfloop index="i" from="1" to="31">
											<option value="#i#" <cfif getSchema.Periodicity eq "day" and getSchema.PeriodicityInterval eq i>selected</cfif>>#i#
										</cfloop>
									</select>
									</cfoutput>	
								</td>
								<td style="padding-left:5px;" class="labelit"><cf_tl id="days"></td>
							</tr>
							<tr>
								<td>
									<input type="radio" name="everyNSelector" value="month" <cfif getSchema.Periodicity eq "month">checked="checked"</cfif>>
								</td>
								<td style="padding-left:5px;">
									<cfoutput>
									<select name="everyNMonths" class="regularxl" id="everyNMonths" onchange="$('input[name=everyNSelector][value=month]').prop('checked', true);">
										<cfloop index="i" from="1" to="12">
											<option value="#i#" <cfif getSchema.Periodicity eq "month" and getSchema.PeriodicityInterval eq i>selected</cfif>>#i#
										</cfloop>
									</select>
									</cfoutput>	
								</td>
								<td style="padding-left:5px;" class="labelit"><cf_tl id="months"></td>
							</tr>
							<tr style="display:none;">
								<td>
									<input type="radio" name="everyNSelector" value="year" <cfif getSchema.Periodicity eq "year">checked="checked"</cfif>>
								</td>
								<td style="padding-left:5px;">
									<cfoutput>
									<select name="everyNYears" class="regularxl" id="everyNYears" onchange="$('input[name=everyNSelector][value=year]').prop('checked', true);">
										<cfloop index="i" from="1" to="10">
											<option value="#i#" <cfif getSchema.Periodicity eq "year" and getSchema.PeriodicityInterval eq i>selected</cfif>>#i#
										</cfloop>
									</select>
									</cfoutput>	
								</td>
								<td style="padding-left:5px;" class="labelit"><cf_tl id="years"></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr><td colspan="3" height="4" class="labelmedium"><cf_tl id="Limit to "></td></tr>
								
				<tr>
					<td colspan="1" style="padding-left:10px" class="labelmedium"><cf_tl id="Day of the week">:</td>
					<td colspan="2">
						<table>
							<tr>
								<td style="width:32;border:1px dotted #C0C0C0; padding:1px;" align="center" class="labelit"><cf_tl id="Sun"></td>
								<td style="width:32;border:1px dotted #C0C0C0; padding:1px;" align="center" class="labelit"><cf_tl id="Mon"></td>
								<td style="width:32;border:1px dotted #C0C0C0; padding:1px;" align="center" class="labelit"><cf_tl id="Tue"></td>
								<td style="width:32;border:1px dotted #C0C0C0; padding:1px;" align="center" class="labelit"><cf_tl id="Wed"></td>
								<td style="width:32;border:1px dotted #C0C0C0; padding:1px;" align="center" class="labelit"><cf_tl id="Thu"></td>
								<td style="width:32;border:1px dotted #C0C0C0; padding:1px;" align="center" class="labelit"><cf_tl id="Fri"></td>
								<td style="width:32;border:1px dotted #C0C0C0; padding:1px;" align="center" class="labelit"><cf_tl id="Sat"></td>
							</tr>
							<tr>
								<td style="height:20px;border:1px dotted #C0C0C0;" align="center"><input type="Checkbox" id="day_1" name="day_1" <cfif ListFindNoCase(getSchema.ApplyDaysOfWeek, 1, ",") or getSchema.recordCount eq 0>checked</cfif>></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input type="Checkbox" id="day_2" name="day_2" <cfif ListFindNoCase(getSchema.ApplyDaysOfWeek, 2, ",") or getSchema.recordCount eq 0>checked</cfif>></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input type="Checkbox" id="day_3" name="day_3" <cfif ListFindNoCase(getSchema.ApplyDaysOfWeek, 3, ",") or getSchema.recordCount eq 0>checked</cfif>></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input type="Checkbox" id="day_4" name="day_4" <cfif ListFindNoCase(getSchema.ApplyDaysOfWeek, 4, ",") or getSchema.recordCount eq 0>checked</cfif>></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input type="Checkbox" id="day_5" name="day_5" <cfif ListFindNoCase(getSchema.ApplyDaysOfWeek, 5, ",") or getSchema.recordCount eq 0>checked</cfif>></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input type="Checkbox" id="day_6" name="day_6" <cfif ListFindNoCase(getSchema.ApplyDaysOfWeek, 6, ",") or getSchema.recordCount eq 0>checked</cfif>></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input type="Checkbox" id="day_7" name="day_7" <cfif ListFindNoCase(getSchema.ApplyDaysOfWeek, 7, ",") or getSchema.recordCount eq 0>checked</cfif>></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<cfset vDayMonthVal1 = "">
				<cfset vDayMonthVal2 = "">
				<cfset vDayMonthVal3 = "">
				<cfif getSchema.recordCount eq 1>
					<cfset cnt = 1>
					<cfloop index="vDayMonthVal" list="#getSchema.ApplyDaysOfMonth#">
						<cfif cnt eq 1>
							<cfset vDayMonthVal1 = vDayMonthVal>
						</cfif>
						<cfif cnt eq 2>
							<cfset vDayMonthVal2 = vDayMonthVal>
						</cfif>
						<cfif cnt eq 3>
							<cfset vDayMonthVal3 = vDayMonthVal>
						</cfif>
						<cfset cnt = cnt + 1>
					</cfloop>
				</cfif>
				
				<tr>
					<td colspan="1" style="padding-left:10px" class="labelmedium"><cf_tl id="Day in month">:</td>
					<td colspan="2" style="padding-left:10px">
						<cfoutput>
							<table>
								<tr>
								<td>
									<input type="Input" id="mth_1" style="text-align:center;width:30px" class="regularxl enterastab" name="mth_1" value="#vDayMonthVal1#">
								</td>
								<td style="padding-left:5px">
									<input type="Input" id="mth_2" style="text-align:center;width:30px" class="regularxl enterastab" name="mth_2" value="#vDayMonthVal2#">
								</td>
								<td style="padding-left:5px">
									<input type="Input" id="mth_3" style="text-align:center;width:30px" class="regularxl enterastab" name="mth_3" value="#vDayMonthVal3#">
								</td>						
								</tr>
							</table>
						</cfoutput>
					</td>
				
				</tr>
								
				
				<tr><td colspan="3" height="4"></td></tr>
			</table>
			</cfform>
		</td>
	</tr>
	
	<tr><td height="6"></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td height="6"></td></tr>
			
	<tr><td align="center" style="padding-top:4px">
		
		<table cellspacing="2">
		<tr>
			<td id="tdSaveAndInherit">
				<cf_tl id="This action will inherit this definition to the coming days. Do you want to continue ?" var="vMes">
				<cf_tl id="Save and Inherit" var="vVal3">
				
				<cfoutput>
				
				<input type="button" name="inherit" value="&nbsp;#vVal3#&nbsp;" class="button10g" style="font-size:13px; height:28;width:190"
				 onclick="if (confirm('#vMes#')) { saveinheritedschedule('#url.ScheduleId#', '#urlencodedformat(url.selecteddate)#', $('input[name=everyNSelector]:checked').val(), document.getElementById('everyNDays').value, document.getElementById('everyNMonths').value, document.getElementById('everyNYears').value, document.getElementById('day_1').checked, document.getElementById('day_2').checked, document.getElementById('day_3').checked, document.getElementById('day_4').checked, document.getElementById('day_5').checked, document.getElementById('day_6').checked, document.getElementById('day_7').checked, document.getElementById('mth_1').value, document.getElementById('mth_2').value, document.getElementById('mth_3').value, document.getElementById('upToDate').value); }">	
				 
				</cfoutput>
				
			</td>
		</tr>
		</table>
	
	</td></tr>
</table>

</td></tr>
</table>	

<cfset ajaxOnLoad("doCalendar")>