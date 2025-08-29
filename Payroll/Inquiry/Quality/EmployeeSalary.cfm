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
<cfset vMonthsList = ListQualify(url.months, "'")>

<cfquery name="getSalary" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT 	ES.*,
				L.Description as LocationDescription,
				P.*
		FROM	EmployeeSalary ES
				INNER JOIN Ref_PayrollLocation L
					ON ES.ServiceLocation = L.LocationCode
				LEFT OUTER JOIN Employee.dbo.Position P ON ES.PositionNo = P.PositionNo	
		WHERE	ES.PersonNo = '#url.personNo#'
		AND		ES.SalarySchedule = '#url.SalarySchedule#'
		AND 	(CONVERT(varchar(4),year(ES.payrollEnd))+convert(varchar(2), month(ES.payrollEnd))) IN (#preserveSingleQuotes(vMonthsList)#)
		ORDER BY ES.payrollEnd DESC

</cfquery>

<table width="95%" align="left" class="navigation_table">

	<tr><td height="10"></td></tr>
	
	<tr class="line labelmedium">
		<td><cf_tl id="Payroll"></td>
		<td><cf_tl id="Level/Step"></td>
		<td><cf_tl id="Location"></td>
		<td><cf_tl id="Class"></td>
		<td><cf_tl id="Position"></td>
		<td><cf_tl id="Calculation Leg"></td>
		<td align="right" style="min-width:50px"><cf_tl id="Days"></td>
		<td align="right" style="min-width:50px"><cf_tl id="SLWOP"></td>		
		<td align="right" style="min-width:50px"><cf_tl id="Suspend"></td>		
	</tr>	
	
	<cfoutput query="getSalary">
		<tr class="navigation_row labelmedium line">
			<td>#dateFormat(payrollEnd, client.dateformatshow)#</td>
			<td>#ServiceLevel#/#ServiceStep#</td>
			<td>#LocationDescription# (#ServiceLocation#)</td>
			<td>#PostClass#</td>
			<td><a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')"><cfif SourcePostNumber eq "">#PositionParentId#<cfelse>#SourcePostNumber#</cfif></a></td>
			<td>#dateFormat(SalaryCalculatedStart, client.dateformatshow)# - #dateFormat(SalaryCalculatedEnd, client.dateformatshow)#</td>
			<td align="right">#SalaryDays#</td>
			<td align="right">#SalarySLWOP#</td>		
			<td align="right" style="padding-right:4px">#SalarySuspend#</td>		
		</tr>
	</cfoutput>
	
	<tr><td height="20"></td></tr>
	
</table>

<cfset ajaxOnLoad("doHighlight")>