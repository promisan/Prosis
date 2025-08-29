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
<cfif url.selectedmonth eq "0">
   <cfset url.selectedmonth = month(now())>
</cfif>

<cfset vInitialMonthDate = createDate(url.selectedYear,url.selectedMonth,1)>
<cfset vEndMonthDate = createDate(url.selectedYear,url.selectedMonth,daysInMonth(vInitialMonthDate))>

<cfset vActiveDateValidation = vEndMonthDate>
<!---current month--->
<cfif year(vEndMonthDate) eq year(now()) and month(vEndMonthDate) eq month(now())>
	<cfset vActiveDateValidation = now()>
<cfelse>
	<!---next months--->
	<cfif vEndMonthDate gt now()>
		<cfset vActiveDateValidation = vInitialMonthDate>
	</cfif>
	<!---prior months--->
	<cfif vEndMonthDate lt now()>
		<cfset vActiveDateValidation = vEndMonthDate>
	</cfif>
</cfif>

<cfquery name="getCustomer" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT TOP 1 *
		FROM 	Customer
		WHERE 	CustomerId = '#url.customerid#'		
</cfquery>

<cfquery name="getWorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT TOP 1 *
		FROM 	WorkOrder
		WHERE 	CustomerId = '#url.customerid#'		
</cfquery>

<cfinvoke component		= "Service.Process.WorkOrder.WorkOrderStaff"
   	method	     		= "GetWorkOrderStaff"
	initialDate		    = "#vInitialMonthDate#"
	endDate			    = "#vEndMonthDate#"
	mission			    = "#getCustomer.mission#"
	customerId 		    = "#url.customerid#"
	getWorkScheduleData	= "true"
	getPositionData     = "false"
	returnvariable	    = "employees">

<cfset session.selectworkorderid = getWorkOrder.workOrderid>
<cfset session.selectactiondate = dateFormat(now(),client.dateFormatShow)>

<table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center">
	
	<!--- ------------ --->
	<!--- list summary --->
	<!--- ------------ --->
	
	<cfquery name="countEmployees" dbtype="query">	
		SELECT DISTINCT PersonNo
		FROM 	employees	
		WHERE	AssignmentDateExpiration >= <cfqueryparam value="#vActiveDateValidation#" cfsqltype="CF_SQL_TIMESTAMP">	
	</cfquery>
	
	<cfquery name="countShifts" dbtype="query">	
		SELECT DISTINCT WorkSchedule
		FROM 	employees
		WHERE	AssignmentDateExpiration >= <cfqueryparam value="#vActiveDateValidation#" cfsqltype="CF_SQL_TIMESTAMP">	
	</cfquery>
	
	<tr>
		<td colspan="2" class="labelmedium" style="padding-left:4px">
			<cfoutput>
				<b>#countEmployees.recordcount#</b> <cf_tl id="active employees">; <b>#countShifts.recordcount#</b> <cf_tl id="shifts">
			</cfoutput>
		</td>
	</tr>	
	
	<cfif employees.recordCount gt 0>
		<tr>
			<td colspan="2">
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "direct"
				   name             = "filtersearch"
				   style            = "font:15px;height:21;width:120"
				   rowclass         = "clsEmployeeRow"
				   rowfields        = "ccontent">
			</td>
		</tr>
	</cfif>
	
	<!--- ------------ --->
	<!--- ------------ --->
	
	<tr><td height="5"></td></tr>
	
	<tr><td height="100%">
	
	<cf_divscroll>
	
	<table>
		
	<cfoutput query="employees" group="WorkSchedule">
	
		<cfquery name="countEmployeesWS" dbtype="query">	
			SELECT  COUNT(*) as Total
			FROM 	employees
			WHERE 	WorkSchedule = '#WorkSchedule#'	
			AND		AssignmentDateExpiration >= <cfqueryparam value="#vActiveDateValidation#" cfsqltype="CF_SQL_TIMESTAMP">
		</cfquery>
		
		<tr style="cursor:pointer" onclick="toggleWorkSchedule('#WorkSchedule#');">
			<td class="labelmedium" width="88%"
				style="height:25;font-size:15px;padding-left:7px;border:0px solid ##C0C0C0; background-color:##ffffff;">
				#ucase(WorkScheduleDescription)# 
			</td>
			<td style="width:1px"></td>
			<td width="12%" class="labelmedium" align="right" style="padding-right:4px;border:0px solid ##C0C0C0;">
				<table>
					<tr>
						<td class="labelit" style="font-size:18px; padding-right:8px; padding-left:3px;">
							<cfif countEmployeesWS.recordCount gt 0>#countEmployeesWS.Total#<cfelse>0</cfif>
						</td>
						<td class="labelit" style="font-size:10px; font-weight:normal;" valign="middle" align="right">
						    <!---
							<cfif countEmployeesWS.Total eq "1"><cf_tl id="active employee"><cfelse><cf_tl id="active employees"></cfif> 
							--->
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<cfset cntRec = 0>
		<cfoutput>
	
			<tr class="clsEmployeeRow workScheduleContainer_#WorkSchedule#" style="display:none;">	
								
				<td style="display:none;" colspan="1" class="ccontent">#WorkScheduleDescription# #IndexNo# #FullName#</td>
				
				<cfset vInactive = "">
				<cfset vInactiveMessage = "">
				<cfif AssignmentDateExpiration lte vActiveDateValidation>
					<cfset vInactive = "background-color:##FC7777;">
					<cf_tl id="Not Active" var="vInactiveMessage">
				</cfif>
				
				<td id="personContainer_#WorkSchedule#_#personNo#"
					class="clsPersonContainer" 
					colspan="3"
					style="cursor:pointer; height:25px; border:1px solid ffffff; padding-left:10px; padding-top:2px; padding-bottom:2px; -webkit-border-radius:1px; -moz-border-radius:5px; border-radius:1px;" 
					onclick="selectPerson('#url.customerid#','#WorkSchedule#','#personNo#','#url.selectedYear#','#url.selectedMonth#');">
											
					<table width="100%" align="center">
						<tr>
							<td style="width:30;padding-right:2px;">
								<cfset cntRec = cntRec + 1>
								#cntRec#.
							</td>
							<td width="15%">
								<cfset vPhotoPathTest = "#session.rootdocumentpath#\EmployeePhoto\#indexNo#.jpg">
								<cfset vPhotoPath = "#session.rootdocument#/EmployeePhoto/#indexNo#.jpg">
								<cfif not fileExists(vPhotoPathTest)>
									<cfif gender eq "F">
										<cfset vPhotoPath = "#session.root#/Images/Logos/no-picture-female.png">
									<cfelse>
										<cfset vPhotoPath = "#session.root#/Images/Logos/no-picture-male.png">
									</cfif>
								</cfif>
								<img src="#vPhotoPath#" style="border:0px solid silver;height:50px; width:47px;" title="#fullName#">
							</td>
							<td style="padding-left:10px;">
								<table width="100%" align="center">
									<tr>
										<td class="labelit">#FullName#</td>
									</tr>
									<tr>
										<td class="labelit">#IndexNo#</td>
									</tr>
								</table>
							</td>
							<td title="#vInactiveMessage#" style="width:10px; #vInactive#"></td>
						</tr>
					</table>
					
				</td>
				
			</tr>
			
			<tr class="clsEmployeeRow workScheduleContainer_#WorkSchedule#" style="display:none;">
				<td style="display:none;" colspan="3" class="ccontent">#WorkScheduleDescription# #IndexNo# #FullName#</td>
				<td style="height:3px;"></td>
			</tr>
		</cfoutput>
		
		<tr class="line">
			<td colspan="5"></td>
		</tr>
		
	</cfoutput>
		
	</table>
	
	</cf_divscroll>
	
	</td>
	</tr?
	
</table>


<script>
	Prosis.busy('no')
</script>