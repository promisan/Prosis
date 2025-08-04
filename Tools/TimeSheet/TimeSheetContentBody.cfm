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
<cf_tl id="Remove" var="lblRemove">
<cf_tl id="Copy from" var="lblCopyFrom">
<cf_tl id="Copy to" var="lblCopyTo">

<cfif len(session.timesheet["DateStart"]) eq 10>
	<cfset selDate = replace("#session.timesheet['DateStart']#","'","","ALL")>
	<cfset dateValue = "">
	<cf_dateConvert Value="#DateFormat('#SelDate#',client.DateFormatShow)#">
	<cfset session.timesheet["DateStart"] = dateValue>
</cfif>

<cfquery name="getThisOrgUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Organization
	WHERE 	OrgUnit = '#url.orgunit#'
</cfquery>

<cfquery name="getOrganizationAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	OrganizationAction
	WHERE 	OrgUnit = '#url.orgunit#'
	AND     CalendarDateEnd >= #session.timesheet["DateStart"]#
	AND     CalendarDateStart <= #session.timesheet["DateEnd"]#
    AND     WorkAction = 'Attendance'	
</cfquery>


<cfinvoke component="Service.Access"  
	method="RoleAccess"
	role="'TimeKeeper'"  
	AccessLevel="'2'"
	Unit="'#url.orgunit#'"
	returnvariable="access">

<cfoutput>

	<cf_divscroll overflowy="scroll">

		<table style="width:99.5%" align="left">
										
		<cfloop query="getPersons">
																
				<cfset Per = PersonNo>
				<cfset Ass = AssignmentNo>
				<cfset dateOb = date>
				
				<tr class="navigation_row clsTimesheetPersonRow" style="border-bottom:1px solid silver;height:18px">
				
					<td	height="100%" 
						style="min-width:340px;width:100%;padding-right:4px" 
						class="clsTimeSheetPerson clsTimeSheetPerson_#personno#"
						onmouseover="$('.clsTimeSheetPerson_#personno#').css('background-color', '##8AFFBB');" 
						onmouseout="$('.clsTimeSheetPerson_#personno#').css('background-color', '');">					
										 												
					   <table width="100%" height="100%">	
					   							   
					   	<cfoutput>		
						<tr class="labelmedium" style="height:18px">
						   <td width="1%" style="padding-top:1px"><cf_img icon="select" onclick="javascript:EditPerson('#PersonNo#','','leave')"></td>
						   <td style="min-width:50px;width:40px;" title="#FunctionDescription#" class="ccontent">#PostGrade#</td>
			    			   <td style="min-width:207px;padding-left:3px;padding-right:3px">
			    			   		<table width="100%">
			    			   			<tr class="fixlengthlist">
			    			   				<td class="ccontent" title="#LastName#, #FirstName#">
			    			   					#LastName#, #FirstName# <!--- - #IndexNo# --->
										    <cfif DateEffective gt session.timesheet["DateStart"] or DateExpiration lt session.timesheet["DateEnd"]>
										    	<font color="808080">: #DateFormat(DateEffective, "DD/MM")# - #DateFormat(DateExpiration, "DD/MM")#</font>
										    </cfif>	
			    			   				</td>
			    			   				
											<cfif getThisOrgUnit.WorkSchema eq 1 
											        and (getOrganizationAction.ActionStatus eq "0" or getOrganizationAction.recordcount eq "0")>
																														
				    			   				<cfif trim(url.removeScheduleFunction) neq "" AND access eq "GRANTED">
			 		    			   				<td width="1%" style="padding-left:5px; padding-right:5px;" align="center" title="#lblRemove#">
														<table>
															<tr>
																<td class="clsTSRemove clsTSRemove_#personNo#" style="width:3px;">&nbsp;</td>
																<td valign="middle">
																	<img src="#session.root#/images/close-x.png" style="height:15px; cursor:pointer;" onclick="removeSchedule('#PersonNo#', #url.removeScheduleFunction#);">
																</td>
															</tr>
														</table>
			 		    			   				</td>
				    			   				</cfif>
												
				    			   				<cfif trim(url.copyScheduleFunction) neq "">
			 		    			   				<td width="1%" style="padding-left:5px; padding-right:5px;" align="center" title="#lblCopyFrom#">
														<table>
															<tr>
																<td class="clsTSCopyFrom clsTSCopyFrom_#personNo#" style="width:3px;">&nbsp;</td>
																<td valign="middle">
																	<img src="#session.root#/images/copy-2.png" style="height:15px; cursor:pointer;" onclick="copySchedule('#PersonNo#', 'from', #url.copyScheduleFunction#);">
																</td>
															</tr>
														</table>
			 		    			   				</td>
			 		    			   				<td width="1%" style="padding-left:5px; padding-right:5px;" align="center" title="#lblCopyTo#">
														<table>
															<tr>
																<td class="clsTSCopyTo clsTSCopyTo_#personNo#" style="width:3px;">&nbsp;</td>
																<td valign="middle">
																	<img src="#session.root#/images/paste-to.png" style="height:15px; cursor:pointer;" onclick="copySchedule('#PersonNo#', 'to', #url.copyScheduleFunction#);">
																</td>
															</tr>
														</table>
			 		    			   				</td>
				    			   				</cfif>
												
			    			   				</cfif>
			    			   			</tr>
							   </table>
						   </td>									  						   
	     				</tr>
						</cfoutput>			    					
	  					</table>							   
									  						   
					</td>
																													
					<cfinclude template="TimeSheetDetail.cfm">							
								
						<cfif url.object eq "Unit">
						
							<cfoutput>
							<td id="#PersonNo#_recap" style="border-left:1px solid silver;">
								<cfif getThisOrgUnit.WorkSchema eq 1>
									<cfset url.personno = per>
									<cfinclude template="TimeSheetPerson.cfm">	
								</cfif>									
							</td>	
							</cfoutput>						
					
					</cfif>	
												
				</tr>
				
				<cfif url.detail eq "true">
				
				    <cfinclude template="TimeSheetContentLeave.cfm">
																   
			   </cfif>						   		
												
		</cfloop>
							
		</table>	
		
	</cf_divscroll>
	
</cfoutput>