<cf_tl id="Assign Responsible" var="1">

<cf_screentop height="100%" 
	line="no" 
	scroll="No" 
	html="Yes" 
	layout="webapp" 
	label="#lt_text#" 	
	banner="gray" 
	user="no">
	
<cfoutput>

	<cfform name="frmWorkScheduleAssignResponsible" 
		action="Schedule/WorkScheduleAssignResponsibleSubmit.cfm?workorderId=#url.workorderId#&workorderline=#url.workorderline#&ActionClass=#url.ActionClass#&WorkSchedule=#url.WorkSchedule#">
		
		<input type="Hidden" id="fAssignResponsibleworkorderId"   value="#url.workorderId#">
		<input type="Hidden" id="fAssignResponsibleworkorderline" value="#url.workorderline#">
		<input type="Hidden" id="fAssignResponsibleActionClass"   value="#url.ActionClass#">
		<input type="Hidden" id="fAssignResponsibleWorkSchedule"  value="#url.WorkSchedule#">
					
		<table width="98%" align="center" cellspacing="3" class="formpadding">
			<tr><td height="5"></td></tr>
			<tr>
				<td colspan="2" class="labelmedium" style="color:red; font-size:12px;">
					** <cf_tl id="This action will replace all responsibles for the actions within this class and workschedule">.
				</td>
			</tr>
			<tr><td height="5"></td></tr>
			<tr>
				<td width="25%" class="labelmedium" style="padding-left:15px;"><cf_tl id="Effective">:</td>
				<td>
					<cf_intelliCalendarDate9
						FieldName="fAssignResponsibleDateEffective"
						class="regularxl"
						Message="Select a valid Effective Date"
						Default="#dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False">
						
					<cfajaxproxy bind="javascript:getDataByDate('fAssignResponsibleDateEffective',{fAssignResponsibleDateEffective})"> 
				</td>
			</tr>
			<tr>
				<td width="25%" class="labelmedium" style="padding-left:15px;"><cf_tl id="Responsible">:</td>
				<td>
					<cfdiv id="divAssignResponsiblePerson" bind="url:Schedule/getPerson.cfm?workorderId=#url.workorderId#&workorderline=#url.workorderline#&ActionClass=#url.ActionClass#&WorkSchedule=#url.WorkSchedule#&selectedDate=#dateFormat(now(),client.dateFormatShow)#&boxName=divEmployeeResponsible">
				</td>
			</tr>
			
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td colspan="2" align="center">
					<cf_tl id="Assign" var="1">
					<input class="button10g" type="Submit" name="btnSubmitWSAE" id="btnSubmitWSAE" value="#lt_text#" onclick="return validatePersonField('PersonNo');">
				</td>
			</tr>
			
		</table>
	</cfform>
	
</cfoutput>

<cfset ajaxOnLoad("doCalendar")>