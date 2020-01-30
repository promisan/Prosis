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