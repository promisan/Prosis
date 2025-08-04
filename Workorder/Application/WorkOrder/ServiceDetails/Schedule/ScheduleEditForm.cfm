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
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder W
		WHERE   WorkOrderId = '#url.workorderid#'		
</cfquery>

<cfquery name="customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Customer
		WHERE   CustomerId = '#workorder.CustomerId#'
</cfquery>

<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine WL 
		 		 INNER JOIN WorkOrderService WS 
				 	ON WL.ServiceDomain = WS.ServiceDomain 
					AND WL.Reference = WS.Reference 
		 WHERE   WL.WorkOrderId     = '#url.workorderid#'	
		 AND     WL.WorkOrderLine   = '#url.workorderline#'
</cfquery>

<cfquery name="DomainClass" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_ServiceItemDomainClass
		WHERE    ServiceDomain    = '#line.servicedomain#'	
		AND      Code             = '#line.servicedomainclass#'
</cfquery>

<cfquery name="Item" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#item.servicedomain#'	
</cfquery>

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   S.*,
				 A.Description AS ActionClassDescription,
				 ES.Description AS WorkScheduleDescription
		FROM     WorkOrderLineSchedule S INNER JOIN WorkOrder W ON W.WorkOrderId = S.WorkOrderId
										 INNER JOIN Ref_Action A ON S.ActionClass = A.Code AND W.Mission = A.Mission
										 INNER JOIN Employee.dbo.WorkSchedule ES ON S.WorkSchedule = ES.Code
		<cfif url.ScheduleId neq "">
		WHERE    S.ScheduleId = '#URL.scheduleId#'
		<cfelse>
		WHERE 	 1=0
		</cfif>
</cfquery>

<table width="100%">

<tr><td colspan="2" class="line"></td></tr>

<tr><td width="85%" style="padding:20px">

	<table width="100%" cellspacing="2" cellpadding="2" align="center" class="formpadding">
					
		<cfoutput>
		
		<input type="hidden" name="ScheduleId" id="ScheduleId" value="#url.ScheduleId#">	
		
		<cfif url.ScheduleId eq "">
		
			<tr>
				<td height="23" width="15%" class="labelmedium"><cfif domain.description neq "">#Domain.description#<cfelse>Id</cfif>:</td>
				<td class="labelmedium" style="padding-left:3px"><b>#line.reference# #line.Description# : #domainClass.description# </b></td>							
			</tr>
		
		<cfelse>
		
			<cfif url.mode neq "copy">
			
				<cfif url.mode eq "edit">
			
					<tr>
						<td height="23" class="labelmedium"><cf_tl id="Reassign schedule">:</i></td>
						<td>
						
						<table cellspacing="0" cellpadding="0">
						<tr><td>
									
						<cfset link = "getWorkOrderLine.cfm?workorderid=#get.workorderid#&workorderline=#get.workorderline#">	
							
						   <cf_selectlookup
						    box          = "orderline"
							link         = "#link#"
							button       = "Yes"
							title        = "Assign to different Line"
							close        = "Yes"		
							filter1      = "W.workorderid"
							filter1value = "#workorder.workorderid#"
							filter2      = "ServiceItem"
							filter2value = "#workorder.serviceitem#"	
							filter3      = "W.Mission"
							filter3value = "#workorder.mission#"								
							icon         = "contract.gif"
							class        = "workorderline"
							des1         = "workorderlineid">	
							
						</td>		
						
						<td id="orderline" style="padding-left:7px" class="labelmediumcl"></td>		
						
						</tr></table>	
					</tr>
					
					<tr><td colspan="2" class="line"></td></tr>
				
				</cfif>		
				
			<tr><td height="23" class="labelmedium"><cf_tl id="Activity class">:</td>
				<td class="labelmedium">
				 
					#get.ActionClassDescription#
					<cfif url.mode eq "edit">
						<input type="hidden" name="ActionClass" id="ActionClass" value="#get.ActionClass#">						
						<input type="hidden" name="workorderline" id="workorderline" value="#get.workorderline#">
					</cfif>
				</td>
				
			</tr>
			
			<tr>
				<td height="23" class="labelmedium"><a href="javascript:workschedule(document.getElementById('WorkSchedule').value)"><font color="0080C0"><u><cf_tl id="Workschedule">:</a></i></td>
				<td>
					<table cellspacing="0" cellpadding="0">
						<tr>
							<td class="labelmedium">							
							
								<cfquery name="lookupWS" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT  WS.*
										FROM    WorkSchedule WS
												INNER JOIN WorkScheduleOrganization WSO
													ON WS.Code = WSO.WorkSchedule
										WHERE   WS.Mission = '#workorder.mission#'
										AND		WS.Operational = 1
										AND		WSO.OrgUnit IN (SELECT I.OrgUnit 
										                        FROM   WorkOrder.dbo.WorkOrderImplementer I
																		INNER JOIN Organization.dbo.Organization O
																			ON I.OrgUnit = O.OrgUnit 
																WHERE  I.WorkOrderId = '#workorder.WorkOrderId#')
										ORDER BY WS.Description
								</cfquery>
								
								<cfif url.mode eq "Edit">
																
								<cfselect class="regularxl"
								   name="WorkSchedule" 
								   id="WorkSchedule" 
								   query="lookupWS" 
								   selected="#get.workSchedule#" 
								   display="Description" 
								   value="Code" 
								   required="Yes" 
								   onchange="ColdFusion.navigate('#session.root#/workorder/application/workOrder/serviceDetails/Schedule/ScheduleDateView.cfm?scheduleId=#url.scheduleId#&mode=#url.mode#&workschedule='+this.value,'detailDiv')"
								   message="Please, select a valid staffing workschedule for this task."/>
								   
								<cfelse>
								
								#get.WorkScheduleDescription#		
								<input type="hidden" name="WorkSchedule" id="WorkSchedule" value="#get.workSchedule#">
								
								</cfif>   
							
								
							</td>
							<td height="23" valign="top" style="padding-top:4px; padding-left:8px;" class="labelmedium">
								<cf_tl id="Class">:
							</td>
							<td style="padding-left:8px;" class="labelmedium">
							    <cfif url.mode eq "edit">
								
								<cfdiv id="divWorkScheduleClass" bind="url:setScheduleClass.cfm?workSchedule={WorkSchedule}&selectedScheduleClass=#get.ScheduleClass#&ScheduleId=#url.ScheduleId#">   
								
								<cfelse>
								
								#get.ScheduleClass#
								
								</cfif>
								
							</td>
						</tr>
					</table>
				</td>					
			</tr>
						
			</cfif>
								
		</cfif>
				
		</cfoutput>
		
		<cfif url.ScheduleId eq "" or url.mode eq "copy">
						
			<tr>
				<td height="23" width="15%" class="labelmedium"><cf_tl id="Action">:</td>
				<td class="labelmediumcl">						
									
						<cfquery name="lookup" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_Action
								
								WHERE    Code IN (SELECT Code 
											      FROM   Ref_ActionServiceItem
												  WHERE  ServiceItem = '#workorder.serviceitem#')
												
								AND		 EntryMode = 'Batch'
								AND 	 Operational = '1'
								ORDER BY ListingOrder
						</cfquery>
																	
						<cfselect class="regularxl" name="ActionClass" id="ActionClass" query="lookup" display="Description" value="Code" required="Yes" message="Please, select a valid action."/>
			
				</td>
			</tr>		
			
			<tr>
				<td height="23" class="labelmedium"><cf_tl id="Workschedule">:</td>
				<td>
					<table cellspacing="0" cellpadding="0">
						<tr>
							<tr>
								<td class="labelmediumcl">
												
										<cfquery name="lookupWS" 
											datasource="AppsEmployee" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT  WS.*
												FROM    WorkSchedule WS
														INNER JOIN WorkScheduleOrganization WSO
															ON WS.Code = WSO.WorkSchedule
												WHERE   WS.Mission = '#workorder.mission#'
												
												AND		WS.Operational = 1
												AND		WSO.OrgUnit IN (SELECT OrgUnit 
												                        FROM   WorkOrder.dbo.WorkOrderImplementer 
																		WHERE  WorkOrderId = '#workorder.WorkOrderId#')
																		
												ORDER BY WS.Description
										</cfquery>
										
										<cfselect class="regularxl"
										   name="WorkSchedule" 
										   id="WorkSchedule" 
										   query="lookupWS" 
										   selected="#get.workSchedule#" 
										   display="Description" 
										   value="Code" 
										   required="Yes" 
										   message="Please, select a valid staffing workschedule for this task."/>
										
								</td>
								<td height="23" valign="top" style="padding-top:4px; padding-left:8px;" class="labelmedium">
									<cf_tl id="Class">:
								</td>
								<td style="padding-left:8px;" class="labelmediumcl">
									<cfdiv id="divWorkScheduleClass" bind="url:setScheduleClass.cfm?workSchedule={WorkSchedule}&selectedScheduleClass=#get.ScheduleClass#&ScheduleId=#url.ScheduleId#">   
								</td>
							</tr>
						</tr>
					</table>
				</td>
			</tr>
			
		</cfif>
				
				
		<tr>
			<td height="23" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Activity Name">:</td>
			<td class="labelmediumcl">
			<cfoutput>		
			   <cfif url.mode eq "Edit">		
			     <input class="regularxl" name="ScheduleName" id="ScheduleName" size="30" maxlength="30" value="#Get.ScheduleName#">
			   <cfelse>
			     #Get.ScheduleName#
				 <input type="Hidden" name="ScheduleName" id="ScheduleName" value="#Get.ScheduleName#">
			   </cfif> 
			</cfoutput>				
			</td>
		</tr>
		
		<cfset priormode = url.mode>
		
		<cfset url.mission     = workorder.mission>
		<cfset url.serviceitem = workorder.serviceitem>				
				
		<cfinclude template="ScheduleCustom.cfm">
		
		<cfset url.mode = priormode>
		
		<tr>
			<td height="23" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Details">:</td>
			<td class="labelmediumcl">
			<cfoutput>	
			   <cfif url.mode eq "Edit">				
			     <textarea style="width:98%;height:50;font-size:14px;padding:3px" class="regular" name="Memo" id="Memo" totlength="500" onkeyup="return ismaxlength(this)">#Get.Memo#</textarea>
			   <cfelse>
			     #Get.Memo#
				 <input type="Hidden" name="Memo" id="Memo" value="#Get.Memo#">
			   </cfif>	 
			</cfoutput>				
			</td>
		</tr>
		
		<tr>
			<td height="23" class="labelmedium"><cf_tl id="Effective">:</td>
			<td class="labelmediumcl">
			
			<table width="100%" cellspacing="0" cellpadding="0">
			   <tr><td class="labelmediumcl">
				<cfset vDate = now()>
				<cfif get.ScheduleEffective neq "">
					<cfset vDate = get.ScheduleEffective>
				</cfif>
				
				<cfif url.mode eq "Edit">
				
					<cf_intelliCalendarDate9
						FieldName="ScheduleEffective" 
						Default="#dateformat(vDate, CLIENT.DateFormatShow)#"
						class="regularxl"
						AllowBlank="False">
					
				<cfelse>
				
				<cfoutput>
					#dateformat(vDate, CLIENT.DateFormatShow)#
					<input type="Hidden" name="ScheduleEffective" id="ScheduleEffective" value="#dateformat(vDate, CLIENT.DateFormatShow)#">
				</cfoutput>
				
				</cfif>	
					
				</td>
				
				<cfif url.ScheduleId neq "">
				
					<td style="padding-left:10px" height="23" class="labelmedium"><cf_tl id="Last scheduled task date">:</td>				
					<td id="expirationbox" style="padding-left:5px" class="labelmedium">					
						<cfinclude template="ScheduleEditExpiration.cfm">				
					</td>				
				
				</cfif>
				
				<td width="40%" align="right" class="labelmedium" style="padding-right:20px;padding-top:4px">
				
				<cfif url.mode eq "edit">
				
					<cfoutput>
						<input type="radio" name="ActionStatus" id="ActionStatus" value="1" <cfif get.ActionStatus eq "1" or url.ScheduleId eq "">checked</cfif>> <cf_tl id="Enabled">
						<input type="radio" name="ActionStatus" id="ActionStatus" value="0" <cfif get.ActionStatus eq "0">checked</cfif>> <cf_tl id="Disabled">
					</cfoutput>
					
				<cfelse>
				
					<cfif get.actionStatus eq "0"><font color="FF0000">disabled</font></cfif>
					<cfoutput>
						<input type="Hidden" name="ActionStatus" id="ActionStatus" value="#get.ActionStatus#">
					</cfoutput>
				
				</cfif>
				
			    </td>
				
				</tr>
			</table>	
			</td>
		</tr>		
							
		<cfif url.scheduleid eq "">
		
			<tr><td height="3"></td></tr>
									
			<tr><td colspan="2" class="line"></td></tr>
			
			<tr><td height="3"></td></tr>
			
			<tr>
				<td colspan="2" style="padding-left:1px">
					<cfif url.mode eq "edit">
					    <input type="button" onclick="insertschedule()" value="Submit Schedule" class="button10g" style="height:30;font-size:12px;width:260px">					
					</cfif>
				</td>
			</tr>
		
		</cfif>

	
	</table>

	<!---
</cfform>
--->

</td>

<td height="100%" style="border-left:0px solid silver;padding-right:4px" valign="top" id="summarybox">
	<cfinclude template="ScheduleSummary.cfm">
</td>

</tr>

</table>

<!---
<cfset AjaxOnLoad("doCalendar")>
--->