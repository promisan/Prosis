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
<cfparam name="url.activityid" default="">

<cfset vThisActivity = url.activityid>

<cfif isDefined("EditActivity.ActivityId")>
	<cfset vThisActivity = EditActivity.ActivityId>
</cfif>

<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM	Parameter
</cfquery>

<cfquery name="getSchema" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT	S.*,
				SC.CalendarDateHour,
				SC.ActivityPayment
		FROM	ProgramActivitySchema S
				LEFT OUTER JOIN ProgramActivitySchemaSchedule SC
					ON S.ActivitySchemaId = SC.ActivitySchemaId
		WHERE	S.ProgramCode = '#URL.ProgramCode#'
		AND		S.ActivityPeriod = '#URL.Period#'
		AND		S.ActivityId = '#vThisActivity#'
</cfquery>

<cfoutput>
	<table width="99%" align="left">
		<tr>
			<td class="labellarge" align="center" style="min-width:100px;border:1px solid ##C0C0C0;"><cf_tl id="Hour"></td>
			
			<cfloop index="vDay" from="1" to="7">
				<cfquery name="getThisSchema" dbtype="query">
					SELECT 	*
					FROM	getSchema
					WHERE 	weekDay = #vDay#
				</cfquery>
				<td align="center" id="day_#vDay#" style="border:1px solid ##C0C0C0; padding:3px;">
					<cfset vThisDay = left(DayOfWeekAsString(vDay),3)>
					<table width="100%">
						<tr class="line">
							<td class="labelmedium" align="left" style="height:30px;padding-left:5px">#vThisDay#
							</td>
							<td align="right" style="padding-right:5px;">
								<cf_input name="PresentationColor_#vDay#" type="colorPicker" palette="basic" ajax=true value="#getThisSchema.PresentationColor#">
							</td>
						</tr>
						<tr>
							<td colspan="2" style="padding-top:2px">
								<table width="100%">
									<tr>
									
										<td style="padding-left:10px;">
											<input type="checkbox" 
												id="selectAll_#vDay#" 
												style="height:18px; width:18px; cursor:pointer" 
												onclick="$('.clsDay_#vDay#').prop('checked', this.checked);">
										</td>
										
										<td class="labelmedium" style="padding-left:10px;font-size:9px;">
											<cf_tl id="T"> 
										</td>
										<td align="center" style="padding-left:5px;">
											<select id="target_#vDay#" name="target_#vDay#" style="height:25px;">
												<cfloop index="vTarget" from="0" to="50">
													<option value="#vTarget#" <cfif getThisSchema.target eq vTarget>selected</cfif>> #vTarget#
												</cfloop>
											</select>
										</td>
									
										
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</cfloop>
		</tr>
		
		<tr>
			<td style="font-size:9px; border-left:1px solid ##C0C0C0; border-bottom:1px solid ##C0C0C0;"></td>
			<cfloop index="vDay" from="1" to="7">
				<td style="font-size:9px; border:1px solid ##C0C0C0; background-color:##E8E8E8;" align="center"><cf_tl id="Active"> / <cf_tl id="Payment"></td>
			</cfloop>
		</tr>
		
		<cfloop index="vHour" from="#parameter.hourStart#" to="#parameter.hourEnd#">
			<cfset vActualHour = vHour>
			<cfif vActualHour lt 0>
				<cfset vActualHour = 24 + vHour>
			</cfif>
			<tr class="line labelmedium" style="height:15px">
				
				<td align="center" id="hour_#vActualHour#" style="border-left:1px solid ##C0C0C0; border-right:1px solid ##C0C0C0; color:##909090;">
					<cfset vThisHour = vActualHour>
					<cfif vActualHour lt 10>
						<cfset vThisHour = "0#vThisHour#">
					</cfif>
					#vThisHour#:00
				</td>
				
				<cfloop index="vDay" from="1" to="7">
				
					<cfquery name="getThisSchema" dbtype="query">
						SELECT 	*
						FROM	getSchema
						WHERE 	weekDay = #vDay#
						AND 	calendarDateHour = #vHour#
					</cfquery>
					
					<td class="labellarge" 
						align="center" 
						id="tdHourDay_#vActualHour#_#vDay#"
						style="border-right:1px solid ##C0C0C0; cursor:pointer;" 
						onmouseover="hourDayHighlight('#vDay#', '#vActualHour#', '##D6FCB3');" 
						onmouseout="hourDayHighlight('#vDay#', '#vActualHour#', '');">
						
							<table width="100%">
								<tr>
									<td style="padding-left:15px">
										<input 
											type="checkbox" 
											class="clsDay_#vDay#" 
											id="hourDay_#vActualHour#_#vDay#" 
											name="hourDay_#vActualHour#_#vDay#" 
											style="height:18px; width:18px; cursor:pointer;"
											<cfif getThisSchema.recordCount eq 1>checked</cfif>>
									</td>
									<td align="right" style="padding-left:5px;">
										<select id="payment_#vActualHour#_#vDay#" name="payment_#vActualHour#_#vDay#" style=";border:0px;border-left:1px solid silver" class="regularxl">
											<option value="0" <cfif getThisSchema.ActivityPayment eq 0>selected</cfif>> ..
											<option value="1" <cfif getThisSchema.ActivityPayment eq 1>selected</cfif>> ND
											<option value="2" <cfif getThisSchema.ActivityPayment eq 2>selected</cfif>> DD
										</select>
									</td>
								</tr>
							</table>
					</td>
				</cfloop>
			</tr>
		</cfloop>
	</table>
</cfoutput>

<script>
	ProsisUI.doColor();
</script>

<cfset AjaxOnLoad("ProsisUI.doColor")> 