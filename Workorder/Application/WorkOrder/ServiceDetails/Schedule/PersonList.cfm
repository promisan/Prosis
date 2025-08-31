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
<cfparam name="url.action"     default="">
<cfparam name="url.personNo"   default="">
<cfparam name="url.viewmode"   default="scheduled">
<cfparam name="url.accessmode" default="edit">

<cfquery name="schedule" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	WorkOrderLineSchedule
		WHERE 	ScheduleId = '#URL.ScheduleId#'
</cfquery>

<cfif schedule.recordCount gt 0>

	<cfquery name="workorder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	WorkOrder
			WHERE 	WorkorderId = '#schedule.workorderid#'
	</cfquery>
	
	<!--- ------------------------------- --->
	<!--- take actions in the submit part --->
	
	<cfif url.action eq "delete">
		
		<cfquery name="Delete" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			     DELETE 
				 FROM  	WorkOrderLineSchedulePosition
				 WHERE 	ScheduleId = '#URL.ScheduleId#'
				 AND 	PersonNo   = '#URL.personNo#'
		</cfquery>
		
	<cfelseif url.action eq "Insert">	
	
	    <cftry>
		
			<cfparam name="url.positionno" default="">
			
			<!--- Get current assignment --->
			<cfquery name  = "currentPosition" 
			   	datasource= "AppsWorkOrder" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
					SELECT 	*
					FROM	Employee.dbo.PersonAssignment PA
					WHERE	PositionNo IN (SELECT PositionNo 
					                       FROM   Employee.dbo.Position 
										   WHERE  PositionNo = PA.PositionNo 
										   AND    Mission    = '#Workorder.mission#')
										   
					AND     PersonNo         = '#url.PersonNo#'
					AND		AssignmentStatus IN ('0','1')
					AND		AssignmentType   = 'Actual'
					AND		Incumbency       > 0
					AND		getDate() BETWEEN DateEffective AND DateExpiration		
			</cfquery>
		
			<cfif currentPosition.recordcount eq "0">
		
				<script>
					alert("An active position could not be found for this person. Operation aborted.")			
				</script>
			
		    <cfelse>
			
				<cfquery name="ValidateInsert" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 	SELECT 	*
						FROM	WorkOrderLineSchedulePosition
					 	WHERE	ScheduleId = '#url.ScheduleId#'
						AND		PositionNo = '#currentPosition.positionno#'
				</cfquery>
				
				<cfif ValidateInsert.recordCount eq 0>
					<cfquery name="Insert" 
					     datasource="AppsWorkOrder" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO WorkOrderLineSchedulePosition (
					           ScheduleId,
					           PersonNo,				 
							   PositionNo,				  
							   isActor,
					           Memo,
					           OfficerUserId,
					           OfficerLastName,
					           OfficerFirstName 	)
					     VALUES ('#url.ScheduleId#',
					             '#url.PersonNo#',					
								 '#currentPosition.positionno#',					 
								 '1',
					             '',
							     '#SESSION.acc#',
							     '#SESSION.last#',
							     '#SESSION.first#' )
					</cfquery>
				</cfif>
			
			</cfif>
		
		<cfcatch>
		
		</cfcatch>
		
		</cftry>
	
	</cfif>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(url.selecteddate,CLIENT.DateFormatShow)#">
	<cfset STRDTE = dateValue>
	
	<cfset ENDDTE = dateValue>
	<cfset ENDDTE = dateAdd("H",23,ENDDTE)>
	<cfset ENDDTE = dateAdd("N",59,ENDDTE)>
	
	<cfif now()-1 lt STRDTE>
	
		<cfset tense = "Future">
			
		<!--- 1. first we get the potential candidates for this workorder, date, schedule of the action --->
			
		<cfinvoke component		= "Service.Process.WorkOrder.WorkOrderStaff"
	   		method	     		= "GetWorkOrderStaff"
			initialDate		    = "#STRDTE#"
			endDate			    = "#STRDTE#"
			mission			    = "#workorder.mission#"		
			workorderid		    = "#schedule.workorderid#"		
			mode                = "subquery"
			returnvariable	    = "potentialemployees"			
			workschedule	    = "#schedule.WorkSchedule#">
				
		<!--- then we optionally filter out only assigned fooks which depends on the selected view --->
		
		<cfparam name="url.viewmode" default="valid">
		
		<cfif url.viewmode eq "scheduled">
				
			<cfquery name="List" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		    	SELECT 	 P.PersonNo,
				         P.IndexNo,
						 P.FullName,				 
						 PP.AssignmentDateExpiration,
						 Pos.SourcePostNumber,
						 SP.PositionNo,
						 SP.isActor,
						 SP.Operational,
						 SP.Memo
						
				FROM     WorkOrderLineSchedulePosition SP INNER JOIN Employee.dbo.Person P ON SP.PersonNo = P.PersonNo 
						 <!--- show data of the validness of the person --->
						 LEFT OUTER JOIN (#preservesingleQuotes(potentialemployees)#) as PP ON SP.PersonNo = PP.PersonNo
						 LEFT OUTER JOIN Employee.dbo.Position Pos ON SP.PositionNo = Pos.PositionNo
				WHERE 	 SP.ScheduleId = '#URL.ScheduleId#'
				ORDER BY SP.isActor DESC, SP.Operational DESC
				</cfquery>	
			
		<cfelseif url.viewmode eq "valid">		
			
			<cfquery name="List" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		    	SELECT 	 PP.PersonNo,
				         PP.IndexNo,
						 PP.FullName,				 
						 PP.AssignmentDateExpiration,
						 PP.SourcePostNumber,
						 PP.PositionNo,
						 SP.isActor,
						 SP.Operational,
						 SP.Memo
						
				FROM    (#preservesingleQuotes(potentialemployees)#) as PP 
				        LEFT OUTER JOIN WorkOrderLineSchedulePosition SP ON PP.PersonNo = SP.PersonNo AND SP.ScheduleId = '#URL.ScheduleId#'
				 
				ORDER BY SP.isActor DESC, SP.Operational DESC
				
				</cfquery>		
		
		</cfif>
			
		
	<cfelse>
	
		<cfset tense = "History">
		
		<cfquery name="List" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  P.PersonNo,
		        P.IndexNo,
				P.FullName,
				PA.DateExpiration,
				Pos.SourcePostNumber,
				Pos.PositionNo,
				(
					SELECT TOP 1 WAP.isActor
					FROM    WorkOrderLineAction WA INNER JOIN
					    	WorkOrderLineActionPerson WAP ON WA.WorkActionId = WAP.WorkActionId
					WHERE   WA.ScheduleId = '#URL.ScheduleId#'
					AND     WA.DateTimePlanning >= #STRDTE# and WA.DateTimePlanning <= #ENDDTE# 
					AND		WAP.PersonNo = P.PersonNo
					ORDER BY WAP.isActor DESC
				) as isActor
		FROM    Employee.dbo.Person P
				INNER JOIN Employee.dbo.PersonAssignment PA
					ON P.PersonNo = PA.PersonNo
				INNER JOIN Employee.dbo.Position Pos
					ON PA.PositionNo = Pos.PositionNo 
		WHERE   (
					#STRDTE# BETWEEN PA.DateEffective AND PA.DateExpiration
					OR
					#ENDDTE# BETWEEN PA.DateEffective AND PA.DateExpiration
				)
		AND		PA.AssignmentStatus IN ('0','1')
		AND		PA.Incumbency > 0
		AND		PA.AssignmentType = 'Actual'
		AND		P.PersonNo IN (
								SELECT  WAP.PersonNo
							 	FROM    WorkOrderLineAction WA INNER JOIN
				               		    WorkOrderLineActionPerson WAP ON WA.WorkActionId = WAP.WorkActionId
							  
							 	WHERE   WA.ScheduleId = '#URL.ScheduleId#' 
							 	AND     WA.DateTimePlanning >= #STRDTE# and WA.DateTimePlanning <= #ENDDTE#
							)
		</cfquery>	
	
	</cfif>
	
	<cf_tl id="Do you want to remove this employee from this schedule ?" var="deleteMsg">
		
	<table width="100%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">
	
		<cfset link = "PersonList.cfm?ScheduleId=#url.ScheduleId#&selectedDate=#url.selectedDate#&viewmode=#url.viewmode#">
		
		<cfif tense eq "History">
												
					<tr>
						<td width="150" colspan="6" class="labelmedium"><font color="FF0000"><cf_tl id="Employees that WERE assigned to this activity"></td>
					</tr>
					
					<cfif list.recordcount eq "0">				
					
						<tr><td colspan="6" align="center" style="padding-left:4px" class="labelit">No records found to show in this view</td></tr>
					
					<cfelse>
					
						<tr>						
							<td style="height:30" width="5%"></td>									
							<td width="10%" class="labelit"><cf_tl id="No"></td>				     
							<td width="10%" class="labelit"><cf_tl id="IndexNo"></td>
							<td class="labelit"><cf_tl id="Full Name"></td>
							<td class="labelit"><cf_tl id="Post Number"></td>
							<td width="10%" class="labelit" align="center"><cf_tl id="Expiry"></td>					
							<td class="labelit" align="center"><cf_tl id="Role"></td>						
					    </tr>
						
						<tr><td colspan="7" class="line"></td></tr>
						
					</cfif>
					
					<cfoutput query="List">							
							
						<TR class="navigation_row">
							<td align="center"></td>
						   	<td height="15" class="labelit" style="padding-left:4px">					
								<a title="view profile" class="navigation_action" href="javascript:EditPerson('#PersonNo#')">
									<font color="0080C0">#PersonNo#</font>
								</a>
							</td>	
							<td class="labelit">#IndexNo#</td>		
						   	<td class="labelit">#FullName#</td>
							<td class="labelit">#SourcePostNumber#</td>
							<td class="labelit" align="center">#dateformat(DateExpiration,client.dateformatshow)#</td>
							<td align="center" class="labelit">
								<cfif isActor eq "0"><cf_tl id="Not Involved"></cfif>
								<cfif isActor eq "1"><cf_tl id="Assistant"></cfif>
								<cfif isActor eq "2"><cf_tl id="Responsible"></cfif>
							</td>
						</TR>
						
				   </cfoutput>		
		
		<cfelse>	
		
					<tr>
						<td width="150" style="height:30" colspan="9" class="labelmedium">
						
						<table width="100%" cellspacing="0" cellpadding="0">
						
						<tr>
						<td style="padding-left:3px" height="30" class="labelmedium"><cf_tl id="Maintain staff ASSIGNED to this activity."></td>										
						<td align="right" style="padding-right:4px">
						
							<cfoutput>
							<table>
							<tr>
							<td><input onclick="ColdFusion.navigate('PersonList.cfm?viewmode='+this.value+'&ScheduleId=#url.ScheduleId#&selectedDate=#url.selecteddate#','dPersonList');" type="radio" name="viewmode" value="scheduled" <cfif url.viewmode eq "scheduled">checked</cfif>></td>
							<td style="padding-left:2px" class="labelit"><cf_tl id="Scheduled"></td>
							<td style="padding-left:6px"><input onclick="ColdFusion.navigate('PersonList.cfm?viewmode='+this.value+'&ScheduleId=#url.ScheduleId#&selectedDate=#url.selecteddate#','dPersonList');" type="radio" name="viewmode" value="valid" <cfif url.viewmode eq "valid">checked</cfif>></td>
							<td style="padding-left:2px" class="labelit"><cf_tl id="Valid Staff"></td>
							</tr>
							</table>
							</cfoutput>
						
						</td>
						</tr>
						</table>
						
						</td>
						
					</tr>
					
					<tr><td colspan="9" class="line"></td></tr>		
											
					<tr>
						
						<td width="5%" style="height:23;padding-left:3px" title="<cf_tl id='Add employees'>">
																
							<cfif url.accessmode eq "edit">
							
							    <cf_selectlookup
								    box          = "dPersonList"
									link         = "#link#"
									button       = "No"
									icon         = "plus_green.png"
									iconHeight   = "17"
									iconWidth    = "17"
									close        = "No"	
									title        = "Add Person"											
									class        = "Employee"
									des1         = "PersonNo"
									filter1		 = "WorkSchedule"
									filter1Value = "#schedule.workSchedule#"
									filter2Value = "#url.selectedDate#"
									filter3Value = "#schedule.workOrderId#">
									
							</cfif>
							
						</td>
						
						<td width="10%" class="labelit"><cf_tl id="Active"></td>				     
						<td width="10%" class="labelit"><cf_tl id="Index"></td>
					   	<td class="labelit"><cf_tl id="Full Name"></td>
						<td width="10%" class="labelit"><cf_tl id="No"></td>	
						<td class="labelit"><cf_tl id="Post Number"></td>
						<td width="10%" class="labelit" align="center"><cf_tl id="Expiry"></td>					
						<td class="labelit" align="center"><cf_tl id="Role"></td>
						<td></td>
						
				    </tr>
					
					<tr><td colspan="9" class="line"></td></tr>
					
									
					<cfif List.recordcount eq "0">
												
						<tr>
							<td colspan="9" align="center" style="padding-top:10px;" class="labelmedium"><font color="FF0000">Attention, currently no staff has been assigned.</font></td>
						</tr>
					
					<cfelse>
									
						<cfoutput query="List">						
							
							<cfset vChecked = "">
							<cfset vColor = "">
							<cfset vClass = "">
							
							<cfif isActor eq 2>
								<cfset vChecked = "checked">
								<cfset vColor = "background-color:lime;">
							<cfelseif isActor eq "1">	
								<cfset vChecked = "checked">
								<cfset vColor = "background-color:yellow;">
							</cfif>
							
							<cfif operational eq 0>
								<cfset vColor = "background-color:F5A9A9;">
								<cfset vClass = "class='labelit'">
							</cfif>
								
							<TR class="navigation_row" style="#vColor#">
								
								<td></td>
								<td class="labelit line">
								<cfif url.viewmode eq "Valid">
								Yes
								<cfelse>
								<cfif operational eq 1>Yes<cfelse><font color="FF0000">No</cfif>
								</cfif>
								</td>
												  
								<td style="height:20px" class="labelit line">#IndexNo#</td>		
							   	<td class="labelit line">#FullName#</td>
							 	<td class="labelit line" height="15"><a title="view profile" class="navigation_action" href="javascript:EditPerson('#PersonNo#')">#PersonNo#</a></td>	
								<td class="labelit line"><a href="javascript:EditPosition('#workorder.mission#','','#PositionNo#')"><font color="0080C0"><cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionNo#</cfif></a></td>
								<td class="labelit line" align="center">#dateformat(AssignmentDateExpiration,client.dateformatshow)#</td>
								
								<td style="padding:3px" class="labelit line" align="center">
								
									<cfif url.accessmode eq "edit" and (operational eq 1 or url.viewmode eq "Valid")>
									
									    <select name="isActor_#personNo#" id="isActor_#personNo#" class="regularxl"
										    onchange="ColdFusion.navigate('setRole.cfm?viewmode=#url.viewmode#&ScheduleId=#url.ScheduleId#&selectedDate=#url.selecteddate#&positionno=#positionno#&personNo=#personNo#&role='+this.value,'dPersonList')">
											<option value="0" <cfif isActor eq "0">selected</cfif>><cf_tl id="Not Involved"></option>								
											<option value="1" <cfif isActor eq "1">selected</cfif>><cf_tl id="Assistant"></option>		
											<option value="2" <cfif isActor eq "2">selected</cfif>><cf_tl id="Responsible"></option>		
										</select>
										
									<cfelse>
																
										<cfif isActor eq "2">
											<cf_tl id="Responsible">
										<cfelseif isActor eq "1">
											<cf_tl id="Assistant">
										<cfelse>		
											--
										</cfif>
										
									</cfif>
									
								</td>	
								
								<td align="center" style="padding-right:4px">
								
									<cfif (isActor eq 0 or isActor eq "1") and list.recordcount gte "2">
										<cfif url.accessmode eq "edit">
											<cf_img icon="delete" onclick="if (confirm('#deleteMsg#')) { ColdFusion.navigate('PersonList.cfm?action=delete&ScheduleId=#url.ScheduleId#&selectedDate=#url.selecteddate#&personNo=#personNo#','dPersonList'); }">
										</cfif>
									</cfif>
									
								</td>						
								
							</TR>
																			
						</cfoutput>
						
					</cfif>	
					
			</cfif>
										
	</table>
	
	<cfset AjaxOnLoad("doHighlight")>

</cfif>