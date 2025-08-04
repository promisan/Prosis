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
<cfquery name="getAction" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT 	*
	   	FROM   	stPersonnelAction
	   	WHERE 	ActionId = '#url.drillid#'			
</cfquery>

<cf_tl id="Historic Personnel Action" var="lblTitle">

<cf_screentop 
	height="100%" 
    html="Yes" 
	scroll="No" 
	jquery="yes" 
	label="#lblTitle#" 
    layout="webapp"
    menuPrint="yes">

 <style>
 	td {
 		font-size: 90% !important;
 	}
 	.clsFieldName {
 		color:#7A7A7A;
 	}
 </style>

<cfoutput>

<cf_divscroll>
	<table width="96%" align="center">
		<tr>
			<td colspan="2">	
				<cfset url.header = "0">
				<cfset ctr      = "1">		
				<cfset openmode = "open"> 
				<cfset url.id = getAction.personNo>
				<cfinclude template="../PersonViewHeaderToggle.cfm">		  
			</td>
		</tr>
		<tr><td height="10"></td></tr>
		<tr class="line" style="font-size:25px">
			<td colspan="2" class="labellarge">
				<cf_tl id="Contract and Position Details" var="1">#ucase(lt_text)#
			</td>
		</tr>
		<tr>
			<td width="50%" style="border-right:1px solid ##C0C0C0; padding:10px;" valign="top">
				<table width="100%" align="center">
					<tr class="line">
						<td class="labellarge clsFieldName" style="width:125px;"><cf_tl id="PANo">:</td>
						<td class="labellarge">#getAction.PersonnelActionNo#</td>
					</tr>
					<tr  class="line">
						<td class="labellarge clsFieldName"><cf_tl id="Duty Station">:</td>
						<td class="labellarge">#getAction.DutyStation#</td>
					</tr>
					<tr class="line">
						<td class="labellarge clsFieldName"><cf_tl id="Unit">:</td>
						<td class="labellarge">#getAction.OrgUnitName#</td>
					</tr>
					<tr class="line">
						<td class="labellarge clsFieldName"><cf_tl id="Appointment">:</td>
						<td class="labellarge">#dateformat(getAction.appointmentStart, client.dateformatshow)# - #dateformat(getAction.appointmentEnd, client.dateformatshow)# [#getAction.AppointmentType#]</td>
					</tr>
					<tr class="line">
						<td class="labellarge clsFieldName"><cf_tl id="Position">:</td>
						<td class="labellarge">#getAction.SourcePostNumber# [#getAction.PostFunding#]</td>
					</tr>
					<tr class="line">
						<td class="labellarge clsFieldName"><cf_tl id="Grade / Step">:</td>
						<td class="labellarge">#getAction.grade# / #getAction.step#</td>
					</tr>
					<tr class="line">
						<td class="labellarge clsFieldName"><cf_tl id="Next Increment">:</td>
						<td class="labellarge">#dateformat(getAction.dateNextIncrement, client.dateformatshow)#</td>
					</tr>
				</table>
			</td>
			<td style="padding:10px;" valign="top">
				<table width="100%" align="center">
					<tr class="line">
						<td class="labellarge clsFieldName" style="width:125px;"><cf_tl id="Marital Status">:</td>
						<td class="labellarge">#getAction.MaritalStatus#</td>
					</tr>
					<tr class="line">
						<td class="labellarge clsFieldName"><cf_tl id="SPA">:</td>
						<td class="labellarge"><cfif getAction.spaEffective neq "" AND dateFormat(getAction.spaEffective, 'yyyy-mm-dd') neq "1900-01-01">#dateformat(getAction.spaEffective, client.dateformatshow)# - #dateformat(getAction.spaExpiration, client.dateformatshow)# (#getAction.spaGrade# / #getAction.spaStep#)<cfelse><cf_tl id="N/A"></cfif></td>
					</tr>
					<tr class="line">
						<td class="labellarge clsFieldName" style="padding-top:3px;border-right:1px solid silver"><cf_tl id="Salary">:</td>
						<td class="labellarge" valign="top">
							<table width="100%">
								<cfif trim(getAction.salaryDependent) neq "">
									<tr class="line">
										<td style="padding-left:5px" class="labellarge" colspan="2">#getAction.salaryDependent#</td>
									</tr>
								</cfif>
								<tr class="line">
									<td style="padding-left:5px" class="labelit clsFieldName" width="65%"><cf_tl id="Dependent Count"></td>
									<td class="labellarge">#getAction.DependentCount#</td>
								</tr>
								<tr class="line">
									<td style="padding-left:5px" class="labelit clsFieldName"><cf_tl id="Post Adjustment"></td>
									<td class="labellarge">
									<cfif getAction.salaryPostAdjustment eq 1>
											<cf_tl id="Yes">
										<cfelse>
											<cf_tl id="No">
										</cfif>
									</td>
								</tr>
								<tr class="line">
									<td style="padding-left:5px" class="labelit clsFieldName"><cf_tl id="Pension Fund"></td>
									<td class="labellarge">
										<cfif getAction.salaryPensionFund eq 1>
											<cf_tl id="Yes">
										<cfelse>
											<cf_tl id="No">
										</cfif>
									</td>
								</tr>
								<tr >
									<td style="padding-left:5px" class="labelit clsFieldName"><cf_tl id="Non Removal"></td>
									<td class="labellarge">
										<cfif getAction.salaryNonRemoval eq 1>
											<cf_tl id="Yes">
										<cfelse>
											<cf_tl id="No">
										</cfif>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="labellarge clsFieldName"><cf_tl id="Medical">:</td>
						<td class="labellarge">#dateformat(getAction.medicalDate, client.dateformatshow)#</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td height="10"></td></tr>
		<tr class="line" style="font-size:25px">
			<td colspan="2" class="labellarge">
				<cf_tl id="Payroll calculation action" var="1">#ucase(lt_text)#
			</td>
		</tr>
		<tr>
			<td colspan="2" style="padding:5px;">

				<cfquery name="getActions" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT 	*
						FROM 	stPersonnelActionDetail
						WHERE 	ActionId = '#url.drillid#'
						ORDER BY SerialNo ASC
				</cfquery>

				<table width="100%" align="center" class="navigation_table">
					<tr class="line labelmedium">
						<td class="clsFieldName" width="5%"><cf_tl id="No"></td>
						<td class="clsFieldName"><cf_tl id="Description"></td>
						<td class="clsFieldName"><cf_tl id="Effective"></td>
					</tr>
					<cfloop query="getActions">
						<tr class="navigation_row line labelmedium">
							<td style="padding-left:5px">#getActions.SerialNo#</td>
							<td>#getActions.ActionName#</td>
							<td>#dateformat(getActions.DateEffective, client.dateformatshow)#</td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" bgcolor="DAF9FC" style="padding:5px;">#getAction.remarks#</td>
		</tr>
		<tr><td height="10"></td></tr>
		<tr class="line" style="font-size:25px">
			<td colspan="2" class="labellarge">
				<cf_tl id="Approval Flow" var="1">#ucase(lt_text)#
			</td>
		</tr>
		<tr>
			<td colspan="2" style="padding:5px;">
				<table width="100%" align="center" class="navigation_table">
					<tr class="line labelmedium">
						<td></td>
						<td class="clsFieldName"><cf_tl id="Date"></td>
						<td class="clsFieldName"><cf_tl id="Officer"></td>
						<td></td>
						<td class="clsFieldName"><cf_tl id="Date"></td>
						<td class="clsFieldName"><cf_tl id="Officer"></td>
						<td></td>
						<td class="clsFieldName"><cf_tl id="Date"></td>
						<td class="clsFieldName"><cf_tl id="Officer"></td>
					</tr>
					<tr class="line labelmedium navigation_row">
						<td class="clsFieldName" style="padding-left:4px"><cf_tl id="Requester">:</td>
						<td class="">#dateformat(getAction.requestDate, client.dateformatshow)#</td>
						<td class="">#getAction.certifyOfficer#</td>					
						<td class="clsFieldName" style="padding-left:4px"><cf_tl id="Certifier">:</td>
						<td class="">#dateformat(getAction.certifyDate, client.dateformatshow)#</td>
						<td class="">#getAction.requestOfficer#</td>					
						<td class="clsFieldName" style="padding-left:4px"><cf_tl id="Approver">:</td>
						<td class="">#dateformat(getAction.approveDate, client.dateformatshow)#</td>
						<td class="">#getAction.approveOfficer#</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td height="5"></td></tr>
	</table>
	
</cf_divscroll>
	
</cfoutput>