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
<cfquery name="person" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT 	*
		FROM	Person
		WHERE	PersonNo = '#url.personno#'
</cfquery>

<table cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td style="padding:26px" height="100%">
			<cfoutput query="person">
				<table cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
					<tr class="line">
						<td id="profileHeaderPhoto" align="center" valign="top" style="padding-left:7px;width:140px;padding-bottom:3px">
						
						    <cf_space spaces="50">
						
							<cfset vPhotoPathTest = "#session.rootdocumentPath#\EmployeePhoto\#indexNo#.jpg">
							<cfset vPhotoPath = "#session.rootdocument#/EmployeePhoto/#indexNo#.jpg">
							<cfif not fileExists(vPhotoPathTest)>
								<cfif gender eq "F">
									<cfset vPhotoPath = "#session.root#/Images/Logos/no-picture-female.png">
								<cfelse>
									<cfset vPhotoPath = "#session.root#/Images/Logos/no-picture-male.png">
								</cfif>
							</cfif>
							<img src="#vPhotoPath#" style="border:1px solid silver;height:160px; width:150;" title="#fullName#" align="absmiddle">
						</td>
						
						<td valign="top" style="padding-left:5px; padding-right:12px;">
						
							<table width="100%" align="center">
								<tr>
									<td colspan="3" class="labellarge" style="font-weight:bold; font-size:23px; cursor:pointer;" onclick="toggleHeader('heigth',350);">#ucase(FullName)# [#ucase(Gender)#]</td>
								</tr>
								
								<tr><td height="10"></td></tr>
								
								<tr id="profileHeaderDetail">
									<td style="padding:4px; border:0px solid ##C0C0C0;-webkit-border-radius:1px;-moz-border-radius:10px;border-radius:1px;" valign="top" width="50%">
																		
									    <cfinclude template="EmployeeProfileViewDetail.cfm">
										<!--- no need to load this also through ajax in my views : Hanno 
										<cfdiv id="divPersonViewDetail" bind="url:Employee/EmployeeProfileViewDetail.cfm?personNo=#personNo#&customerid=#url.customerid#&workschedule=#url.workschedule#">
										--->
									</td>
									<td>&nbsp;&nbsp;</td>
									<td style="padding:4px; padding-right:5px; border:0px solid ##C0C0C0;-webkit-border-radius:1px;-moz-border-radius:10px;border-radius:1px;" valign="top" width="50%">
									    <cfinclude template="EmployeeProfileViewWorkSchedule.cfm">
										<!--- no need to load this also through ajax in my views : Hanno 
										<cfdiv id="divPersonViewSchedule" bind="url:Employee/EmployeeProfileViewWorkSchedule.cfm?personNo=#personNo#&customerid=#url.customerid#&workschedule=#url.workschedule#">
										--->
									</td>
								</tr>
								
							</table>
						</td>
						
					</tr>
					
					<tr>
						<td colspan="2" valign="top" height="100%">
							<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top" width="25%" height="100%" style="min-width:300px;border-right:0px solid silver">
										<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
										
										    <!--- 
											<tr>
												<td valign="top" height="22px" class="labelmedium">
													<cfset vTenseMessage = "Planned Activities">
													<cfif createDate(url.selectedYear, url.selectedMonth, 1) lt createDate(year(now()), month(now()), 1)>
														<cfset vTenseMessage = "Performed Activities">
													</cfif>
													<cf_tl id="#vTenseMessage#">
												</td>
											</tr>
											--->
											<tr>
												<td valign="top" height="100%">
													<cf_divscroll id="divPersonViewActivities" height="100%" overflowy="auto" style="padding-right:5px;height:100%; min-height:100%; min-width:250px;">
													   <cfinclude template="EmployeeProfileViewActivities.cfm">
													   <!--- 
														<cfdiv id="divPersonViewActivities" style="height:100%; min-height:100%; min-width:250px;" 
														bind="url:Employee/EmployeeProfileViewActivities.cfm?personNo=#personNo#&customerid=#url.customerid#&workschedule=#url.workschedule#&selectedYear=#url.selectedYear#&selectedMonth=#url.selectedMonth#">													
														--->
													</cf_divscroll>
												</td>
											</tr>
										</table>
									</td>
									
									<cfif listing.recordCount gt 0>
									
									<td style="padding-left:4px;padding-right:15px" valign="top" align="center" class="labelmediumcl" id="divPersonViewCalendar">
										<table height="100%">
											<tr>
												<td valign="middle" class="labelmedium">
													<cf_tl id="Please select a task to view its schedule">
												</td>
											</tr>
										</table>
																			
										<cfset vSelectedDate = createDate(url.selectedYear,url.selectedMonth,1)>
																															
									</td>
									
									</cfif>
									
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</cfoutput>
		</td>
	</tr>
</table>