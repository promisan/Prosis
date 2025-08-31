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
<table width="93%" cellspacing="0" cellpadding="0" align="center">

<tr><td style="height:50px;padding-top:10px" class="labelmedium line">
Apply the default staff work-schedule for salary calculations, which only applies if no other overruling schedule is found.<br>This schedule
is used also for leave balance calculation purposes.
</td></tr>

<tr class="line"><td style="padding-top:5px;padding-bottom:5px"  align="center">
<table width="460" cellspacing="0" cellpadding="0" class="formpadding" bgcolor="ffffef">

<cfoutput>
<cfloop index="i" from="1" to="7">
	<tr>
		<td width = "5%">
		</td>
		
		<td class="labelmedium">
			 #DayofWeekAsString(DayOfWeek(i))#
		</td> 
		
		<cfquery name="GetSSWork" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     SalaryScheduleWork
			WHERE    SalarySchedule = '#URL.ID1#'
			AND      Weekday = '#i#'
		</cfquery>

		<td>
				<select name="WorkHours_#i#" id="WorkHours_#i#" class="regularxl" style="width:50px">
					
					<cfloop index="it" list = "0,4,5,6,7,7.5,8">
					
					    <option value="#it#" <cfif GetSSWork.WorkHours eq it>selected</cfif>>#it#</option>
					
					</cfloop>	
					
				</select>
		</td>
	</tr>
</cfloop>

</cfoutput>

</table>
</td>
</tr>
</table>