<!--
    Copyright © 2025 Promisan

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
	<table width="100%" align="center" class="formpadding">
		<tr class="linedotted">
			<td class="labellarge" colspan="2">
				<cf_tl id="from" var="1">
				#ucase(lt_text)#
			</td>
		</tr>
		<tr>
			<td class="labelmedium" width="30%">
				<cf_tl id="As of" var="1">
				<span style="font-size:90%; color:808080;">#lt_text#:</span>
			</td>
			<td align="right">
				<!-- <cfform name="copySchedule1">-->
				<cf_intelliCalendarDate9
				    class="regularxl"
					FieldName="copyAsOfDate" 
					Default="#dateformat(vAsOf, CLIENT.DateFormatShow)#"
					DateValidStart="#dateformat(vDateValidStart, "yyyymmdd")#"
					message="Enter a valid as of date"
					AllowBlank="False"
					Manual="False"
					scriptdate="doScheduleChangeDate">	
				<!-- </cfform> -->
			</td>
		</tr>
		<tr>
			<td class="labelmedium" width="25%">
				<cf_tl id="Weeks" var="1">
				<span style="font-size:90%; color:808080;">#lt_text#:</span>
			</td>
			<td align="right">
				<select name="copyWeeks" id="copyWeeks" class="regularxl" onchange="doScheduleChange();">
					<cfloop from="1" to="#url.maxWeeks#" index="k">
						<option value="#k#" <cfif k eq url.weeks>selected</cfif>> #k#
					</cfloop>
				</select>
			</td>
		</tr>
		<tr><td height="20"></td></tr>
		<tr class="linedotted">
			<td class="labellarge" colspan="2">
				<cf_tl id="Starting" var="1">
				#ucase(lt_text)#
			</td>
		</tr>
		<tr>
			<td class="labelmedium" width="45%">
				<cf_tl id="Effective" var="1">
				<span style="font-size:90%; color:808080;">#lt_text#:</span>
			</td>
			<td align="right">
				<!-- <cfform name="copySchedule2">-->
				<cf_intelliCalendarDate9
				    class="regularxl"
					FieldName="copyEffectiveDate" 
					Default="#dateformat(vAsOfEnd, CLIENT.DateFormatShow)#"
					DateValidStart="#dateformat(vAsOfEnd, "yyyymmdd")#"
					message="Enter a valid effective date"
					AllowBlank="False"
					Manual="False">	
				<!-- </cfform> -->
			</td>
		</tr>
		<tr>
			<td class="labelmedium" width="45%">
				<cf_tl id="Not beyond" var="1">
				<span style="font-size:90%; color:808080;">#lt_text#:</span>
			</td>
			<td align="right">
				<!-- <cfform name="copySchedule3">-->
				<cf_intelliCalendarDate9
				    class="regularxl"
					FieldName="copyMaxDate" 
					Default="#dateformat(vAsOfEnd, CLIENT.DateFormatShow)#"
					DateValidStart="#dateformat(vAsOfEnd, "yyyymmdd")#"
					message="Enter a valid max date"
					AllowBlank="False"
					Manual="False">	
				<!-- </cfform> -->
			</td>
		</tr>
	</table>
</cfoutput>