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

<!--
<cfform method="post" name="xxscheduleform" id="_scheduleform">
-->

<table width="99%" cellspacing="4" align="center">

<tr><td height="5"></td></tr>

<tr>
	
<cfquery name  = "schedule" 
    datasource= "AppsWorkOrder" 
	username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">    
		SELECT	*
		FROM   	WorkOrderLineSchedule
		WHERE  	ScheduleId  = '#url.ScheduleId#'					  		
</cfquery>

<cfparam name="url.workschedule" default="#schedule.workschedule#">
		
<cfquery name  = "get" 
    datasource= "AppsWorkOrder" 
	username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">    
		SELECT	*
		FROM   	WorkOrderLineScheduleDate
		WHERE  	ScheduleId   = '#url.ScheduleId#'					  
		AND     ScheduleDate =  #url.selecteddate#	
		AND     Operational = 1
</cfquery>

<cfif url.selecteddate gte now()-1>
	<cfset accessmode = "edit">
<cfelse>
	<cfset accessmode = "view">
</cfif>
		
<cfoutput>

	<cfif accessmode eq "View" and get.recordcount eq "0">
	
		<td class="labelmediumcl" align="center"><cf_tl id="No Schedule"></td>
	
	<cfelse>
			
		<td width="50%" valign="top">
					
				<table width="100%">
								
				<!--- check the valid schedule on the staffing level here --->
				
				<cfset vWOId = "00000000-0000-0000-0000-000000000000">
				<cfif schedule.workOrderId neq "">
					<cfset vWOId = schedule.workOrderId>
				</cfif>
				
				<cfquery name  = "checkValid" 
			    	datasource= "AppsEmployee" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">    
						SELECT 	H.*
						FROM	WorkScheduleDateHour H
						WHERE	H.WorkSchedule = '#url.workSchedule#'
						AND		H.CalendarDate = #url.selecteddate#
												
						AND		EXISTS
									(
										SELECT	'X'
										FROM	WorkScheduleOrganization
										WHERE	WorkSchedule = H.WorkSchedule
										AND		OrgUnit IN  (SELECT  OrgUnit
															 FROM	 WorkOrder.dbo.WorkorderImplementer
															 WHERE   WorkOrderId = '#vWOId#'  )
									) 
									
						ORDER BY CalendarHour ASC
				</cfquery>
				
				<cfquery name  = "getWorkSchedule" 
			    	datasource= "AppsEmployee" 
				    username  = "#SESSION.login#" 
					password  = "#SESSION.dbpw#">
						SELECT 	*
						FROM	WorkSchedule
						WHERE	Code = '#url.workSchedule#'	
				</cfquery>			
			
				<cfif checkValid.recordCount eq 0>
				
					<tr>
						<td colspan="2" align="center" class="labelmedium"><font color="FF0000"><cf_tl id="Attention">: <cf_tl id="Activities may not be scheduled for this action on" class="message"> <b>#dateformat(url.selecteddate,client.dateformatshow)#</b>.</td>
					</tr>
					
					<tr><td colspan="2">
					
						<table width="100%" align="center">
							<tr>
								<td>
									<cfdiv id="dPersonList" bind="url:#session.root#/workorder/application/workOrder/serviceDetails/Schedule/PersonList.cfm?ScheduleId=#url.ScheduleId#&selecteddate=#dateFormat(url.selecteddate,client.dateSQL)#&accessmode=#accessmode#">
								</td>
							</tr>
						</table>		
						
					</td></tr>
				
				<cfelse>
					
					<cfif url.mode eq "edit">
					
						<tr>
						    <!---
							<td width="1%" valign="top" class="labelmedium" style="padding-right:10px;"><cf_tl id="Actioned">:</td>
							--->
		
							<td valign="top">
							
								<table border="0" cellspacing="0" cellpadding="0">
								
								<cfset vEnabled = "">
								
								<!--- Show Anytime row --->
								<cfif dateDiff('d', now(), url.selecteddate) gte 0>
								
										<cfquery name  = "check" 
										    	datasource= "AppsWorkOrder" 
											    username  = "#SESSION.login#" 
												password  = "#SESSION.dbpw#">    
													SELECT	*
													FROM   	WorkOrderLineScheduleDate
													WHERE  	ScheduleId   = '#url.ScheduleId#'					  
													AND     ScheduleDate =  #url.selecteddate#	
													AND		ScheduleHour = '-1'
													AND     Operational = 1
										</cfquery>
										
										<cfset vMemo = "">
										<cfif check.recordCount gt 0>
											<cfset vMemo = check.memo>
											<cfset vEnabled = "disabled">
										</cfif>
								
									<tr>
									
										<td style="padding:0px;padding-left:3px;padding-right:3px">
											<input type="checkbox" name="Hour_AnyTime" 
											   id="Hour_AnyTime" 
											   value="-1" 
											   <cfif check.recordcount eq "1">checked</cfif> 
											   onclick="selectAnyTime(this);">									
										</td>
										<td class="labelit" style="padding-right:4px"><cf_tl id="Anytime"></td>
										
										<td style="padding:0px;padding-left:3px;padding-right:20px;">
											<cfinput type="text" class="enterastab" name="Memo_AnyTime" id="Memo_AnyTime" style="padding:1px; width:120px;" value="#vMemo#" maxlength="80">
										</td>
										
									</tr>
								
								</cfif>
								
								<!--- Show first hour of the schedule --->
								
								<cfloop query="checkValid" endrow="1">																		

									<cfset vCalendarHour = CalendarHour>
																	
									<cfif dateDiff('d', now(), url.selecteddate) gte 0>
									
										<!---future and now--->
										
										<cfquery name  = "check" 
									    	datasource= "AppsWorkOrder" 
										    username  = "#SESSION.login#" 
											password  = "#SESSION.dbpw#">    
												SELECT	*
												FROM   	WorkOrderLineScheduleDate
												WHERE  	ScheduleId   = '#url.ScheduleId#'					  
												AND     ScheduleDate =  #url.selecteddate#	
												AND		ScheduleHour = '#vCalendarHour#'
												AND     Operational = 1
										</cfquery>
										
									<cfelse>
									
										<!---past--->
										
										<cfquery name  = "check" 
									    	datasource= "AppsWorkOrder" 
										    username  = "#SESSION.login#" 
											password  = "#SESSION.dbpw#">    
												SELECT	(DATEPART(hour, DateTimePlanning) + (CONVERT(FLOAT, DATEPART(minute, DateTimePlanning)) / 60.0)) ScheduleHour,
														ActionMemo as Memo
												FROM	WorkOrderLineAction
												WHERE	ScheduleId = '#url.ScheduleId#'
												AND		YEAR(DateTimePlanning)  = '#year(url.selecteddate)#'
												AND		MONTH(DateTimePlanning) = '#month(url.selecteddate)#'
												AND		DAY(DateTimePlanning)   = '#day(url.selecteddate)#'
												AND		(DATEPART(hour, DateTimePlanning) + (CONVERT(FLOAT, DATEPART(minute, DateTimePlanning)) / 60.0)) = '#vCalendarHour#'
										</cfquery>
										
									</cfif>
									
									<cfset vMemo = "">
									<cfif check.recordCount gt 0>
										<cfset vMemo = check.memo>
									</cfif>
									
									<tr>
										<td style="padding:0px;padding-left:3px;padding-right:3px">
										
											<input type="checkbox" name="Hour_#replace(vCalendarHour,'.','_','ALL')#" class="enterastab clsHour" #vEnabled#
											   id="Hour_#replace(vCalendarHour,'.','_','ALL')#" value="#vCalendarHour#" <cfif check.recordcount eq "1">checked</cfif>>
										</td>
										
										<td class="labelit" style="padding:1px;padding-right:5px;">
											<cfset hrS = Int(Abs(vCalendarHour))>
											<cfset minS = (Abs(vCalendarHour) - Int(Abs(vCalendarHour))) * 60>
											<cfif hrS lt 10>0</cfif>#hrS#:<cfif minS lt 10>0</cfif>#minS#h
										</td>
										
										<td style="padding:1px;padding-left:3px;padding-right:25px;">
											<cfif vEnabled eq "">
												<cfinput type="text" name="Memo_#replace(vCalendarHour,'.','_','ALL')#" id="Memo_#replace(vCalendarHour,'.','_','ALL')#" class="clsHourMemo enterastab" style="padding:1px; width:120px;" value="#vMemo#" maxlength="80">
											<cfelse>
												<cfinput type="text" name="Memo_#replace(vCalendarHour,'.','_','ALL')#" id="Memo_#replace(vCalendarHour,'.','_','ALL')#" class="clsHourMemo enterastab" style="padding:1px; width:120px;" value="#vMemo#" maxlength="80" disabled>
											</cfif>
									    </td>																																					
							
								</cfloop>
								
								<!--- -------------------------------------------------- --->			
								<!--- Show the rest of the valid schedule a period ahead --->		
								<!--- -------------------------------------------------- --->	
								
								<cfset row = "1">	
										
								<cfloop query="checkValid">																								

									<cfset vCalendarHour = CalendarHour + (getWorkSchedule.HourMode / 60)>
																	
									<cfif dateDiff('d', now(), url.selecteddate) gte 0>
									
										<!---future and now--->
										
										<cfquery name  = "check" 
									    	datasource= "AppsWorkOrder" 
										    username  = "#SESSION.login#" 
											password  = "#SESSION.dbpw#">    
												SELECT	*
												FROM   	WorkOrderLineScheduleDate
												WHERE  	ScheduleId   = '#url.ScheduleId#'					  
												AND     ScheduleDate =  #url.selecteddate#	
												AND		ScheduleHour = '#vCalendarHour#'
												AND     Operational = 1
										</cfquery>
										
									<cfelse>
									
										<!---past--->
										
										<cfquery name  = "check" 
									    	datasource= "AppsWorkOrder" 
										    username  = "#SESSION.login#" 
											password  = "#SESSION.dbpw#">    
												SELECT	(DATEPART(hour, DateTimePlanning) + (CONVERT(FLOAT, DATEPART(minute, DateTimePlanning)) / 60.0)) ScheduleHour,
														ActionMemo as Memo
												FROM	WorkOrderLineAction
												WHERE	ScheduleId = '#url.ScheduleId#'
												AND		YEAR(DateTimePlanning)  = '#year(url.selecteddate)#'
												AND		MONTH(DateTimePlanning) = '#month(url.selecteddate)#'
												AND		DAY(DateTimePlanning)   = '#day(url.selecteddate)#'
												AND		(DATEPART(hour, DateTimePlanning) + (CONVERT(FLOAT, DATEPART(minute, DateTimePlanning)) / 60.0)) = '#vCalendarHour#'
										</cfquery>
										
									</cfif>
									
									<cfset vMemo = "">
									<cfif check.recordCount gt 0>
										<cfset vMemo = check.memo>
									</cfif>
									
									<cfset row = row+1>
									
									<cfif row eq "1">									
										<tr>										
									</cfif>
									
										<td style="padding:0px;padding-left:3px;padding-right:3px">										
											<input type="checkbox" name="Hour_#replace(vCalendarHour,'.','_','ALL')#" class="clsHour" #vEnabled#
											   id="Hour_#replace(vCalendarHour,'.','_','ALL')#" value="#vCalendarHour#" <cfif check.recordcount eq "1">checked</cfif>>
										</td>
										
										<td class="labelit" style="padding:1px;padding-right:5px;">
											<cfset hrS = Int(Abs(vCalendarHour))>
											<cfset minS = (Abs(vCalendarHour) - Int(Abs(vCalendarHour))) * 60>
											<cfif hrS lt 10>0</cfif>#hrS#:<cfif minS lt 10>0</cfif>#minS#h
										</td>
										
										<td style="padding:1px;padding-left:3px;padding-right:25px;">
											<cfif vEnabled eq "">
												<cfinput type="text" name="Memo_#replace(vCalendarHour,'.','_','ALL')#" id="Memo_#replace(vCalendarHour,'.','_','ALL')#" class="clsHourMemo enterastab" style="padding:1px; width:120px;" value="#vMemo#" maxlength="80">
											<cfelse>
												<cfinput type="text" name="Memo_#replace(vCalendarHour,'.','_','ALL')#" id="Memo_#replace(vCalendarHour,'.','_','ALL')#" class="clsHourMemo enterastab" style="padding:1px; width:120px;" value="#vMemo#" maxlength="80" disabled>
											</cfif>
									    </td>
										
									<cfif row eq "2">									
									</tr>
									<cfset row = 0>
									</cfif>	
																														
							
								</cfloop>								
								
								</table>
																	
							</td>	
							
							<td valign="top" width="100%" style="border:1px dotted silver">
								<cfdiv id="dPersonList" bind="url:#session.root#/workorder/application/workOrder/serviceDetails/Schedule/PersonList.cfm?ScheduleId=#url.ScheduleId#&selecteddate=#dateFormat(url.selecteddate,client.dateSQL)#&accessmode=#accessmode#">
							</td>
							
						</tr>	
									
							
					</cfif>
				
				</cfif>
							
				<tr><td colspan="7" class="line"></td></tr>
				
				</table>
				
		</td>
			
		</tr>		
			
		<cfif accessmode eq "edit">
			
			<tr><td colspan="2" style="padding-left-4px;">
				
				<cfif trim(url.scheduleId) neq "" and trim(url.scheduleId) neq "00000000-0000-0000-0000-000000000000">

				<table cellspacing="1" cellpadding="1" class="formpadding">
				<tr>
				
					<cfif url.mode eq "edit">					
					
						<td>
						
							<cf_tl id="Inherit" var="1">
							
							<input class="button10g" style="width:170;height:25px" 
							   type="button" name="Inherit" value="#lt_text#" onclick="inheritschedule('#url.ScheduleId#','#urlencodedformat(url.selecteddate)#','#url.mode#')">
																				 
						</td>
						
						<td>
						
							<cf_tl id="Save" var="1">
							
							<input class="button10s" style="width:170;height:25px" 
							   type="button" name="Inherit" value="#lt_text#" onclick="saveschedule('#url.ScheduleId#','#urlencodedformat(url.selecteddate)#','add','#url.mode#')">
								 
								
						</td>
						
					<cfelseif url.mode eq "copy">
					
						<td>
							<cf_tl id="Create Copy" var="1">
						    <cf_button width="150px;"
								height="25px;"
							    value="#lt_text#" 
							    name="Save"
							    onclick="copyschedule('#url.ScheduleId#','#urlencodedformat(url.selecteddate)#','#url.mode#')">							 
						</td>
					</cfif>	
				</tr>
				</table>
				
				</cfif>
			
			</td></tr>
			
		</cfif>
						
	</cfif>	
	
</cfoutput>	

</table>

<!--
</cfform>
-->