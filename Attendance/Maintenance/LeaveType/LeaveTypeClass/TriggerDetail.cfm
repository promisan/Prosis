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
<cfquery name="getTriggers" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT   T.*,
	   			(
	   				SELECT 	Tx.SalaryTrigger
	   				FROM 	Employee.dbo.Ref_LeaveTypeClassTrigger Tx
	   				WHERE   Tx.LeaveType = '#url.LeaveType#'
	   				AND 	Tx.LeaveTypeClass = '#url.LeaveTypeClass#'
	   				AND 	Tx.SalaryTrigger = T.SalaryTrigger
	   			) as isSelected
	   FROM     Ref_PayrollTrigger T
	   WHERE    T.Operational = '1'
	   AND		T.EnableContract != '0'
	   ORDER BY T.Description
</cfquery>

<cfset vCols = 4>
<cfset vWidth = 100/vCols>

<table width="100%" align="center" class="formpadding">
	<tr>
		<cfset vCnt = 0>
		<cfoutput query="getTriggers">
			<td width="#vWidth#%">
				<table>
					<tr>
						<td>
							<input 
								id="trigger_#url.LeaveType#_#url.LeaveTypeClass#_#SalaryTrigger#" 
								type="checkbox" 
								<cfif isSelected eq SalaryTrigger>checked</cfif>
								onclick="ptoken.navigate('#session.root#/Attendance/Maintenance/LeaveType/LeaveTypeClass/TriggerSubmit.cfm?LeaveType=#url.LeaveType#&LeaveTypeClass=#LeaveTypeClass#&SalaryTrigger=#SalaryTrigger#&status='+this.checked,'submit_#url.LeaveType#_#url.LeaveTypeClass#_#SalaryTrigger#');">
						</td>
						<td class="labelit">
							<label for="trigger_#url.LeaveType#_#url.LeaveTypeClass#_#SalaryTrigger#">#Description# <span style="font-size:70%;">[#SalaryTrigger#]</span></label>
						</td>
						<td id="submit_#url.LeaveType#_#url.LeaveTypeClass#_#SalaryTrigger#"></td>
					</tr>
				</table>
			</td>
			<cfset vCnt = vCnt + 1>
			<cfif vCnt eq vCols>
				<cfset vCnt = 0>
				</tr>
				<tr>
			</cfif>
		</cfoutput>
	</tr>
</table>