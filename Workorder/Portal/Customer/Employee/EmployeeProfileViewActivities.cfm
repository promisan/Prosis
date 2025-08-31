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
<cfset vInitialMonthDate = createDate(url.selectedYear,url.selectedMonth,1)>
<cfset vEndMonthDate 	 = createDate(url.selectedYear,url.selectedMonth,daysInMonth(vInitialMonthDate))>
<cfset vDataTense		 = "present">
<cfset vDataTenseMessage = "No activities planned for this month">

<cfif vInitialMonthDate lt createDate(year(now()), month(now()), 1)>
	<cfset vDataTense = "past">
	<cfset vDataTenseMessage = "No activities performed in this month">
</cfif>


	
<cfinvoke component		= "Service.Process.WorkOrder.WorkOrderStaff"
   	method	     		= "GetWorkOrderScheduledActions"
	initialDate		    = "#dateformat(vInitialMonthDate,client.dateformatshow)#"
	endDate			    = "#dateformat(vEndMonthDate,client.dateformatshow)#"
	tense				= "#vDataTense#"	
	customerId 		    = "#url.customerid#"
	workSchedule		= "#url.workSchedule#"
	personNo		    = "#url.personNo#"
	actorType			= "1,2"
	IncludePersonInfo   = "true"
	mode                = "subquery"
	returnvariable	    = "Activity">
				
	
<cfquery name="listing" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	
	SELECT *
	
	FROM (	
	
		SELECT tbl.*, 
				(SELECT   TOP 1 ScheduleHour
	             FROM	  WorkOrderLineScheduleDate
			     WHERE    ScheduleId = tbl.scheduleId
				 AND	  ScheduleDate = '#dateFormat(now(),client.dateSQL)#'
				 AND	  Operational = 1
				 ORDER BY ScheduleHour ASC) as ScheduleHour
					   
		FROM (#preservesingleQuotes(Activity)#) as tbl
	
	     ) as derrived
	
	ORDER BY ActionClass, Reference, ServiceDomainClass, ScheduleHour
	
	
</cfquery>		

<table width="100%" cellspacing="0" cellpadding="1" align="center">
	
	<cfif listing.recordCount eq 0>
		<tr>
			<td colspan="5" class="labelmedium" align="center" style="padding-top:50px;color:red;"><i><cf_tl id="#vDataTenseMessage#"></td>
		</tr>
	</cfif>
	
	<cfoutput query="listing" group="ActionClass">
	
		<tr>
			<td></td>
			<td colspan="4" class="labelmedium" style="height:40px;font-size:25px">#ActionClassDescription#</td>
		</tr>
			
		<cfoutput group="Reference">
				
			<cfoutput group="ServiceDomainClass">
			
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td colspan="2" class="labelit"><font color="002350">#ServiceDescription#: <b>#ClassDescription#</b></td>
				</tr>
				<tr><td height="1"></td></tr>
			
				<cfoutput>
				
					<tr><td height="1" colspan="4"></td>
					    <td style="border-left:0px dotted ##C0C0C0;"></td></tr>
						
					<tr>
						<td style="width:10px;"></td>
						<td style="width:5px;"></td>
						
						<td colspan="3" 
							id="activityContainer_#ScheduleId#"
							class="clsActivityContainer" 
							valign="middle"
							bgcolor="ffffcf"
							style="cursor:pointer; height:20px; border-top:1px solid silver; padding:2px;" 
							onclick="selectActivity('#ScheduleId#','#urlEncodedFormat(vInitialMonthDate)#','#PersonNo#','#PositionNo#');">
								<table width="96%" cellspacing="0" cellpadding="0" align="left">
									<tr>
										<td class="labelit" valign="top" width="2%" style="padding-left:3px;padding-right:3px;">
										  <cf_space spaces="6">
											#currentrow#.									
										</td>
									    <!---
										<td width="2%" class="labelit" style="padding-right:3px;" align="left" valign="middle">
											<cf_tl id="View Procedures" var="1">
											<img src="#session.root#/Images/document_edit.png" height="15px;" align="absmiddle" title="#lt_text#" 
												 onclick="getActivityProcedures('#ScheduleId#');">
										</td>										
										--->
										<td  align="left" valign="top" style="padding-right:3px">
											<table>
												<tr class="labelit">
													<td valign="top" width="100%">#Memo#</td>
													
													<cfif url.selectedYear eq year(now()) and url.selectedMonth eq month(now())>
													
														<td valign="top" width="1%" style="padding-left:5px;">
														   <cf_space spaces="10">
															<table>
																<tr class="labelit">
																	<td align="left"><cf_tl id="Today"></td>
																</tr>
																<tr>
																	<td class="labelit">
																	
																	    <!---
																		<cfquery name="firstHourOfTheDay" 
																			datasource="appsWorkOrder" 
																			username="#SESSION.login#" 
																			password="#SESSION.dbpw#"> 
																				SELECT    TOP 1 *
																				FROM	  WorkOrderLineScheduleDate
																				WHERE	  ScheduleId = '#scheduleId#'
																				AND		  ScheduleDate = '#dateFormat(now(),client.dateSQL)#'
																				AND		  Operational = 1
																				ORDER BY  ScheduleHour ASC
																		</cfquery>
																		--->
																		
																		<cfif schedulehour neq "">
																			<cfset vHour = Int(Abs(ScheduleHour))>
																			<cfset vMinute = Abs(ScheduleHour) - Int(Abs(ScheduleHour))>
																			<cfset vMinute = Round(vMinute * 60)>
																			<cfif vHour lt 10>
																				<cfset vHour = "0" & vHour>
																			</cfif>
																			<cfif vMinute lt 10>
																				<cfset vMinute = "0" & vMinute>
																			</cfif>
																			#vHour#:#vMinute#
																		<cfelse>
																			--
																		</cfif>
																	</td>
																</tr>
															</table>
														</td>
													
													</cfif>
													
												</tr>
											</table>
										</td>
									</tr>
								</table>
						</td>
						<td style="width:20px;"></td>
					</tr>
					
				</cfoutput>
				
				<tr><td style="height:5px;"></td></tr>
							
			</cfoutput>
			
			<tr><td style="height:5px;"></td></tr>
			
		</cfoutput>
	
	</cfoutput>
	
</table>
	