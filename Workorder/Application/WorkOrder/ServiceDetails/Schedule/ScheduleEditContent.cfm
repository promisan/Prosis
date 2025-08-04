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
<cfparam name="url.mode"       		default="edit">
<cfparam name="url.scheduleid" 		default="">
<cfparam name="url.workorderid" 	default="">
<cfparam name="url.workorderline" 	default="">

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

<cfform name="scheduleform" onsubmit="return false" method="POST">	

<table height="<cfif url.ScheduleId neq "">100%</cfif>" class="formpadding" width="100%" valign="top" align="center" style="padding-left:25px;padding-right:15px">

        <tr><td id="process"></td></tr>
				
		<cfif url.ScheduleId neq "">
				
		<tr style="height:30">
		
			<td style="height:30px; cursor:pointer;" onclick="<cfif url.ScheduleId neq "">toggleSection('ScheduleSection');</cfif>">
				<table cellspacing="2" cellpadding="2">
				
					<tr>
						<td style="padding-left:10px;">
							<cfoutput>
								
								<cfif url.mode eq "copy">
									<img id="togglerScheduleSection" src="#SESSION.root#/Images/arrowdown3.gif">
								<cfelse>
									<img id="togglerScheduleSection" src="#SESSION.root#/Images/arrowright.gif">
								</cfif>
								
							</cfoutput>
							
						</td>
						<td class="labellarge" style="padding-left:10px;" id="scheduleheader">
						
						<cfif url.ScheduleId eq "">
						
							<cf_tl id="Schedule">
							
						<cfelse>	
										
						
							<cfinclude template="getScheduleHeader.cfm">																	
														
						</cfif>
						
						</td>
					</tr>
					
				</table>
			</td>
		</tr>	
		
		</cfif>
				
		<cfset vDisplaySection = "display:none;">
		<cfif url.ScheduleId eq "" or url.mode eq "copy">
			<cfset vDisplaySection = "">
		</cfif>
		
		<cfoutput>
		
			<tr id="ScheduleSection" style="#vDisplaySection#">
				<td style="height:40;padding-left:20px;" valign="top" id="headerDiv">		
				
				<cfinclude template="ScheduleEditForm.cfm">
				
				</td>
			</tr>
		
		</cfoutput>
				
			
		<!--- <cfif url.ScheduleId neq ""> --->		
							
			<tr id="DetailSection">
				<td height="100%" style="padding:20px;">
																	
						<cfdiv id="detailDiv" 
						   bind="url:#session.root#/workorder/application/workOrder/serviceDetails/Schedule/ScheduleDetail.cfm?scheduleId=#url.scheduleId#&mode=#url.mode#">
					
				</td>
			</tr>
					
		<!--- </cfif> --->
		
</table>

</cfform>