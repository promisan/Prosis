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
<cfparam name="url.moduleaccessmode" 	default="workOrder">
<cfparam name="url.ActionClass" 		default="">
<cfparam name="url.WorkSchedule" 		default="">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   S.*,
		       
				 (SELECT TOP 1 ScheduleDate FROM WorkOrderLineScheduleDate WHERE ScheduleId = S.ScheduleId AND Operational = 1 AND ScheduleDate > getDate() ORDER BY ScheduleDate) as ScheduleDateNext,
				 
			     (SELECT TOP 1 ScheduleHour FROM WorkOrderLineScheduleDate WHERE ScheduleId = S.ScheduleId AND Operational = 1 AND ScheduleDate > getDate() ORDER BY ScheduleDate) as ScheduleHourNext,				
				 
				 (SELECT TOP 1 ScheduleDate FROM WorkOrderLineScheduleDate WHERE ScheduleId = S.ScheduleId AND Operational = 1 ORDER BY ScheduleDate DESC) as ScheduleExpiration,
								
				 (SELECT DISTINCT WLS.ScheduleId
				  FROM   WorkOrderLineSchedule WLS INNER JOIN
	                     WorkOrderLineScheduleDate WLSD ON WLS.ScheduleId = WLSD.ScheduleId
				  WHERE   WLSD.ScheduleDate > GETDATE() 
				  AND     WLS.ScheduleId = S.ScheduleId
				  AND     WLSD.ScheduleHour >= 0
				  AND	  WLSD.Operational = 1
				  AND     WLS.WorkSchedule NOT IN
                          (
							SELECT   WorkSchedule
                            FROM     Employee.dbo.WorkScheduleDateHour SD
                            WHERE    WorkSchedule      = WLS.WorkSchedule 
							AND      WLSD.ScheduleDate = SD.CalendarDate 
							AND      (
							 				WLSD.ScheduleHour = SD.CalendarHour
											OR
											WLSD.ScheduleHour = (SD.CalendarHour + (SELECT HourMode/60.0 FROM Employee.dbo.WorkSchedule WHERE Code = WLS.WorkSchedule))
											OR
											WLSD.ScheduleHour = -1
									 )												
							)
				 ) as hasMissingHours,
								 
				 
				 A.Description AS ActionClassDescription,
				 ES.Description as WorkScheduleDescription,
				 ES.Operational as ScheduleOperational,
				 W.Mission,
				 
				 (SELECT Description 
				  FROM   Employee.dbo.Ref_ScheduleClass 
				  WHERE  Code = ES.ScheduleClass) as ScheduleClassNameDefault,
				  
				 (SELECT Description 
				  FROM   Employee.dbo.Ref_ScheduleClass 
				  WHERE  Code = S.ScheduleClass) as ScheduleClassName
				  
				 
		FROM     WorkOrderLineSchedule S
				 INNER JOIN Employee.dbo.WorkSchedule ES
				 	ON ES.Code = S.WorkSchedule
				 INNER JOIN WorkOrder W
				 	ON W.WorkOrderId = S.WorkOrderId
				 INNER JOIN Ref_Action A
				 	ON S.ActionClass = A.Code
		WHERE    S.WorkorderId     = '#url.workorderId#'
		AND      S.WorkorderLine   = #url.workorderline#
		AND      S.ActionStatus != '9'
		<cfif url.moduleaccessmode eq "staffing">
		AND    	 S.ActionClass   = '#url.ActionClass#'
		AND      S.WorkSchedule  = '#url.WorkSchedule#'
		</cfif>
		ORDER BY S.ActionClass, S.WorkSchedule, S.ScheduleClass, LTRIM(S.Memo) ASC
</cfquery>


<table width="100%" height="100%">

<tr><td height="20">

			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font:13px;height:21;width:120"
			   rowclass         = "searchclass"
			   rowfields        = "ccontent">
						   
	   </td></tr>
	   
<tr><td height="100%">			

	<cf_divscroll style="height:100%">
	
	<table width="98%" align="center">
	
		<tr class="hide"><td height="5"></td></tr>
		
		<tr>
		
			<td colspan="2" style="padding-left:4px">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
			
			<tr>		    
			    <td width="15%" style="padding-left:30px;" class="labelit"><cf_tl id="Action"></td>
				<td width="90"  class="labelit"><cf_tl id="Effective"></td>			
				<td width="90"  class="labelit"><cf_tl id="Expiration"></td>			
				<td width="120" class="labelit"><cf_tl id="Next Action"></td>
				<td class="labelit"><cf_tl id="Memo"></td>		  
				<td align="center" class="labelit"><cf_tl id="Status"></td>
				<td height="23" align="center" class="labelmedium">
					<cfif url.moduleaccessmode eq "workorder">
						<cfoutput>
							<A href="javascript:editSchedule('#url.workorderId#','#url.workorderline#','','edit')">
							<font color="0080FF">[<cf_tl id="add">]</font></a>
						</cfoutput>
					</cfif>
				</td>
			</tr>
			<tr><td class="line" colspan="7"></td></tr>
					
			<cfif get.recordCount eq 0>		
				<tr><td align="center" height="25" class="labelit" colspan="6" style="color:808080; font-weight:bold;">[<cf_tl id="No schedules recorded">]</td></tr>
				<tr><td class="line" colspan="6"></td></tr>			
			</cfif>
			
			<cfset previousClass = "">
			
			<cfoutput query="get" group="ActionClass">
				
				<cfoutput group="WorkSchedule">
																
					<tr class="<cfif ActionClass neq previousClass>line</cfif>">
					<cfset vShade = "">
					<cfif ActionClass neq previousClass>
						<cfset vShade = "background-color:E4E4E4;">
					</cfif>
					<td style="height:45px;font-size:19px;padding-left:9px;border-top:1px solid silver" bgcolor="efefef">					
						<cfif ActionClass neq previousClass>
							<font color="black">#ActionClassDescription#
						</cfif>
					</td>
					
					<td colspan="6" class="label" style="padding-left:6px;border-top:1px solid gray" bgcolor="efefef">
						<table cellspacing="0" cellpadding="0">
							<tr>
								
								<td valign="middle" style="padding-left:0px;">
									<table>
										<tr>
											<td valign="middle" style="width:400px" class="labelmedium"><font color="000080"><u><cfif ScheduleClassName eq "">#ScheduleClassNameDefault#<cfelse>#ScheduleClassName#</cfif> / #WorkScheduleDescription#</b>
											<cfif scheduleoperational eq "0"><font color="FF0000">[deactivated]</b></cfif>
											</td>
											<td valign="middle" class="labelit" style="padding-top:3px;padding-left:10px; color:##a0a0a0; font-size:14px;">
											
												<cfquery name="getResponsibles" 
													datasource="AppsWorkOrder" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT DISTINCT 	
																WP.PersonNo,
																P.FirstName,
																P.LastName
														FROM 	WorkOrderLineSchedulePosition WP 
														        INNER JOIN Employee.dbo.Person P   ON WP.PersonNo = P.PersonNo	
																INNER JOIN WorkOrderLineSchedule S ON WP.ScheduleId = S.ScheduleId
														WHERE	S.WorkOrderId   = '#WorkOrderId#'
														AND		S.WorkOrderLine = '#WorkOrderLine#'
														AND		S.ActionClass   = '#ActionClass#'
														AND		S.WorkSchedule  = '#WorkSchedule#'
														AND		WP.isActor IN ('2')
														AND		WP.Operational  = 1
												</cfquery>
												
												<cfset responsibleList = "">
												<cfloop query="getResponsibles">
													<cfsavecontent variable="responsibleList">#responsibleList#<a title="view profile" href="javascript:EditPerson('#PersonNo#')" style="color:0080C0">#FirstName# #LastName#</a>,</cfsavecontent>
												</cfloop>
												
												<cfif responsibleList neq "">
													<cfset responsibleList = mid(responsibleList, 1, len(responsibleList)-2)>
												<cfelse>
													<cf_tl id="no active responsibles" var="1">
													<cfsavecontent variable="responsibleList"><font color="red">#lt_text#</cfsavecontent>																					
												</cfif>
												
												<!--- we now show on the line 
												#responsibleList#
												--->
												
											</td>
										</tr>
									</table>
								</td>
								
								<td>
									<cf_tl id="Assign Responsible" var="1">
									<img src="#session.root#/Images/person4.png" 
										height="14" 
										align="absmiddle" 
										style="cursor:pointer;" 
										title="#lt_text#" 
										onclick="assignResponsibleWorkSchedule('#url.workorderId#','#url.workorderline#','#ActionClass#','#WorkSchedule#');">
								</td>
								<td style="padding-left:5px;">
									<cfif url.moduleaccessmode eq "workorder">
										<cf_tl id="Replicate task" var="1">
										<img 
											src="#session.root#/Images/copy.png" 
											height="13" 
											align="absmiddle" 
											style="cursor:pointer;" 
											title="#lt_text#" 
											onclick="copyWorkSchedule('#url.workorderId#','#url.workorderline#','#ActionClass#','#WorkSchedule#');">
									</cfif>
								</td>
								
							</tr>
						</table>
					</td>
					</tr>
					
					
					<cfset row = 0>
					
						<cfoutput>
						
						<cfset row = row+1>		
						
						<cfif scheduleoperational eq "0">
						    <cfset color="FEBBAF">
						<cfelse>
							<cfset color="transparent">
						</cfif>		
										
						<tr bgcolor="#color#" class="labelmedium navigation_row searchclass line">
							
							<td width="20%" style="padding-left:30px;padding-right:5px" class="line">
							<table><tr><td width="15" style="padding-right:6px">
											<cf_img icon="edit" navigation="Yes" onclick="editSchedule('#url.workorderId#','#url.workorderline#','#scheduleId#','edit');">
										</td>
										<td class="labelmedium ccontent"><cfif schedulename neq "">#ScheduleName#<cfelse>[name]</cfif></td>
									</tr>
							</table>
							</td>
							
							<td height="19">#dateFormat(ScheduleEffective,'#CLIENT.dateformatshow#')#</td>	
							
							<td height="19">#dateFormat(ScheduleExpiration,'#CLIENT.dateformatshow#')#</td>	
							
							<td height="19">						
							
							<cfif ActionStatus eq 1 and ScheduleDateNext lte now()>
							
								<font color="FF0000"><cf_tl id="No Schedule"></font>
								
							<cfelseif hasMissingHours neq "">
							
								<font color="FF0000"><b>Hour mismatch</font>		
							
							<cfelse>
							
								#dateFormat(ScheduleDateNext,'#CLIENT.dateformatshow#')#
								<cfif scheduleHourNext gte "0">
								<cf_ConvertDecimalToHour DecimalHour = "#ScheduleHourNext#">	
								#StringHour#
								</cfif>
								
							</cfif>
							
							</td>	
							
							<td class="line ccontent" style="padding-left:4px">#Memo#</td>
								
							<td class="line" align="center" id="status_#scheduleid#">
							
								<cfif ActionStatus eq 1><cf_tl id="Active"><cfelse><font color="FF0000"><cf_tl id="Blocked"></cfif>
								
							</td>
							<td class="line" style="padding-left:5px">
								<table>
									<tr>
										<td>
										   <input type="checkbox" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('Schedule/setScheduleStatus.cfm?scheduleid=#scheduleid#&actionstatus='+this.checked,'status_#scheduleid#')" name="ActionStatus" <cfif actionstatus eq "1">checked</cfif>>
										</td>
										<td width="3"></td>
										
										<td width="3"></td>
										<td width="15">
											<cfif url.moduleaccessmode eq "workorder">
												<cf_tl id="copy" var="1">
												<img src="#session.root#/Images/copy.png" height="13" align="absmiddle" style="cursor:pointer;" title="#lt_text#" onclick="editSchedule('#url.workorderId#','#url.workorderline#','#scheduleId#','copy');">
											</cfif>
										</td>
										<cfif scheduleexpiration eq "" or actionstatus eq "0">
										<td width="3"></td>
										<td width="15">
											<cf_img icon="delete" onclick="purgeSchedule('#url.workorderId#','#url.workorderline#','#scheduleId#');">	
										</td>
										</cfif>
									</tr>
								</table>
							</td>
						</tr>
						
						<!--- added --->
						
						<cfquery name="getCurrentActors" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT	SP.*,
										P.FirstName,
										P.LastName
								FROM	WorkOrderLineSchedulePosition SP
										INNER JOIN Employee.dbo.Person P
											ON SP.PersonNo = P.PersonNo
								WHERE 	SP.ScheduleId = '#ScheduleId#' 
								AND 	(SP.PersonNo IS NOT NULL AND SP.PersonNo != '')
								AND		SP.isActor IN ('1','2')
								AND		SP.Operational  = 1
						</cfquery>
						
						<cfif getCurrentActors.recordCount gt 0>
						
							<tr class="navigation_row_child searchclass">
								<td></td>
								<td colspan="6" style="padding-left:5px;">
									<table width="100%" cellspacing="0" cellpadding="0" align="center">
										<tr>
											<td width="1%">
											   <div class="ccontent hide">#memo# #ScheduleName#</div>
												<img src="#session.root#/Images/join.gif">
											</td>
											<td align="left">
												<table cellspacing="0" cellpadding="0">
													<tr>
																						   
														
														<cfloop query="getCurrentActors">
															<cfset vPersonColor = "0080C0">
															<cfif operational eq 0>
																<cfset vPersonColor = "F5A9A9">
															</cfif>
															
															<td class="labelit" style="border:0px dotted ##C0C0C0; padding-left:2px; padding-right:2px;">
																<a title="view position" href="javascript:EditPosition('#get.mission#','','#PositionNo#')" style="color:#vPersonColor#">#PositionNo#:</a> 
																<a title="view profile" href="javascript:EditPerson('#PersonNo#')" style="color:#vPersonColor#">#FirstName# #LastName# <cfif isactor eq "2">(*)</cfif></a>
															</td>
															
														</cfloop>
														
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							
							<cfelseif scheduleexpiration gte now()>
							
							<tr class="navigation_row_child searchclass">
							<td>
							<div class="ccontent hide">#memo# #ScheduleName#</div>
							</td>
							
							 <cfif getCurrentActors.recordcount eq "0">
														
									<td colspan="6" class="labelit"><font color="FF0000"><cf_tl id="Attention">:<cf_tl id="No current actors set">.</font></td>
														
							 </cfif>
							 
							 </tr>
						
						</cfif>
						
					
					</cfoutput>		
					
					<cfset previousClass = ActionClass>
					
				</cfoutput>
				
				</tr><td height="20"></td>
				
			</cfoutput>
			
			
			</table>
			
			</td>
		
		</tr>
	
	</table>
	
	</cf_divscroll>

</td></tr>	  
</table>

<cfset AjaxOnLoad("doHighlight")>	