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
 
<cfquery name="PayrollItems" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT      P.PayrollItem, 
	            P.PayrollItemName, 
				P.Source, 
				R.SalarySchedule, 
				R.GLAccount, 
				R.PostClass
				
	FROM        Ref_PayrollItem AS P INNER JOIN
                     (SELECT        SalarySchedule, Mission, PayrollItem, GLAccount, '' AS PostClass
                      FROM         SalarySchedulePayrollItem AS A
                      WHERE        Mission = '#url.mission#' 
      			      AND          (NOT EXISTS
                                           (SELECT    'X'
                                            FROM      SalarySchedulePayrollItemClass
                                            WHERE     Mission = A.Mission 
											AND       SalarySchedule = A.SalarySchedule 
											AND       PayrollItem = A.PayrollItem)) 
			         AND          Operational = 1 
			         AND          GLAccount IN (SELECT GLAccount FROM  Accounting.dbo.Ref_Account)

                     UNION ALL
					 
                     SELECT       A.SalarySchedule, A.Mission, A.PayrollItem, B.GLAccount, B.PostClass
                     FROM         SalarySchedulePayrollItem AS A INNER JOIN
                                  SalarySchedulePayrollItemClass AS B ON B.Mission = A.Mission AND B.SalarySchedule = A.SalarySchedule AND 
                                         B.PayrollItem = A.PayrollItem
                     WHERE        A.Mission = '#url.mission#' 
			         AND          Operational = 1) AS R ON P.PayrollItem = R.PayrollItem
	
  	WHERE 	    R.GlAccount = '#url.id1#'

</cfquery>


<cfoutput>

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

        <tr class="labelmedium line">
		   <td><cf_tl id="Schedule"></td>
		   <td><cf_tl id="Code"></td>
		   <td><cf_tl id="Name"></td>
		   <td><cf_tl id="Class"></td>
		   <td><cf_tl id="Source"></td>
	   </tr>
			
		<cfloop query="PayrollItems">
		
			<tr class="labelmedium line navigation_row">					
				<td>#SalarySchedule#</td>					
				<td><a href="##" onclick="javascript:window.open('#CLIENT.root#/Payroll/Maintenance/SalaryItem/RecordEditTab.cfm?ID1=#PayrollItem#','_blank')">#PayrollItem#</a></td>			
				<td>#PayrollItemName#</td>							
				<td>#PostClass#</td>		
				<td>#Source#</td>
			</tr>		
			
		</cfloop>
		
</table>
</cfoutput>

<cfset ajaxonload("doHighlight")>